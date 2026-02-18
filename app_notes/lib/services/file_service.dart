/// File service for handling file operations.
///
/// This service delegates file operations to the Rust backend via FFI
/// for high-performance operations, with fallback to Dart's File API.
library;

import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as path;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:app_notes/models/file_entry.dart';
import 'package:app_notes/services/rust_service.dart';

part 'file_service.g.dart';

/// Provider for FileService.
@riverpod
FileService fileService(FileServiceRef ref) {
  return FileService(RustService.instance);
}

/// Service for file system operations.
///
/// This service uses the Rust backend via FFI for file operations,
/// providing better performance and cross-platform consistency.
class FileService {
  /// The Rust service instance.
  final RustService _rustService;

  /// Whether to use the Rust backend (when available).
  final bool _useRust;

  /// Creates a new file service.
  ///
  /// [rustService] is optional. If not provided, the singleton instance
  /// is used. If Rust is not available, falls back to Dart's File API.
  FileService([RustService? rustService])
    : _rustService = rustService ?? RustService.instance,
      _useRust = false; // Set to true when FFI is fully integrated

  /// Reads the directory structure and returns file entries.
  ///
  /// Returns a list of [FileEntry] objects for all files and folders
  /// in the specified directory. The list is sorted with directories
  /// first, then files, both alphabetically.
  ///
  /// If [recursive] is true, includes all subdirectories recursively.
  Future<List<FileEntry>> readDirectory(
    String dirPath, {
    bool recursive = false,
  }) async {
    try {
      if (_useRust) {
        return await _rustService.readDirectory(dirPath);
      }

      // Fallback to Dart implementation
      return await _readDirectoryDart(dirPath, recursive: recursive);
    } catch (e) {
      debugPrint('Error reading directory: $e');
      return [];
    }
  }

  Future<List<FileEntry>> _readDirectoryDart(
    String dirPath, {
    bool recursive = false,
  }) async {
    final dir = Directory(dirPath);
    if (!await dir.exists()) {
      return [];
    }

    final entries = <FileEntry>[];

    try {
      await for (final entity in dir.list()) {
        final stat = await entity.stat();
        final isDirectory = entity is Directory;

        final entry = FileEntry(
          name: path.basename(entity.path),
          path: entity.path,
          isDirectory: isDirectory,
          size: isDirectory ? 0 : stat.size,
          modifiedTime: stat.modified,
          children: isDirectory && recursive
              ? await _readDirectoryDart(entity.path, recursive: recursive)
              : [],
        );

        entries.add(entry);
      }
    } catch (e) {
      debugPrint('Error reading directory contents: $e');
    }

    // Sort: folders first, then by name
    entries.sort((a, b) {
      if (a.isDirectory && !b.isDirectory) return -1;
      if (!a.isDirectory && b.isDirectory) return 1;
      return a.name.toLowerCase().compareTo(b.name.toLowerCase());
    });

    return entries;
  }

  /// Read file contents as string.
  ///
  /// Returns null if the file doesn't exist or cannot be read.
  Future<String?> readFile(String filePath) async {
    try {
      if (_useRust) {
        return await _rustService.readFile(filePath);
      }

      // Fallback to Dart implementation
      final file = File(filePath);
      if (!await file.exists()) {
        return null;
      }
      return await file.readAsString();
    } catch (e) {
      debugPrint('Error reading file: $e');
      return null;
    }
  }

  /// Write string contents to file.
  ///
  /// Creates parent directories if they don't exist.
  /// Returns true on success, false on failure.
  Future<bool> writeFile(String filePath, String contents) async {
    try {
      if (_useRust) {
        await _rustService.writeFile(filePath, contents);
        return true;
      }

      // Fallback to Dart implementation
      final file = File(filePath);

      // Create parent directories if they don't exist
      final parentDir = file.parent;
      if (!await parentDir.exists()) {
        await parentDir.create(recursive: true);
      }

      await file.writeAsString(contents);
      return true;
    } catch (e) {
      debugPrint('Error writing file: $e');
      return false;
    }
  }

  /// Create a new folder.
  ///
  /// Returns true on success, false on failure.
  Future<bool> createFolder(String parentPath, String folderName) async {
    try {
      final newPath = path.join(parentPath, folderName);

      if (_useRust) {
        await _rustService.createDirectory(newPath);
        return true;
      }

      // Fallback to Dart implementation
      final dir = Directory(newPath);
      await dir.create(recursive: true);
      return true;
    } catch (e) {
      debugPrint('Error creating folder: $e');
      return false;
    }
  }

  /// Create a new file.
  ///
  /// Creates parent directories if they don't exist.
  /// Returns true on success, false on failure.
  Future<bool> createFile(String parentPath, String fileName) async {
    try {
      final newPath = path.join(parentPath, fileName);

      if (_useRust) {
        await _rustService.createFile(newPath);
        return true;
      }

      // Fallback to Dart implementation
      final file = File(newPath);
      await file.create(recursive: true);
      return true;
    } catch (e) {
      debugPrint('Error creating file: $e');
      return false;
    }
  }

  /// Delete a file or folder.
  ///
  /// For directories, deletes recursively.
  /// Returns true on success, false on failure.
  Future<bool> delete(String filePath) async {
    try {
      final entity = FileSystemEntity.typeSync(filePath);

      if (_useRust) {
        if (entity == FileSystemEntityType.directory) {
          await _rustService.deleteDirectory(filePath);
        } else if (entity == FileSystemEntityType.file) {
          await _rustService.deleteFile(filePath);
        }
        return true;
      }

      // Fallback to Dart implementation
      if (entity == FileSystemEntityType.directory) {
        await Directory(filePath).delete(recursive: true);
      } else if (entity == FileSystemEntityType.file) {
        await File(filePath).delete();
      }
      return true;
    } catch (e) {
      debugPrint('Error deleting: $e');
      return false;
    }
  }

  /// Rename a file or folder.
  ///
  /// Returns true on success, false on failure.
  Future<bool> rename(String oldPath, String newName) async {
    try {
      final parent = path.dirname(oldPath);
      final newPath = path.join(parent, newName);

      if (_useRust) {
        await _rustService.renameFile(oldPath, newPath);
        return true;
      }

      // Fallback to Dart implementation
      final entity = FileSystemEntity.typeSync(oldPath);

      if (entity == FileSystemEntityType.directory) {
        await Directory(oldPath).rename(newPath);
      } else if (entity == FileSystemEntityType.file) {
        await File(oldPath).rename(newPath);
      }
      return true;
    } catch (e) {
      debugPrint('Error renaming: $e');
      return false;
    }
  }

  /// Check if a file or directory exists.
  ///
  /// Returns true if the path exists, false otherwise.
  bool exists(String filePath) {
    try {
      if (_useRust) {
        return _rustService.fileExists(filePath);
      }

      // Fallback to Dart implementation
      final entity = FileSystemEntity.typeSync(filePath);
      return entity != FileSystemEntityType.notFound;
    } catch (e) {
      debugPrint('Error checking existence: $e');
      return false;
    }
  }
}
