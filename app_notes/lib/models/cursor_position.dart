/// Cursor position model for tracking cursor location in the editor.
library;

import 'package:freezed_annotation/freezed_annotation.dart';

part 'cursor_position.freezed.dart';
part 'cursor_position.g.dart';

/// Represents a cursor position in the text editor.
@freezed
class CursorPosition with _$CursorPosition {
  /// Creates a new cursor position.
  const factory CursorPosition({
    /// Line number (0-indexed).
    @Default(0) int line,

    /// Column number (0-indexed).
    @Default(0) int column,
  }) = _CursorPosition;

  /// Creates a CursorPosition from JSON.
  factory CursorPosition.fromJson(Map<String, dynamic> json) =>
      _$CursorPositionFromJson(json);

  const CursorPosition._();

  /// Returns a string representation for display (1-indexed).
  String get displayPosition => 'Ln ${line + 1}, Col ${column + 1}';
}
