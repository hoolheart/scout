//! Language runtime management for multi-language OSGi framework

pub mod rust;

use crate::core::{BundleException, BundleLanguage, BundleResult, LanguageRuntime};
use std::collections::HashMap;
use std::sync::Arc;
use parking_lot::RwLock;
