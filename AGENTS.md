# AGENTS.md - Agentic Coding Guidelines

This file provides guidelines for AI agents operating in the `app_notes/` directory - a Flutter + Rust Markdown desktop application.

---

## Project Overview

- **Type**: Cross-platform Desktop Application (Flutter + Rust)
- **Location**: `/home/hzhou/workspace/scout/app_notes/`
- **Tech Stack**: Flutter Desktop, Riverpod, flutter_rust_bridge, Rust (tokio, pulldown-cmark)
- **Platforms**: Windows, macOS, Linux

---

## Build Commands

### Flutter (Frontend)

```bash
cd /home/hzhou/workspace/scout/app_notes

# Install dependencies
flutter pub get

# Run code generation (required after model/state changes)
dart run build_runner build --delete-conflicting-outputs

# Run a single test
flutter test test/models_test.dart
flutter test test/state_test.dart
flutter test --name "EditorState"
flutter test test/services/file_service_test.dart

# Run tests with coverage
flutter test --coverage

# Analyze code (lint)
flutter analyze
flutter analyze lib/
flutter analyze lib/state/editor_state.dart

# Build for release
flutter build linux --release
flutter build macos --release
flutter build windows --release
```

### Rust (Backend)

```bash
cd /home/hzhou/workspace/scout/app_notes/rust

# Build
cargo build
cargo build --release

# Run tests
cargo test
cargo test file_service
cargo test markdown

# Format code
cargo fmt
cargo fmt --check

# Lint
cargo clippy -- -D warnings

# Documentation
cargo doc --no-deps
```

---

## Code Style Guidelines

### Flutter/Dart

#### Imports
- Use **package imports** for internal code: `import 'package:app_notes/models/file_entry.dart';`
- Use **relative imports** within the same package when appropriate
- Group imports: `dart:` first, then `package:`, then relative
- Sort imports alphabetically within groups

#### Formatting
- Use **2 spaces** for indentation
- Maximum line length: **80 characters** (soft limit 100)
- Use trailing commas for better diffs
- Always use `const` constructors when possible

#### Types
- Prefer **strong typing** - avoid `dynamic` when possible
- Use `late` for lazy initialization
- Use `sealed` classes for exhaustive pattern matching
- Prefer **immutable** data classes (Freezed)

#### Naming Conventions
- **Classes/Enums**: `CamelCase` (e.g., `EditorState`)
- **Methods/Variables**: `camelCase` (e.g., `updateContent`)
- **Constants**: `kCamelCase` (e.g., `kDefaultFontSize`)
- **Files**: `snake_case` (e.g., `editor_state.dart`)
- **Booleans**: Use prefixes like `is`, `has`, `can` (e.g., `isDirty`, `hasError`)

#### Error Handling
- Use **Result types** or try-catch for recoverable errors
- Display user-friendly error messages in UI
- Log errors for debugging: `debugPrint()` or `logger`
- Never swallow exceptions silently

#### Riverpod/State
- Use `@riverpod` annotations for code generation
- Use `@override` for `build()` methods
- Use `ref.watch()` for reactive UI, `ref.read()` for one-time reads
- Prefer `select()` to minimize rebuilds

---

### Rust

#### Imports
- Use `use` for bringing items into scope
- Group by crate: `std::`, `tokio::`, `crate::`
- Prefer absolute paths for public API

#### Formatting
- Use **4 spaces** for indentation (Rust standard)
- Follow `cargo fmt` output
- Maximum line length: **100 characters**

#### Types
- Use `&str` for string slices, `String` for owned strings
- Use `&[T]` for slices, `Vec<T>` for owned vectors
- Prefer `Option<T>` over null values
- Use `Result<T, E>` for error handling

#### Naming Conventions
- **Snake case** for variables and functions: `read_file`
- **CamelCase** for types and traits: `FileEntry`
- **SCREAMING_SNAKE** for constants: `MAX_FILE_SIZE`
- **CamelCase** for enums variants: `FileNotFound`

#### Error Handling
- Use `thiserror` for error enum definitions
- Use `anyhow` for application-level error handling
- Always handle `Result` types explicitly
- Provide user-friendly error messages

#### Async
- Use `tokio::fs` for async file operations
- Use `#[tokio::main]` for async main functions
- Avoid blocking operations in async context

---

## Architecture

```
app_notes/
├── lib/
│   ├── main.dart           # Entry point
│   ├── app.dart            # App configuration
│   ├── models/             # Data models (Freezed)
│   ├── state/              # Riverpod state management
│   ├── services/           # Business logic services
│   ├── ui/
│   │   ├── layout/        # Page layouts
│   │   ├── widgets/       # Reusable widgets
│   │   └── shortcuts/     # Keyboard shortcuts
│   └── src/rust/          # Generated FFI bindings
├── rust/
│   ├── src/
│   │   ├── lib.rs         # FFI exports
│   │   ├── api.rs         # API definitions
│   │   ├── error.rs       # Error types
│   │   ├── file_service.rs
│   │   ├── markdown.rs
│   │   └── watcher.rs
│   └── Cargo.toml
├── test/                   # Unit tests
└── pubspec.yaml
```

---

## Key Patterns

### FFI (Rust ↔ Flutter)
- Rust functions use `#[frb]` or `#[frb(sync)]` annotations
- Flutter calls through generated `NativeImpl` class
- Errors are converted to strings for FFI

### State Management
- AppState: Global app configuration
- WorkspaceState: Current workspace and file tree
- EditorState: Open files and editing state
- PreviewState: Preview panel visibility

### File Operations
- All file I/O goes through Rust backend via FFI
- FileService wraps FFI calls with Dart-friendly API
- Operations are async using Riverpod

---

## Testing

### Unit Tests
- Place in `test/` directory mirroring `lib/` structure
- Use `flutter_test` and `riverpod_test`
- Test state changes, not UI rendering
- Use `ProviderContainer` for Riverpod testing

### Naming
- `test/models_test.dart` - Model tests
- `test/state_test.dart` - State management tests
- `test/services/xxx_test.dart` - Service tests
- `test/ui/xxx_test.dart` - Widget tests

### Best Practices
- Test one thing per test case
- Use descriptive test names: `test('should save file when content changes')`
- Mock external dependencies
- Assert on relevant fields only

---

## Common Tasks

### Adding a New Model
1. Create `lib/models/xxx.dart` using Freezed
2. Run: `dart run build_runner build`
3. Import and use in state/services

### Adding a New State
1. Create `lib/state/xxx_state.dart` with `@riverpod` annotation
2. Define state class with Freezed
3. Run code generation
4. Add provider to `lib/state/state.dart`

### Adding Rust API
1. Define function in `rust/src/api.rs` with `#[frb]` annotation
2. Implement in appropriate module (file_service.rs, markdown.rs, etc.)
3. Run: `flutter_rust_bridge_codegen generate`
4. Wrap in Dart service layer

---

## Dependencies

### Adding Flutter Package
```bash
flutter pub add package_name
# Or manually add to pubspec.yaml, then:
flutter pub get
dart run build_runner build --delete-conflicting-outputs
```

### Adding Rust Crate
```bash
# Add to rust/Cargo.toml
cargo fetch
cargo build
```

---

## CI/CD

The project uses standard Flutter/Rust tooling. Ensure:
- All tests pass before merging
- `flutter analyze` shows no errors
- `cargo fmt` and `cargo clippy` pass
- Build succeeds on target platforms

---

## Notes

- This project uses **very_good_analysis** for strict linting
- Generated code (`.g.dart`, `.freezed.dart`) should not be edited manually
- FFI bindings are auto-generated - do not modify `lib/src/rust/` manually
- Use `debugPrint()` for logging in debug mode
