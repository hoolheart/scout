//! File system watcher for monitoring note changes.
//!
//! This module provides a file system watcher that monitors markdown files
//! for changes and reports events back to the Flutter frontend.

use crate::api::{FileEvent, WatcherConfig};
use crate::error::{AppError, Result};
use notify::{Event as NotifyEvent, EventKind, RecommendedWatcher, RecursiveMode, Watcher};
use std::path::{Path, PathBuf};
use std::sync::Arc;
use tokio::sync::{mpsc, Mutex};
use tracing::{debug, info, warn};

/// A file system watcher for monitoring note changes.
pub struct FileWatcher {
    /// The underlying notify watcher.
    watcher: Arc<Mutex<Option<RecommendedWatcher>>>,
    /// Channel for receiving events.
    event_sender: mpsc::UnboundedSender<FileEvent>,
    /// Current watched paths.
    watched_paths: Arc<Mutex<Vec<PathBuf>>>,
    /// Configuration.
    config: WatcherConfig,
}

impl FileWatcher {
    /// Create a new file watcher.
    ///
    /// # Arguments
    ///
    /// * `event_sender` - Channel sender for file events.
    /// * `config` - Watcher configuration.
    ///
    /// # Returns
    ///
    /// Returns a new `FileWatcher` instance.
    pub fn new(
        event_sender: mpsc::UnboundedSender<FileEvent>,
        config: WatcherConfig,
    ) -> Result<Self> {
        Ok(Self {
            watcher: Arc::new(Mutex::new(None)),
            event_sender,
            watched_paths: Arc::new(Mutex::new(Vec::new())),
            config,
        })
    }

    /// Start watching a directory.
    ///
    /// # Arguments
    ///
    /// * `path` - Path to the directory to watch.
    ///
    /// # Returns
    ///
    /// Returns `Ok(())` on success, or an error if the path cannot be watched.
    pub async fn watch(&self, path: impl AsRef<Path>) -> Result<()> {
        let path = path.as_ref();

        if !path.exists() {
            return Err(AppError::file_not_found(path.to_string_lossy()));
        }

        if !path.is_dir() {
            return Err(AppError::invalid_path(format!(
                "{} is not a directory",
                path.display()
            )));
        }

        let recursive_mode = if self.config.recursive {
            RecursiveMode::Recursive
        } else {
            RecursiveMode::NonRecursive
        };

        let event_sender = self.event_sender.clone();
        let config = self.config.clone();

        // Create the watcher
        let watcher = notify::recommended_watcher(
            move |res: std::result::Result<NotifyEvent, notify::Error>| match res {
                Ok(event) => {
                    handle_notify_event(event, &event_sender, &config);
                }
                Err(e) => {
                    warn!("Watcher error: {}", e);
                }
            },
        )
        .map_err(|e| AppError::watcher(format!("Failed to create watcher: {}", e)))?;

        let mut watcher_guard = self.watcher.lock().await;
        *watcher_guard = Some(watcher);

        // Watch the path
        if let Some(ref mut w) = watcher_guard.as_mut() {
            w.watch(path, recursive_mode)
                .map_err(|e| AppError::watcher(format!("Failed to watch path: {}", e)))?;
        }

        // Add to watched paths
        let mut paths = self.watched_paths.lock().await;
        paths.push(path.to_path_buf());

        info!("Started watching: {}", path.display());

        Ok(())
    }

    /// Stop watching a directory.
    ///
    /// # Arguments
    ///
    /// * `path` - Path to the directory to stop watching.
    ///
    /// # Returns
    ///
    /// Returns `Ok(())` on success, or an error if the path is not being watched.
    pub async fn unwatch(&self, path: impl AsRef<Path>) -> Result<()> {
        let path = path.as_ref();

        let mut watcher_guard = self.watcher.lock().await;
        if let Some(ref mut w) = watcher_guard.as_mut() {
            w.unwatch(path)
                .map_err(|e| AppError::watcher(format!("Failed to unwatch path: {}", e)))?;
        }

        let mut paths = self.watched_paths.lock().await;
        paths.retain(|p| p != path);

        info!("Stopped watching: {}", path.display());

        Ok(())
    }

    /// Stop the watcher completely.
    pub async fn stop(&self) -> Result<()> {
        let mut watcher_guard = self.watcher.lock().await;
        *watcher_guard = None;

        let mut paths = self.watched_paths.lock().await;
        paths.clear();

        info!("File watcher stopped");

        Ok(())
    }

    /// Get the list of watched paths.
    pub async fn watched_paths(&self) -> Vec<String> {
        let paths = self.watched_paths.lock().await;
        paths
            .iter()
            .map(|p| p.to_string_lossy().to_string())
            .collect()
    }
}

/// Handle a notify event and convert it to our FileEvent type.
fn handle_notify_event(
    event: NotifyEvent,
    sender: &mpsc::UnboundedSender<FileEvent>,
    config: &WatcherConfig,
) {
    // Filter by extension if configured
    if !config.extensions.is_empty() {
        let has_valid_extension = event.paths.iter().any(|p| {
            if let Some(ext) = p.extension() {
                let ext = ext.to_string_lossy().to_lowercase();
                config
                    .extensions
                    .iter()
                    .any(|e| e.trim_start_matches('.').to_lowercase() == ext)
            } else {
                false
            }
        });

        if !has_valid_extension {
            return;
        }
    }

    // Filter hidden files if configured
    if config.ignore_hidden {
        let has_hidden = event.paths.iter().any(|p| {
            p.file_name()
                .map(|n| n.to_string_lossy().starts_with('.'))
                .unwrap_or(false)
        });

        if has_hidden {
            return;
        }
    }

    let file_event = match event.kind {
        EventKind::Create(_) => {
            if let Some(path) = event.paths.first() {
                Some(FileEvent::Created {
                    path: path.to_string_lossy().to_string(),
                })
            } else {
                None
            }
        }
        EventKind::Modify(_) => {
            if let Some(path) = event.paths.first() {
                Some(FileEvent::Modified {
                    path: path.to_string_lossy().to_string(),
                })
            } else {
                None
            }
        }
        EventKind::Remove(_) => {
            if let Some(path) = event.paths.first() {
                Some(FileEvent::Deleted {
                    path: path.to_string_lossy().to_string(),
                })
            } else {
                None
            }
        }
        EventKind::Other => {
            if event.paths.len() >= 2 {
                Some(FileEvent::Renamed {
                    from: event.paths[0].to_string_lossy().to_string(),
                    to: event.paths[1].to_string_lossy().to_string(),
                })
            } else {
                None
            }
        }
        _ => None,
    };

    if let Some(event) = file_event {
        debug!("File event: {:?}", event);
        if let Err(e) = sender.send(event) {
            warn!("Failed to send file event: {}", e);
        }
    }
}

/// Create a new file watcher with default configuration.
///
/// # Returns
///
/// Returns a tuple of (FileWatcher, event_receiver).
pub fn create_watcher() -> (FileWatcher, mpsc::UnboundedReceiver<FileEvent>) {
    let (tx, rx) = mpsc::unbounded_channel();
    let config = WatcherConfig::default();
    let watcher = FileWatcher::new(tx, config).expect("Failed to create watcher");
    (watcher, rx)
}

/// Async task for processing file watcher events.
pub async fn run_watcher_task(mut receiver: mpsc::UnboundedReceiver<FileEvent>) {
    while let Some(event) = receiver.recv().await {
        debug!("Processing file event: {:?}", event);
        // Events are sent to Flutter via the bridge
        // Additional processing can be done here if needed
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use std::time::Duration;
    use tempfile::TempDir;
    use tokio::time::timeout;

    #[tokio::test]
    async fn test_watcher_create() {
        let (tx, mut rx) = mpsc::unbounded_channel();
        let config = WatcherConfig::default();
        let watcher = FileWatcher::new(tx, config).unwrap();

        let temp_dir = TempDir::new().unwrap();
        watcher.watch(temp_dir.path()).await.unwrap();

        // Create a test file
        let test_file = temp_dir.path().join("test.md");
        tokio::fs::write(&test_file, "# Test").await.unwrap();

        // Wait for event (with timeout)
        let result = timeout(Duration::from_secs(5), rx.recv()).await;

        watcher.stop().await.unwrap();

        assert!(result.is_ok());
        let event = result.unwrap();
        assert!(event.is_some());
    }

    #[tokio::test]
    async fn test_watched_paths() {
        let (tx, _rx) = mpsc::unbounded_channel();
        let config = WatcherConfig::default();
        let watcher = FileWatcher::new(tx, config).unwrap();

        let temp_dir = TempDir::new().unwrap();
        watcher.watch(temp_dir.path()).await.unwrap();

        let paths = watcher.watched_paths().await;
        assert_eq!(paths.len(), 1);
        assert!(paths[0].contains(temp_dir.path().file_name().unwrap().to_str().unwrap()));

        watcher.stop().await.unwrap();
    }

    #[test]
    fn test_event_conversion() {
        let (tx, mut rx) = mpsc::unbounded_channel();
        let config = WatcherConfig::default();

        let event = NotifyEvent {
            kind: EventKind::Create(notify::event::CreateKind::File),
            paths: vec![PathBuf::from("/test/file.md")],
            attrs: notify::event::EventAttributes::new(),
        };

        handle_notify_event(event, &tx, &config);

        let result = rx.try_recv();
        assert!(result.is_ok());
        match result.unwrap() {
            FileEvent::Created { path } => {
                assert_eq!(path, "/test/file.md");
            }
            _ => panic!("Wrong event type"),
        }
    }

    #[test]
    fn test_extension_filtering() {
        let (tx, mut rx) = mpsc::unbounded_channel();
        let config = WatcherConfig {
            extensions: vec![".md".to_string()],
            ..Default::default()
        };

        // Create event for .txt file should be filtered out
        let event = NotifyEvent {
            kind: EventKind::Create(notify::event::CreateKind::File),
            paths: vec![PathBuf::from("/test/file.txt")],
            attrs: notify::event::EventAttributes::new(),
        };

        handle_notify_event(event, &tx, &config);

        // Should not receive event
        let result = rx.try_recv();
        assert!(result.is_err());

        // Create event for .md file should pass through
        let event = NotifyEvent {
            kind: EventKind::Create(notify::event::CreateKind::File),
            paths: vec![PathBuf::from("/test/file.md")],
            attrs: notify::event::EventAttributes::new(),
        };

        handle_notify_event(event, &tx, &config);

        let result = rx.try_recv();
        assert!(result.is_ok());
    }
}
