/// Workspace state management using Riverpod.
library;

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:app_notes/models/file_entry.dart';
import 'package:app_notes/models/workspace.dart';
import 'package:app_notes/services/file_service.dart';
import 'package:app_notes/services/rust_service.dart';
import 'package:app_notes/state/app_state.dart';

part 'workspace_state.g.dart';

/// Exception thrown when workspace operations fail.
class WorkspaceException implements Exception {
  /// Error message.
  final String message;

  /// Creates a new workspace exception.
  const WorkspaceException(this.message);

  @override
  String toString() => 'WorkspaceException: $message';
}

/// Types of file system events.
enum FileSystemEventType {
  /// File or directory was created.
  created,

  /// File was modified.
  modified,

  /// File or directory was deleted.
  deleted,

  /// File was renamed.
  renamed,
}

/// Workspace state for managing the current workspace.
@riverpod
class WorkspaceState extends _$WorkspaceState {
  FileService? _fileService;

  FileService get _service => _fileService ??= FileService();

  @override
  Workspace? build() => null;

  /// Current watch ID for file system monitoring.
  String? _currentWatchId;

  /// Stream subscription for file system events.
  StreamSubscription<dynamic>? _fileWatchSubscription;

  /// Open a workspace at the given path.
  Future<void> openWorkspace(String workspacePath) async {
    if (workspacePath.isEmpty) {
      throw const WorkspaceException('工作区路径不能为空');
    }

    try {
      // 1. 检查目录是否存在
      final directoryExists = _service.exists(workspacePath);
      if (!directoryExists) {
        throw WorkspaceException('目录不存在: $workspacePath');
      }

      // 2. 读取目录内容
      final name = p.basename(workspacePath);
      final entries = await _service.readDirectory(workspacePath);

      // 3. 构建文件树
      final root = FileEntry(
        name: name,
        path: workspacePath,
        isDirectory: true,
        children: entries,
        isExpanded: true,
      );

      // 4. 更新状态
      state = Workspace(
        path: workspacePath,
        name: name,
        root: root,
        recentFiles: [],
      );

      // 5. 添加到最近工作区
      ref.read(appStateProvider.notifier).addRecentWorkspace(workspacePath);

      // 6. 开始文件监控
      await _startWatching(workspacePath);

      debugPrint('Workspace opened: $workspacePath');
    } catch (e) {
      debugPrint('Error opening workspace: $e');
      throw WorkspaceException('无法打开工作区: $e');
    }
  }

  /// Open a recent workspace by path.
  Future<void> openRecentWorkspace(String workspacePath) async {
    // Validate the workspace still exists
    final exists = _service.exists(workspacePath);
    if (!exists) {
      // Remove from recent workspaces if it no longer exists
      ref.read(appStateProvider.notifier).removeRecentWorkspace(workspacePath);
      throw WorkspaceException('工作区不存在: $workspacePath');
    }

    await openWorkspace(workspacePath);
  }

  /// Close the current workspace.
  Future<void> closeWorkspace() async {
    if (state == null) return;

    // 停止文件监控
    await _stopWatching();

    state = null;
    debugPrint('Workspace closed');
  }

  /// Start watching the workspace for file system changes.
  Future<void> _startWatching(String path) async {
    try {
      final rustService = RustService.instance;
      if (!rustService.isInitialized) {
        debugPrint('Rust service not initialized, skipping file watch');
        return;
      }

      _currentWatchId = await rustService.watchWorkspace(path);
      debugPrint('Started watching workspace: $_currentWatchId');
    } catch (e) {
      debugPrint('Failed to start file watching: $e');
      // Don't throw - file watching is not critical
    }
  }

  /// Stop watching the workspace.
  Future<void> _stopWatching() async {
    try {
      if (_currentWatchId != null) {
        final rustService = RustService.instance;
        await rustService.unwatchWorkspace(_currentWatchId!);
        debugPrint('Stopped watching workspace: $_currentWatchId');
        _currentWatchId = null;
      }

      await _fileWatchSubscription?.cancel();
      _fileWatchSubscription = null;
    } catch (e) {
      debugPrint('Error stopping file watcher: $e');
    }
  }

  /// Refresh the file tree.
  Future<void> refreshFileTree() async {
    if (state == null) return;

    final entries = await _service.readDirectory(state!.path);

    state = state!.copyWith(root: state!.root?.copyWith(children: entries));
  }

  /// Load file tree (alias for refresh).
  Future<void> loadFileTree() async {
    await refreshFileTree();
  }

  /// Toggle folder expansion by path.
  void toggleFolderExpansion(String folderPath) {
    if (state == null || state!.root == null) return;

    final updatedRoot = _toggleExpansionInEntry(state!.root!, folderPath);
    state = state!.copyWith(root: updatedRoot);
  }

  FileEntry _toggleExpansionInEntry(FileEntry entry, String targetPath) {
    if (entry.path == targetPath) {
      return entry.copyWith(isExpanded: !entry.isExpanded);
    }

    if (entry.children.isNotEmpty) {
      return entry.copyWith(
        children: entry.children
            .map((child) => _toggleExpansionInEntry(child, targetPath))
            .toList(),
      );
    }

    return entry;
  }

  /// Add a file to recent files.
  void addRecentFile(String filePath) {
    if (state == null) return;

    final updated = [
      filePath,
      ...state!.recentFiles.where((p) => p != filePath),
    ].take(20).toList();

    state = state!.copyWith(recentFiles: updated);
  }

  /// Expand a folder by path.
  void expandFolder(String folderPath) {
    if (state == null || state!.root == null) return;

    final entry = _findEntryInTree(state!.root!, folderPath);
    if (entry != null && entry.isDirectory && !entry.isExpanded) {
      final updatedRoot = _setExpansionInEntry(state!.root!, folderPath, true);
      state = state!.copyWith(root: updatedRoot);
    }
  }

  /// Collapse a folder by path.
  void collapseFolder(String folderPath) {
    if (state == null || state!.root == null) return;

    final entry = _findEntryInTree(state!.root!, folderPath);
    if (entry != null && entry.isDirectory && entry.isExpanded) {
      final updatedRoot = _setExpansionInEntry(state!.root!, folderPath, false);
      state = state!.copyWith(root: updatedRoot);
    }
  }

  FileEntry _setExpansionInEntry(
    FileEntry entry,
    String targetPath,
    bool isExpanded,
  ) {
    if (entry.path == targetPath) {
      return entry.copyWith(isExpanded: isExpanded);
    }

    if (entry.children.isNotEmpty) {
      return entry.copyWith(
        children: entry.children
            .map((child) => _setExpansionInEntry(child, targetPath, isExpanded))
            .toList(),
      );
    }

    return entry;
  }

  /// Reload the file tree for a specific folder.
  ///
  /// Useful after file system events or when expanding a folder
  /// that hasn't been loaded yet.
  Future<void> reloadFolder(String folderPath) async {
    if (state == null) return;

    try {
      final entries = await _service.readDirectory(folderPath);
      state = state!.copyWith(
        root: _updateFolderChildren(state!.root!, folderPath, entries),
      );
    } catch (e) {
      debugPrint('Error reloading folder: $e');
    }
  }

  FileEntry _updateFolderChildren(
    FileEntry entry,
    String targetPath,
    List<FileEntry> newChildren,
  ) {
    if (entry.path == targetPath) {
      // Preserve expansion state for existing children
      final existingExpanded = <String, bool>{};
      for (final child in entry.children) {
        if (child.isDirectory) {
          existingExpanded[child.path] = child.isExpanded;
        }
      }

      // Apply expansion state to new children
      final updatedChildren = newChildren.map((child) {
        if (child.isDirectory && existingExpanded.containsKey(child.path)) {
          return child.copyWith(isExpanded: existingExpanded[child.path]!);
        }
        return child;
      }).toList();

      return entry.copyWith(children: updatedChildren);
    }

    if (entry.children.isNotEmpty) {
      return entry.copyWith(
        children: entry.children
            .map(
              (child) => _updateFolderChildren(child, targetPath, newChildren),
            )
            .toList(),
      );
    }

    return entry;
  }

  /// Handle file system events from the watcher.
  ///
  /// This method should be called when file system events are received
  /// from the Rust file watcher.
  void handleFileSystemEvent(
    FileSystemEventType type,
    String path, {
    String? oldPath,
  }) {
    if (state == null) return;

    switch (type) {
      case FileSystemEventType.created:
        _handleFileCreated(path);
      case FileSystemEventType.modified:
        _handleFileModified(path);
      case FileSystemEventType.deleted:
        _handleFileDeleted(path);
      case FileSystemEventType.renamed:
        if (oldPath != null) {
          _handleFileRenamed(oldPath, path);
        }
    }
  }

  void _handleFileCreated(String path) {
    // Refresh the parent folder
    final parentPath = p.dirname(path);
    unawaited(reloadFolder(parentPath));
  }

  void _handleFileModified(String path) {
    // Update the file entry if it's in the tree
    // For now, just refresh the parent folder
    final parentPath = p.dirname(path);
    unawaited(reloadFolder(parentPath));
  }

  void _handleFileDeleted(String path) {
    // Remove the entry from the tree
    state = state!.copyWith(root: _removeEntryFromTree(state!.root!, path));
  }

  void _handleFileRenamed(String oldPath, String newPath) {
    // Remove old entry and refresh parent folder
    state = state!.copyWith(root: _removeEntryFromTree(state!.root!, oldPath));
    final newParentPath = p.dirname(newPath);
    unawaited(reloadFolder(newParentPath));
  }

  FileEntry _removeEntryFromTree(FileEntry entry, String targetPath) {
    if (entry.path == targetPath) {
      // This shouldn't happen for root, but handle it anyway
      return entry;
    }

    // Filter out the target from children
    final updatedChildren = entry.children.where((child) {
      return child.path != targetPath;
    }).toList();

    // If children were removed, return updated entry
    if (updatedChildren.length != entry.children.length) {
      return entry.copyWith(children: updatedChildren);
    }

    // Otherwise, recursively search in children
    return entry.copyWith(
      children: entry.children
          .map((child) => _removeEntryFromTree(child, targetPath))
          .toList(),
    );
  }

  /// Find a file entry by path in the tree.
  FileEntry? findEntryByPath(String entryPath) {
    if (state?.root == null) return null;
    return _findEntryInTree(state!.root!, entryPath);
  }

  FileEntry? _findEntryInTree(FileEntry entry, String targetPath) {
    if (entry.path == targetPath) return entry;

    for (final child in entry.children) {
      final found = _findEntryInTree(child, targetPath);
      if (found != null) return found;
    }

    return null;
  }
}

/// Whether a workspace is currently open (derived from WorkspaceState).
@riverpod
bool hasWorkspaceOpen(HasWorkspaceOpenRef ref) {
  return ref.watch(workspaceStateProvider) != null;
}

/// The current workspace path (derived from WorkspaceState).
@riverpod
String? currentWorkspacePath(CurrentWorkspacePathRef ref) {
  return ref.watch(workspaceStateProvider.select((w) => w?.path));
}

/// The current workspace name (derived from WorkspaceState).
@riverpod
String? currentWorkspaceName(CurrentWorkspaceNameRef ref) {
  return ref.watch(workspaceStateProvider.select((w) => w?.name));
}

/// The file tree root entry (derived from WorkspaceState).
@riverpod
FileEntry? fileTreeRoot(FileTreeRootRef ref) {
  return ref.watch(workspaceStateProvider.select((w) => w?.root));
}

/// Recent files in the current workspace (derived from WorkspaceState).
@riverpod
List<String> workspaceRecentFiles(WorkspaceRecentFilesRef ref) {
  return ref.watch(workspaceStateProvider.select((w) => w?.recentFiles ?? []));
}
