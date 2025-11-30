//! Bundle trait and related types for the multi-language OSGi framework

use crate::core::{BundleException, BundleId, BundleLanguage, BundleState, BundleResult, Version};
use std::any::Any;
use std::collections::HashMap;
use std::path::Path;

/// Bundle context trait - provides access to framework services
pub trait BundleContext: Send + Sync {
    /// Get the bundle associated with this context
    fn get_bundle(&self) -> &dyn Bundle;

    /// Register a service with the framework (simplified for Step 1)
    fn register_service(
        &self,
        service_name: &str,
        properties: HashMap<String, String>,
    ) -> BundleResult<ServiceRegistration>;

    /// Get a service reference by class name
    fn get_service_reference(&self, class_name: &str) -> Option<ServiceReference>;

    /// Get multiple service references with optional filter
    fn get_service_references(
        &self,
        class_name: &str,
        filter: Option<&str>,
    ) -> Vec<ServiceReference>;

    /// Get the actual service instance from a reference (simplified for Step 1)
    fn get_service(&self, reference: &ServiceReference) -> Option<Box<dyn Service>>;
}

/// Service trait - base interface for all services
pub trait Service: Send + Sync {
    /// Get service properties for discovery and filtering
    fn get_service_properties(&self) -> HashMap<String, String>;

    /// Get the service interface name (typically the trait name)
    fn get_service_interface(&self) -> &'static str {
        std::any::type_name::<Self>()
    }
}

/// Bundle activator trait - lifecycle management for bundles
pub trait BundleActivator: Send + Sync {
    /// Called when the bundle is started
    fn start(&mut self, context: Box<dyn BundleContext>) -> BundleResult<()>;

    /// Called when the bundle is stopped
    fn stop(&mut self, context: Box<dyn BundleContext>) -> BundleResult<()>;
}

/// Main Bundle trait - core interface for all bundles
pub trait Bundle: Send + Sync {
    /// Get the unique bundle identifier
    fn get_bundle_id(&self) -> BundleId;

    /// Get the symbolic name of the bundle
    fn get_symbolic_name(&self) -> &str;

    /// Get the version of the bundle
    fn get_version(&self) -> &Version;

    /// Get the current state of the bundle
    fn get_state(&self) -> BundleState;

    /// Get the programming language of the bundle
    fn get_language(&self) -> BundleLanguage;

    /// Start the bundle
    fn start(&mut self) -> BundleResult<()>;

    /// Stop the bundle
    fn stop(&mut self) -> BundleResult<()>;

    /// Update the bundle
    fn update(&mut self) -> BundleResult<()>;

    /// Uninstall the bundle
    fn uninstall(&mut self) -> BundleResult<()>;

    /// Get the bundle context
    fn get_bundle_context(&self) -> Option<Box<dyn BundleContext>>;
}

/// Service registration information
#[derive(Debug, Clone)]
pub struct ServiceRegistration {
    pub service_id: crate::core::ServiceId,
    pub bundle_id: BundleId,
    pub service_name: String,
    pub properties: HashMap<String, String>,
    pub language: BundleLanguage,
}

/// Service reference for looking up services
#[derive(Debug, Clone)]
pub struct ServiceReference {
    pub service_id: crate::core::ServiceId,
    pub bundle_id: BundleId,
    pub service_name: String,
    pub properties: HashMap<String, String>,
    pub language: BundleLanguage,
}

/// Bundle event types
#[derive(Debug, Clone)]
pub enum BundleEvent {
    Installed(BundleId),
    Resolved(BundleId),
    Starting(BundleId),
    Started(BundleId),
    Stopping(BundleId),
    Stopped(BundleId),
    Updated(BundleId),
    Uninstalled(BundleId),
}

/// Service event types
#[derive(Debug, Clone)]
pub enum ServiceEvent {
    Registered(ServiceReference),
    Modified(ServiceReference),
    Unregistering(ServiceReference),
}

/// Language runtime trait - manages bundles of a specific programming language
pub trait LanguageRuntime: Send + Sync {
    /// Get the language this runtime supports
    fn get_language(&self) -> BundleLanguage;

    /// Initialize the language runtime
    fn initialize(&mut self) -> BundleResult<()>;

    /// Shutdown the language runtime
    fn shutdown(&mut self) -> BundleResult<()>;

    /// Load a bundle using this runtime
    fn load_bundle(&self, path: &Path, manifest: &crate::core::BundleManifest) -> BundleResult<Box<dyn Bundle>>;

    /// Create a service proxy for cross-language access
    fn create_service_proxy(&self, service_ref: &ServiceReference) -> BundleResult<Box<dyn Service>>;

    /// Marshal data to a format suitable for this language
    fn marshal_data(&self, data: &dyn Any) -> BundleResult<Vec<u8>>;

    /// Unmarshal data from a format suitable for this language
    fn unmarshal_data(&self, data: &[u8], type_hint: &str) -> BundleResult<Box<dyn Any>>;
}
