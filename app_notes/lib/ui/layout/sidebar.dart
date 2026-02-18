/// Sidebar with file tree and toolbar.
library;

import 'package:app_notes/state/editor_state.dart';
import 'package:app_notes/state/workspace_state.dart';
import 'package:app_notes/ui/widgets/file_tree_view.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Sidebar widget containing file tree.
class Sidebar extends ConsumerWidget {
  /// Creates the sidebar.
  const Sidebar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final workspacePath = ref.watch(currentWorkspacePathProvider);
    final fileTree = ref.watch(fileTreeRootProvider);

    return Container(
      width: 280,
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
                  ),
          ),
        ],
      ),
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
              final result = await FilePicker.platform.getDirectoryPath();
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
                : () {
                    // TODO(hzhou): Implement new file creation
                  },
          ),
          // New folder button
          IconButton(
            icon: const Icon(Icons.create_new_folder_outlined),
            tooltip: 'New Folder',
            onPressed: workspacePath == null
                ? null
                : () {
                    // TODO(hzhou): Implement new folder creation
                  },
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
              final result = await FilePicker.platform.getDirectoryPath();
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
