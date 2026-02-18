//! Error handling for the app notes library.
//!
//! This module defines all the error types used throughout the library
//! and provides conversions to user-friendly error messages.
//!
//! All errors can be serialized to JSON for communication with Flutter.

use serde::{Deserialize, Serialize};
use thiserror::Error;

/// The main error type for the app notes library.
#[derive(Error, Debug, Clone, PartialEq, Serialize, Deserialize)]
pub enum AppError {
    /// IO error (file operations).
    #[error("IO error: {message}")]
    #[serde(rename = "IoError")]
    Io {
        /// Error message describing the IO failure.
        message: String,
    },

    /// File not found.
    #[error("File not found: {path}")]
    #[serde(rename = "FileNotFound")]
    FileNotFound {
        /// Path to the file that was not found.
        path: String,
    },

    /// Permission denied.
    #[error("Permission denied: {path}")]
    #[serde(rename = "PermissionDenied")]
    PermissionDenied {
        /// Path to the file/directory that access was denied to.
        path: String,
    },

    /// Invalid path.
    #[error("Invalid path: {path}")]
    #[serde(rename = "InvalidPath")]
    InvalidPath {
        /// The invalid path.
        path: String,
    },

    /// Parse error (markdown parsing).
    #[error("Parse error: {message}")]
    #[serde(rename = "ParseError")]
    Parse {
        /// Error message describing the parse failure.
        message: String,
    },

    /// Serialization error.
    #[error("Serialization error: {message}")]
    #[serde(rename = "SerializeError")]
    Serialization {
        /// Error message describing the serialization failure.
        message: String,
    },

    /// Configuration error.
    #[error("Configuration error: {message}")]
    #[serde(rename = "ConfigError")]
    Config {
        /// Error message describing the configuration error.
        message: String,
    },

    /// Watcher error (file system watcher).
    #[error("Watcher error: {message}")]
    #[serde(rename = "WatchError")]
    Watcher {
        /// Error message describing the watcher failure.
        message: String,
    },

    /// General error with a message.
    #[error("Error: {message}")]
    #[serde(rename = "OtherError")]
    Other {
        /// Generic error message.
        message: String,
    },
}

impl AppError {
    /// Create a new IO error.
    pub fn io(message: impl Into<String>) -> Self {
        Self::Io {
            message: message.into(),
        }
    }

    /// Create a new file not found error.
    pub fn file_not_found(path: impl Into<String>) -> Self {
        Self::FileNotFound { path: path.into() }
    }

    /// Create a new permission denied error.
    pub fn permission_denied(path: impl Into<String>) -> Self {
        Self::PermissionDenied { path: path.into() }
    }

    /// Create a new invalid path error.
    pub fn invalid_path(path: impl Into<String>) -> Self {
        Self::InvalidPath { path: path.into() }
    }

    /// Create a new parse error.
    pub fn parse(message: impl Into<String>) -> Self {
        Self::Parse {
            message: message.into(),
        }
    }

    /// Create a new serialization error.
    pub fn serialization(message: impl Into<String>) -> Self {
        Self::Serialization {
            message: message.into(),
        }
    }

    /// Create a new configuration error.
    pub fn config(message: impl Into<String>) -> Self {
        Self::Config {
            message: message.into(),
        }
    }

    /// Create a new watcher error.
    pub fn watcher(message: impl Into<String>) -> Self {
        Self::Watcher {
            message: message.into(),
        }
    }

    /// Create a new general error.
    pub fn other(message: impl Into<String>) -> Self {
        Self::Other {
            message: message.into(),
        }
    }

    /// Get the error code for this error type.
    pub fn code(&self) -> &'static str {
        match self {
            Self::Io { .. } => "IO_ERROR",
            Self::FileNotFound { .. } => "FILE_NOT_FOUND",
            Self::PermissionDenied { .. } => "PERMISSION_DENIED",
            Self::InvalidPath { .. } => "INVALID_PATH",
            Self::Parse { .. } => "PARSE_ERROR",
            Self::Serialization { .. } => "SERIALIZATION_ERROR",
            Self::Config { .. } => "CONFIG_ERROR",
            Self::Watcher { .. } => "WATCHER_ERROR",
            Self::Other { .. } => "OTHER_ERROR",
        }
    }

    /// Convert to a user-friendly error message.
    pub fn to_user_message(&self) -> String {
        match self {
            Self::FileNotFound { path } => {
                format!(
                    "The file '{}' could not be found. Please check the path and try again.",
                    path
                )
            }
            Self::PermissionDenied { path } => {
                format!(
                    "Permission denied accessing '{}'. Please check your permissions.",
                    path
                )
            }
            Self::Io { message } => {
                format!("An error occurred while accessing the file: {}", message)
            }
            Self::InvalidPath { path } => {
                format!(
                    "The path '{}' is not valid. Please provide a valid file path.",
                    path
                )
            }
            Self::Serialization { message } => {
                format!("Failed to serialize/deserialize data: {}", message)
            }
            Self::Watcher { message } => {
                format!("File watcher error: {}", message)
            }
            _ => self.to_string(),
        }
    }

    /// Serialize the error to JSON string for Flutter communication.
    pub fn to_json(&self) -> String {
        serde_json::to_string(self).unwrap_or_else(|_| format!("{{\"error\":\"{}\"}}", self))
    }

    /// Create an error from a JSON string (for Flutter communication).
    pub fn from_json(json: &str) -> std::result::Result<Self, serde_json::Error> {
        serde_json::from_str(json)
    }
}

/// Result type alias for the app notes library.
pub type Result<T> = std::result::Result<T, AppError>;

impl From<std::io::Error> for AppError {
    fn from(err: std::io::Error) -> Self {
        match err.kind() {
            std::io::ErrorKind::NotFound => Self::FileNotFound {
                path: err.to_string(),
            },
            std::io::ErrorKind::PermissionDenied => Self::PermissionDenied {
                path: err.to_string(),
            },
            std::io::ErrorKind::InvalidInput => Self::InvalidPath {
                path: err.to_string(),
            },
            _ => Self::Io {
                message: err.to_string(),
            },
        }
    }
}

impl From<serde_json::Error> for AppError {
    fn from(err: serde_json::Error) -> Self {
        Self::Serialization {
            message: err.to_string(),
        }
    }
}

impl From<anyhow::Error> for AppError {
    fn from(err: anyhow::Error) -> Self {
        Self::Other {
            message: err.to_string(),
        }
    }
}

impl AppError {
    /// Get the error category for grouping similar errors.
    pub fn category(&self) -> ErrorCategory {
        match self {
            Self::Io { .. } | Self::FileNotFound { .. } | Self::PermissionDenied { .. } => {
                ErrorCategory::Io
            }
            Self::Serialization { .. } | Self::Parse { .. } => ErrorCategory::Data,
            Self::InvalidPath { .. } | Self::Config { .. } => ErrorCategory::Configuration,
            Self::Watcher { .. } => ErrorCategory::Runtime,
            Self::Other { .. } => ErrorCategory::Unknown,
        }
    }

    /// Check if this error is recoverable (user can retry).
    pub fn is_recoverable(&self) -> bool {
        matches!(self, Self::Io { .. } | Self::Watcher { .. })
    }
}

/// Error categories for grouping.
#[derive(Debug, Clone, Copy, PartialEq, Eq, Serialize, Deserialize)]
pub enum ErrorCategory {
    /// IO-related errors.
    #[serde(rename = "io")]
    Io,
    /// Data processing errors.
    #[serde(rename = "data")]
    Data,
    /// Configuration errors.
    #[serde(rename = "configuration")]
    Configuration,
    /// Runtime errors.
    #[serde(rename = "runtime")]
    Runtime,
    /// Unknown errors.
    #[serde(rename = "unknown")]
    Unknown,
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_error_display() {
        let err = AppError::io("permission denied");
        assert_eq!(err.to_string(), "IO error: permission denied");
    }

    #[test]
    fn test_error_code() {
        let err = AppError::file_not_found("/test.md");
        assert_eq!(err.code(), "FILE_NOT_FOUND");

        let err = AppError::io("error");
        assert_eq!(err.code(), "IO_ERROR");

        let err = AppError::permission_denied("/test.md");
        assert_eq!(err.code(), "PERMISSION_DENIED");

        let err = AppError::watcher("watch failed");
        assert_eq!(err.code(), "WATCHER_ERROR");
    }

    #[test]
    fn test_user_message() {
        let err = AppError::file_not_found("/test.md");
        let msg = err.to_user_message();
        assert!(msg.contains("could not be found"));

        let err = AppError::permission_denied("/test.md");
        let msg = err.to_user_message();
        assert!(msg.contains("Permission denied"));

        let err = AppError::serialization("json error");
        let msg = err.to_user_message();
        assert!(msg.contains("serialize"));
    }

    #[test]
    fn test_from_io_error() {
        let io_err = std::io::Error::new(std::io::ErrorKind::NotFound, "not found");
        let app_err: AppError = io_err.into();
        assert!(matches!(app_err, AppError::FileNotFound { .. }));

        let io_err = std::io::Error::new(std::io::ErrorKind::PermissionDenied, "no access");
        let app_err: AppError = io_err.into();
        assert!(matches!(app_err, AppError::PermissionDenied { .. }));
    }

    #[test]
    fn test_from_json_error() {
        let json_result: std::result::Result<serde_json::Value, _> =
            serde_json::from_str("invalid json");
        if let Err(e) = json_result {
            let app_err: AppError = e.into();
            assert!(matches!(app_err, AppError::Serialization { .. }));
        }
    }

    #[test]
    fn test_error_json_serialization() {
        let err = AppError::file_not_found("/test.md");
        let json = err.to_json();
        assert!(json.contains("FileNotFound"));
        assert!(json.contains("/test.md"));

        // Deserialize back
        let deserialized = AppError::from_json(&json).unwrap();
        assert_eq!(err, deserialized);
    }

    #[test]
    fn test_error_json_all_variants() {
        let errors = vec![
            AppError::io("io error"),
            AppError::file_not_found("/path"),
            AppError::permission_denied("/path"),
            AppError::invalid_path("/path"),
            AppError::parse("parse error"),
            AppError::serialization("json error"),
            AppError::config("config error"),
            AppError::watcher("watch error"),
            AppError::other("other error"),
        ];

        for err in errors {
            let json = err.to_json();
            let deserialized = AppError::from_json(&json).unwrap();
            assert_eq!(err, deserialized, "Failed for error: {:?}", err);
        }
    }

    #[test]
    fn test_permission_denied_helper() {
        let err = AppError::permission_denied("/secret.md");
        assert!(matches!(err, AppError::PermissionDenied { path } if path == "/secret.md"));
    }
}
