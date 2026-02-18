/// Rust service for FFI communication with the Rust backend.
library;

import 'dart:async';

import 'package:app_notes/models/file_entry.dart';
import 'package:app_notes/src/rust/api/api.dart';
import 'package:flutter/foundation.dart';

/// Exception thrown when a Rust FFI operation fails.
class RustException implements Exception {
  /// Error message.
  final String message;

  /// Creates a new Rust exception.
  const RustException(this.message);

  @override
  String toString() => 'RustException: $message';
}

/// Service for communicating with the Rust backend via FFI.
///
/// This service provides a Dart-friendly API for file operations
/// that delegates to Rust for high-performance file system operations.
class RustService {
  static RustService? _instance;

  /// Gets the singleton instance of RustService.
  static RustService get instance => _instance ??= RustService._internal();

  RustService._internal();

  bool _initialized = false;

  /// Whether the service has been initialized.
  bool get isInitialized => _initialized;

  /// Initialize the Rust runtime.
  ///
  /// This should be called once at application startup before
  /// using any Rust API functions.
  Future<void> initialize() async {
    if (_initialized) return;

    try {
      await initializeRustApi();
      _initialized = true;
      debugPrint('RustService initialized successfully');
    } catch (e) {
      debugPrint('Failed to initialize RustService: $e');
      // Fallback to stub implementation
      api = StubRustApi();
      _initialized = true;
    }
  }

  /// Get the Rust library version.
  String getRustVersion() {
    _ensureInitialized();
    try {
      return api.getRustVersion();
    } catch (e) {
      debugPrint('Error getting Rust version: $e');
      return 'unknown';
    }
  }

  /// Read a file's contents.
  ///
  /// Returns the file content as a string.
  /// Throws [RustException] if the file cannot be read.
  Future<String> readFile(String filePath) async {
    _ensureInitialized();
    try {
      return await api.rustReadFile(path: filePath);
    } catch (e) {
      throw RustException('Failed to read file "$filePath": $e');
    }
  }

  /// Write content to a file.
  ///
  /// Throws [RustException] if the file cannot be written.
  Future<void> writeFile(String filePath, String content) async {
    _ensureInitialized();
    try {
      await api.rustWriteFile(path: filePath, content: content);
    } catch (e) {
      throw RustException('Failed to write file "$filePath": $e');
    }
  }

  /// Read a directory and return its entries.
  ///
  /// Returns a list of [FileEntry] objects representing files and folders.
  /// Throws [RustException] if the directory cannot be read.
  Future<List<FileEntry>> readDirectory(String dirPath) async {
    _ensureInitialized();
    try {
      final dtos = await api.rustReadDirectory(path: dirPath);
      return dtos.map(_mapFileEntryDto).toList();
    } catch (e) {
      throw RustException('Failed to read directory "$dirPath": $e');
    }
  }

  /// Create an empty file at the specified path.
  ///
  /// Creates parent directories if they don't exist.
  /// Throws [RustException] if the file cannot be created.
  Future<void> createFile(String filePath) async {
    _ensureInitialized();
    try {
      await api.rustCreateFile(path: filePath);
    } catch (e) {
      throw RustException('Failed to create file "$filePath": $e');
    }
  }

  /// Delete a file.
  ///
  /// Throws [RustException] if the file cannot be deleted.
  Future<void> deleteFile(String filePath) async {
    _ensureInitialized();
    try {
      await api.rustDeleteFile(path: filePath);
    } catch (e) {
      throw RustException('Failed to delete file "$filePath": $e');
    }
  }

  /// Rename (move) a file.
  ///
  /// Throws [RustException] if the file cannot be renamed.
  Future<void> renameFile(String oldPath, String newPath) async {
    _ensureInitialized();
    try {
      await api.rustRenameFile(oldPath: oldPath, newPath: newPath);
    } catch (e) {
      throw RustException(
        'Failed to rename file from "$oldPath" to "$newPath": $e',
      );
    }
  }

  /// Check if a file or directory exists.
  ///
  /// Note: This is a synchronous operation.
  bool fileExists(String filePath) {
    _ensureInitialized();
    try {
      return api.rustFileExists(path: filePath);
    } catch (e) {
      debugPrint('Error checking file existence: $e');
      return false;
    }
  }

  /// Create a directory and all parent directories.
  ///
  /// Throws [RustException] if the directory cannot be created.
  Future<void> createDirectory(String dirPath) async {
    _ensureInitialized();
    try {
      await api.rustCreateDirectory(path: dirPath);
    } catch (e) {
      throw RustException('Failed to create directory "$dirPath": $e');
    }
  }

  /// Delete a directory and all its contents recursively.
  ///
  /// Throws [RustException] if the directory cannot be deleted.
  Future<void> deleteDirectory(String dirPath) async {
    _ensureInitialized();
    try {
      await api.rustDeleteDirectory(path: dirPath);
    } catch (e) {
      throw RustException('Failed to delete directory "$dirPath": $e');
    }
  }

  /// Start watching a workspace directory.
  ///
  /// Returns a watch ID that can be used to stop watching.
  /// Throws [RustException] if watching fails.
  Future<String> watchWorkspace(String dirPath) async {
    _ensureInitialized();
    try {
      // For now, this is a stub implementation since the FFI API
      // may not have this method fully implemented yet
      debugPrint('Starting workspace watch for: $dirPath');
      // Return a generated watch ID based on the path hash
      return 'watch_${dirPath.hashCode}';
    } catch (e) {
      throw RustException('Failed to watch workspace "$dirPath": $e');
    }
  }

  /// Stop watching a workspace.
  ///
  /// Throws [RustException] if unwatching fails.
  Future<void> unwatchWorkspace(String watchId) async {
    _ensureInitialized();
    try {
      debugPrint('Stopping workspace watch: $watchId');
      // Stub implementation
    } catch (e) {
      throw RustException('Failed to unwatch workspace "$watchId": $e');
    }
  }

  /// Check if a workspace is currently being watched.
  Future<bool> isWatching(String watchId) async {
    _ensureInitialized();
    try {
      // Stub implementation
      return false;
    } catch (e) {
      debugPrint('Error checking watch status: $e');
      return false;
    }
  }

  /// Convert a FileEntryDto to a FileEntry model.
  FileEntry _mapFileEntryDto(FileEntryDto dto) {
    return FileEntry(
      name: dto.name,
      path: dto.path,
      isDirectory: dto.isDirectory,
      size: dto.size,
      modifiedTime: dto.modifiedTime != null
          ? DateTime.fromMillisecondsSinceEpoch(dto.modifiedTime!)
          : null,
    );
  }

  void _ensureInitialized() {
    if (!_initialized) {
      throw StateError(
        'RustService has not been initialized. Call initialize() first.',
      );
    }
  }
}

/// Provider for RustService (to be used with Riverpod).
///
/// Example usage:
/// ```dart
/// final rustService = ref.watch(rustServiceProvider);
/// ```
// Note: This will be defined in the providers file or can be added here
// final rustServiceProvider = Provider<RustService>((ref) => RustService.instance);
