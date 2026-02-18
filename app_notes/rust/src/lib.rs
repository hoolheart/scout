//! App Notes Rust Backend
//!
//! This library provides a Rust backend for the Markdown notes desktop application.
//! It uses flutter_rust_bridge for FFI communication with Flutter.

#![deny(unsafe_code)]
#![warn(missing_docs)]

pub mod api;
pub mod error;
pub mod file_service;
pub mod markdown;
pub mod watcher;

pub use api::*;
pub use error::{AppError, Result};
pub use file_service::FileEntry;

use flutter_rust_bridge::frb;
use tracing::info;

/// Initialize the Rust library.
/// This function should be called before using any other API.
///
/// # Example
///
/// ```rust
/// use app_notes_rust::initialize;
///
/// initialize();
/// ```
#[frb(sync)]
pub fn initialize() {
    // Initialize tracing subscriber for logging
    let _ = tracing_subscriber::fmt()
        .with_env_filter("app_notes_rust=info")
        .try_init();

    info!("App Notes Rust backend initialized");
}

/// Get the library version.
///
/// # Returns
///
/// Returns the version string of the library.
#[frb(sync)]
pub fn get_version() -> String {
    env!("CARGO_PKG_VERSION").to_string()
}

/// Echo a message back to the caller.
/// This is a simple test function to verify FFI connectivity.
///
/// # Arguments
///
/// * `message` - The message to echo.
///
/// # Returns
///
/// Returns the echoed message with a prefix.
///
/// # Example
///
/// ```rust
/// use app_notes_rust::echo;
///
/// let result = echo("Hello".to_string());
/// assert_eq!(result, "Echo: Hello");
/// ```
#[frb(sync)]
pub fn echo(message: String) -> String {
    format!("Echo: {}", message)
}

/// Async version of echo for testing async runtime.
///
/// # Arguments
///
/// * `message` - The message to echo.
///
/// # Returns
///
/// Returns the echoed message with an async prefix.
pub async fn echo_async(message: String) -> String {
    tokio::time::sleep(tokio::time::Duration::from_millis(10)).await;
    format!("Async Echo: {}", message)
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_echo() {
        let result = echo("test".to_string());
        assert_eq!(result, "Echo: test");
    }

    #[test]
    fn test_get_version() {
        let version = get_version();
        assert!(!version.is_empty());
        assert_eq!(version, "0.1.0");
    }

    #[tokio::test]
    async fn test_echo_async() {
        let result = echo_async("async test".to_string()).await;
        assert_eq!(result, "Async Echo: async test");
    }
}
