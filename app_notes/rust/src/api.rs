//! Public API definitions for flutter_rust_bridge.
//!
//! This module contains all the public types and functions that are
//! exposed to Flutter via flutter_rust_bridge.

use flutter_rust_bridge::frb;
use serde::{Deserialize, Serialize};

// Re-export file_service functions for FFI
use crate::file_service;

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
    Created { path: String },
    /// File was modified.
    Modified { path: String },
    /// File was deleted.
    Deleted { path: String },
    /// File was renamed.
    Renamed { from: String, to: String },
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
pub async fn rust_write_file(
    path: String,
    content: String,
) -> std::result::Result<(), String> {
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
pub async fn rust_read_directory(
    path: String,
) -> std::result::Result<Vec<FileEntryDto>, String> {
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
}
