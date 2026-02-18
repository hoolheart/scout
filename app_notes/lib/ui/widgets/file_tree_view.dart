/// File tree view widget for displaying hierarchical file structure.
library;

import 'package:flutter/material.dart';

import 'package:app_notes/models/file_entry.dart';

/// Callback when a file entry is tapped.
typedef FileEntryCallback = void Function(FileEntry entry);

/// Widget for displaying a hierarchical file tree.
class FileTreeView extends StatelessWidget {
  /// Creates a file tree view.
  const FileTreeView({
    required this.entries,
    this.onEntryTap,
    this.onEntryExpand,
    super.key,
  });

  /// List of root file entries.
  final List<FileEntry> entries;

  /// Called when an entry is tapped.
  final FileEntryCallback? onEntryTap;

  /// Called when a folder expand/collapse is toggled.
  final FileEntryCallback? onEntryExpand;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: entries.length,
      itemBuilder: (context, index) {
        return _FileTreeItem(
          entry: entries[index],
          level: 0,
          onTap: onEntryTap,
          onExpand: onEntryExpand,
        );
      },
    );
  }
}

class _FileTreeItem extends StatelessWidget {
  const _FileTreeItem({
    required this.entry,
    required this.level,
    this.onTap,
    this.onExpand,
  });

  final FileEntry entry;
  final int level;
  final FileEntryCallback? onTap;
  final FileEntryCallback? onExpand;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: () => onTap?.call(entry),
          child: Container(
            height: 36,
            padding: EdgeInsets.only(left: 16.0 + level * 16),
            child: Row(
              children: [
                // Expand/collapse icon for folders
                if (entry.isDirectory)
                  SizedBox(
                    width: 24,
                    height: 24,
                    child: IconButton(
                      icon: Icon(
                        entry.isExpanded
                            ? Icons.expand_more
                            : Icons.chevron_right,
                        size: 18,
                      ),
                      padding: EdgeInsets.zero,
                      onPressed: () => onExpand?.call(entry),
                    ),
                  )
                else
                  const SizedBox(width: 24),
                // File/Folder icon
                Icon(
                  _getIconForEntry(entry),
                  size: 18,
                  color: _getColorForEntry(entry, theme),
                ),
                const SizedBox(width: 8),
                // File name
                Expanded(
                  child: Text(
                    entry.name,
                    style: theme.textTheme.bodyMedium?.copyWith(fontSize: 13),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
        // Recursively render children if expanded
        if (entry.isDirectory && entry.isExpanded)
          ...entry.children.map(
            (child) => _FileTreeItem(
              entry: child,
              level: level + 1,
              onTap: onTap,
              onExpand: onExpand,
            ),
          ),
      ],
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
