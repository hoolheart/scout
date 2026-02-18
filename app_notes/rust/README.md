# App Notes Rust Backend

Rust backend for the Markdown notes desktop application using flutter_rust_bridge.

## Project Structure

```
rust/
├── Cargo.toml          # Rust dependencies and configuration
├── src/
│   ├── lib.rs          # FFI export entry point
│   ├── api.rs          # Public API definitions
│   ├── error.rs        # Error handling
│   ├── file_service.rs # File system service
│   ├── markdown.rs     # Markdown processing
│   └── watcher.rs      # File system watcher
└── tests/              # Integration tests
```

## Prerequisites

- Rust 1.70+ (install from [rustup.rs](https://rustup.rs))
- Flutter Rust Bridge CLI (for code generation)

## Building

### 1. Build the Rust library

```bash
cd /home/hzhou/workspace/scout/app_notes/rust

cargo build
```

### 2. For release build

```bash
cargo build --release
```

### 3. Run tests

```bash
cargo test
```

## Flutter Rust Bridge Integration

### 1. Install flutter_rust_bridge_codegen

```bash
cargo install flutter_rust_bridge_codegen
```

### 2. Generate FFI bindings

```bash
flutter_rust_bridge_codegen generate \
  --rust-input ./src/api.rs \
  --dart-output ../lib/src/bridge_generated.dart \
  --c-output ../ios/Runner/bridge_generated.h
```

Or use the configuration file:

```bash
flutter_rust_bridge_codegen generate
```

## API Overview

### Core Functions

- `initialize()` - Initialize the Rust backend
- `get_version()` - Get library version
- `echo(message)` - Simple echo test

### File Operations

- `read_note(path)` - Read a markdown note
- `write_note(note)` - Write a markdown note
- `list_notes(dir_path)` - List all notes in directory
- `list_folders(dir_path)` - List all folders
- `delete_note(path)` - Delete a note

### Markdown Processing

- `parse_markdown(content, config)` - Parse markdown content
- `markdown_to_html(content)` - Convert markdown to HTML
- `extract_plain_text(content)` - Get plain text
- `get_table_of_contents(content)` - Extract TOC
- `validate_markdown(content)` - Validate syntax

### File Watcher

- `FileWatcher::watch(path)` - Start watching directory
- `FileWatcher::unwatch(path)` - Stop watching directory

## Dependencies

- **flutter_rust_bridge** - FFI bridge for Flutter
- **tokio** - Async runtime
- **anyhow** - Error handling
- **pulldown-cmark** - Markdown parser
- **notify** - File system watcher
- **serde** - Serialization
- **tracing** - Logging

## Features

- `default` - Standard features
- `test-helpers` - Additional test utilities

## Testing

```bash
# Run all tests
cargo test

# Run with output
cargo test -- --nocapture

# Run specific test
cargo test test_echo

# Run integration tests
cargo test --test '*'
```

## Platform Support

- Linux
- macOS
- Windows
- iOS (via Flutter)
- Android (via Flutter)

## License

MIT
