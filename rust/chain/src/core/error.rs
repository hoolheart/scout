//! Error types for the multi-language OSGi framework

use thiserror::Error;
use std::path::PathBuf;

/// Main error type for bundle operations
#[derive(Error, Debug)]
pub enum BundleException {
    #[error("Failed to load bundle: {0}")]
    LoadFailed(String),

    #[error("Bundle symbol not found: {0}")]
    SymbolNotFound(String),

    #[error("Invalid bundle state transition: from {from:?} to {to:?}")]
    InvalidStateTransition { from: BundleState, to: BundleState },

    #[error("Missing package: {package} with version {version_range}")]
    MissingPackage { package: String, version_range: String },

    #[error("Missing bundle: {symbolic_name} with version {version_range}")]
    MissingBundle { symbolic_name: String, version_range: String },

    #[error("Missing capability: {capability}")]
    MissingCapability { capability: String },

    #[error("Incompatible version: expected {expected}, found {found}")]
    IncompatibleVersion { expected: String, found: String },

    #[error("Security violation: {0}")]
    SecurityViolation(String),

    #[error("Service exception: {0}")]
    ServiceException(String),

    #[error("Framework exception: {0}")]
    FrameworkException(String),

    #[error("IO error: {0}")]
    Io(#[from] std::io::Error),

    #[error("Unsupported language: {0}")]
    UnsupportedLanguage(String),

    #[error("Language detection failed: {0}")]
    LanguageDetectionFailed(String),

    #[error("Marshaling error: {0}")]
    MarshalingError(String),

    #[error("Cross-language error: {original_error} -> {translated_message} ({source_language} to {target_language})")]
    CrossLanguageError {
        original_error: String,
        translated_message: String,
        source_language: String,
        target_language: String,
        severity: String,
    },

    #[error("Method not found: {0}")]
    MethodNotFound(String),

    #[error("Unsupported language string: {0}")]
    UnsupportedLanguageString(String),
}

/// Result type alias for bundle operations
pub type BundleResult<T> = Result<T, BundleException>;

/// Bundle state enumeration
#[derive(Debug, Clone, Copy, PartialEq, Eq, serde::Serialize, serde::Deserialize)]
pub enum BundleState {
    Uninstalled = 0,
    Installed = 1,
    Resolved = 2,
    Starting = 3,
    Active = 4,
    Stopping = 5,
}

impl BundleState {
    /// Check if a state transition is valid
    pub fn is_valid_transition(&self, new_state: BundleState) -> bool {
        match (*self, new_state) {
            (BundleState::Uninstalled, BundleState::Installed) => true,
            (BundleState::Installed, BundleState::Resolved) => true,
            (BundleState::Installed, BundleState::Uninstalled) => true,
            (BundleState::Resolved, BundleState::Installed) => true,
            (BundleState::Resolved, BundleState::Starting) => true,
            (BundleState::Resolved, BundleState::Uninstalled) => true,
            (BundleState::Starting, BundleState::Active) => true,
            (BundleState::Starting, BundleState::Stopping) => true,
            (BundleState::Active, BundleState::Stopping) => true,
            (BundleState::Stopping, BundleState::Resolved) => true,
            _ => false,
        }
    }
}
