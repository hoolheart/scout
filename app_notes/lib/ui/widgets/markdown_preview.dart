/// Markdown preview widget for rendering Markdown content.
library;

import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:app_notes/state/state.dart';

/// Markdown preview widget that renders Markdown content as formatted text.
class MarkdownPreview extends ConsumerWidget {
  /// The file path to preview.
  final String filePath;

  /// Creates a new Markdown preview.
  const MarkdownPreview({super.key, required this.filePath});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final openFile = ref.watch(
      editorStateProvider.select(
        (files) => files.where((f) => f.path == filePath).firstOrNull,
      ),
    );

    if (openFile == null) {
      return Container(
        color: Theme.of(context).colorScheme.surface,
        child: const Center(child: Text('No file selected')),
      );
    }

    final theme = Theme.of(context);

    return Container(
      color: theme.colorScheme.surface,
      child: Markdown(
        data: openFile.content,
        selectable: true,
        styleSheet: MarkdownStyleSheet.fromTheme(theme).copyWith(
          p: theme.textTheme.bodyLarge?.copyWith(height: 1.6),
          code: TextStyle(
            fontFamily: 'monospace',
            fontSize: 14,
            backgroundColor: theme.colorScheme.surfaceContainerHighest,
          ),
          codeblockDecoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(8),
          ),
          h1: theme.textTheme.headlineLarge,
          h2: theme.textTheme.headlineMedium,
          h3: theme.textTheme.headlineSmall,
          h4: theme.textTheme.titleLarge,
          h5: theme.textTheme.titleMedium,
          h6: theme.textTheme.titleSmall,
          blockquote: theme.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            fontStyle: FontStyle.italic,
          ),
          blockquoteDecoration: BoxDecoration(
            border: Border(
              left: BorderSide(color: theme.colorScheme.primary, width: 4),
            ),
          ),
          blockquotePadding: const EdgeInsets.only(left: 16),
        ),
      ),
    );
  }
}
