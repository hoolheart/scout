//! Public API definitions for flutter_rust_bridge.
//!
//! This module contains all the public types and functions that are
//! exposed to Flutter via flutter_rust_bridge.

use flutter_rust_bridge::frb;
use serde::{Deserialize, Serialize};

// Re-export file_service functions for FFI
use crate::file_service;
use crate::markdown;
use crate::watcher;
use std::sync::Arc;
use tokio::sync::Mutex;

/// Represents a markdown note file.
#[derive(Debug, Clone, Serialize, Deserialize, PartialEq)]
pub struct Note {
    /// Unique identifier for the note.
    pub id: String,
    /// Title of the note.
    pub title: String,
    /// Content of the note in Markdown format.
    pub content: String,
    /// Path to the note file.
    pub path: String,
    /// Last modified timestamp (Unix timestamp).
    pub modified_at: i64,
    /// Created timestamp (Unix timestamp).
    pub created_at: i64,
}

impl Note {
    /// Create a new note with the given id and title.
    pub fn new(id: String, title: String) -> Self {
        let now = chrono::Utc::now().timestamp();
        Self {
            id,
            title,
            content: String::new(),
            path: String::new(),
            modified_at: now,
            created_at: now,
        }
    }
}

/// Represents a note folder.
#[derive(Debug, Clone, Serialize, Deserialize, PartialEq)]
pub struct Folder {
    /// Unique identifier for the folder.
    pub id: String,
    /// Name of the folder.
    pub name: String,
    /// Path to the folder.
    pub path: String,
}

/// Result type for API operations.
#[derive(Debug, Clone, Serialize, Deserialize, PartialEq)]
pub struct ApiResult<T> {
    /// Whether the operation was successful.
    pub success: bool,
    /// Error message if the operation failed.
    pub error: Option<String>,
    /// Data returned by the operation.
    pub data: Option<T>,
}

impl<T> ApiResult<T> {
    /// Create a successful result.
    pub fn success(data: T) -> Self {
        Self {
            success: true,
            error: None,
            data: Some(data),
        }
    }

    /// Create a failed result.
    pub fn error(message: impl Into<String>) -> Self {
        Self {
            success: false,
            error: Some(message.into()),
            data: None,
        }
    }
}

impl<T> Default for ApiResult<T>
where
    T: Default,
{
    fn default() -> Self {
        Self::success(T::default())
    }
}

/// Configuration options for the file watcher.
#[derive(Debug, Clone, Serialize, Deserialize, Default)]
pub struct WatcherConfig {
    /// Whether to watch subdirectories recursively.
    pub recursive: bool,
    /// File extensions to watch (e.g., [".md", ".markdown"]).
    /// Empty means watch all files.
    pub extensions: Vec<String>,
    /// Whether to ignore hidden files.
    pub ignore_hidden: bool,
}

/// Represents a file system event.
#[derive(Debug, Clone, Serialize, Deserialize, PartialEq)]
pub enum FileEvent {
    /// File was created.
    Created {
        /// Path to the created file.
        path: String,
    },
    /// File was modified.
    Modified {
        /// Path to the modified file.
        path: String,
    },
    /// File was deleted.
    Deleted {
        /// Path to the deleted file.
        path: String,
    },
    /// File was renamed.
    Renamed {
        /// Original path before rename.
        from: String,
        /// New path after rename.
        to: String,
    },
}

/// Settings for the markdown parser.
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct MarkdownConfig {
    /// Whether to enable GitHub-flavored Markdown.
    pub gfm: bool,
    /// Whether to enable tables.
    pub tables: bool,
    /// Whether to enable strikethrough.
    pub strikethrough: bool,
    /// Whether to enable task lists.
    pub tasklists: bool,
    /// Whether to enable smart punctuation.
    pub smart_punctuation: bool,
    /// Whether to enable heading attributes.
    pub heading_attributes: bool,
}

impl Default for MarkdownConfig {
    fn default() -> Self {
        Self {
            gfm: true,
            tables: true,
            strikethrough: true,
            tasklists: true,
            smart_punctuation: false,
            heading_attributes: false,
        }
    }
}

// ==================== FFI API Functions ====================

/// Initialize the Rust runtime.
/// This function should be called before using any other API.
#[frb(init)]
pub fn init_app() {
    // Initialize tracing subscriber for logging
    let _ = tracing_subscriber::fmt()
        .with_env_filter("app_notes_rust=info")
        .try_init();

    tracing::info!("App Notes Rust backend initialized via FFI");
}

/// Get the Rust library version.
///
/// # Returns
///
/// Returns the version string of the library.
#[frb(sync)]
pub fn get_rust_version() -> String {
    env!("CARGO_PKG_VERSION").to_string()
}

/// Read a file asynchronously.
///
/// # Arguments
///
/// * `path` - Path to the file.
///
/// # Returns
///
/// Returns the file content as a string, or an error message.
pub async fn rust_read_file(path: String) -> std::result::Result<String, String> {
    match file_service::read_file(path).await {
        Ok(content) => Ok(content),
        Err(e) => Err(e.to_user_message()),
    }
}

/// Write content to a file asynchronously.
///
/// # Arguments
///
/// * `path` - Path to the file.
/// * `content` - Content to write.
///
/// # Returns
///
/// Returns Ok(()) on success, or an error message.
pub async fn rust_write_file(path: String, content: String) -> std::result::Result<(), String> {
    match file_service::write_file(path, content).await {
        Ok(()) => Ok(()),
        Err(e) => Err(e.to_user_message()),
    }
}

/// Read the contents of a directory asynchronously.
///
/// # Arguments
///
/// * `path` - Path to the directory.
///
/// # Returns
///
/// Returns a vector of FileEntryDto on success, or an error message.
pub async fn rust_read_directory(path: String) -> std::result::Result<Vec<FileEntryDto>, String> {
    match file_service::read_directory(path).await {
        Ok(entries) => Ok(entries.into_iter().map(FileEntryDto::from).collect()),
        Err(e) => Err(e.to_user_message()),
    }
}

/// Create an empty file asynchronously.
///
/// # Arguments
///
/// * `path` - Path to the file to create.
///
/// # Returns
///
/// Returns Ok(()) on success, or an error message.
pub async fn rust_create_file(path: String) -> std::result::Result<(), String> {
    match file_service::create_file(path).await {
        Ok(()) => Ok(()),
        Err(e) => Err(e.to_user_message()),
    }
}

/// Delete a file asynchronously.
///
/// # Arguments
///
/// * `path` - Path to the file to delete.
///
/// # Returns
///
/// Returns Ok(()) on success, or an error message.
pub async fn rust_delete_file(path: String) -> std::result::Result<(), String> {
    match file_service::delete_file(path).await {
        Ok(()) => Ok(()),
        Err(e) => Err(e.to_user_message()),
    }
}

/// Rename (move) a file asynchronously.
///
/// # Arguments
///
/// * `old_path` - Current path of the file.
/// * `new_path` - New path for the file.
///
/// # Returns
///
/// Returns Ok(()) on success, or an error message.
pub async fn rust_rename_file(
    old_path: String,
    new_path: String,
) -> std::result::Result<(), String> {
    match file_service::rename_file(old_path, new_path).await {
        Ok(()) => Ok(()),
        Err(e) => Err(e.to_user_message()),
    }
}

/// Check if a file or directory exists.
///
/// # Arguments
///
/// * `path` - Path to check.
///
/// # Returns
///
/// Returns true if the path exists, false otherwise.
#[frb(sync)]
pub fn rust_file_exists(path: String) -> bool {
    std::path::Path::new(&path).exists()
}

/// Create a directory and all parent directories if needed.
///
/// # Arguments
///
/// * `path` - Path to the directory to create.
///
/// # Returns
///
/// Returns Ok(()) on success, or an error message.
pub async fn rust_create_directory(path: String) -> std::result::Result<(), String> {
    match file_service::create_directory(path).await {
        Ok(()) => Ok(()),
        Err(e) => Err(e.to_user_message()),
    }
}

/// Delete a directory recursively.
///
/// # Arguments
///
/// * `path` - Path to the directory to delete.
///
/// # Returns
///
/// Returns Ok(()) on success, or an error message.
pub async fn rust_delete_directory(path: String) -> std::result::Result<(), String> {
    match tokio::fs::remove_dir_all(&path).await {
        Ok(()) => Ok(()),
        Err(e) => Err(format!("Failed to delete directory: {}", e)),
    }
}

/// Data transfer object for file entries.
/// This is used for FFI communication with Flutter.
#[derive(Debug, Clone, Serialize, Deserialize, PartialEq)]
#[frb]
pub struct FileEntryDto {
    /// Name of the file or directory.
    pub name: String,
    /// Full path to the file or directory.
    pub path: String,
    /// Whether this is a directory.
    pub is_directory: bool,
    /// Size in bytes (0 for directories).
    pub size: u64,
    /// Last modified time as Unix timestamp in milliseconds.
    pub modified_time: Option<u64>,
}

impl From<file_service::FileEntry> for FileEntryDto {
    fn from(entry: file_service::FileEntry) -> Self {
        // Convert seconds to milliseconds for Flutter compatibility
        let modified_time_ms = entry.modified_time.map(|secs| secs * 1000);

        Self {
            name: entry.name,
            path: entry.path,
            is_directory: entry.is_directory,
            size: entry.size,
            modified_time: modified_time_ms,
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_note_creation() {
        let note = Note::new("1".to_string(), "Test".to_string());
        assert_eq!(note.id, "1");
        assert_eq!(note.title, "Test");
        assert!(note.content.is_empty());
    }

    #[test]
    fn test_api_result_success() {
        let result: ApiResult<String> = ApiResult::success("data".to_string());
        assert!(result.success);
        assert_eq!(result.data, Some("data".to_string()));
        assert!(result.error.is_none());
    }

    #[test]
    fn test_api_result_error() {
        let result: ApiResult<String> = ApiResult::error("something went wrong");
        assert!(!result.success);
        assert!(result.data.is_none());
        assert_eq!(result.error, Some("something went wrong".to_string()));
    }

    #[test]
    fn test_markdown_config_default() {
        let config = MarkdownConfig::default();
        assert!(config.gfm);
        assert!(config.tables);
        assert!(config.strikethrough);
        assert!(config.tasklists);
        assert!(!config.smart_punctuation);
    }

    #[test]
    fn test_file_event_serialization() {
        let event = FileEvent::Created {
            path: "/test.md".to_string(),
        };
        let json = serde_json::to_string(&event).unwrap();
        assert!(json.contains("Created"));
        assert!(json.contains("/test.md"));
    }

    #[test]
    fn test_get_rust_version() {
        let version = get_rust_version();
        assert!(!version.is_empty());
        assert!(version.contains('.'));
    }

    #[test]
    fn test_file_entry_dto_conversion() {
        let file_entry = file_service::FileEntry {
            name: "test.md".to_string(),
            path: "/path/to/test.md".to_string(),
            is_directory: false,
            size: 100,
            modified_time: Some(1234567890), // seconds
        };

        let dto = FileEntryDto::from(file_entry);

        assert_eq!(dto.name, "test.md");
        assert_eq!(dto.path, "/path/to/test.md");
        assert!(!dto.is_directory);
        assert_eq!(dto.size, 100);
        assert_eq!(dto.modified_time, Some(1234567890000)); // milliseconds
    }

    #[test]
    fn test_parse_result_dto_conversion() {
        let result = markdown::ParseResult {
            html: "<h1>Test</h1>".to_string(),
            word_count: 10,
            char_count: 50,
            headings: vec![markdown::Heading {
                level: 1,
                text: "Test".to_string(),
                anchor: "test".to_string(),
            }],
        };

        let dto = ParseResultDto::from(result);

        assert_eq!(dto.html, "<h1>Test</h1>");
        assert_eq!(dto.word_count, 10);
        assert_eq!(dto.char_count, 50);
        assert_eq!(dto.headings.len(), 1);
        assert_eq!(dto.headings[0].text, "Test");
    }

    #[test]
    fn test_heading_dto_conversion() {
        let heading = markdown::Heading {
            level: 2,
            text: "Section".to_string(),
            anchor: "section".to_string(),
        };

        let dto = HeadingDto::from(heading);

        assert_eq!(dto.level, 2);
        assert_eq!(dto.text, "Section");
        assert_eq!(dto.anchor, "section");
    }
}

// =============================================================================
// Task R4 & R6: FFI API Functions
// =============================================================================

/// DTO for markdown parse results.
#[derive(Debug, Clone, Serialize, Deserialize, PartialEq)]
#[frb]
pub struct ParseResultDto {
    /// Rendered HTML content.
    pub html: String,
    /// Word count.
    pub word_count: u32,
    /// Character count.
    pub char_count: u32,
    /// Extracted headings.
    pub headings: Vec<HeadingDto>,
}

impl From<markdown::ParseResult> for ParseResultDto {
    fn from(result: markdown::ParseResult) -> Self {
        Self {
            html: result.html,
            word_count: result.word_count,
            char_count: result.char_count,
            headings: result.headings.into_iter().map(HeadingDto::from).collect(),
        }
    }
}

/// DTO for markdown headings.
#[derive(Debug, Clone, Serialize, Deserialize, PartialEq)]
#[frb]
pub struct HeadingDto {
    /// Heading level (1-6).
    pub level: u8,
    /// Heading text.
    pub text: String,
    /// Heading anchor ID.
    pub anchor: String,
}

impl From<markdown::Heading> for HeadingDto {
    fn from(heading: markdown::Heading) -> Self {
        Self {
            level: heading.level,
            text: heading.text,
            anchor: heading.anchor,
        }
    }
}

/// DTO for file system events.
#[derive(Debug, Clone, Serialize, Deserialize, PartialEq)]
#[frb]
pub enum FileSystemEventDto {
    /// File or directory was created.
    Created {
        /// Path to the created file or directory.
        path: String,
        /// Whether the created path is a directory.
        is_dir: bool,
    },
    /// File was modified.
    Modified {
        /// Path to the modified file.
        path: String,
    },
    /// File was deleted.
    Deleted {
        /// Path to the deleted file.
        path: String,
    },
    /// File was renamed.
    Renamed {
        /// Original path before rename.
        old_path: String,
        /// New path after rename.
        new_path: String,
    },
}

impl From<watcher::FileSystemEvent> for FileSystemEventDto {
    fn from(event: watcher::FileSystemEvent) -> Self {
        match event {
            watcher::FileSystemEvent::Created { path, is_dir } => {
                FileSystemEventDto::Created { path, is_dir }
            }
            watcher::FileSystemEvent::Modified { path } => FileSystemEventDto::Modified { path },
            watcher::FileSystemEvent::Deleted { path } => FileSystemEventDto::Deleted { path },
            watcher::FileSystemEvent::Renamed { old_path, new_path } => {
                FileSystemEventDto::Renamed { old_path, new_path }
            }
        }
    }
}

/// Parse markdown content and return comprehensive result.
///
/// # Arguments
///
/// * `content` - The markdown content to parse.
///
/// # Returns
///
/// Returns a `ParseResultDto` containing HTML, word count, char count, and headings.
#[frb(sync)]
pub fn rust_parse_markdown(content: String) -> ParseResultDto {
    let result = markdown::parse_markdown(&content);
    ParseResultDto::from(result)
}

/// Convert markdown to HTML.
///
/// # Arguments
///
/// * `content` - The markdown content to convert.
///
/// # Returns
///
/// Returns the rendered HTML string.
#[frb(sync)]
pub fn rust_markdown_to_html(content: String) -> String {
    markdown::markdown_to_html(&content)
}

/// Extract plain text from markdown.
///
/// # Arguments
///
/// * `content` - The markdown content.
///
/// # Returns
///
/// Returns the plain text without markdown syntax.
#[frb(sync)]
pub fn rust_extract_plain_text(content: String) -> String {
    markdown::extract_plain_text(&content)
}

/// Count words in text.
///
/// # Arguments
///
/// * `text` - The plain text to count.
///
/// # Returns
///
/// Returns a tuple of (word_count, char_count).
#[frb(sync)]
pub fn rust_count_words(text: String) -> (u32, u32) {
    markdown::count_words(&text)
}

/// Global watcher state for FFI workspace watching.
static WATCHER_STATE: once_cell::sync::Lazy<Arc<Mutex<Option<WatcherState>>>> =
    once_cell::sync::Lazy::new(|| Arc::new(Mutex::new(None)));

/// Internal watcher state struct.
struct WatcherState {
    watch_id: String,
    watcher: watcher::FileWatcher,
}

/// Start watching a workspace directory.
///
/// # Arguments
///
/// * `path` - Path to the workspace directory to watch.
///
/// # Returns
///
/// Returns a watch ID on success, or an error message on failure.
pub async fn rust_watch_workspace(path: String) -> std::result::Result<String, String> {
    let watch_id = format!("watch_{:x}", md5_hash(&path));

    let config = WatcherConfig {
        recursive: true,
        extensions: vec![
            ".md".to_string(),
            ".markdown".to_string(),
            ".mdown".to_string(),
        ],
        ignore_hidden: true,
    };

    let (tx, mut rx) = tokio::sync::mpsc::channel(100);
    let watcher = watcher::FileWatcher::new(tx, config).map_err(|e| e.to_user_message())?;

    watcher
        .watch(&path)
        .await
        .map_err(|e| e.to_user_message())?;

    // Store watcher in global state
    let mut state = WATCHER_STATE.lock().await;
    *state = Some(WatcherState {
        watch_id: watch_id.clone(),
        watcher,
    });

    // Spawn event processing task
    tokio::spawn(async move {
        while let Some(_event) = rx.recv().await {
            // Events would be sent to Flutter via a stream sink in a real implementation
            // For now, we just log them
            tracing::debug!("Workspace file event received");
        }
    });

    tracing::info!("Started watching workspace: {} -> {}", watch_id, path);

    Ok(watch_id)
}

/// Stop watching a workspace.
///
/// # Arguments
///
/// * `watch_id` - The watch ID returned by `rust_watch_workspace`.
///
/// # Returns
///
/// Returns Ok(()) on success, or an error message on failure.
pub async fn rust_unwatch_workspace(watch_id: String) -> std::result::Result<(), String> {
    let mut state = WATCHER_STATE.lock().await;

    if let Some(watcher_state) = state.take() {
        if watcher_state.watch_id == watch_id {
            watcher_state
                .watcher
                .stop()
                .await
                .map_err(|e| e.to_user_message())?;
            tracing::info!("Stopped watching workspace: {}", watch_id);
            Ok(())
        } else {
            Err("Invalid watch ID".to_string())
        }
    } else {
        Err("No active watcher found".to_string())
    }
}

/// Check if a workspace is being watched.
///
/// # Arguments
///
/// * `watch_id` - The watch ID to check.
///
/// # Returns
///
/// Returns true if the workspace is being watched.
pub async fn rust_is_watching(watch_id: String) -> bool {
    let state = WATCHER_STATE.lock().await;
    if let Some(ref watcher_state) = *state {
        watcher_state.watch_id == watch_id
    } else {
        false
    }
}

/// Simple md5 hash helper.
fn md5_hash(data: &str) -> u64 {
    use std::collections::hash_map::DefaultHasher;
    use std::hash::{Hash, Hasher};

    let mut hasher = DefaultHasher::new();
    data.hash(&mut hasher);
    hasher.finish()
}
