/// File tree view widget for displaying hierarchical file structure.
library;

import 'package:flutter/material.dart';

import 'package:app_notes/models/file_entry.dart';

/// Callback when a file entry is tapped.
typedef FileEntryCallback = void Function(FileEntry entry);

/// Callback for file operations.
typedef FileOperationCallback = void Function(String path);
typedef FileRenameCallback = void Function(String path, String newName);

/// Widget for displaying a hierarchical file tree.
class FileTreeView extends StatefulWidget {
  /// Creates a file tree view.
  const FileTreeView({
    required this.entries,
    this.onEntryTap,
    this.onEntryExpand,
    this.onNewFile,
    this.onNewFolder,
    this.onRename,
    this.onDelete,
    this.selectedPath,
    super.key,
  });

  /// List of root file entries.
  final List<FileEntry> entries;

  /// Called when an entry is tapped.
  final FileEntryCallback? onEntryTap;

  /// Called when a folder expand/collapse is toggled.
  final FileEntryCallback? onEntryExpand;

  /// Called when creating a new file.
  final FileOperationCallback? onNewFile;

  /// Called when creating a new folder.
  final FileOperationCallback? onNewFolder;

  /// Called when renaming an entry.
  final FileRenameCallback? onRename;

  /// Called when deleting an entry.
  final FileOperationCallback? onDelete;

  /// Currently selected file path.
  final String? selectedPath;

  @override
  State<FileTreeView> createState() => _FileTreeViewState();
}

class _FileTreeViewState extends State<FileTreeView> {
  final Map<String, bool> _hovering = {};

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.entries.length,
      itemBuilder: (context, index) {
        return _FileTreeItem(
          entry: widget.entries[index],
          level: 0,
          selectedPath: widget.selectedPath,
          onTap: widget.onEntryTap,
          onExpand: widget.onEntryExpand,
          onNewFile: widget.onNewFile,
          onNewFolder: widget.onNewFolder,
          onRename: widget.onRename,
          onDelete: widget.onDelete,
          hovering: _hovering,
          onHoverChange: (path, isHovering) {
            setState(() {
              _hovering[path] = isHovering;
            });
          },
        );
      },
    );
  }
}

class _FileTreeItem extends StatelessWidget {
  const _FileTreeItem({
    required this.entry,
    required this.level,
    this.selectedPath,
    this.onTap,
    this.onExpand,
    this.onNewFile,
    this.onNewFolder,
    this.onRename,
    this.onDelete,
    required this.hovering,
    required this.onHoverChange,
  });

  final FileEntry entry;
  final int level;
  final String? selectedPath;
  final FileEntryCallback? onTap;
  final FileEntryCallback? onExpand;
  final FileOperationCallback? onNewFile;
  final FileOperationCallback? onNewFolder;
  final FileRenameCallback? onRename;
  final FileOperationCallback? onDelete;
  final Map<String, bool> hovering;
  final void Function(String, bool) onHoverChange;

  bool get isSelected => selectedPath == entry.path;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isHover = hovering[entry.path] ?? false;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        MouseRegion(
          onEnter: (_) => onHoverChange(entry.path, true),
          onExit: (_) => onHoverChange(entry.path, false),
          child: GestureDetector(
            onSecondaryTapUp: (details) =>
                _showContextMenu(context, details.globalPosition),
            child: InkWell(
              onTap: () => onTap?.call(entry),
              child: Container(
                height: 32,
                padding: EdgeInsets.only(left: 12.0 + level * 16),
                decoration: BoxDecoration(
                  color: isSelected
                      ? theme.colorScheme.primary.withAlpha(25)
                      : isHover
                      ? theme.colorScheme.onSurface.withAlpha(10)
                      : null,
                  border: Border(
                    left: BorderSide(
                      color: isSelected
                          ? theme.colorScheme.primary
                          : Colors.transparent,
                      width: 2,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    // Expand/collapse icon for folders
                    if (entry.isDirectory)
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: IconButton(
                          icon: Icon(
                            entry.isExpanded
                                ? Icons.expand_more
                                : Icons.chevron_right,
                            size: 16,
                          ),
                          padding: EdgeInsets.zero,
                          onPressed: () => onExpand?.call(entry),
                        ),
                      )
                    else
                      const SizedBox(width: 20),
                    // File/Folder icon
                    Icon(
                      _getIconForEntry(entry),
                      size: 16,
                      color: _getColorForEntry(entry, theme),
                    ),
                    const SizedBox(width: 8),
                    // File name
                    Expanded(
                      child: Text(
                        entry.name,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontSize: 13,
                          fontWeight: isSelected
                              ? FontWeight.w500
                              : FontWeight.normal,
                          color: isSelected
                              ? theme.colorScheme.primary
                              : theme.colorScheme.onSurface,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        // Recursively render children if expanded
        if (entry.isDirectory && entry.isExpanded)
          ...entry.children.map(
            (child) => _FileTreeItem(
              entry: child,
              level: level + 1,
              selectedPath: selectedPath,
              onTap: onTap,
              onExpand: onExpand,
              onNewFile: onNewFile,
              onNewFolder: onNewFolder,
              onRename: onRename,
              onDelete: onDelete,
              hovering: hovering,
              onHoverChange: onHoverChange,
            ),
          ),
      ],
    );
  }

  void _showDialogAfterMenu(
    BuildContext context,
    void Function(BuildContext) showDialog,
  ) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (context.mounted) {
        showDialog(context);
      }
    });
  }

  void _showContextMenu(BuildContext context, Offset position) {
    final theme = Theme.of(context);

    final items = <PopupMenuEntry<dynamic>>[
      if (entry.isDirectory) ...[
        PopupMenuItem(
          enabled: false,
          child: Text(
            entry.name,
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface.withAlpha(153),
            ),
          ),
        ),
        const PopupMenuDivider(),
        PopupMenuItem(
          onTap: () => _showDialogAfterMenu(context, _showNewFileDialog),
          child: Row(
            children: [
              Icon(
                Icons.insert_drive_file,
                size: 18,
                color: theme.colorScheme.onSurface,
              ),
              const SizedBox(width: 12),
              const Text('New File'),
            ],
          ),
        ),
        PopupMenuItem(
          onTap: () => _showDialogAfterMenu(context, _showNewFolderDialog),
          child: Row(
            children: [
              Icon(
                Icons.create_new_folder,
                size: 18,
                color: theme.colorScheme.onSurface,
              ),
              const SizedBox(width: 12),
              const Text('New Folder'),
            ],
          ),
        ),
        const PopupMenuDivider(),
      ],
      PopupMenuItem(
        onTap: () => _showDialogAfterMenu(context, _showRenameDialog),
        child: Row(
          children: [
            Icon(Icons.edit, size: 18, color: theme.colorScheme.onSurface),
            const SizedBox(width: 12),
            const Text('Rename'),
          ],
        ),
      ),
      PopupMenuItem(
        onTap: () => _showDialogAfterMenu(context, _showDeleteConfirmation),
        child: Row(
          children: [
            Icon(Icons.delete, size: 18, color: theme.colorScheme.error),
            const SizedBox(width: 12),
            Text('Delete', style: TextStyle(color: theme.colorScheme.error)),
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

  void _showNewFileDialog(BuildContext context) {
    final controller = TextEditingController();

    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('New File'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(
            labelText: 'File name',
            hintText: 'Enter file name (e.g., note.md)',
            border: OutlineInputBorder(),
          ),
          onSubmitted: (value) {
            if (value.isNotEmpty) {
              final newPath = '${entry.path}/$value';
              onNewFile?.call(newPath);
            }
            Navigator.of(dialogContext).pop();
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              final fileName = controller.text.trim();
              if (fileName.isNotEmpty) {
                final newPath = '${entry.path}/$fileName';
                onNewFile?.call(newPath);
              }
              Navigator.of(dialogContext).pop();
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  void _showNewFolderDialog(BuildContext context) {
    final controller = TextEditingController();

    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('New Folder'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(
            labelText: 'Folder name',
            hintText: 'Enter folder name',
            border: OutlineInputBorder(),
          ),
          onSubmitted: (value) {
            if (value.isNotEmpty) {
              final newPath = '${entry.path}/$value';
              onNewFolder?.call(newPath);
            }
            Navigator.of(dialogContext).pop();
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              final folderName = controller.text.trim();
              if (folderName.isNotEmpty) {
                final newPath = '${entry.path}/$folderName';
                onNewFolder?.call(newPath);
              }
              Navigator.of(dialogContext).pop();
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  void _showRenameDialog(BuildContext context) {
    final controller = TextEditingController(text: entry.name);

    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Rename'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(
            labelText: 'New name',
            border: OutlineInputBorder(),
          ),
          onSubmitted: (value) {
            if (value.isNotEmpty && value != entry.name) {
              onRename?.call(entry.path, value);
            }
            Navigator.of(dialogContext).pop();
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              final newName = controller.text.trim();
              if (newName.isNotEmpty && newName != entry.name) {
                onRename?.call(entry.path, newName);
              }
              Navigator.of(dialogContext).pop();
            },
            child: const Text('Rename'),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Confirm Delete'),
        content: Text('Are you sure you want to delete "${entry.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              onDelete?.call(entry.path);
              Navigator.of(dialogContext).pop();
            },
            style: FilledButton.styleFrom(backgroundColor: colorScheme.error),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  IconData _getIconForEntry(FileEntry entry) {
    if (entry.isDirectory) {
      return entry.isExpanded ? Icons.folder_open : Icons.folder;
    }

    final ext = entry.extension.toLowerCase();
    switch (ext) {
      case 'md':
        return Icons.description;
      case 'txt':
        return Icons.text_snippet;
      case 'json':
        return Icons.data_object;
      case 'yaml':
      case 'yml':
        return Icons.settings;
      case 'dart':
        return Icons.code;
      case 'js':
      case 'ts':
        return Icons.javascript;
      case 'html':
        return Icons.html;
      case 'css':
        return Icons.css;
      case 'png':
      case 'jpg':
      case 'jpeg':
      case 'gif':
      case 'svg':
        return Icons.image;
      default:
        return Icons.insert_drive_file;
    }
  }

  Color _getColorForEntry(FileEntry entry, ThemeData theme) {
    if (entry.isDirectory) {
      return theme.colorScheme.primary.withAlpha(204);
    }

    final ext = entry.extension.toLowerCase();
    switch (ext) {
      case 'md':
        return theme.colorScheme.secondary;
      case 'dart':
        return Colors.blue;
      case 'json':
        return Colors.amber;
      default:
        return theme.colorScheme.onSurface.withAlpha(153);
    }
  }
}
