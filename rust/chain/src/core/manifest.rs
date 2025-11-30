//! Bundle manifest for metadata and dependency management

use crate::core::{BundleLanguage, Version, VersionRange};
use serde::{Deserialize, Serialize};
use std::collections::HashMap;
use std::path::PathBuf;

/// Bundle manifest containing metadata and dependencies
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct BundleManifest {
    pub bundle_symbolic_name: String,
    pub bundle_version: Version,
    pub bundle_name: Option<String>,
    pub bundle_description: Option<String>,
    pub bundle_vendor: Option<String>,
    pub bundle_license: Option<String>,
    pub bundle_doc_url: Option<String>,
    pub bundle_category: Option<String>,
    pub bundle_location: PathBuf,

    // Language specification
    pub bundle_language: BundleLanguage,

    // OSGi Import-Package header equivalent
    pub import_package: Vec<PackageImport>,

    // OSGi Export-Package header equivalent
    pub export_package: Vec<PackageExport>,

    // OSGi Require-Bundle header equivalent
    pub require_bundle: Vec<BundleRequirement>,

    // OSGI Bundle-RequiredExecutionEnvironment equivalent
    pub bundle_required_execution_environment: Vec<String>,

    // Custom capabilities and requirements
    pub provide_capability: Vec<Capability>,
    pub require_capability: Vec<Requirement>,

    // Service registration
    pub service_component: Vec<ServiceComponent>,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct PackageImport {
    pub package_name: String,
    pub version_range: VersionRange,
    pub resolution: ResolutionPolicy,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct PackageExport {
    pub package_name: String,
    pub version: Version,
    pub uses: Vec<String>,
    pub include: Vec<String>,
    pub exclude: Vec<String>,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub enum ResolutionPolicy {
    Mandatory,
    Optional,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct BundleRequirement {
    pub symbolic_name: String,
    pub version_range: VersionRange,
    pub visibility: BundleVisibility,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub enum BundleVisibility {
    Private,
    Reexport,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct Capability {
    pub name: String,
    pub namespace: String,
    pub version: Version,
    pub attributes: HashMap<String, String>,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct Requirement {
    pub name: String,
    pub namespace: String,
    pub version_range: VersionRange,
    pub filter: Option<String>,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct ServiceComponent {
    pub name: String,
    pub implementation: String,
    pub service_interfaces: Vec<String>,
    pub immediate: bool,
    pub properties: HashMap<String, String>,
}

impl BundleManifest {
    /// Create a new bundle manifest with required fields
    pub fn new(
        symbolic_name: String,
        version: Version,
        language: BundleLanguage,
        location: PathBuf,
    ) -> Self {
        Self {
            bundle_symbolic_name: symbolic_name,
            bundle_version: version,
            bundle_language: language,
            bundle_location: location,
            bundle_name: None,
            bundle_description: None,
            bundle_vendor: None,
            bundle_license: None,
            bundle_doc_url: None,
            bundle_category: None,
            import_package: Vec::new(),
            export_package: Vec::new(),
            require_bundle: Vec::new(),
            bundle_required_execution_environment: Vec::new(),
            provide_capability: Vec::new(),
            require_capability: Vec::new(),
            service_component: Vec::new(),
        }
    }

    /// Parse manifest from TOML file
    pub fn from_toml(path: &std::path::Path) -> Result<Self, String> {
        let content = std::fs::read_to_string(path)
            .map_err(|e| format!("Failed to read manifest file: {}", e))?;

        toml::from_str(&content)
            .map_err(|e| format!("Failed to parse TOML manifest: {}", e))
    }

    /// Parse manifest from JSON file
    pub fn from_json(path: &std::path::Path) -> Result<Self, String> {
        let content = std::fs::read_to_string(path)
            .map_err(|e| format!("Failed to read manifest file: {}", e))?;

        serde_json::from_str(&content)
            .map_err(|e| format!("Failed to parse JSON manifest: {}", e))
    }

    /// Detect language from manifest content if not explicitly specified
    pub fn detect_language(&self) -> Result<BundleLanguage, String> {
        // Check if language is specified in required execution environment
        for env in &self.bundle_required_execution_environment {
            if let Some(lang_str) = env.strip_prefix("language:") {
                if let Some(lang) = BundleLanguage::from_str(lang_str) {
                    return Ok(lang);
                }
            }
        }

        // Auto-detect from file extension
        if let Some(ext) = self.bundle_location.extension() {
            match ext.to_str() {
                Some("so") | Some("dll") | Some("dylib") => {
                    // Could be Rust or C/C++, default to Rust for now
                    Ok(BundleLanguage::Rust)
                }
                Some("py") | Some("pyc") => Ok(BundleLanguage::Python),
                _ => Err("Cannot detect bundle language from file extension".to_string()),
            }
        } else {
            Err("No file extension found for language detection".to_string())
        }
    }

    /// Validate the manifest for required fields and consistency
    pub fn validate(&self) -> Result<(), String> {
        if self.bundle_symbolic_name.is_empty() {
            return Err("Bundle symbolic name is required".to_string());
        }

        if self.bundle_symbolic_name.contains(' ') {
            return Err("Bundle symbolic name cannot contain spaces".to_string());
        }

        // Additional validation logic can be added here
        Ok(())
    }
}

/// Default implementation for basic manifest creation
impl Default for BundleManifest {
    fn default() -> Self {
        Self::new(
            "com.example.bundle".to_string(),
            Version::new(1, 0, 0, None),
            BundleLanguage::Rust,
            PathBuf::from("bundle.rs"),
        )
    }
}
