//! Rust language runtime implementation

use crate::core::{
    Bundle, BundleContext, BundleException, BundleLanguage, BundleManifest, BundleResult,
    LanguageRuntime, Service, ServiceReference,
};
use libloading::{Library, Symbol};
use std::any::Any;
use std::collections::HashMap;
use std::path::Path;
use std::sync::Arc;
use parking_lot::RwLock;

/// Rust language runtime
pub struct RustLanguageRuntime {
    library_cache: Arc<RwLock<HashMap<String, Library>>>,
}

impl RustLanguageRuntime {
    pub fn new() -> Self {
        Self {
            library_cache: Arc::new(RwLock::new(HashMap::new())),
        }
    }
}

impl LanguageRuntime for RustLanguageRuntime {
    fn get_language(&self) -> BundleLanguage {
        BundleLanguage::Rust
    }

    fn initialize(&mut self) -> BundleResult<()> {
        log::info!("Initializing Rust language runtime");
        // For now, just log initialization
        // In a full implementation, we'd set up any Rust-specific runtime requirements
        Ok(())
    }

    fn shutdown(&mut self) -> BundleResult<()> {
        log::info!("Shutting down Rust language runtime");
        // Clear the library cache
        self.library_cache.write().clear();
        Ok(())
    }

    fn load_bundle(&self, path: &Path, manifest: &BundleManifest) -> BundleResult<Box<dyn Bundle>> {
        log::info!("Loading Rust bundle from: {}", path.display());

        // For now, return a stub implementation
        // In Step 2, we'll implement proper Rust bundle loading
        let bundle = RustBundle::new(manifest.clone());
        Ok(Box::new(bundle))
    }

    fn create_service_proxy(&self, service_ref: &ServiceReference) -> BundleResult<Box<dyn Service>> {
        // For Rust services, we don't need a proxy - direct trait object usage
        Err(BundleException::ServiceException(
            "Direct service access for Rust bundles - no proxy needed".to_string(),
        ))
    }

    fn marshal_data(&self, data: &dyn Any) -> BundleResult<Vec<u8>> {
        // For Rust-to-Rust communication, we can use bincode
        // This will be enhanced in Step 3 with proper marshaling
        Err(BundleException::MarshalingError(
            "Rust marshaling not implemented yet".to_string(),
        ))
    }

    fn unmarshal_data(&self, data: &[u8], type_hint: &str) -> BundleResult<Box<dyn Any>> {
        // For Rust-to-Rust communication, we can use bincode
        // This will be enhanced in Step 3 with proper marshaling
        Err(BundleException::MarshalingError(
            "Rust unmarshaling not implemented yet".to_string(),
        ))
    }
}

/// Basic Rust bundle implementation (stub for Step 1)
struct RustBundle {
    bundle_id: crate::core::BundleId,
    symbolic_name: String,
    version: crate::core::Version,
    state: parking_lot::RwLock<crate::core::BundleState>,
    manifest: BundleManifest,
}

impl RustBundle {
    fn new(manifest: BundleManifest) -> Self {
        Self {
            bundle_id: crate::core::BundleId::new(),
            symbolic_name: manifest.bundle_symbolic_name.clone(),
            version: manifest.bundle_version.clone(),
            state: parking_lot::RwLock::new(crate::core::BundleState::Installed),
            manifest,
        }
    }
}

impl Bundle for RustBundle {
    fn get_bundle_id(&self) -> crate::core::BundleId {
        self.bundle_id
    }

    fn get_symbolic_name(&self) -> &str {
        &self.symbolic_name
    }

    fn get_version(&self) -> &crate::core::Version {
        &self.version
    }

    fn get_state(&self) -> crate::core::BundleState {
        *self.state.read()
    }

    fn get_language(&self) -> BundleLanguage {
        BundleLanguage::Rust
    }

    fn start(&mut self) -> BundleResult<()> {
        let mut state = self.state.write();
        if !state.is_valid_transition(crate::core::BundleState::Starting) {
            return Err(BundleException::InvalidStateTransition {
                from: *state,
                to: crate::core::BundleState::Starting,
            });
        }
        *state = crate::core::BundleState::Starting;

        // In a real implementation, we'd call the bundle activator here
        log::info!("Starting Rust bundle: {}", self.symbolic_name);

        *state = crate::core::BundleState::Active;
        Ok(())
    }

    fn stop(&mut self) -> BundleResult<()> {
        let mut state = self.state.write();
        if !state.is_valid_transition(crate::core::BundleState::Stopping) {
            return Err(BundleException::InvalidStateTransition {
                from: *state,
                to: crate::core::BundleState::Stopping,
            });
        }
        *state = crate::core::BundleState::Stopping;

        // In a real implementation, we'd call the bundle activator here
        log::info!("Stopping Rust bundle: {}", self.symbolic_name);

        *state = crate::core::BundleState::Resolved;
        Ok(())
    }

    fn update(&mut self) -> BundleResult<()> {
        // Stub implementation for Step 1
        log::info!("Updating Rust bundle: {}", self.symbolic_name);
        Ok(())
    }

    fn uninstall(&mut self) -> BundleResult<()> {
        // Stub implementation for Step 1
        log::info!("Uninstalling Rust bundle: {}", self.symbolic_name);
        Ok(())
    }

    fn get_bundle_context(&self) -> Option<Box<dyn BundleContext>> {
        // Stub implementation for Step 1
        None
    }
}
