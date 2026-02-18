# AppNotes - Markdown Desktop Editor

A modern desktop application for editing and previewing Markdown files, built with Flutter and Rust.

## Features

- 📝 **Markdown Editing**: Write and edit Markdown with syntax highlighting
- 👁️ **Live Preview**: See your rendered Markdown in real-time
- 📁 **File Management**: Browse and manage files with an intuitive sidebar
- 🌓 **Light/Dark Mode**: Support for both light and dark themes
- 🖥️ **Cross-Platform**: Works on Windows, macOS, and Linux

## Project Structure

```
app_notes/
├── lib/
│   ├── main.dart                 # Application entry point
│   ├── app.dart                  # App widget with theme configuration
│   ├── models/
│   │   └── file_entry.dart       # File system entry model
│   ├── state/
│   │   └── app_state.dart        # Riverpod state management
│   ├── services/
│   │   └── file_service.dart     # File system operations
│   └── ui/
│       ├── layout/
│       │   ├── main_layout.dart      # Main application layout
│       │   ├── sidebar.dart          # File tree sidebar
│       │   ├── editor_area.dart      # Markdown editor/preview
│       │   └── window_title_bar.dart # Custom window controls
│       └── widgets/
│           └── file_tree_view.dart   # File tree widget
├── macos/                        # macOS platform files
├── windows/                      # Windows platform files
├── linux/                        # Linux platform files
└── rust/                         # Rust backend (flutter_rust_bridge)
```

## Getting Started

### Prerequisites

- Flutter SDK 3.11.0 or higher
- Dart SDK
- Rust toolchain (for flutter_rust_bridge)

### Installation

1. **Clone the repository:**
   ```bash
   git clone <repository-url>
   cd app_notes
   ```

2. **Install Flutter dependencies:**
   ```bash
   flutter pub get
   ```

3. **Generate code:**
   ```bash
   dart run build_runner build
   ```

### Running the Application

#### Linux
```bash
flutter run -d linux
```

#### macOS
```bash
flutter run -d macos
```

#### Windows
```bash
flutter run -d windows
```

### Building for Production

#### Linux
```bash
flutter build linux
```

#### macOS
```bash
flutter build macos
```

#### Windows
```bash
flutter build windows
```

## Development

### Code Generation

This project uses code generation for Riverpod and Freezed. Run the following command after modifying annotated files:

```bash
dart run build_runner build --delete-conflicting-outputs
```

Or watch for changes:

```bash
dart run build_runner watch
```

### Linting

The project uses `very_good_analysis` for strict linting rules. Run:

```bash
flutter analyze
```

### Testing

Run tests with:

```bash
flutter test
```

## Dependencies

### Core
- **flutter_rust_bridge**: FFI bridge for Rust integration
- **flutter_riverpod**: State management
- **window_manager**: Desktop window management

### UI
- **flutter_markdown**: Markdown rendering
- **file_picker**: File and folder selection dialogs

### Utilities
- **freezed**: Immutable data classes
- **path**: File path manipulation

## Architecture

The application follows a clean architecture pattern:

- **Models**: Immutable data classes using Freezed
- **State**: Riverpod for reactive state management
- **Services**: Business logic and file operations
- **UI**: Widgets organized by layout and reusable components

## License

This project is licensed under the MIT License.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.
