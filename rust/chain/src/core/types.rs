//! Core types for the multi-language OSGi framework

use serde::{Deserialize, Serialize};
use std::fmt;
use uuid::Uuid;

/// Unique identifier for bundles
#[derive(Debug, Clone, Copy, PartialEq, Eq, Hash, Serialize, Deserialize)]
pub struct BundleId(pub Uuid);

impl BundleId {
    pub fn new() -> Self {
        Self(Uuid::new_v4())
    }
}

impl Default for BundleId {
    fn default() -> Self {
        Self::new()
    }
}

impl fmt::Display for BundleId {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        write!(f, "{}", self.0)
    }
}

/// Unique identifier for services
#[derive(Debug, Clone, Copy, PartialEq, Eq, Hash, Serialize, Deserialize)]
pub struct ServiceId(pub Uuid);

impl ServiceId {
    pub fn new() -> Self {
        Self(Uuid::new_v4())
    }
}

impl Default for ServiceId {
    fn default() -> Self {
        Self::new()
    }
}

impl fmt::Display for ServiceId {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        write!(f, "{}", self.0)
    }
}

/// Supported programming languages for bundles
#[derive(Debug, Clone, Copy, PartialEq, Eq, Hash, Serialize, Deserialize)]
pub enum BundleLanguage {
    Rust,
    C,
    Cpp,
    Python,
    // Extensible for future languages: Go, JavaScript, etc.
}

impl BundleLanguage {
    /// Get the file extension typically used for this language
    pub fn file_extension(&self) -> &'static str {
        match self {
            BundleLanguage::Rust => "rs",
            BundleLanguage::C => "c",
            BundleLanguage::Cpp => "cpp",
            BundleLanguage::Python => "py",
        }
    }

    /// Get the dynamic library extension for this language
    pub fn lib_extension(&self) -> &'static str {
        #[cfg(target_os = "windows")]
        return match self {
            BundleLanguage::Rust | BundleLanguage::C | BundleLanguage::Cpp => "dll",
            BundleLanguage::Python => "pyd",
        };

        #[cfg(target_os = "linux")]
        return match self {
            BundleLanguage::Rust | BundleLanguage::C | BundleLanguage::Cpp => "so",
            BundleLanguage::Python => "so",
        };

        #[cfg(target_os = "macos")]
        return match self {
            BundleLanguage::Rust | BundleLanguage::C | BundleLanguage::Cpp => "dylib",
            BundleLanguage::Python => "so",
        };
    }

    /// Parse language from string representation
    pub fn from_str(s: &str) -> Option<Self> {
        match s.to_lowercase().as_str() {
            "rust" => Some(BundleLanguage::Rust),
            "c" => Some(BundleLanguage::C),
            "cpp" | "c++" => Some(BundleLanguage::Cpp),
            "python" => Some(BundleLanguage::Python),
            _ => None,
        }
    }
}

impl fmt::Display for BundleLanguage {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        match self {
            BundleLanguage::Rust => write!(f, "Rust"),
            BundleLanguage::C => write!(f, "C"),
            BundleLanguage::Cpp => write!(f, "C++"),
            BundleLanguage::Python => write!(f, "Python"),
        }
    }
}

/// Version information following semantic versioning
#[derive(Debug, Clone, PartialEq, Eq, PartialOrd, Ord, Serialize, Deserialize)]
pub struct Version {
    pub major: u32,
    pub minor: u32,
    pub micro: u32,
    pub qualifier: Option<String>,
}

impl Version {
    pub fn new(major: u32, minor: u32, micro: u32, qualifier: Option<String>) -> Self {
        Self { major, minor, micro, qualifier }
    }

    /// Parse version from string (format: "major.minor.micro.qualifier")
    pub fn parse(version_str: &str) -> Result<Self, String> {
        let parts: Vec<&str> = version_str.split('.').collect();

        if parts.len() < 2 || parts.len() > 4 {
            return Err("Invalid version format".to_string());
        }

        let major = parts[0].parse().map_err(|_| "Invalid major version")?;
        let minor = parts[1].parse().map_err(|_| "Invalid minor version")?;
        let micro = parts.get(2).and_then(|s| s.parse().ok()).unwrap_or(0);
        let qualifier = parts.get(3).map(|s| s.to_string());

        Ok(Self { major, minor, micro, qualifier })
    }

    /// Convert to string representation
    pub fn to_string(&self) -> String {
        match &self.qualifier {
            Some(q) => format!("{}.{}.{}.{}", self.major, self.minor, self.micro, q),
            None => format!("{}.{}.{}", self.major, self.minor, self.micro),
        }
    }
}

impl fmt::Display for Version {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        write!(f, "{}", self.to_string())
    }
}

/// Version range for dependency resolution
#[derive(Debug, Clone, PartialEq, Eq, Serialize, Deserialize)]
pub struct VersionRange {
    pub start: Version,
    pub end: Option<Version>,
    pub start_inclusive: bool,
    pub end_inclusive: bool,
}

impl VersionRange {
    pub fn new(start: Version, end: Option<Version>, start_inclusive: bool, end_inclusive: bool) -> Self {
        Self { start, end, start_inclusive, end_inclusive }
    }

    /// Check if a version matches this range
    pub fn matches(&self, version: &Version) -> bool {
        let start_ok = if self.start_inclusive {
            version >= &self.start
        } else {
            version > &self.start
        };

        let end_ok = match (&self.end, self.end_inclusive) {
            (Some(end), true) => version <= end,
            (Some(end), false) => version < end,
            (None, _) => true,
        };

        start_ok && end_ok
    }
}

/// Framework state enumeration
#[derive(Debug, Clone, Copy, PartialEq, Eq, Serialize, Deserialize)]
pub enum FrameworkState {
    Inactive,
    Starting,
    Active,
    Stopping,
    Error,
}
