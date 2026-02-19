/// Status bar widget for displaying file information and editor state.
library;

import 'package:app_notes/models/open_file.dart';
import 'package:app_notes/state/editor_state.dart';
import 'package:app_notes/state/save_status.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as path;

/// Status bar widget displaying file info, cursor position, and save status.
class StatusBar extends ConsumerWidget {
  /// Creates the status bar.
  const StatusBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeFile = ref.watch(activeEditorFileProvider);
    final theme = Theme.of(context);

    return Container(
      height: 28,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(top: BorderSide(color: theme.dividerColor)),
      ),
      child: Row(
        children: [
          // File information
          if (activeFile != null) ...[
            _FileInfoSection(file: activeFile),
          ] else ...[
            Text(
              'No file selected',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withAlpha(128),
              ),
            ),
          ],

          const Spacer(),

          // Right side information
          if (activeFile != null) ...[
            _SaveStatusIndicator(file: activeFile),
            const SizedBox(width: 16),
            _StatusItem(icon: Icons.code, label: 'UTF-8'),
            const SizedBox(width: 12),
            _StatusItem(label: 'LF'),
            const SizedBox(width: 16),
            _CursorPositionIndicator(file: activeFile),
            const SizedBox(width: 16),
            _CharacterCountIndicator(file: activeFile),
          ],
        ],
      ),
    );
  }
}

/// File information section showing path and file type.
class _FileInfoSection extends StatelessWidget {
  /// Creates the file info section.
  const _FileInfoSection({required this.file});

  /// The active file.
  final OpenFile file;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDirty = file.isDirty || file.originalContent != file.content;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          _getFileIcon(),
          size: 14,
          color: isDirty
              ? Colors.orange
              : theme.colorScheme.onSurface.withAlpha(153),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Tooltip(
            message: file.path,
            child: Text(
              file.path,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withAlpha(204),
              ),
            ),
          ),
        ),
      ],
    );
  }

  IconData _getFileIcon() {
    final ext = path.extension(file.name).toLowerCase();
    switch (ext) {
      case '.md':
      case '.markdown':
        return Icons.description;
      case '.txt':
        return Icons.text_snippet;
      case '.json':
        return Icons.data_object;
      case '.yaml':
      case '.yml':
        return Icons.settings;
      default:
        return Icons.insert_drive_file;
    }
  }
}

/// Save status indicator showing unsaved/saved/saving/error states.
class _SaveStatusIndicator extends StatelessWidget {
  /// Creates the save status indicator.
  const _SaveStatusIndicator({required this.file});

  /// The file to show status for.
  final OpenFile file;

  @override
  Widget build(BuildContext context) {
    // Check for save error first
    if (file.saveError != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.error,
            size: 12,
            color: Theme.of(context).colorScheme.error,
          ),
          const SizedBox(width: 4),
          Text(
            'Save failed',
            style: TextStyle(
              fontSize: 12,
              color: Theme.of(context).colorScheme.error,
            ),
          ),
        ],
      );
    }

    if (file.isSaving) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 10,
            height: 10,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue[400]!),
            ),
          ),
          const SizedBox(width: 4),
          Text(
            'Saving...',
            style: TextStyle(fontSize: 12, color: Colors.blue[700]),
          ),
        ],
      );
    }

    final isDirty = file.isDirty || file.originalContent != file.content;
    if (isDirty) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: Colors.orange,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            'Unsaved',
            style: TextStyle(fontSize: 12, color: Colors.orange[700]),
          ),
        ],
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.check_circle, size: 12, color: Colors.green[600]),
        const SizedBox(width: 4),
        Text('Saved', style: TextStyle(fontSize: 12, color: Colors.green[700])),
      ],
    );
  }
}

/// Cursor position indicator showing line:column.
class _CursorPositionIndicator extends StatelessWidget {
  /// Creates the cursor position indicator.
  const _CursorPositionIndicator({required this.file});

  /// The file to show cursor position for.
  final OpenFile file;

  @override
  Widget build(BuildContext context) {
    final position = file.cursorPosition;
    final line = (position?.line ?? 0) + 1;
    final column = (position?.column ?? 0) + 1;

    return _StatusItem(icon: Icons.place, label: '$line:$column');
  }
}

/// Character count indicator.
class _CharacterCountIndicator extends StatelessWidget {
  /// Creates the character count indicator.
  const _CharacterCountIndicator({required this.file});

  /// The file to count characters for.
  final OpenFile file;

  @override
  Widget build(BuildContext context) {
    final charCount = file.content.length;
    final wordCount = _countWords(file.content);
    final lineCount = '\n'.allMatches(file.content).length + 1;

    return Tooltip(
      message: 'Lines: $lineCount | Words: $wordCount',
      child: _StatusItem(icon: Icons.text_fields, label: '$charCount chars'),
    );
  }

  int _countWords(String text) {
    if (text.isEmpty) return 0;
    // Count words by splitting on whitespace
    return text.trim().split(RegExp(r'\s+')).where((s) => s.isNotEmpty).length;
  }
}

/// Generic status item widget.
class _StatusItem extends StatelessWidget {
  /// Creates a status item.
  const _StatusItem({this.icon, required this.label});

  /// Optional icon.
  final IconData? icon;

  /// Label text.
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null) ...[
          Icon(
            icon,
            size: 12,
            color: theme.colorScheme.onSurface.withAlpha(128),
          ),
          const SizedBox(width: 4),
        ],
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: theme.colorScheme.onSurface.withAlpha(178),
          ),
        ),
      ],
    );
  }
}
