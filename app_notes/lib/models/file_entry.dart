/// File entry model representing a file or folder in the file tree.
library;

import 'package:freezed_annotation/freezed_annotation.dart';

part 'file_entry.freezed.dart';
part 'file_entry.g.dart';

/// Represents a file or folder in the file system.
@freezed
class FileEntry with _$FileEntry {
  /// Creates a new file entry.
  const factory FileEntry({
    /// Display name of the file or folder.
    required String name,

    /// Full path to the file or folder.
    required String path,

    /// Whether this entry is a directory (folder).
    required bool isDirectory,

    /// File size in bytes (0 for directories).
    @Default(0) int size,

    /// Last modified timestamp.
    DateTime? modifiedTime,

    /// For folders: list of child entries.
    @Default([]) List<FileEntry> children,

    /// Whether this folder is currently expanded in the tree view.
    @Default(false) bool isExpanded,
  }) = _FileEntry;

  /// Creates a FileEntry from JSON.
  factory FileEntry.fromJson(Map<String, dynamic> json) =>
      _$FileEntryFromJson(json);

  const FileEntry._();

  /// Returns true if this is a markdown file.
  bool get isMarkdown => !isDirectory && name.toLowerCase().endsWith('.md');

  /// Returns true if this entry has children.
  bool get hasChildren => children.isNotEmpty;

  /// Returns the file extension (e.g., 'md', 'txt'). Empty for folders.
  String get extension => isDirectory
      ? ''
      : name.contains('.')
      ? name.split('.').last
      : '';
}
