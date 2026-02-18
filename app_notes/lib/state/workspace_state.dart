/// Workspace state management using Riverpod.
library;

import 'package:path/path.dart' as path;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:app_notes/models/file_entry.dart';
import 'package:app_notes/models/workspace.dart';
import 'package:app_notes/services/file_service.dart';

part 'workspace_state.g.dart';

/// Workspace state for managing the current workspace.
@riverpod
class WorkspaceState extends _$WorkspaceState {
  FileService? _fileService;

  FileService get _service => _fileService ??= FileService();

  @override
  Workspace? build() => null;

  /// Open a workspace at the given path.
  Future<void> openWorkspace(String workspacePath) async {
    if (workspacePath.isEmpty) return;

    final name = path.basename(workspacePath);
    final entries = await _service.readDirectory(workspacePath);

    state = Workspace(
      path: workspacePath,
      name: name,
      root: FileEntry(
        name: name,
        path: workspacePath,
        isDirectory: true,
        children: entries,
        isExpanded: true,
      ),
      recentFiles: [],
    );
  }

  /// Close the current workspace.
  Future<void> closeWorkspace() async {
    state = null;
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
