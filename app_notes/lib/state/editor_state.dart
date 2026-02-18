/// Editor state management using Riverpod.
library;

import 'package:path/path.dart' as path;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:app_notes/models/cursor_position.dart';
import 'package:app_notes/models/open_file.dart';
import 'package:app_notes/services/file_service.dart';

part 'editor_state.g.dart';

/// Editor state for managing open files and editing operations.
@riverpod
class EditorState extends _$EditorState {
  FileService? _fileService;
  String? _activeFilePath;

  FileService get _service => _fileService ??= FileService();

  @override
  List<OpenFile> build() => [];

  /// Get the currently active file path.
  String? get activeFilePath => _activeFilePath;

  /// Get the currently active file.
  OpenFile? get activeFile {
    if (_activeFilePath == null) return null;
    return state.where((f) => f.path == _activeFilePath).firstOrNull;
  }

  /// Open a file by path.
  Future<void> openFile(String filePath) async {
    if (filePath.isEmpty) return;

    // Check if already open
    final existing = state.where((f) => f.path == filePath).firstOrNull;
    if (existing != null) {
      setActiveFile(filePath);
      return;
    }

    // Read file content
    final content = await _service.readFile(filePath) ?? '';
    final name = path.basename(filePath);

    final newFile = OpenFile(
      path: filePath,
      name: name,
      content: content,
      originalContent: content,
      isDirty: false,
      cursorPosition: const CursorPosition(),
    );

    // Update state
    final newState = [...state, newFile];
    state = newState;

    // Set active file after state is updated
    if (state.any((f) => f.path == filePath)) {
      _activeFilePath = filePath;
    }
  }

  /// Close a file by path.
  Future<void> closeFile(String filePath) async {
    state = state.where((f) => f.path != filePath).toList();

    // If we closed the active file, set another one active
    if (_activeFilePath == filePath) {
      _activeFilePath = state.isNotEmpty ? state.last.path : null;
    }
  }

  /// Save a file by path.
  Future<bool> saveFile(String filePath) async {
    final file = state.where((f) => f.path == filePath).firstOrNull;
    if (file == null) return false;

    final success = await _service.writeFile(filePath, file.content);
    if (success) {
      state = state.map((f) {
        if (f.path == filePath) {
          return f.copyWith(originalContent: f.content, isDirty: false);
        }
        return f;
      }).toList();
    }
    return success;
  }

  /// Update content of a file.
  void updateContent(String filePath, String content) {
    state = state.map((f) {
      if (f.path == filePath) {
        final isDirty = f.originalContent != content;
        return f.copyWith(content: content, isDirty: isDirty);
      }
      return f;
    }).toList();
  }

  /// Set the active file.
  void setActiveFile(String filePath) {
    if (state.any((f) => f.path == filePath)) {
      _activeFilePath = filePath;
    }
  }

  /// Set cursor position for a file.
  void setCursorPosition(String filePath, CursorPosition position) {
    state = state.map((f) {
      if (f.path == filePath) {
        return f.copyWith(cursorPosition: position);
      }
      return f;
    }).toList();
  }

  /// Check if a file has unsaved changes.
  bool hasUnsavedChanges(String filePath) {
    final file = state.where((f) => f.path == filePath).firstOrNull;
    if (file == null) return false;
    return file.isDirty || file.originalContent != file.content;
  }

  /// Save all open files.
  Future<void> saveAll() async {
    for (final file in state) {
      if (hasUnsavedChanges(file.path)) {
        await saveFile(file.path);
      }
    }
  }

  /// Close all files.
  void closeAll() {
    state = [];
    _activeFilePath = null;
  }

  /// Check if any file has unsaved changes.
  bool get hasAnyUnsavedChanges {
    return state.any((f) => f.isDirty || f.originalContent != f.content);
  }
}

/// The count of open files (derived from EditorState).
@riverpod
int openFileCount(OpenFileCountRef ref) {
  return ref.watch(editorStateProvider).length;
}

/// Whether any files are open (derived from EditorState).
@riverpod
bool hasOpenFiles(HasOpenFilesRef ref) {
  return ref.watch(editorStateProvider).isNotEmpty;
}

/// The active file path (derived from EditorState).
@riverpod
String? activeEditorFilePath(ActiveEditorFilePathRef ref) {
  return ref.watch(editorStateProvider.notifier).activeFilePath;
}

/// The active file (derived from EditorState).
@riverpod
OpenFile? activeEditorFile(ActiveEditorFileRef ref) {
  return ref.watch(editorStateProvider.notifier).activeFile;
}

/// Whether there are unsaved changes (derived from EditorState).
@riverpod
bool hasUnsavedChangesGlobally(HasUnsavedChangesGloballyRef ref) {
  return ref.watch(editorStateProvider.notifier).hasAnyUnsavedChanges;
}
