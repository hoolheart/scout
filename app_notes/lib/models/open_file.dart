/// Open file model representing a file currently open in the editor.
library;

import 'package:freezed_annotation/freezed_annotation.dart';

import 'cursor_position.dart';

part 'open_file.freezed.dart';
part 'open_file.g.dart';

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
    @JsonKey(toJson: _cursorPositionToJson, fromJson: _cursorPositionFromJson)
    CursorPosition? cursorPosition,
  }) = _OpenFile;

  /// Creates an OpenFile from JSON.
  factory OpenFile.fromJson(Map<String, dynamic> json) =>
      _$OpenFileFromJson(json);

  const OpenFile._();

  /// Returns true if the file has been modified since opening.
  bool get hasChanges =>
      isDirty || (originalContent != null && originalContent != content);
}

/// Converts CursorPosition to JSON.
Map<String, dynamic>? _cursorPositionToJson(CursorPosition? position) {
  return position?.toJson();
}

/// Converts JSON to CursorPosition.
CursorPosition? _cursorPositionFromJson(Map<String, dynamic>? json) {
  if (json == null) return null;
  return CursorPosition.fromJson(json);
}
