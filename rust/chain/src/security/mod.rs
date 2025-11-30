//! Security and sandboxing for multi-language OSGi framework

use crate::core::{BundleException, BundleLanguage, BundleResult};
use std::collections::HashMap;

/// Multi-language security manager
pub struct MultiLanguageSecurityManager {
    language_permissions: HashMap<BundleLanguage, LanguageSecurityPolicy>,
}

#[derive(Debug, Clone)]
pub struct LanguageSecurityPolicy {
    pub allowed_system_calls: Vec<String>,
    pub memory_limits: MemoryLimits,
    pub file_access_restrictions: FileAccessPolicy,
    pub network_access: bool,
    pub external_process_spawn: bool,
}

#[derive(Debug, Clone)]
pub struct MemoryLimits {
    pub max_heap_size: usize,
    pub max_stack_size: usize,
}

#[derive(Debug, Clone)]
pub struct FileAccessPolicy {
    pub read_allowed_paths: Vec<String>,
    pub write_allowed_paths: Vec<String>,
    pub restricted_paths: Vec<String>,
}

impl MultiLanguageSecurityManager {
    pub fn new() -> Self {
        // Create default security policies for each language
        let mut language_permissions = HashMap::new();

        language_permissions.insert(
            BundleLanguage::Rust,
            LanguageSecurityPolicy {
                allowed_system_calls: vec![],
                memory_limits: MemoryLimits {
                    max_heap_size: 1024 * 1024 * 1024, // 1GB
                    max_stack_size: 8 * 1024 * 1024,   // 8MB
                },
                file_access_restrictions: FileAccessPolicy {
                    read_allowed_paths: vec!["/tmp".to_string()],
                    write_allowed_paths: vec!["/tmp".to_string()],
                    restricted_paths: vec!["/etc".to_string(), "/home".to_string()],
                },
                network_access: false,
                external_process_spawn: false,
            },
        );

        // Similar policies for other languages will be added in later steps

        Self {
            language_permissions,
        }
    }

    pub fn check_permission(&self, language: BundleLanguage, permission: &str) -> BundleResult<bool> {
        let policy = self.language_permissions.get(&language)
            .ok_or_else(|| BundleException::SecurityViolation(format!("No security policy for language: {:?}", language)))?;

        // Simplified permission checking - will be enhanced in later steps
        Ok(true)
    }
}
