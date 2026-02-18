/// Workspace model representing the current working directory.
library;

import 'package:freezed_annotation/freezed_annotation.dart';

import 'file_entry.dart';

part 'workspace.freezed.dart';
part 'workspace.g.dart';

/// Represents the current workspace (opened folder).
@freezed
class Workspace with _$Workspace {
  /// Creates a new workspace.
  const factory Workspace({
    /// Full path to the workspace root.
    required String path,

    /// Display name of the workspace.
    required String name,

    /// Root file entry representing the entire file tree.
    @JsonKey(toJson: _fileEntryToJson, fromJson: _fileEntryFromJson)
    FileEntry? root,

    /// List of recently accessed files in this workspace.
    @Default([]) List<String> recentFiles,
  }) = _Workspace;

  /// Creates a Workspace from JSON.
  factory Workspace.fromJson(Map<String, dynamic> json) =>
      _$WorkspaceFromJson(json);

  const Workspace._();

  /// Returns the count of recent files.
  int get recentFilesCount => recentFiles.length;
}

/// Converts FileEntry to JSON.
Map<String, dynamic>? _fileEntryToJson(FileEntry? entry) {
  return entry?.toJson();
}

/// Converts JSON to FileEntry.
FileEntry? _fileEntryFromJson(Map<String, dynamic>? json) {
  if (json == null) return null;
  return FileEntry.fromJson(json);
}
