//! File system service for managing notes.
//!
//! This module provides functions for reading, writing, and managing
//! markdown note files. All operations are asynchronous and use tokio::fs.

use crate::api::{ApiResult, Folder, Note};
use crate::error::{AppError, Result};
use serde::{Deserialize, Serialize};
use std::path::Path;
use tokio::fs;
use tracing::{debug, info, warn};

/// Represents a file or directory entry in the file system.
#[derive(Debug, Clone, Serialize, Deserialize, PartialEq)]
pub struct FileEntry {
    /// Name of the file or directory.
    pub name: String,
    /// Full path to the file or directory.
    pub path: String,
    /// Whether this is a directory.
    pub is_directory: bool,
    /// Size in bytes (0 for directories).
    pub size: u64,
    /// Last modified time as Unix timestamp (seconds since epoch).
    pub modified_time: Option<u64>,
}

impl FileEntry {
    /// Create a new FileEntry from a tokio directory entry.
    async fn from_tokio_entry(entry: tokio::fs::DirEntry) -> Result<Self> {
        let path = entry.path();
        let name = entry.file_name().to_string_lossy().to_string();
        let path_str = path.to_string_lossy().to_string();

        let metadata = entry
            .metadata()
            .await
            .map_err(|e| AppError::io(e.to_string()))?;
        let is_directory = metadata.is_dir();
        let size = if is_directory { 0 } else { metadata.len() };

        let modified_time = metadata.modified().ok().and_then(|t| {
            t.duration_since(std::time::UNIX_EPOCH)
                .ok()
                .map(|d| d.as_secs())
        });

        Ok(FileEntry {
            name,
            path: path_str,
            is_directory,
            size,
            modified_time,
        })
    }
}

/// Read a file from disk asynchronously.
///
/// # Arguments
///
/// * `path` - Path to the file.
///
/// # Returns
///
/// Returns the file content as a String.
///
/// # Errors
///
/// Returns `AppError::FileNotFound` if the file doesn't exist.
/// Returns `AppError::PermissionDenied` if access is denied.
/// Returns `AppError::Io` for other IO errors.
///
/// # Example
///
/// ```rust,ignore
/// use app_notes_rust::file_service::read_file;
///
/// let content = read_file("/path/to/file.md".to_string()).await?;
/// ```
pub async fn read_file(path: String) -> Result<String> {
    let path = Path::new(&path);

    // Use tokio::fs::metadata for async metadata operations
    let metadata = match fs::metadata(path).await {
        Ok(m) => m,
        Err(e) if e.kind() == std::io::ErrorKind::NotFound => {
            return Err(AppError::file_not_found(path.to_string_lossy()));
        }
        Err(e) if e.kind() == std::io::ErrorKind::PermissionDenied => {
            return Err(AppError::permission_denied(path.to_string_lossy()));
        }
        Err(e) => return Err(AppError::io(e.to_string())),
    };

    // Check if it's a file
    if !metadata.is_file() {
        return Err(AppError::invalid_path(format!(
            "{} is not a file",
            path.display()
        )));
    }

    // Read file content
    let content = fs::read_to_string(path).await.map_err(|e| {
        if e.kind() == std::io::ErrorKind::PermissionDenied {
            AppError::permission_denied(path.to_string_lossy())
        } else {
            AppError::io(e.to_string())
        }
    })?;

    debug!("Read file: {}", path.display());
    Ok(content)
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
/// Returns `Ok(())` on success.
///
/// # Errors
///
/// Returns `AppError::PermissionDenied` if access is denied.
/// Returns `AppError::Io` for other IO errors.
///
/// # Example
///
/// ```rust,ignore
/// use app_notes_rust::file_service::write_file;
///
/// write_file("/path/to/file.md".to_string(), "# Hello".to_string()).await?;
/// ```
pub async fn write_file(path: String, content: String) -> Result<()> {
    let path = Path::new(&path);

    // Ensure parent directory exists
    if let Some(parent) = path.parent() {
        match fs::metadata(parent).await {
            Ok(m) if m.is_dir() => {}
            Ok(_) => {
                return Err(AppError::invalid_path(format!(
                    "{} exists but is not a directory",
                    parent.display()
                )));
            }
            Err(e) if e.kind() == std::io::ErrorKind::NotFound => {
                fs::create_dir_all(parent).await.map_err(|e| {
                    if e.kind() == std::io::ErrorKind::PermissionDenied {
                        AppError::permission_denied(parent.to_string_lossy())
                    } else {
                        AppError::io(format!("Failed to create directory: {}", e))
                    }
                })?;
            }
            Err(e) if e.kind() == std::io::ErrorKind::PermissionDenied => {
                return Err(AppError::permission_denied(parent.to_string_lossy()));
            }
            Err(e) => return Err(AppError::io(e.to_string())),
        }
    }

    // Write file content
    fs::write(path, content).await.map_err(|e| {
        if e.kind() == std::io::ErrorKind::PermissionDenied {
            AppError::permission_denied(path.to_string_lossy())
        } else {
            AppError::io(e.to_string())
        }
    })?;

    info!("Wrote file: {}", path.display());
    Ok(())
}

/// Check if a file or directory exists.
///
/// # Arguments
///
/// * `path` - Path to check.
///
/// # Returns
///
/// Returns `true` if the path exists, `false` otherwise.
pub async fn file_exists(path: String) -> Result<bool> {
    let path = Path::new(&path);
    match fs::metadata(path).await {
        Ok(_) => Ok(true),
        Err(e) if e.kind() == std::io::ErrorKind::NotFound => Ok(false),
        Err(e) if e.kind() == std::io::ErrorKind::PermissionDenied => {
            Err(AppError::permission_denied(path.to_string_lossy()))
        }
        Err(e) => Err(AppError::io(e.to_string())),
    }
}

/// Read the contents of a directory.
///
/// # Arguments
///
/// * `path` - Path to the directory.
///
/// # Returns
///
/// Returns a vector of `FileEntry` representing files and directories.
///
/// # Errors
///
/// Returns `AppError::FileNotFound` if the directory doesn't exist.
/// Returns `AppError::InvalidPath` if the path is not a directory.
/// Returns `AppError::PermissionDenied` if access is denied.
pub async fn read_directory(path: String) -> Result<Vec<FileEntry>> {
    let path = Path::new(&path);

    // Check if path exists and is a directory
    match fs::metadata(path).await {
        Ok(m) => {
            if !m.is_dir() {
                return Err(AppError::invalid_path(format!(
                    "{} is not a directory",
                    path.display()
                )));
            }
        }
        Err(e) if e.kind() == std::io::ErrorKind::NotFound => {
            return Err(AppError::file_not_found(path.to_string_lossy()));
        }
        Err(e) if e.kind() == std::io::ErrorKind::PermissionDenied => {
            return Err(AppError::permission_denied(path.to_string_lossy()));
        }
        Err(e) => return Err(AppError::io(e.to_string())),
    }

    let mut entries = vec![];
    let mut read_dir = fs::read_dir(path).await.map_err(|e| {
        if e.kind() == std::io::ErrorKind::PermissionDenied {
            AppError::permission_denied(path.to_string_lossy())
        } else {
            AppError::io(e.to_string())
        }
    })?;

    while let Some(entry) = read_dir
        .next_entry()
        .await
        .map_err(|e| AppError::io(e.to_string()))?
    {
        match FileEntry::from_tokio_entry(entry).await {
            Ok(entry) => entries.push(entry),
            Err(e) => warn!("Failed to read entry: {}", e),
        }
    }

    // Sort entries: directories first, then by name
    entries.sort_by(|a, b| match (a.is_directory, b.is_directory) {
        (true, false) => std::cmp::Ordering::Less,
        (false, true) => std::cmp::Ordering::Greater,
        _ => a.name.cmp(&b.name),
    });

    debug!(
        "Read directory {} with {} entries",
        path.display(),
        entries.len()
    );
    Ok(entries)
}

/// Create a directory and all parent directories if needed.
///
/// # Arguments
///
/// * `path` - Path to the directory to create.
///
/// # Returns
///
/// Returns `Ok(())` on success.
///
/// # Errors
///
/// Returns `AppError::PermissionDenied` if access is denied.
/// Returns `AppError::Io` for other IO errors.
pub async fn create_directory(path: String) -> Result<()> {
    let path = Path::new(&path);

    fs::create_dir_all(path).await.map_err(|e| {
        if e.kind() == std::io::ErrorKind::PermissionDenied {
            AppError::permission_denied(path.to_string_lossy())
        } else if e.kind() == std::io::ErrorKind::AlreadyExists {
            AppError::io(format!("Directory already exists: {}", path.display()))
        } else {
            AppError::io(e.to_string())
        }
    })?;

    info!("Created directory: {}", path.display());
    Ok(())
}

/// Create an empty file.
///
/// # Arguments
///
/// * `path` - Path to the file to create.
///
/// # Returns
///
/// Returns `Ok(())` on success.
///
/// # Errors
///
/// Returns `AppError::PermissionDenied` if access is denied.
/// Returns `AppError::Io` for other IO errors.
pub async fn create_file(path: String) -> Result<()> {
    let path = Path::new(&path);

    // Ensure parent directory exists
    if let Some(parent) = path.parent() {
        match fs::metadata(parent).await {
            Ok(m) if m.is_dir() => {}
            Ok(_) => {
                return Err(AppError::invalid_path(format!(
                    "{} exists but is not a directory",
                    parent.display()
                )));
            }
            Err(e) if e.kind() == std::io::ErrorKind::NotFound => {
                fs::create_dir_all(parent).await.map_err(|e| {
                    if e.kind() == std::io::ErrorKind::PermissionDenied {
                        AppError::permission_denied(parent.to_string_lossy())
                    } else {
                        AppError::io(format!("Failed to create directory: {}", e))
                    }
                })?;
            }
            Err(e) if e.kind() == std::io::ErrorKind::PermissionDenied => {
                return Err(AppError::permission_denied(parent.to_string_lossy()));
            }
            Err(e) => return Err(AppError::io(e.to_string())),
        }
    }

    // Create the file (will fail if it already exists)
    fs::File::create(path).await.map_err(|e| {
        if e.kind() == std::io::ErrorKind::PermissionDenied {
            AppError::permission_denied(path.to_string_lossy())
        } else {
            AppError::io(e.to_string())
        }
    })?;

    info!("Created file: {}", path.display());
    Ok(())
}

/// Delete a file.
///
/// # Arguments
///
/// * `path` - Path to the file to delete.
///
/// # Returns
///
/// Returns `Ok(())` on success.
///
/// # Errors
///
/// Returns `AppError::FileNotFound` if the file doesn't exist.
/// Returns `AppError::PermissionDenied` if access is denied.
/// Returns `AppError::Io` for other IO errors.
pub async fn delete_file(path: String) -> Result<()> {
    let path = Path::new(&path);

    // Check if file exists and is a file
    match fs::metadata(path).await {
        Ok(m) => {
            if !m.is_file() {
                return Err(AppError::invalid_path(format!(
                    "{} is not a file",
                    path.display()
                )));
            }
        }
        Err(e) if e.kind() == std::io::ErrorKind::NotFound => {
            return Err(AppError::file_not_found(path.to_string_lossy()));
        }
        Err(e) if e.kind() == std::io::ErrorKind::PermissionDenied => {
            return Err(AppError::permission_denied(path.to_string_lossy()));
        }
        Err(e) => return Err(AppError::io(e.to_string())),
    }

    fs::remove_file(path).await.map_err(|e| {
        if e.kind() == std::io::ErrorKind::PermissionDenied {
            AppError::permission_denied(path.to_string_lossy())
        } else {
            AppError::io(e.to_string())
        }
    })?;

    info!("Deleted file: {}", path.display());
    Ok(())
}

/// Rename (move) a file.
///
/// # Arguments
///
/// * `old_path` - Current path of the file.
/// * `new_path` - New path for the file.
///
/// # Returns
///
/// Returns `Ok(())` on success.
///
/// # Errors
///
/// Returns `AppError::FileNotFound` if the source file doesn't exist.
/// Returns `AppError::PermissionDenied` if access is denied.
/// Returns `AppError::Io` for other IO errors.
pub async fn rename_file(old_path: String, new_path: String) -> Result<()> {
    let old_path = Path::new(&old_path);
    let new_path = Path::new(&new_path);

    // Check if source exists
    match fs::metadata(old_path).await {
        Ok(_) => {}
        Err(e) if e.kind() == std::io::ErrorKind::NotFound => {
            return Err(AppError::file_not_found(old_path.to_string_lossy()));
        }
        Err(e) if e.kind() == std::io::ErrorKind::PermissionDenied => {
            return Err(AppError::permission_denied(old_path.to_string_lossy()));
        }
        Err(e) => return Err(AppError::io(e.to_string())),
    }

    // Ensure parent directory of destination exists
    if let Some(parent) = new_path.parent() {
        match fs::metadata(parent).await {
            Ok(m) if m.is_dir() => {}
            Ok(_) => {
                return Err(AppError::invalid_path(format!(
                    "{} exists but is not a directory",
                    parent.display()
                )));
            }
            Err(e) if e.kind() == std::io::ErrorKind::NotFound => {
                fs::create_dir_all(parent).await.map_err(|e| {
                    if e.kind() == std::io::ErrorKind::PermissionDenied {
                        AppError::permission_denied(parent.to_string_lossy())
                    } else {
                        AppError::io(format!("Failed to create directory: {}", e))
                    }
                })?;
            }
            Err(e) if e.kind() == std::io::ErrorKind::PermissionDenied => {
                return Err(AppError::permission_denied(parent.to_string_lossy()));
            }
            Err(e) => return Err(AppError::io(e.to_string())),
        }
    }

    fs::rename(old_path, new_path).await.map_err(|e| {
        if e.kind() == std::io::ErrorKind::PermissionDenied {
            AppError::permission_denied(old_path.to_string_lossy())
        } else {
            AppError::io(e.to_string())
        }
    })?;

    info!(
        "Renamed file from {} to {}",
        old_path.display(),
        new_path.display()
    );
    Ok(())
}

// ===== Synchronous functions for backward compatibility =====

/// Read a note file from disk.
///
/// # Arguments
///
/// * `path` - Path to the markdown file.
///
/// # Returns
///
/// Returns an `ApiResult<Note>` containing the note data or an error message.
pub fn read_note(path: String) -> ApiResult<Note> {
    match read_note_inner(&path) {
        Ok(note) => ApiResult::success(note),
        Err(e) => ApiResult::error(e.to_user_message()),
    }
}

fn read_note_inner(path: &str) -> Result<Note> {
    let path = Path::new(path);

    if !path.exists() {
        return Err(AppError::file_not_found(path.to_string_lossy()));
    }

    if !path.is_file() {
        return Err(AppError::invalid_path(format!(
            "{} is not a file",
            path.display()
        )));
    }

    let content = std::fs::read_to_string(path)?;

    // Extract title from first heading or filename
    let title = extract_title(&content, path);

    // Generate a unique ID based on the file path
    let id = format!("{:x}", md5::compute(path.to_string_lossy().as_bytes()));

    let metadata = std::fs::metadata(path)?;
    let modified_at = metadata
        .modified()
        .map(|t| {
            t.duration_since(std::time::UNIX_EPOCH)
                .unwrap_or_default()
                .as_secs() as i64
        })
        .unwrap_or(0);

    let created_at = metadata
        .created()
        .map(|t| {
            t.duration_since(std::time::UNIX_EPOCH)
                .unwrap_or_default()
                .as_secs() as i64
        })
        .unwrap_or(0);

    debug!("Read note '{}' from {}", title, path.display());

    Ok(Note {
        id,
        title,
        content,
        path: path.to_string_lossy().to_string(),
        modified_at,
        created_at,
    })
}

/// Write a note file to disk.
///
/// # Arguments
///
/// * `note` - The note to write.
///
/// # Returns
///
/// Returns an `ApiResult<()>` indicating success or failure.
pub fn write_note(note: Note) -> ApiResult<()> {
    match write_note_inner(&note) {
        Ok(()) => ApiResult::success(()),
        Err(e) => ApiResult::error(e.to_user_message()),
    }
}

fn write_note_inner(note: &Note) -> Result<()> {
    let path = Path::new(&note.path);

    // Ensure parent directory exists
    if let Some(parent) = path.parent() {
        std::fs::create_dir_all(parent)?;
    }

    std::fs::write(path, &note.content)?;

    info!("Wrote note '{}' to {}", note.title, note.path);

    Ok(())
}

/// List all markdown files in a directory.
///
/// # Arguments
///
/// * `dir_path` - Path to the directory.
///
/// # Returns
///
/// Returns an `ApiResult<Vec<Note>>` containing all notes in the directory.
pub fn list_notes(dir_path: String) -> ApiResult<Vec<Note>> {
    match list_notes_inner(&dir_path) {
        Ok(notes) => ApiResult::success(notes),
        Err(e) => ApiResult::error(e.to_user_message()),
    }
}

fn list_notes_inner(dir_path: &str) -> Result<Vec<Note>> {
    let path = Path::new(dir_path);

    if !path.exists() {
        return Err(AppError::file_not_found(dir_path));
    }

    if !path.is_dir() {
        return Err(AppError::invalid_path(format!(
            "{} is not a directory",
            dir_path
        )));
    }

    let mut notes = Vec::new();

    for entry in std::fs::read_dir(path)? {
        let entry = entry?;
        let file_path = entry.path();

        if is_markdown_file(&file_path) {
            match read_note_inner(&file_path.to_string_lossy()) {
                Ok(note) => notes.push(note),
                Err(e) => warn!("Failed to read {}: {}", file_path.display(), e),
            }
        }
    }

    // Sort by modified time, newest first
    notes.sort_by(|a, b| b.modified_at.cmp(&a.modified_at));

    debug!("Listed {} notes in {}", notes.len(), dir_path);

    Ok(notes)
}

/// List all folders in a directory.
///
/// # Arguments
///
/// * `dir_path` - Path to the directory.
///
/// # Returns
///
/// Returns an `ApiResult<Vec<Folder>>` containing all folders.
pub fn list_folders(dir_path: String) -> ApiResult<Vec<Folder>> {
    match list_folders_inner(&dir_path) {
        Ok(folders) => ApiResult::success(folders),
        Err(e) => ApiResult::error(e.to_user_message()),
    }
}

fn list_folders_inner(dir_path: &str) -> Result<Vec<Folder>> {
    let path = Path::new(dir_path);

    if !path.exists() {
        return Err(AppError::file_not_found(dir_path));
    }

    let mut folders = Vec::new();

    for entry in std::fs::read_dir(path)? {
        let entry = entry?;
        let file_path = entry.path();

        if file_path.is_dir() {
            let name = file_path
                .file_name()
                .map(|n| n.to_string_lossy().to_string())
                .unwrap_or_default();

            let id = format!("{:x}", md5::compute(file_path.to_string_lossy().as_bytes()));

            folders.push(Folder {
                id,
                name,
                path: file_path.to_string_lossy().to_string(),
            });
        }
    }

    Ok(folders)
}

/// Delete a note file.
///
/// # Arguments
///
/// * `path` - Path to the note file.
///
/// # Returns
///
/// Returns an `ApiResult<()>` indicating success or failure.
pub fn delete_note(path: String) -> ApiResult<()> {
    match delete_note_inner(&path) {
        Ok(()) => ApiResult::success(()),
        Err(e) => ApiResult::error(e.to_user_message()),
    }
}

fn delete_note_inner(path: &str) -> Result<()> {
    let path = Path::new(path);

    if !path.exists() {
        return Err(AppError::file_not_found(path.to_string_lossy()));
    }

    std::fs::remove_file(path)?;

    info!("Deleted note at {}", path.display());

    Ok(())
}

/// Check if a file is a markdown file.
fn is_markdown_file(path: &Path) -> bool {
    if !path.is_file() {
        return false;
    }

    let ext = path
        .extension()
        .and_then(|e| e.to_str())
        .map(|e| e.to_lowercase());

    matches!(
        ext.as_deref(),
        Some("md") | Some("markdown") | Some("mdown")
    )
}

/// Extract the title from markdown content.
/// Falls back to filename if no heading is found.
fn extract_title(content: &str, path: &Path) -> String {
    // Look for first H1 heading
    for line in content.lines() {
        let trimmed = line.trim();
        if let Some(title) = trimmed.strip_prefix("# ") {
            return title.to_string();
        }
    }

    // Fallback to filename without extension
    path.file_stem()
        .map(|s| s.to_string_lossy().to_string())
        .unwrap_or_else(|| "Untitled".to_string())
}

// Simple md5 hash helper
mod md5 {
    use std::collections::hash_map::DefaultHasher;
    use std::hash::{Hash, Hasher};

    pub fn compute(data: &[u8]) -> u64 {
        let mut hasher = DefaultHasher::new();
        data.hash(&mut hasher);
        hasher.finish()
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use std::io::Write;
    use tempfile::TempDir;

    // ===== Async Tests =====

    #[tokio::test]
    async fn test_read_file_success() -> anyhow::Result<()> {
        let temp_dir = TempDir::new()?;
        let file_path = temp_dir.path().join("test.txt");
        let content = "Hello, World!";
        std::fs::write(&file_path, content)?;

        let result = read_file(file_path.to_string_lossy().to_string()).await?;
        assert_eq!(result, content);

        Ok(())
    }

    #[tokio::test]
    async fn test_read_file_not_found() {
        let result = read_file("/nonexistent/path/file.txt".to_string()).await;
        assert!(matches!(result, Err(AppError::FileNotFound { .. })));
    }

    #[tokio::test]
    async fn test_read_file_not_a_file() -> anyhow::Result<()> {
        let temp_dir = TempDir::new()?;
        let result = read_file(temp_dir.path().to_string_lossy().to_string()).await;
        assert!(matches!(result, Err(AppError::InvalidPath { .. })));
        Ok(())
    }

    #[tokio::test]
    async fn test_write_file_success() -> anyhow::Result<()> {
        let temp_dir = TempDir::new()?;
        let file_path = temp_dir.path().join("test.txt");
        let content = "Test content";

        write_file(file_path.to_string_lossy().to_string(), content.to_string()).await?;

        let read_content = std::fs::read_to_string(&file_path)?;
        assert_eq!(read_content, content);

        Ok(())
    }

    #[tokio::test]
    async fn test_write_file_creates_directories() -> anyhow::Result<()> {
        let temp_dir = TempDir::new()?;
        let file_path = temp_dir.path().join("subdir").join("test.txt");
        let content = "Test content";

        write_file(file_path.to_string_lossy().to_string(), content.to_string()).await?;

        assert!(file_path.exists());
        let read_content = std::fs::read_to_string(&file_path)?;
        assert_eq!(read_content, content);

        Ok(())
    }

    #[tokio::test]
    async fn test_file_exists() -> anyhow::Result<()> {
        let temp_dir = TempDir::new()?;
        let file_path = temp_dir.path().join("test.txt");

        // File doesn't exist yet
        let exists = file_exists(file_path.to_string_lossy().to_string()).await?;
        assert!(!exists);

        // Create file
        std::fs::write(&file_path, "test")?;

        let exists = file_exists(file_path.to_string_lossy().to_string()).await?;
        assert!(exists);

        Ok(())
    }

    #[tokio::test]
    async fn test_create_directory() -> anyhow::Result<()> {
        let temp_dir = TempDir::new()?;
        let dir_path = temp_dir.path().join("new_dir").join("nested");

        create_directory(dir_path.to_string_lossy().to_string()).await?;

        assert!(dir_path.exists());
        assert!(dir_path.is_dir());

        Ok(())
    }

    #[tokio::test]
    async fn test_create_file() -> anyhow::Result<()> {
        let temp_dir = TempDir::new()?;
        let file_path = temp_dir.path().join("new_file.txt");

        create_file(file_path.to_string_lossy().to_string()).await?;

        assert!(file_path.exists());
        assert!(file_path.is_file());

        Ok(())
    }

    #[tokio::test]
    async fn test_delete_file_success() -> anyhow::Result<()> {
        let temp_dir = TempDir::new()?;
        let file_path = temp_dir.path().join("to_delete.txt");
        std::fs::write(&file_path, "test")?;

        delete_file(file_path.to_string_lossy().to_string()).await?;

        assert!(!file_path.exists());

        Ok(())
    }

    #[tokio::test]
    async fn test_delete_file_not_found() {
        let result = delete_file("/nonexistent/path/file.txt".to_string()).await;
        assert!(matches!(result, Err(AppError::FileNotFound { .. })));
    }

    #[tokio::test]
    async fn test_rename_file_success() -> anyhow::Result<()> {
        let temp_dir = TempDir::new()?;
        let old_path = temp_dir.path().join("old_name.txt");
        let new_path = temp_dir.path().join("new_name.txt");
        std::fs::write(&old_path, "test content")?;

        rename_file(
            old_path.to_string_lossy().to_string(),
            new_path.to_string_lossy().to_string(),
        )
        .await?;

        assert!(!old_path.exists());
        assert!(new_path.exists());
        assert_eq!(std::fs::read_to_string(&new_path)?, "test content");

        Ok(())
    }

    #[tokio::test]
    async fn test_rename_file_creates_directories() -> anyhow::Result<()> {
        let temp_dir = TempDir::new()?;
        let old_path = temp_dir.path().join("file.txt");
        let new_path = temp_dir.path().join("subdir").join("moved.txt");
        std::fs::write(&old_path, "test content")?;

        rename_file(
            old_path.to_string_lossy().to_string(),
            new_path.to_string_lossy().to_string(),
        )
        .await?;

        assert!(!old_path.exists());
        assert!(new_path.exists());

        Ok(())
    }

    #[tokio::test]
    async fn test_rename_file_not_found() {
        let result = rename_file(
            "/nonexistent/source.txt".to_string(),
            "/dest.txt".to_string(),
        )
        .await;
        assert!(matches!(result, Err(AppError::FileNotFound { .. })));
    }

    #[tokio::test]
    async fn test_read_directory() -> anyhow::Result<()> {
        let temp_dir = TempDir::new()?;

        // Create some files and directories
        std::fs::write(temp_dir.path().join("file1.txt"), "content1")?;
        std::fs::write(temp_dir.path().join("file2.md"), "content2")?;
        std::fs::create_dir(temp_dir.path().join("subdir"))?;

        let entries = read_directory(temp_dir.path().to_string_lossy().to_string()).await?;

        assert_eq!(entries.len(), 3);

        // Check that directories come first
        let first_entry = &entries[0];
        assert!(first_entry.is_directory);
        assert_eq!(first_entry.name, "subdir");

        Ok(())
    }

    #[tokio::test]
    async fn test_read_directory_not_found() {
        let result = read_directory("/nonexistent/directory".to_string()).await;
        assert!(matches!(result, Err(AppError::FileNotFound { .. })));
    }

    #[tokio::test]
    async fn test_read_directory_not_a_directory() -> anyhow::Result<()> {
        let temp_dir = TempDir::new()?;
        let file_path = temp_dir.path().join("not_a_dir.txt");
        std::fs::write(&file_path, "test")?;

        let result = read_directory(file_path.to_string_lossy().to_string()).await;
        assert!(matches!(result, Err(AppError::InvalidPath { .. })));

        Ok(())
    }

    #[tokio::test]
    async fn test_file_entry_metadata() -> anyhow::Result<()> {
        let temp_dir = TempDir::new()?;
        let file_path = temp_dir.path().join("test.txt");
        std::fs::write(&file_path, "test content")?;

        let entries = read_directory(temp_dir.path().to_string_lossy().to_string()).await?;

        assert_eq!(entries.len(), 1);
        let entry = &entries[0];
        assert_eq!(entry.name, "test.txt");
        assert!(!entry.is_directory);
        assert_eq!(entry.size, 12); // "test content" length
        assert!(entry.modified_time.is_some());

        Ok(())
    }

    // ===== Sync Tests (backward compatibility) =====

    #[test]
    fn test_is_markdown_file() -> anyhow::Result<()> {
        let temp_dir = TempDir::new()?;

        let md_file = temp_dir.path().join("test.md");
        std::fs::write(&md_file, "# Test")?;

        let markdown_file = temp_dir.path().join("test.markdown");
        std::fs::write(&markdown_file, "# Test")?;

        let txt_file = temp_dir.path().join("test.txt");
        std::fs::write(&txt_file, "text")?;

        assert!(is_markdown_file(&md_file));
        assert!(is_markdown_file(&markdown_file));
        assert!(!is_markdown_file(&txt_file));

        Ok(())
    }

    #[test]
    fn test_extract_title_from_heading() {
        let content = "# My Title\n\nSome content";
        let path = Path::new("test.md");
        assert_eq!(extract_title(content, path), "My Title");
    }

    #[test]
    fn test_extract_title_from_filename() {
        let content = "Some content without heading";
        let path = Path::new("/path/to/MyNote.md");
        assert_eq!(extract_title(content, path), "MyNote");
    }

    #[test]
    fn test_read_write_note() -> anyhow::Result<()> {
        let temp_dir = TempDir::new()?;
        let note_path = temp_dir.path().join("test.md");

        let note = Note {
            id: "1".to_string(),
            title: "Test".to_string(),
            content: "# Test Note\n\nContent here.".to_string(),
            path: note_path.to_string_lossy().to_string(),
            modified_at: 0,
            created_at: 0,
        };

        write_note_inner(&note)?;

        let read = read_note_inner(&note_path.to_string_lossy())?;
        assert_eq!(read.content, note.content);
        assert_eq!(read.title, "Test Note");

        Ok(())
    }

    #[test]
    fn test_list_notes() -> anyhow::Result<()> {
        let temp_dir = TempDir::new()?;

        let mut file1 = std::fs::File::create(temp_dir.path().join("note1.md"))?;
        writeln!(file1, "# Note 1")?;

        let mut file2 = std::fs::File::create(temp_dir.path().join("note2.md"))?;
        writeln!(file2, "# Note 2")?;

        std::fs::File::create(temp_dir.path().join("not_markdown.txt"))?;

        let notes = list_notes_inner(temp_dir.path().to_str().unwrap())?;
        assert_eq!(notes.len(), 2);

        Ok(())
    }
}
