/// File picker service for selecting files and folders.
///
/// This service provides cross-platform file picking functionality
/// using the file_picker package.
library;

import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;

/// Exception thrown when file picking operations fail.
class FilePickerException implements Exception {
  /// Error message.
  final String message;

  /// Creates a new file picker exception.
  const FilePickerException(this.message);

  @override
  String toString() => 'FilePickerException: $message';
}

/// Service for file picking operations.
class FilePickerService {
  /// Private constructor to prevent instantiation.
  FilePickerService._();

  /// Pick a single Markdown file.
  ///
  /// Shows a file picker dialog filtered to Markdown file extensions.
  /// Returns the selected file path, or null if the user cancels.
  static Future<String?> pickMarkdownFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['md', 'markdown', 'mdown'],
        dialogTitle: '选择 Markdown 文件',
        allowMultiple: false,
      );

      if (result == null || result.files.isEmpty) {
        return null;
      }

      final path = result.files.single.path;
      if (path == null) {
        throw const FilePickerException('无法获取文件路径');
      }

      return path;
    } catch (e) {
      debugPrint('Error picking markdown file: $e');
      return null;
    }
  }

  /// Pick multiple Markdown files.
  ///
  /// Shows a file picker dialog filtered to Markdown file extensions.
  /// Returns a list of selected file paths, or empty list if cancelled.
  static Future<List<String>> pickMultipleMarkdownFiles() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['md', 'markdown', 'mdown'],
        dialogTitle: '选择 Markdown 文件',
        allowMultiple: true,
      );

      if (result == null || result.files.isEmpty) {
        return [];
      }

      return result.files
          .where((f) => f.path != null)
          .map((f) => f.path!)
          .toList();
    } catch (e) {
      debugPrint('Error picking multiple markdown files: $e');
      return [];
    }
  }

  /// Pick a workspace folder.
  ///
  /// Shows a directory picker dialog.
  /// Returns the selected folder path, or null if cancelled.
  static Future<String?> pickWorkspaceFolder() async {
    try {
      final result = await FilePicker.platform.getDirectoryPath(
        dialogTitle: '选择工作区文件夹',
      );

      return result;
    } catch (e) {
      debugPrint('Error picking workspace folder: $e');
      return null;
    }
  }

  /// Pick a save location for a new file.
  ///
  /// Shows a save file dialog with optional default file name.
  /// Returns the selected save path, or null if cancelled.
  static Future<String?> pickSaveLocation({
    String? defaultFileName,
    List<String>? allowedExtensions,
  }) async {
    try {
      final result = await FilePicker.platform.saveFile(
        dialogTitle: '保存文件',
        fileName: defaultFileName ?? 'untitled.md',
        type: FileType.custom,
        allowedExtensions: allowedExtensions ?? ['md', 'markdown'],
      );

      return result;
    } catch (e) {
      debugPrint('Error picking save location: $e');
      return null;
    }
  }

  /// Pick a file with custom extensions.
  ///
  /// Shows a file picker dialog with specified extensions.
  /// Returns the selected file path, or null if cancelled.
  static Future<String?> pickFileWithExtensions(
    List<String> extensions, {
    String dialogTitle = '选择文件',
  }) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: extensions,
        dialogTitle: dialogTitle,
        allowMultiple: false,
      );

      if (result == null || result.files.isEmpty) {
        return null;
      }

      final path = result.files.single.path;
      if (path == null) {
        throw const FilePickerException('无法获取文件路径');
      }

      return path;
    } catch (e) {
      debugPrint('Error picking file with extensions $extensions: $e');
      return null;
    }
  }

  /// Validate if a file is a Markdown file.
  ///
  /// Returns true if the file has a Markdown extension.
  static bool isMarkdownFile(String filePath) {
    final ext = p.extension(filePath).toLowerCase();
    return ext == '.md' || ext == '.markdown' || ext == '.mdown';
  }

  /// Get a user-friendly file name from path.
  ///
  /// Returns the file name without extension if possible.
  static String getDisplayName(String filePath) {
    final fileName = p.basename(filePath);
    if (isMarkdownFile(filePath)) {
      return p.basenameWithoutExtension(filePath);
    }
    return fileName;
  }

  /// Check if a path is a directory.
  static Future<bool> isDirectory(String path) async {
    try {
      final stat = await FileStat.stat(path);
      return stat.type == FileSystemEntityType.directory;
    } catch (e) {
      return false;
    }
  }

  /// Check if a path is a file.
  static Future<bool> isFile(String path) async {
    try {
      final stat = await FileStat.stat(path);
      return stat.type == FileSystemEntityType.file;
    } catch (e) {
      return false;
    }
  }

  /// Ensure a file has a Markdown extension.
  ///
  /// If the file path doesn't have a Markdown extension,
  /// adds '.md' to the end.
  static String ensureMarkdownExtension(String filePath) {
    if (isMarkdownFile(filePath)) {
      return filePath;
    }
    return '$filePath.md';
  }
}
