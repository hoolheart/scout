/// Editor area for viewing and editing files.
library;

import 'package:app_notes/models/open_file.dart';
import 'package:app_notes/state/editor_state.dart';
import 'package:app_notes/state/preview_state.dart';
import 'package:app_notes/ui/widgets/markdown_editor.dart';
import 'package:app_notes/ui/widgets/markdown_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

    return Shortcuts(
      shortcuts: {
        LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.tab):
            const _NextTabIntent(),
        LogicalKeySet(
          LogicalKeyboardKey.control,
          LogicalKeyboardKey.shift,
          LogicalKeyboardKey.tab,
        ): const _PreviousTabIntent(),
        LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyW):
            const _CloseTabIntent(),
      },
      child: Actions(
        actions: {
          _NextTabIntent: CallbackAction<_NextTabIntent>(
            onInvoke: (_) => _switchToNextTab(ref),
          ),
          _PreviousTabIntent: CallbackAction<_PreviousTabIntent>(
            onInvoke: (_) => _switchToPreviousTab(ref),
          ),
          _CloseTabIntent: CallbackAction<_CloseTabIntent>(
            onInvoke: (_) => _closeCurrentTab(ref),
          ),
        },
        child: Focus(
          autofocus: true,
          child: Column(
            children: [
              // Tab bar for open files
              _buildTabBar(context, ref, openFiles, activeFile),
              const Divider(height: 1),
              // Editor content for active file
              if (activeFile != null) ...[
                _buildToolbar(context, ref, activeFile),
                const Divider(height: 1),
                Expanded(
                  child: _buildEditorPreview(activeFile.path, showPreview),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _switchToNextTab(WidgetRef ref) {
    final files = ref.read(editorStateProvider);
    final activePath = ref.read(activeEditorFilePathProvider);
    if (files.isEmpty || activePath == null) return;

    final currentIndex = files.indexWhere((f) => f.path == activePath);
    if (currentIndex == -1) return;

    final nextIndex = (currentIndex + 1) % files.length;
    ref.read(editorStateProvider.notifier).setActiveFile(files[nextIndex].path);
  }

  void _switchToPreviousTab(WidgetRef ref) {
    final files = ref.read(editorStateProvider);
    final activePath = ref.read(activeEditorFilePathProvider);
    if (files.isEmpty || activePath == null) return;

    final currentIndex = files.indexWhere((f) => f.path == activePath);
    if (currentIndex == -1) return;

    final prevIndex = (currentIndex - 1 + files.length) % files.length;
    ref.read(editorStateProvider.notifier).setActiveFile(files[prevIndex].path);
  }

  void _closeCurrentTab(WidgetRef ref) {
    final activePath = ref.read(activeEditorFilePathProvider);
    if (activePath != null) {
      ref.read(editorStateProvider.notifier).closeFile(activePath);
    }
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
      child: Row(
        children: [
          // Tab list
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: files.length,
              itemBuilder: (context, index) =>
                  _buildTab(context, ref, files, index, activeFile),
            ),
          ),
          // Toolbar buttons
          _buildToolbarButtons(context, ref),
        ],
      ),
    );
  }

  Widget _buildTab(
    BuildContext context,
    WidgetRef ref,
    List<OpenFile> files,
    int index,
    OpenFile? activeFile,
  ) {
    final theme = Theme.of(context);
    final file = files[index];
    final isActive = file.path == activeFile?.path;
    final hasChanges = ref
        .read(editorStateProvider.notifier)
        .hasUnsavedChanges(file.path);

    return _TabWidget(
      file: file,
      isActive: isActive,
      hasChanges: hasChanges,
      onTap: () {
        ref.read(editorStateProvider.notifier).setActiveFile(file.path);
      },
      onClose: () {
        ref.read(editorStateProvider.notifier).closeFile(file.path);
      },
      onCloseOthers: () {
        for (final other in files) {
          if (other.path != file.path) {
            ref.read(editorStateProvider.notifier).closeFile(other.path);
          }
        }
      },
      onCloseToTheRight: () {
        for (var i = index + 1; i < files.length; i++) {
          ref.read(editorStateProvider.notifier).closeFile(files[i].path);
        }
      },
    );
  }

  Widget _buildToolbarButtons(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final showPreview = ref.watch(previewStateProvider);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        border: Border(left: BorderSide(color: theme.dividerColor)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Preview toggle button
          IconButton(
            icon: Icon(
              showPreview ? Icons.visibility : Icons.visibility_off,
              size: 18,
            ),
            tooltip: showPreview ? 'Hide Preview' : 'Show Preview',
            onPressed: () {
              ref.read(previewStateProvider.notifier).toggle();
            },
          ),
        ],
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

/// Custom tab widget with context menu
class _TabWidget extends StatefulWidget {
  const _TabWidget({
    required this.file,
    required this.isActive,
    required this.hasChanges,
    required this.onTap,
    required this.onClose,
    required this.onCloseOthers,
    required this.onCloseToTheRight,
  });

  final OpenFile file;
  final bool isActive;
  final bool hasChanges;
  final VoidCallback onTap;
  final VoidCallback onClose;
  final VoidCallback onCloseOthers;
  final VoidCallback onCloseToTheRight;

  @override
  State<_TabWidget> createState() => _TabWidgetState();
}

class _TabWidgetState extends State<_TabWidget> {
  bool _isHovering = false;
  bool _isCloseHovering = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onSecondaryTapUp: (details) =>
          _showContextMenu(context, details.globalPosition),
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovering = true),
        onExit: (_) => setState(() => _isHovering = false),
        child: InkWell(
          onTap: widget.onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: widget.isActive
                  ? theme.colorScheme.surface
                  : _isHovering
                  ? theme.colorScheme.onSurface.withAlpha(10)
                  : null,
              border: Border(
                bottom: BorderSide(
                  color: widget.isActive
                      ? theme.colorScheme.primary
                      : Colors.transparent,
                  width: 2,
                ),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // File icon with unsaved indicator
                Stack(
                  children: [
                    Icon(
                      Icons.description,
                      size: 16,
                      color: widget.isActive
                          ? theme.colorScheme.primary
                          : theme.colorScheme.onSurface.withAlpha(178),
                    ),
                    if (widget.hasChanges)
                      Positioned(
                        right: 0,
                        top: 0,
                        child: Container(
                          width: 6,
                          height: 6,
                          decoration: const BoxDecoration(
                            color: Colors.orange,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(width: 8),
                // File name
                Text(
                  widget.file.name,
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: widget.isActive
                        ? FontWeight.w600
                        : FontWeight.w400,
                    color: widget.isActive
                        ? theme.colorScheme.onSurface
                        : theme.colorScheme.onSurface.withAlpha(178),
                  ),
                ),
                const SizedBox(width: 8),
                // Close button
                MouseRegion(
                  onEnter: (_) => setState(() => _isCloseHovering = true),
                  onExit: (_) => setState(() => _isCloseHovering = false),
                  child: GestureDetector(
                    onTap: widget.onClose,
                    child: Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        color: _isCloseHovering
                            ? theme.colorScheme.onSurface.withAlpha(51)
                            : Colors.transparent,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.close,
                        size: 12,
                        color: _isCloseHovering
                            ? theme.colorScheme.onSurface
                            : theme.colorScheme.onSurface.withAlpha(128),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showContextMenu(BuildContext context, Offset position) {
    final theme = Theme.of(context);

    final items = <PopupMenuEntry<dynamic>>[
      PopupMenuItem(
        enabled: false,
        child: Text(
          widget.file.name,
          style: theme.textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface.withAlpha(153),
          ),
        ),
      ),
      const PopupMenuDivider(),
      PopupMenuItem(
        onTap: widget.onClose,
        child: Row(
          children: [
            Icon(Icons.close, size: 18, color: theme.colorScheme.onSurface),
            const SizedBox(width: 12),
            const Text('Close'),
          ],
        ),
      ),
      PopupMenuItem(
        onTap: widget.onCloseOthers,
        child: Row(
          children: [
            Icon(Icons.close, size: 18, color: theme.colorScheme.onSurface),
            const SizedBox(width: 12),
            const Text('Close Others'),
          ],
        ),
      ),
      PopupMenuItem(
        onTap: widget.onCloseToTheRight,
        child: Row(
          children: [
            Icon(
              Icons.keyboard_tab,
              size: 18,
              color: theme.colorScheme.onSurface,
            ),
            const SizedBox(width: 12),
            const Text('Close to the Right'),
          ],
        ),
      ),
    ];

    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
        position.dx,
        position.dy,
        position.dx + 1,
        position.dy + 1,
      ),
      items: items,
    );
  }
}

/// Intent classes for keyboard shortcuts
class _NextTabIntent extends Intent {
  const _NextTabIntent();
}

class _PreviousTabIntent extends Intent {
  const _PreviousTabIntent();
}

class _CloseTabIntent extends Intent {
  const _CloseTabIntent();
}
