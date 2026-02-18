/// Editor area for viewing and editing files.
library;

import 'package:app_notes/models/open_file.dart';
import 'package:app_notes/state/editor_state.dart';
import 'package:app_notes/state/preview_state.dart';
import 'package:app_notes/ui/widgets/markdown_editor.dart';
import 'package:app_notes/ui/widgets/markdown_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Editor area widget for displaying and editing file content.
class EditorArea extends ConsumerWidget {
  /// Creates the editor area.
  const EditorArea({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeFile = ref.watch(activeEditorFileProvider);
    final openFiles = ref.watch(editorStateProvider);
    final showPreview = ref.watch(previewStateProvider);

    if (openFiles.isEmpty) {
      return _buildEmptyState(context);
    }

    return Column(
      children: [
        // Tab bar for open files
        _buildTabBar(context, ref, openFiles, activeFile),
        const Divider(height: 1),
        // Editor content for active file
        if (activeFile != null) ...[
          _buildToolbar(context, ref, activeFile),
          const Divider(height: 1),
          Expanded(child: _buildEditorPreview(activeFile.path, showPreview)),
        ],
      ],
    );
  }

  Widget _buildTabBar(
    BuildContext context,
    WidgetRef ref,
    List<OpenFile> files,
    OpenFile? activeFile,
  ) {
    final theme = Theme.of(context);

    return Container(
      height: 36,
      color: theme.colorScheme.surfaceContainerHighest.withAlpha(51),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: files.length,
        itemBuilder: (context, index) {
          final file = files[index];
          final isActive = file.path == activeFile?.path;
          final hasChanges = ref
              .read(editorStateProvider.notifier)
              .hasUnsavedChanges(file.path);

          return InkWell(
            onTap: () {
              ref.read(editorStateProvider.notifier).setActiveFile(file.path);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: isActive
                        ? theme.colorScheme.primary
                        : Colors.transparent,
                    width: 2,
                  ),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.description,
                    size: 16,
                    color: hasChanges ? Colors.orange : null,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    file.name,
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
                  if (hasChanges) ...[
                    const SizedBox(width: 4),
                    const Text(
                      '●',
                      style: TextStyle(color: Colors.orange, fontSize: 8),
                    ),
                  ],
                  const SizedBox(width: 8),
                  InkWell(
                    onTap: () {
                      ref
                          .read(editorStateProvider.notifier)
                          .closeFile(file.path);
                    },
                    child: Icon(
                      Icons.close,
                      size: 14,
                      color: theme.colorScheme.onSurface.withAlpha(153),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildToolbar(BuildContext context, WidgetRef ref, OpenFile file) {
    final theme = Theme.of(context);
    final hasChanges = ref
        .read(editorStateProvider.notifier)
        .hasUnsavedChanges(file.path);
    final showPreview = ref.watch(previewStateProvider);

    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(color: theme.colorScheme.surface),
      child: Row(
        children: [
          // File name
          Icon(Icons.description, size: 18, color: theme.colorScheme.primary),
          const SizedBox(width: 8),
          Text(
            file.name,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          if (hasChanges)
            Text(
              ' *',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.primary,
              ),
            ),
          const Spacer(),
          // Preview toggle button
          IconButton(
            onPressed: () {
              ref.read(previewStateProvider.notifier).toggle();
            },
            icon: Icon(
              showPreview ? Icons.visibility : Icons.visibility_off,
              size: 20,
              color: showPreview ? theme.colorScheme.primary : null,
            ),
            tooltip: showPreview ? 'Hide Preview' : 'Show Preview',
          ),
          const SizedBox(width: 8),
          // Save button
          FilledButton.icon(
            onPressed: hasChanges
                ? () async {
                    await ref
                        .read(editorStateProvider.notifier)
                        .saveFile(file.path);
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('File saved'),
                          duration: Duration(seconds: 1),
                        ),
                      );
                    }
                  }
                : null,
            icon: const Icon(Icons.save, size: 18),
            label: const Text('Save'),
          ),
        ],
      ),
    );
  }

  Widget _buildEditorPreview(String filePath, bool showPreview) {
    return Row(
      children: [
        // Editor
        Expanded(
          flex: showPreview ? 1 : 2,
          child: MarkdownEditor(filePath: filePath),
        ),
        // Preview (optional)
        if (showPreview) ...[
          const VerticalDivider(width: 1),
          Expanded(child: MarkdownPreview(filePath: filePath)),
        ],
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.edit_note,
            size: 64,
            color: theme.colorScheme.onSurface.withAlpha(51),
          ),
          const SizedBox(height: 16),
          Text(
            'Select a file to view or edit',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurface.withAlpha(128),
            ),
          ),
        ],
      ),
    );
  }
}
