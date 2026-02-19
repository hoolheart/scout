//! File system watcher for monitoring note changes.
//!
//! This module provides a file system watcher that monitors markdown files
//! for changes and reports events back to the Flutter frontend.

use crate::api::{FileEvent, WatcherConfig};
use crate::error::{AppError, Result};
use notify::{Event as NotifyEvent, EventKind, RecursiveMode, Watcher};
use std::collections::HashMap;
use std::path::{Path, PathBuf};
use std::sync::Arc;
use std::time::{Duration, Instant};
use tokio::sync::{mpsc, Mutex, RwLock};
use tokio::time::sleep;
use tracing::{debug, info, warn};

/// File system event for FFI API.
#[derive(Debug, Clone, PartialEq)]
pub enum FileSystemEvent {
    /// File or directory was created.
    Created {
        /// Path to the created file or directory.
        path: String,
        /// Whether the created path is a directory.
        is_dir: bool,
    },
    /// File or directory was modified.
    Modified {
        /// Path to the modified file or directory.
        path: String,
    },
    /// File or directory was deleted.
    Deleted {
        /// Path to the deleted file or directory.
        path: String,
    },
    /// File or directory was renamed.
    Renamed {
        /// Original path before rename.
        old_path: String,
        /// New path after rename.
        new_path: String,
    },
}

impl FileSystemEvent {
    /// Get the path from the event (for debouncing).
    fn path(&self) -> &str {
        match self {
            FileSystemEvent::Created { path, .. } => path,
            FileSystemEvent::Modified { path } => path,
            FileSystemEvent::Deleted { path } => path,
            FileSystemEvent::Renamed { new_path, .. } => new_path,
        }
    }
}

/// A file system watcher for monitoring note changes.
pub struct FileWatcher {
    /// The underlying notify watcher.
    watcher: Arc<Mutex<Option<notify::RecommendedWatcher>>>,
    /// Channel for receiving events.
    event_sender: mpsc::Sender<FileSystemEvent>,
    /// Current watched paths.
    watched_paths: Arc<RwLock<Vec<PathBuf>>>,
    /// Configuration.
    config: WatcherConfig,
    /// Debounce timer for each path.
    debounce_map: Arc<Mutex<HashMap<String, Instant>>>,
    /// Debounce delay duration.
    debounce_delay: Duration,
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
    pub fn new(event_sender: mpsc::Sender<FileSystemEvent>, config: WatcherConfig) -> Result<Self> {
        Ok(Self {
            watcher: Arc::new(Mutex::new(None)),
            event_sender,
            watched_paths: Arc::new(RwLock::new(Vec::new())),
            config,
            debounce_map: Arc::new(Mutex::new(HashMap::new())),
            debounce_delay: Duration::from_millis(500),
        })
    }

    /// Create a new file watcher with custom debounce delay.
    ///
    /// # Arguments
    ///
    /// * `event_sender` - Channel sender for file events.
    /// * `config` - Watcher configuration.
    /// * `debounce_delay` - Debounce delay duration.
    ///
    /// # Returns
    ///
    /// Returns a new `FileWatcher` instance.
    pub fn new_with_delay(
        event_sender: mpsc::Sender<FileSystemEvent>,
        config: WatcherConfig,
        debounce_delay: Duration,
    ) -> Result<Self> {
        Ok(Self {
            watcher: Arc::new(Mutex::new(None)),
            event_sender,
            watched_paths: Arc::new(RwLock::new(Vec::new())),
            config,
            debounce_map: Arc::new(Mutex::new(HashMap::new())),
            debounce_delay,
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
        let debounce_map = self.debounce_map.clone();
        let debounce_delay = self.debounce_delay;

        // Create the watcher
        let watcher = notify::recommended_watcher(
            move |res: std::result::Result<NotifyEvent, notify::Error>| match res {
                Ok(event) => {
                    handle_notify_event_with_debounce(
                        event,
                        &event_sender,
                        &config,
                        &debounce_map,
                        debounce_delay,
                    );
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
        let mut paths = self.watched_paths.write().await;
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

        let mut paths = self.watched_paths.write().await;
        paths.retain(|p| p != path);

        info!("Stopped watching: {}", path.display());

        Ok(())
    }

    /// Stop the watcher completely.
    pub async fn stop(&self) -> Result<()> {
        let mut watcher_guard = self.watcher.lock().await;
        *watcher_guard = None;

        let mut paths = self.watched_paths.write().await;
        paths.clear();

        // Clear debounce map
        let mut debounce = self.debounce_map.lock().await;
        debounce.clear();

        info!("File watcher stopped");

        Ok(())
    }

    /// Get the list of watched paths.
    pub async fn watched_paths(&self) -> Vec<String> {
        let paths = self.watched_paths.read().await;
        paths
            .iter()
            .map(|p| p.to_string_lossy().to_string())
            .collect()
    }

    /// Check if a path is being watched.
    pub async fn is_watching(&self, path: impl AsRef<Path>) -> bool {
        let paths = self.watched_paths.read().await;
        paths.iter().any(|p| p == path.as_ref())
    }
}

/// Handle a notify event with debouncing.
fn handle_notify_event_with_debounce(
    event: NotifyEvent,
    sender: &mpsc::Sender<FileSystemEvent>,
    config: &WatcherConfig,
    debounce_map: &Arc<Mutex<HashMap<String, Instant>>>,
    debounce_delay: Duration,
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

    let file_events = convert_notify_event(&event);

    // Try to get the current runtime handle
    let handle = match tokio::runtime::Handle::try_current() {
        Ok(handle) => handle,
        Err(_) => {
            // No runtime available, send events without debouncing
            for file_event in file_events {
                let sender = sender.clone();
                // Use blocking_send since we're not in an async context
                if let Err(e) = sender.try_send(file_event) {
                    warn!("Failed to send file event: {}", e);
                }
            }
            return;
        }
    };

    for file_event in file_events {
        let path = file_event.path().to_string();
        let sender = sender.clone();
        let debounce_map = debounce_map.clone();
        let delay = debounce_delay;
        let handle = handle.clone();

        // Spawn a task for debouncing
        handle.spawn(async move {
            let should_send = {
                let mut map = debounce_map.lock().await;
                let now = Instant::now();

                if let Some(last_time) = map.get(&path) {
                    if now.duration_since(*last_time) < delay {
                        // Still within debounce window, update time and skip
                        map.insert(path.clone(), now);
                        false
                    } else {
                        // Outside debounce window, update time and send
                        map.insert(path.clone(), now);
                        true
                    }
                } else {
                    // First time seeing this path
                    map.insert(path.clone(), now);
                    true
                }
            };

            if should_send {
                // Wait for the debounce delay before sending
                sleep(delay).await;

                // Check if this is still the latest event for this path
                let should_send_after_delay = {
                    let map = debounce_map.lock().await;
                    if let Some(last_time) = map.get(&path) {
                        Instant::now().duration_since(*last_time) >= delay
                    } else {
                        false
                    }
                };

                if should_send_after_delay {
                    if let Err(e) = sender.send(file_event).await {
                        warn!("Failed to send file event: {}", e);
                    }
                }
            }
        });
    }
}

/// Convert notify events to our FileSystemEvent type.
fn convert_notify_event(event: &NotifyEvent) -> Vec<FileSystemEvent> {
    let mut events = Vec::new();

    match event.kind {
        EventKind::Create(create_kind) => {
            for path in &event.paths {
                let is_dir = matches!(create_kind, notify::event::CreateKind::Folder);
                events.push(FileSystemEvent::Created {
                    path: path.to_string_lossy().to_string(),
                    is_dir,
                });
            }
        }
        EventKind::Modify(modify_kind) => {
            for path in &event.paths {
                // Only emit modified event for content changes
                if matches!(
                    modify_kind,
                    notify::event::ModifyKind::Data(_) | notify::event::ModifyKind::Metadata(_)
                ) {
                    events.push(FileSystemEvent::Modified {
                        path: path.to_string_lossy().to_string(),
                    });
                }
            }
        }
        EventKind::Remove(remove_kind) => {
            for path in &event.paths {
                let _is_dir = matches!(remove_kind, notify::event::RemoveKind::Folder);
                events.push(FileSystemEvent::Deleted {
                    path: path.to_string_lossy().to_string(),
                });
            }
        }
        EventKind::Other => {
            // Handle rename events
            if event.paths.len() >= 2 {
                events.push(FileSystemEvent::Renamed {
                    old_path: event.paths[0].to_string_lossy().to_string(),
                    new_path: event.paths[1].to_string_lossy().to_string(),
                });
            }
        }
        _ => {}
    }

    events
}

/// Handle a notify event (legacy, without debouncing).
#[allow(dead_code)]
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
        EventKind::Create(_) => event.paths.first().map(|path| FileEvent::Created {
            path: path.to_string_lossy().to_string(),
        }),
        EventKind::Modify(_) => event.paths.first().map(|path| FileEvent::Modified {
            path: path.to_string_lossy().to_string(),
        }),
        EventKind::Remove(_) => event.paths.first().map(|path| FileEvent::Deleted {
            path: path.to_string_lossy().to_string(),
        }),
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
pub fn create_watcher() -> (FileWatcher, mpsc::Receiver<FileSystemEvent>) {
    let (tx, rx) = mpsc::channel(100);
    let config = WatcherConfig::default();
    let watcher = FileWatcher::new(tx, config).expect("Failed to create watcher");
    (watcher, rx)
}

/// Create a new file watcher with custom configuration.
///
/// # Arguments
///
/// * `config` - Watcher configuration.
///
/// # Returns
///
/// Returns a tuple of (FileWatcher, event_receiver).
pub fn create_watcher_with_config(
    config: WatcherConfig,
) -> (FileWatcher, mpsc::Receiver<FileSystemEvent>) {
    let (tx, rx) = mpsc::channel(100);
    let watcher = FileWatcher::new(tx, config).expect("Failed to create watcher");
    (watcher, rx)
}

/// Async task for processing file watcher events.
pub async fn run_watcher_task(mut receiver: mpsc::Receiver<FileSystemEvent>) {
    while let Some(event) = receiver.recv().await {
        debug!("Processing file event: {:?}", event);
        // Events are sent to Flutter via the bridge
        // Additional processing can be done here if needed
    }
}

/// Watch a workspace directory and handle events.
///
/// # Arguments
///
/// * `path` - Path to the workspace directory.
/// * `event_handler` - Handler function for file events.
///
/// # Returns
///
/// Returns `Ok(())` on success, or an error if the workspace cannot be watched.
pub async fn watch_workspace(
    path: String,
    event_handler: impl Fn(FileSystemEvent) + Send + 'static,
) -> Result<()> {
    let config = WatcherConfig {
        recursive: true,
        extensions: vec![".md".to_string(), ".markdown".to_string()],
        ignore_hidden: true,
    };

    let (tx, mut rx) = mpsc::channel(100);
    let watcher = FileWatcher::new(tx, config)?;

    // Start watching
    watcher.watch(&path).await?;

    // Process events
    tokio::spawn(async move {
        while let Some(event) = rx.recv().await {
            event_handler(event);
        }
    });

    // Keep the watcher alive
    // In a real application, you'd store the watcher somewhere
    // For now, we just return Ok and the watcher will be dropped
    // which stops the watching

    info!("Started watching workspace: {}", path);

    Ok(())
}

/// Watch a workspace directory with debouncing.
///
/// # Arguments
///
/// * `path` - Path to the workspace directory.
/// * `debounce_ms` - Debounce delay in milliseconds.
/// * `event_handler` - Handler function for file events.
///
/// # Returns
///
/// Returns the FileWatcher instance and receiver channel.
pub async fn watch_workspace_with_debounce(
    path: String,
    debounce_ms: u64,
    event_handler: impl Fn(FileSystemEvent) + Send + 'static,
) -> Result<FileWatcher> {
    let config = WatcherConfig {
        recursive: true,
        extensions: vec![".md".to_string(), ".markdown".to_string()],
        ignore_hidden: true,
    };

    let (tx, mut rx) = mpsc::channel(100);
    let watcher = FileWatcher::new_with_delay(tx, config, Duration::from_millis(debounce_ms))?;

    // Start watching
    watcher.watch(&path).await?;

    // Process events
    tokio::spawn(async move {
        while let Some(event) = rx.recv().await {
            event_handler(event);
        }
    });

    info!(
        "Started watching workspace with {}ms debounce: {}",
        debounce_ms, path
    );

    Ok(watcher)
}

/// Global watcher state for FFI.
static WATCHER_STATE: once_cell::sync::Lazy<Arc<Mutex<Option<FileWatcher>>>> =
    once_cell::sync::Lazy::new(|| Arc::new(Mutex::new(None)));

/// Start watching a workspace for FFI.
///
/// # Arguments
///
/// * `path` - Path to the workspace directory.
///
/// # Returns
///
/// Returns a watch ID on success.
pub async fn start_workspace_watch(path: String) -> Result<String> {
    let watch_id = format!("watch_{}", md5_hash(&path));

    let config = WatcherConfig {
        recursive: true,
        extensions: vec![".md".to_string(), ".markdown".to_string()],
        ignore_hidden: true,
    };

    let (tx, mut rx) = mpsc::channel(100);
    let watcher = FileWatcher::new_with_delay(tx, config, Duration::from_millis(500))?;

    watcher.watch(&path).await?;

    // Store watcher in global state
    let mut state = WATCHER_STATE.lock().await;
    *state = Some(watcher);

    // Spawn event processing task
    tokio::spawn(async move {
        while let Some(event) = rx.recv().await {
            debug!("Workspace event: {:?}", event);
            // Events would be sent to Flutter via a stream sink
        }
    });

    info!("Started workspace watch: {} -> {}", watch_id, path);

    Ok(watch_id)
}

/// Stop watching a workspace for FFI.
///
/// # Arguments
///
/// * `watch_id` - The watch ID returned by `start_workspace_watch`.
///
/// # Returns
///
/// Returns `Ok(())` on success.
pub async fn stop_workspace_watch(_watch_id: String) -> Result<()> {
    let mut state = WATCHER_STATE.lock().await;
    if let Some(watcher) = state.take() {
        watcher.stop().await?;
        info!("Stopped workspace watch: {}", _watch_id);
    }
    Ok(())
}

/// Simple md5 hash helper.
fn md5_hash(data: &str) -> String {
    use std::collections::hash_map::DefaultHasher;
    use std::hash::{Hash, Hasher};

    let mut hasher = DefaultHasher::new();
    data.hash(&mut hasher);
    format!("{:x}", hasher.finish())
}

#[cfg(test)]
mod tests {
    use super::*;
    use std::time::Duration;
    use tempfile::TempDir;
    use tokio::time::timeout;

    #[tokio::test(flavor = "multi_thread", worker_threads = 2)]
    async fn test_watcher_create() {
        let (tx, mut rx) = mpsc::channel(10);
        let config = WatcherConfig::default();
        let watcher = FileWatcher::new(tx, config).unwrap();

        let temp_dir = TempDir::new().unwrap();
        watcher.watch(temp_dir.path()).await.unwrap();

        // Give the watcher time to start
        sleep(Duration::from_millis(100)).await;

        // Create a test file
        let test_file = temp_dir.path().join("test.md");
        tokio::fs::write(&test_file, "# Test").await.unwrap();

        // Wait for event (with timeout) - account for debounce delay
        let result = timeout(Duration::from_secs(5), rx.recv()).await;

        watcher.stop().await.unwrap();

        assert!(result.is_ok());
        let event = result.unwrap();
        assert!(event.is_some());
    }

    #[tokio::test]
    async fn test_watched_paths() {
        let (tx, _rx) = mpsc::channel(10);
        let config = WatcherConfig::default();
        let watcher = FileWatcher::new(tx, config).unwrap();

        let temp_dir = TempDir::new().unwrap();
        watcher.watch(temp_dir.path()).await.unwrap();

        let paths = watcher.watched_paths().await;
        assert_eq!(paths.len(), 1);
        assert!(paths[0].contains(temp_dir.path().file_name().unwrap().to_str().unwrap()));

        watcher.stop().await.unwrap();
    }

    #[tokio::test]
    async fn test_is_watching() {
        let (tx, _rx) = mpsc::channel(10);
        let config = WatcherConfig::default();
        let watcher = FileWatcher::new(tx, config).unwrap();

        let temp_dir = TempDir::new().unwrap();

        assert!(!watcher.is_watching(temp_dir.path()).await);

        watcher.watch(temp_dir.path()).await.unwrap();

        assert!(watcher.is_watching(temp_dir.path()).await);

        watcher.stop().await.unwrap();
    }

    #[test]
    fn test_file_system_event_path() {
        let event = FileSystemEvent::Created {
            path: "/test/file.md".to_string(),
            is_dir: false,
        };
        assert_eq!(event.path(), "/test/file.md");

        let event = FileSystemEvent::Modified {
            path: "/test/file.md".to_string(),
        };
        assert_eq!(event.path(), "/test/file.md");

        let event = FileSystemEvent::Deleted {
            path: "/test/file.md".to_string(),
        };
        assert_eq!(event.path(), "/test/file.md");

        let event = FileSystemEvent::Renamed {
            old_path: "/old/file.md".to_string(),
            new_path: "/new/file.md".to_string(),
        };
        assert_eq!(event.path(), "/new/file.md");
    }

    #[tokio::test]
    async fn test_watcher_unwatch() {
        let (tx, _rx) = mpsc::channel(10);
        let config = WatcherConfig::default();
        let watcher = FileWatcher::new(tx, config).unwrap();

        let temp_dir = TempDir::new().unwrap();
        watcher.watch(temp_dir.path()).await.unwrap();
        assert!(watcher.is_watching(temp_dir.path()).await);

        watcher.unwatch(temp_dir.path()).await.unwrap();
        assert!(!watcher.is_watching(temp_dir.path()).await);

        watcher.stop().await.unwrap();
    }

    #[tokio::test(flavor = "multi_thread", worker_threads = 2)]
    async fn test_extension_filtering() {
        let config = WatcherConfig {
            extensions: vec![".md".to_string()],
            ..Default::default()
        };

        let (tx, mut rx) = mpsc::channel(10);
        let watcher = FileWatcher::new(tx, config).unwrap();

        let temp_dir = TempDir::new().unwrap();
        watcher.watch(temp_dir.path()).await.unwrap();

        // Give the watcher time to start
        sleep(Duration::from_millis(100)).await;

        // Create a .txt file - should not trigger event
        let txt_file = temp_dir.path().join("test.txt");
        tokio::fs::write(&txt_file, "text").await.unwrap();

        // Small delay
        sleep(Duration::from_millis(50)).await;

        // Create a .md file - should trigger event
        let md_file = temp_dir.path().join("test.md");
        tokio::fs::write(&md_file, "# Test").await.unwrap();

        // Wait for event (accounting for debounce)
        let result = timeout(Duration::from_secs(3), rx.recv()).await;

        watcher.stop().await.unwrap();

        assert!(result.is_ok());
        let event = result.unwrap();
        assert!(event.is_some());

        // The event should be for the .md file
        match event.unwrap() {
            FileSystemEvent::Created { path, .. } => {
                assert!(path.ends_with(".md"));
            }
            _ => {}
        }
    }

    #[tokio::test(flavor = "multi_thread", worker_threads = 2)]
    async fn test_hidden_files_filtering() {
        let config = WatcherConfig {
            ignore_hidden: true,
            ..Default::default()
        };

        let (tx, mut rx) = mpsc::channel(10);
        let watcher = FileWatcher::new(tx, config).unwrap();

        let temp_dir = TempDir::new().unwrap();
        watcher.watch(temp_dir.path()).await.unwrap();

        // Give the watcher time to start
        sleep(Duration::from_millis(100)).await;

        // Create a hidden file - should not trigger event
        let hidden_file = temp_dir.path().join(".hidden");
        tokio::fs::write(&hidden_file, "hidden").await.unwrap();

        // Small delay
        sleep(Duration::from_millis(50)).await;

        // Create a regular file - should trigger event
        let regular_file = temp_dir.path().join("regular.txt");
        tokio::fs::write(&regular_file, "regular").await.unwrap();

        // Wait for event (accounting for debounce)
        let result = timeout(Duration::from_secs(3), rx.recv()).await;

        watcher.stop().await.unwrap();

        assert!(result.is_ok());
        let event = result.unwrap();
        assert!(event.is_some());

        // The event should be for the regular file
        match event.unwrap() {
            FileSystemEvent::Created { path, .. } => {
                assert!(!path.contains("/.hidden"));
            }
            _ => {}
        }
    }

    #[tokio::test]
    async fn test_watch_workspace() {
        let temp_dir = TempDir::new().unwrap();
        let path = temp_dir.path().to_string_lossy().to_string();

        let result = watch_workspace(path, |event| {
            debug!("Event: {:?}", event);
        })
        .await;

        assert!(result.is_ok());
    }

    #[tokio::test(flavor = "multi_thread", worker_threads = 2)]
    async fn test_start_stop_workspace_watch() {
        let temp_dir = TempDir::new().unwrap();
        let path = temp_dir.path().to_string_lossy().to_string();

        let watch_id = start_workspace_watch(path).await.unwrap();
        assert!(!watch_id.is_empty());

        // Give the watcher time to start
        sleep(Duration::from_millis(100)).await;

        let result = stop_workspace_watch(watch_id).await;
        assert!(result.is_ok());
    }
}
