/// Sidebar with file tree and toolbar.
library;

import 'package:app_notes/services/file_picker_service.dart';
import 'package:app_notes/services/file_service.dart';
import 'package:app_notes/state/app_state.dart';
import 'package:app_notes/state/editor_state.dart';
import 'package:app_notes/state/workspace_state.dart';
import 'package:app_notes/ui/widgets/file_tree_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Sidebar widget containing file tree.
class Sidebar extends ConsumerStatefulWidget {
  /// Creates the sidebar.
  const Sidebar({super.key});

  @override
  ConsumerState<Sidebar> createState() => _SidebarState();
}

class _SidebarState extends ConsumerState<Sidebar> {
  bool _isResizing = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final workspacePath = ref.watch(currentWorkspacePathProvider);
    final fileTree = ref.watch(fileTreeRootProvider);
    final sidebarWidth = ref.watch(
      appStateProvider.select((s) => s.sidebarWidth),
    );
    final activeFilePath = ref.watch(activeEditorFilePathProvider);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: sidebarWidth,
          color: theme.colorScheme.surfaceContainerHighest.withAlpha(77),
          child: Column(
            children: [
              // Toolbar
              _buildToolbar(context, ref, workspacePath),
              const Divider(height: 1),
              // Workspace header
              if (workspacePath != null)
                _buildWorkspaceHeader(context, workspacePath),
              // File tree
              Expanded(
                child: workspacePath == null
                    ? _buildEmptyState(context, ref)
                    : fileTree == null
                    ? const Center(child: CircularProgressIndicator())
                    : FileTreeView(
                        entries: fileTree.children,
                        selectedPath: activeFilePath,
                        onEntryTap: (entry) {
                          if (!entry.isDirectory) {
                            ref
                                .read(editorStateProvider.notifier)
                                .openFile(entry.path);
                          }
                        },
                        onEntryExpand: (entry) {
                          ref
                              .read(workspaceStateProvider.notifier)
                              .toggleFolderExpansion(entry.path);
                        },
                        onNewFile: (path) =>
                            _showNewFileDialog(context, ref, path),
                        onNewFolder: (path) =>
                            _showNewFolderDialog(context, ref, path),
                        onRename: (path, newName) =>
                            _renameEntry(ref, path, newName),
                        onDelete: (path) => _deleteEntry(ref, path),
                      ),
              ),
            ],
          ),
        ),
        // Resizer
        MouseRegion(
          cursor: SystemMouseCursors.resizeColumn,
          onEnter: (_) => setState(() => _isResizing = true),
          onExit: (_) => setState(() => _isResizing = false),
          child: GestureDetector(
            onHorizontalDragUpdate: (details) {
              final newWidth = sidebarWidth + details.delta.dx;
              ref.read(appStateProvider.notifier).setSidebarWidth(newWidth);
            },
            child: Container(
              width: 4,
              color: _isResizing
                  ? theme.colorScheme.primary.withAlpha(128)
                  : Colors.transparent,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildToolbar(
    BuildContext context,
    WidgetRef ref,
    String? workspacePath,
  ) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          // Open folder button
          IconButton(
            icon: const Icon(Icons.folder_open_outlined),
            tooltip: 'Open Folder',
            onPressed: () async {
              final result = await FilePickerService.pickWorkspaceFolder();
              if (result != null) {
                await ref
                    .read(workspaceStateProvider.notifier)
                    .openWorkspace(result);
              }
            },
          ),
          const Spacer(),
          // New file button
          IconButton(
            icon: const Icon(Icons.note_add_outlined),
            tooltip: 'New File',
            onPressed: workspacePath == null
                ? null
                : () => _showNewFileDialog(context, ref, workspacePath),
          ),
          // New folder button
          IconButton(
            icon: const Icon(Icons.create_new_folder_outlined),
            tooltip: 'New Folder',
            onPressed: workspacePath == null
                ? null
                : () => _showNewFolderDialog(context, ref, workspacePath),
          ),
          // Refresh button
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh',
            onPressed: workspacePath == null
                ? null
                : () async {
                    await ref
                        .read(workspaceStateProvider.notifier)
                        .refreshFileTree();
                  },
          ),
        ],
      ),
    );
  }

  void _showNewFileDialog(
    BuildContext context,
    WidgetRef ref,
    String parentPath,
  ) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('New File'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(
            labelText: 'File name',
            hintText: 'e.g., notes.md',
            border: OutlineInputBorder(),
          ),
          onSubmitted: (value) async {
            if (value.isNotEmpty) {
              await _createFile(ref, parentPath, value);
            }
            if (context.mounted) Navigator.of(context).pop();
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              final name = controller.text.trim();
              if (name.isNotEmpty) {
                await _createFile(ref, parentPath, name);
              }
              if (context.mounted) Navigator.of(context).pop();
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  void _showNewFolderDialog(
    BuildContext context,
    WidgetRef ref,
    String parentPath,
  ) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('New Folder'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(
            labelText: 'Folder name',
            hintText: 'e.g., Documents',
            border: OutlineInputBorder(),
          ),
          onSubmitted: (value) async {
            if (value.isNotEmpty) {
              await _createFolder(ref, parentPath, value);
            }
            if (context.mounted) Navigator.of(context).pop();
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              final name = controller.text.trim();
              if (name.isNotEmpty) {
                await _createFolder(ref, parentPath, name);
              }
              if (context.mounted) Navigator.of(context).pop();
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  Future<void> _createFile(
    WidgetRef ref,
    String parentPath,
    String fileName,
  ) async {
    final fileService = FileService();
    final success = await fileService.createFile(parentPath, fileName);
    if (success) {
      await ref.read(workspaceStateProvider.notifier).refreshFileTree();
      // Open the newly created file
      final newFilePath =
          '$parentPath${parentPath.endsWith('/') ? '' : '/'}$fileName';
      if (mounted) {
        await ref.read(editorStateProvider.notifier).openFile(newFilePath);
      }
    }
  }

  Future<void> _createFolder(
    WidgetRef ref,
    String parentPath,
    String folderName,
  ) async {
    final fileService = FileService();
    final success = await fileService.createFolder(parentPath, folderName);
    if (success) {
      await ref.read(workspaceStateProvider.notifier).refreshFileTree();
    }
  }

  Future<void> _renameEntry(WidgetRef ref, String path, String newName) async {
    final fileService = FileService();
    final success = await fileService.rename(path, newName);
    if (success) {
      await ref.read(workspaceStateProvider.notifier).refreshFileTree();
    }
  }

  Future<void> _deleteEntry(WidgetRef ref, String path) async {
    final fileService = FileService();
    final success = await fileService.delete(path);
    if (success) {
      // Close the file if it's open
      ref.read(editorStateProvider.notifier).closeFile(path);
      await ref.read(workspaceStateProvider.notifier).refreshFileTree();
    }
  }

  Widget _buildWorkspaceHeader(BuildContext context, String workspacePath) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Icon(Icons.folder, size: 16, color: theme.colorScheme.primary),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              workspacePath.split('/').last,
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.folder_open,
            size: 48,
            color: theme.colorScheme.onSurface.withAlpha(77),
          ),
          const SizedBox(height: 16),
          Text(
            'No folder opened',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withAlpha(128),
            ),
          ),
          const SizedBox(height: 8),
          TextButton.icon(
            onPressed: () async {
              final result = await FilePickerService.pickWorkspaceFolder();
              if (result != null) {
                await ref
                    .read(workspaceStateProvider.notifier)
                    .openWorkspace(result);
              }
            },
            icon: const Icon(Icons.folder_open),
            label: const Text('Open Folder'),
          ),
        ],
      ),
    );
  }
}
