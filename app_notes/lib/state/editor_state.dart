/// Editor state management using Riverpod.
library;

import 'dart:async';

import 'package:path/path.dart' as path;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:app_notes/models/cursor_position.dart';
import 'package:app_notes/models/open_file.dart';
import 'package:app_notes/services/file_service.dart';

part 'editor_state.g.dart';

/// Auto-save debounce duration.
const autoSaveDebounceDuration = Duration(seconds: 2);

/// Editor state for managing open files and editing operations.
@riverpod
class EditorState extends _$EditorState {
  FileService? _fileService;
  String? _activeFilePath;
  final Map<String, Timer> _autoSaveTimers = {};

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
      isSaving: false,
      saveError: null,
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
    // Cancel any pending auto-save for this file
    _cancelAutoSave(filePath);

    state = state.where((f) => f.path != filePath).toList();

    // If we closed the active file, set another one active
    if (_activeFilePath == filePath) {
      _activeFilePath = state.isNotEmpty ? state.last.path : null;
    }
  }

  /// Save a file by path.
  Future<bool> saveFile(String filePath) async {
    final index = state.indexWhere((f) => f.path == filePath);
    if (index == -1) return false;

    final file = state[index];
    if (!file.isDirty) return true;

    // Set saving state
    _updateFileState(index, file.copyWith(isSaving: true, saveError: null));

    try {
      final success = await _service.writeFile(filePath, file.content);

      if (success) {
        // Update state to saved
        _updateFileState(
          index,
          file.copyWith(
            originalContent: file.content,
            isDirty: false,
            isSaving: false,
            saveError: null,
          ),
        );
        return true;
      } else {
        // Save failed
        _updateFileState(
          index,
          file.copyWith(isSaving: false, saveError: 'Failed to save file'),
        );
        return false;
      }
    } catch (e) {
      // Save failed with error
      _updateFileState(
        index,
        file.copyWith(isSaving: false, saveError: e.toString()),
      );
      return false;
    }
  }

  /// Update content of a file with auto-save.
  void updateContent(String filePath, String content) {
    final index = state.indexWhere((f) => f.path == filePath);
    if (index == -1) return;

    final file = state[index];
    final isDirty = file.originalContent != content;

    state = [
      ...state.sublist(0, index),
      file.copyWith(
        content: content,
        isDirty: isDirty,
        saveError: null, // Clear any previous error
      ),
      ...state.sublist(index + 1),
    ];

    // Schedule auto-save if content is dirty
    if (isDirty) {
      _scheduleAutoSave(filePath);
    }
  }

  /// Schedule auto-save with debounce.
  void _scheduleAutoSave(String filePath) {
    _cancelAutoSave(filePath);
    _autoSaveTimers[filePath] = Timer(autoSaveDebounceDuration, () {
      saveFile(filePath);
      _autoSaveTimers.remove(filePath);
    });
  }

  /// Cancel pending auto-save for a specific file.
  void _cancelAutoSave(String filePath) {
    _autoSaveTimers[filePath]?.cancel();
    _autoSaveTimers.remove(filePath);
  }

  /// Cancel all pending auto-saves.
  void _cancelAllAutoSaves() {
    for (final timer in _autoSaveTimers.values) {
      timer.cancel();
    }
    _autoSaveTimers.clear();
  }

  /// Helper to update a single file in state.
  void _updateFileState(int index, OpenFile updatedFile) {
    state = [
      ...state.sublist(0, index),
      updatedFile,
      ...state.sublist(index + 1),
    ];
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
    _cancelAllAutoSaves();
    state = [];
    _activeFilePath = null;
  }

  /// Check if any file has unsaved changes.
  bool get hasAnyUnsavedChanges {
    return state.any((f) => f.isDirty || f.originalContent != f.content);
  }

  /// Check if any file is currently being saved.
  bool get isAnyFileSaving {
    return state.any((f) => f.isSaving);
  }

  /// Get the save error for a specific file.
  String? getSaveError(String filePath) {
    final file = state.where((f) => f.path == filePath).firstOrNull;
    return file?.saveError;
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

/// Whether any file is currently being saved.
@riverpod
bool isAnyFileSaving(IsAnyFileSavingRef ref) {
  return ref.watch(editorStateProvider.notifier).isAnyFileSaving;
}
