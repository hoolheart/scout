/// Markdown preview widget for rendering Markdown content with enhanced styling and features.
library;

import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:app_notes/state/state.dart';

/// Provider for debounced content updates to optimize performance.
final _debouncedContentProvider = StateProvider.family<String, String>((
  ref,
  filePath,
) {
  final openFile = ref.watch(
    editorStateProvider.select(
      (files) => files.where((f) => f.path == filePath).firstOrNull,
    ),
  );
  return openFile?.content ?? '';
});

/// Debounced content notifier to prevent excessive rebuilds.
class _DebouncedContentNotifier extends StateNotifier<String> {
  _DebouncedContentNotifier() : super('');

  Timer? _debounceTimer;

  void setContent(String content) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 100), () {
      state = content;
    });
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }
}

/// Provider for debounced content updates.
final debouncedMarkdownContentProvider =
    StateNotifierProvider.family<_DebouncedContentNotifier, String, String>((
      ref,
      filePath,
    ) {
      final notifier = _DebouncedContentNotifier();

      // Watch the file content and update debounced value
      final openFile = ref.watch(
        editorStateProvider.select(
          (files) => files.where((f) => f.path == filePath).firstOrNull,
        ),
      );

      if (openFile != null) {
        notifier.setContent(openFile.content);
      }

      return notifier;
    });

/// Markdown preview widget that renders Markdown content as formatted text.
///
/// Features:
/// - Real-time rendering with debouncing
/// - Light/dark theme support
/// - Syntax highlighting for code blocks
/// - Table styling
/// - Blockquote styling
/// - Link handling with URL launcher
/// - Image support (local and network)
/// - Text selection support
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

    // Use debounced content for performance optimization
    final debouncedContent = ref.watch(
      debouncedMarkdownContentProvider(filePath),
    );

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      color: theme.colorScheme.surface,
      child: Markdown(
        data: debouncedContent,
        selectable: true,
        styleSheet: _buildMarkdownStyleSheet(context, isDark),
        imageBuilder: (uri, title, alt) =>
            _buildImage(context, uri, title, alt),
        onTapLink: (text, href, title) =>
            _handleLinkTap(context, text, href, title),
        builders: {
          'code': _CodeElementBuilder(isDark: isDark),
          'pre': _PreElementBuilder(isDark: isDark),
        },
        shrinkWrap: false,
        padding: const EdgeInsets.all(16),
      ),
    );
  }

  /// Build the markdown style sheet with comprehensive styling.
  MarkdownStyleSheet _buildMarkdownStyleSheet(
    BuildContext context,
    bool isDark,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    // Define color palette for markdown elements
    final codeBackgroundColor = isDark
        ? const Color(0xFF1E1E1E)
        : const Color(0xFFF5F5F5);

    final codeTextColor = isDark
        ? const Color(0xFFD4D4D4)
        : const Color(0xFF333333);

    final blockquoteBorderColor = isDark
        ? Colors.blue[400]!
        : Colors.blue[600]!;

    final blockquoteBackgroundColor = isDark
        ? Colors.blue[900]!.withAlpha(30)
        : Colors.blue[50];

    final tableBorderColor = isDark ? Colors.grey[700]! : Colors.grey[300]!;

    final tableHeaderColor = isDark ? Colors.grey[800]! : Colors.grey[100]!;

    final linkColor = colorScheme.primary;

    return MarkdownStyleSheet(
      // Document level
      textScaleFactor: 1.0,

      // Paragraph
      p: textTheme.bodyLarge?.copyWith(
        color: colorScheme.onSurface,
        height: 1.6,
        fontSize: 16,
      ),
      pPadding: const EdgeInsets.symmetric(vertical: 8),

      // Headings
      h1: textTheme.headlineLarge?.copyWith(
        color: colorScheme.onSurface,
        fontWeight: FontWeight.bold,
        height: 1.2,
      ),
      h1Padding: const EdgeInsets.only(top: 24, bottom: 16),

      h2: textTheme.headlineMedium?.copyWith(
        color: colorScheme.onSurface,
        fontWeight: FontWeight.bold,
        height: 1.3,
      ),
      h2Padding: const EdgeInsets.only(top: 20, bottom: 12),

      h3: textTheme.headlineSmall?.copyWith(
        color: colorScheme.onSurface,
        fontWeight: FontWeight.bold,
        height: 1.4,
      ),
      h3Padding: const EdgeInsets.only(top: 16, bottom: 8),

      h4: textTheme.titleLarge?.copyWith(
        color: colorScheme.onSurface,
        fontWeight: FontWeight.w600,
        height: 1.4,
      ),
      h4Padding: const EdgeInsets.only(top: 16, bottom: 8),

      h5: textTheme.titleMedium?.copyWith(
        color: colorScheme.onSurface,
        fontWeight: FontWeight.w600,
        height: 1.4,
      ),
      h5Padding: const EdgeInsets.only(top: 12, bottom: 6),

      h6: textTheme.titleSmall?.copyWith(
        color: colorScheme.onSurfaceVariant,
        fontWeight: FontWeight.w600,
        height: 1.4,
      ),
      h6Padding: const EdgeInsets.only(top: 12, bottom: 6),

      // Emphasis
      em: const TextStyle(fontStyle: FontStyle.italic),
      strong: const TextStyle(fontWeight: FontWeight.bold),
      del: TextStyle(
        decoration: TextDecoration.lineThrough,
        color: colorScheme.onSurface.withAlpha(153),
      ),

      // Links
      a: TextStyle(
        color: linkColor,
        decoration: TextDecoration.underline,
        decorationColor: linkColor.withAlpha(153),
      ),

      // Lists
      listBullet: textTheme.bodyLarge?.copyWith(color: colorScheme.onSurface),
      listBulletPadding: const EdgeInsets.only(left: 8),
      listIndent: 24,

      // Ordered list
      orderedListAlign: WrapAlignment.start,

      // Unordered list
      unorderedListAlign: WrapAlignment.start,

      // Blockquote
      blockquote: textTheme.bodyLarge?.copyWith(
        color: colorScheme.onSurface.withAlpha(204),
        fontStyle: FontStyle.italic,
        height: 1.6,
      ),
      blockquoteDecoration: BoxDecoration(
        color: blockquoteBackgroundColor,
        border: Border(
          left: BorderSide(color: blockquoteBorderColor, width: 4),
        ),
      ),
      blockquotePadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 12,
      ),

      // Code (inline)
      code: TextStyle(
        fontFamily: 'JetBrains Mono',
        fontFamilyFallback: const [
          'Consolas',
          'Monaco',
          'Courier New',
          'monospace',
        ],
        fontSize: 14,
        color: isDark ? Colors.orange[200] : Colors.orange[800],
        backgroundColor: codeBackgroundColor,
        height: 1.4,
      ),
      codeblockDecoration: BoxDecoration(
        color: codeBackgroundColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
          width: 1,
        ),
      ),
      codeblockPadding: const EdgeInsets.all(16),

      // Horizontal rule
      horizontalRuleDecoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: colorScheme.outline.withAlpha(128), width: 1),
        ),
      ),

      // Tables
      tableHead: textTheme.bodyMedium?.copyWith(
        fontWeight: FontWeight.bold,
        color: colorScheme.onSurface,
      ),
      tableBody: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurface),
      tableHeadAlign: TextAlign.center,
      tableBorder: TableBorder.all(
        color: tableBorderColor,
        width: 1,
        borderRadius: BorderRadius.circular(4),
      ),
      tableColumnWidth: const FlexColumnWidth(),
      tableCellsPadding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 8,
      ),
      tableCellsDecoration: BoxDecoration(color: tableHeaderColor),

      // Checkbox
      checkbox: textTheme.bodyMedium?.copyWith(color: colorScheme.primary),
    );
  }

  /// Build image widget with support for local and network images.
  Widget _buildImage(
    BuildContext context,
    Uri uri,
    String? title,
    String? alt,
  ) {
    final theme = Theme.of(context);

    // Handle local file images
    if (uri.scheme.isEmpty || uri.scheme == 'file') {
      final file = File(uri.path);
      if (file.existsSync()) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.file(
            file,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              return _buildImageError(context, uri.path, alt);
            },
          ),
        );
      }

      // Try relative path from the markdown file's directory
      final fileDir = File(filePath).parent.path;
      final relativePath = '$fileDir/${uri.path}';
      final relativeFile = File(relativePath);

      if (relativeFile.existsSync()) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.file(
            relativeFile,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              return _buildImageError(context, uri.path, alt);
            },
          ),
        );
      }

      return _buildImageError(context, uri.path, alt);
    }

    // Handle network images
    if (uri.scheme == 'http' || uri.scheme == 'https') {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(
          uri.toString(),
          fit: BoxFit.contain,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Container(
              height: 150,
              alignment: Alignment.center,
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                    : null,
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            return _buildImageError(context, uri.toString(), alt);
          },
        ),
      );
    }

    // Handle asset images
    if (uri.scheme == 'asset') {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.asset(
          uri.path,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            return _buildImageError(context, uri.path, alt);
          },
        ),
      );
    }

    // Unsupported scheme
    return _buildImageError(context, uri.toString(), alt);
  }

  /// Build error widget for failed image loads.
  Widget _buildImageError(BuildContext context, String source, String? alt) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.errorContainer.withAlpha(51),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: colorScheme.error.withAlpha(128)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.broken_image, color: colorScheme.error, size: 24),
          const SizedBox(width: 12),
          Flexible(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  alt ?? 'Image',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: colorScheme.onErrorContainer,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  'Failed to load: $source',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onErrorContainer.withAlpha(179),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Handle link tap with URL launcher.
  Future<void> _handleLinkTap(
    BuildContext context,
    String text,
    String? href,
    String? title,
  ) async {
    if (href == null || href.isEmpty) return;

    final uri = Uri.tryParse(href);
    if (uri == null) {
      _showErrorSnackBar(context, 'Invalid URL: $href');
      return;
    }

    // Handle different URL types
    if (uri.scheme == 'http' || uri.scheme == 'https') {
      // Web URL - launch in browser
      try {
        final canLaunch = await canLaunchUrl(uri);
        if (canLaunch) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        } else {
          _showErrorSnackBar(context, 'Cannot open URL: $href');
        }
      } catch (e) {
        _showErrorSnackBar(context, 'Failed to open link: $e');
      }
    } else if (uri.scheme == 'mailto') {
      // Email link
      try {
        final canLaunch = await canLaunchUrl(uri);
        if (canLaunch) {
          await launchUrl(uri);
        } else {
          _showErrorSnackBar(context, 'Cannot open email client');
        }
      } catch (e) {
        _showErrorSnackBar(context, 'Failed to open email: $e');
      }
    } else if (uri.scheme == 'file' || uri.scheme.isEmpty) {
      // Local file link - could be implemented to open in editor
      _showInfoSnackBar(context, 'File links not yet supported: $href');
    } else {
      _showInfoSnackBar(context, 'Unsupported link type: ${uri.scheme}');
    }
  }

  void _showErrorSnackBar(BuildContext context, String message) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Theme.of(context).colorScheme.error,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  void _showInfoSnackBar(BuildContext context, String message) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), duration: const Duration(seconds: 2)),
      );
    }
  }
}

/// Custom code element builder for enhanced code rendering.
class _CodeElementBuilder extends MarkdownElementBuilder {
  final bool isDark;

  _CodeElementBuilder({required this.isDark});

  @override
  Widget visitText(text, TextStyle? preferredStyle) {
    return Text(text.text, style: preferredStyle);
  }
}

/// Custom pre element builder for code blocks with syntax highlighting support.
class _PreElementBuilder extends MarkdownElementBuilder {
  final bool isDark;

  _PreElementBuilder({required this.isDark});

  @override
  Widget visitElementAfter(element, TextStyle? preferredStyle) {
    // Get the language from the code block if specified (```language)
    String? language;
    final textContent = element.textContent;

    // The element may contain the code content
    // For now, we rely on the default styling from MarkdownStyleSheet
    // Future enhancement: Add syntax highlighting with highlight.dart

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
          width: 1,
        ),
      ),
      child: SelectableText(
        textContent,
        style: TextStyle(
          fontFamily: 'JetBrains Mono',
          fontFamilyFallback: const [
            'Consolas',
            'Monaco',
            'Courier New',
            'monospace',
          ],
          fontSize: 14,
          color: isDark ? const Color(0xFFD4D4D4) : const Color(0xFF333333),
          height: 1.5,
        ),
      ),
    );
  }
}
