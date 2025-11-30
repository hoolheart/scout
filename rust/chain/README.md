# Chain - Multi-Language OSGi Framework

A Rust implementation of an OSGi-compliant modular framework that supports bundles written in multiple programming languages including Rust, C/C++, and Python.

## Overview

This framework extends the traditional OSGi (Open Service Gateway Initiative) specification to support multi-language interoperability, allowing developers to create modular applications where components can be written in different programming languages while maintaining seamless communication and service discovery.

## Features

### Core Capabilities
- **Multi-Language Support**: Native support for Rust, C/C++, and Python bundles
- **Cross-Language Service Registry**: Unified service discovery across language boundaries
- **Dynamic Module System**: Hot-deployment of bundles with full lifecycle management
- **Service-Oriented Architecture**: Loose coupling through service interfaces
- **Version Management**: Support for multiple versions of bundles and services

### Language Integration
- **Rust Bundles**: Native dynamic libraries with trait-based service interfaces
- **C/C++ Bundles**: C ABI-compatible libraries with standardized interfaces
- **Python Bundles**: Python modules with class-based service implementations
- **Extensible Architecture**: Easy to add support for additional languages

### Advanced Features
- **Data Marshaling**: Multiple serialization formats (Bincode, CBOR, JSON, MessagePack, Protobuf)
- **Security & Sandboxing**: Language-specific security policies and isolated execution
- **Performance Optimization**: Intelligent caching and hot-path detection
- **Cross-Platform**: Works on Linux, Windows, and macOS

## Project Structure

```
chain/
├── src/
│   ├── core/           # Core types, traits, and error handling
│   ├── bundle/         # Bundle implementations for different languages
│   ├── service/        # Service registry and management
│   ├── marshaling/     # Cross-language data serialization
│   ├── language/       # Language-specific runtime implementations
│   ├── security/       # Security and sandboxing
│   └── main.rs         # Example usage and demo
├── Cargo.toml          # Project dependencies
└── README.md           # This file
```

## Quick Start

### Basic Usage

```rust
use chain::{MultiLanguageOSGiFramework, FrameworkConfig};

fn main() -> Result<(), Box<dyn std::error::Error>> {
    // Configure the framework
    let config = FrameworkConfig {
        bundle_directories: vec![PathBuf::from("bundles")],
        auto_start: true,
        sandbox_enabled: true,
        ..Default::default()
    };

    // Create and start the framework
    let mut framework = MultiLanguageOSGiFramework::new(config)?;
    framework.start()?;

    // Install bundles (language auto-detected)
    let bundle_id = framework.install_bundle(PathBuf::from("bundles/my_bundle.so"))?;

    // Use services across language boundaries
    let service_refs = framework.get_service_references("MyService", None)?;
    for ref_ in service_refs {
        let service = framework.get_service_cross_language(&ref_, BundleLanguage::Rust)?;
        // Use service regardless of implementation language
    }

    // Stop the framework
    framework.stop()?;
    Ok(())
}
```

### Creating a Rust Bundle

```rust
use chain::{Bundle, BundleContext, BundleLanguage, Service};

// Define your service trait
pub trait CalculatorService: Service {
    fn add(&self, a: i32, b: i32) -> i32;
}

// Implement the bundle
pub struct MyBundle {
    bundle_id: BundleId,
    symbolic_name: String,
    // ... other fields
}

impl Bundle for MyBundle {
    fn get_bundle_id(&self) -> BundleId { self.bundle_id }
    fn get_symbolic_name(&self) -> &str { &self.symbolic_name }
    fn get_language(&self) -> BundleLanguage { BundleLanguage::Rust }
    // ... implement other required methods
}
```

## Development Plan

This project follows a structured 7-step development plan:

### ✅ Step 1: Core Multi-Language Infrastructure (COMPLETED)
- Enhanced Bundle trait with language support
- BundleLanguage enum and language detection system
- LanguageRuntime trait and base runtime structure
- MultiLanguageOSGiFramework core structure

### ⏳ Step 2: Rust Language Runtime Implementation (Next)
- Full RustLanguageRuntime implementation
- Dynamic library loading and symbol resolution
- Rust bundle activator integration
- Service registration and discovery

### ⏳ Step 3: Data Marshaling and Serialization System
- Multiple serialization format support (Bincode, CBOR, JSON, MessagePack, Protobuf)
- Intelligent format selection for language pairs
- Cross-language type conversion system

### ⏳ Step 4: C/C++ Language Runtime Implementation
- C/C++ language runtime with FFI integration
- C bundle interface definitions
- Cross-language service proxy implementation

### ⏳ Step 5: Python Language Runtime Implementation
- Python interpreter integration
- Python bundle interface system
- Python C API integration for service access

### ⏳ Step 6: Cross-Language Service Registry and Security
- Enhanced service registry with cross-language support
- Language-specific security policies and sandboxing
- Permission management and audit logging

### ⏳ Step 7: Integration, Testing, and Documentation
- Comprehensive test suite for all language combinations
- Performance benchmarks and optimization
- Complete documentation and examples

## Architecture

### Core Components

1. **MultiLanguageOSGiFramework**: Main framework orchestrator
2. **LanguageRuntime**: Language-specific bundle management
3. **ServiceRegistry**: Cross-language service discovery
4. **MarshalingEngine**: Data serialization for inter-language communication
5. **SecurityManager**: Language-specific security policies

### Key Traits

- `Bundle`: Core bundle interface with language support
- `LanguageRuntime`: Language-specific runtime management
- `Service`: Base service interface for all services
- `BundleContext`: Provides framework services to bundles
- `BundleActivator`: Bundle lifecycle management

## Dependencies

- **serde**: Serialization framework
- **libloading**: Dynamic library loading
- **parking_lot**: High-performance synchronization primitives
- **dashmap**: Concurrent HashMap implementation
- **uuid**: Unique identifier generation
- **thiserror**: Error handling

## Building and Running

```bash
# Build the project
cargo build

# Run the example
cargo run

# Run tests
cargo test

# Run with logging
RUST_LOG=info cargo run
```

## Current Status

This project implements **Step 1** of the development plan. The core infrastructure is in place with:

- ✅ Complete type system with language support
- ✅ Error handling and state management
- ✅ Basic framework structure
- ✅ Rust language runtime stub
- ✅ Service registry stub
- ✅ Security framework stub

The framework can be instantiated and started, but full bundle loading and cross-language features will be implemented in subsequent steps.

## Contributing

This is a development project following a specific implementation plan. Contributions should align with the established architecture and development roadmap.

## License

This project is part of a research and development initiative for multi-language modular frameworks.
