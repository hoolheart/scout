/// Open file model representing a file currently open in the editor.
library;

import 'package:freezed_annotation/freezed_annotation.dart';

import 'cursor_position.dart';

part 'open_file.freezed.dart';

/// Represents a file that is currently open in the editor.
@freezed
class OpenFile with _$OpenFile {
  /// Creates a new open file.
  const factory OpenFile({
    /// Full path to the file.
    required String path,

    /// Display name of the file.
    required String name,

    /// Current content of the file in the editor.
    required String content,

    /// Original content when the file was opened (for detecting changes).
    String? originalContent,

    /// Whether the file has unsaved changes.
    @Default(false) bool isDirty,

    /// Whether the file is currently being saved.
    @Default(false) bool isSaving,

    /// Error message if saving failed.
    String? saveError,

    /// Current cursor position in the file.
    CursorPosition? cursorPosition,
  }) = _OpenFile;

  const OpenFile._();

  /// Returns true if the file has been modified since opening.
  bool get hasChanges =>
      isDirty || (originalContent != null && originalContent != content);
}
