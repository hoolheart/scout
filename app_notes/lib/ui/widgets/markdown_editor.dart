/// Markdown editor widget using flutter_code_editor.
library;

import 'package:app_notes/models/cursor_position.dart';
import 'package:flutter/material.dart';
import 'package:flutter_code_editor/flutter_code_editor.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:highlight/languages/markdown.dart';

import 'package:app_notes/models/models.dart';
import 'package:app_notes/state/state.dart';
import 'syntax_highlight_themes.dart';

/// Markdown editor widget with syntax highlighting and line numbers.
class MarkdownEditor extends ConsumerStatefulWidget {
  /// The file path being edited.
  final String filePath;

  /// Creates a new Markdown editor.
  const MarkdownEditor({super.key, required this.filePath});

  @override
  ConsumerState<MarkdownEditor> createState() => _MarkdownEditorState();
}

class _MarkdownEditorState extends ConsumerState<MarkdownEditor> {
  CodeController? _controller;
  String? _lastFilePath;

  @override
  void initState() {
    super.initState();
    _initializeController();
  }

  @override
  void didUpdateWidget(MarkdownEditor oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.filePath != oldWidget.filePath) {
      _disposeController();
      _initializeController();
    }
  }

  @override
  void dispose() {
    _disposeController();
    super.dispose();
  }

  void _initializeController() {
    final openFiles = ref.read(editorStateProvider);
    final openFile = openFiles
        .where((f) => f.path == widget.filePath)
        .firstOrNull;

    if (openFile != null) {
      _controller = CodeController(
        text: openFile.content,
        language: markdown,
        params: const EditorParams(tabSpaces: 2),
      );
      _controller?.addListener(_onControllerChanged);
      _lastFilePath = widget.filePath;
    }
  }

  void _disposeController() {
    _controller?.removeListener(_onControllerChanged);
    _controller?.dispose();
    _controller = null;
  }

  void _onControllerChanged() {
    final content = _controller?.text;
    if (content != null &&
        content !=
            ref
                .read(editorStateProvider)
                .where((f) => f.path == widget.filePath)
                .firstOrNull
                ?.content) {
      ref
          .read(editorStateProvider.notifier)
          .updateContent(widget.filePath, content);
    }

    // Update cursor position
    _updateCursorPosition();
  }

  void _updateCursorPosition() {
    if (_controller == null) return;

    final selection = _controller!.selection;
    if (selection.isValid) {
      final text = _controller!.text;
      final cursorOffset = selection.extentOffset;

      // Calculate line and column
      final lines = text.substring(0, cursorOffset).split('\n');
      final line = lines.length - 1;
      final column = lines.last.length;

      ref
          .read(editorStateProvider.notifier)
          .setCursorPosition(
            widget.filePath,
            CursorPosition(line: line, column: column),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final editorFontSize = ref.watch(
      appStateProvider.select((s) => s.editorFontSize),
    );
    final editorFontFamily = ref.watch(
      appStateProvider.select((s) => s.editorFontFamily),
    );

    if (_controller == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Focus(
      onKeyEvent: (node, event) {
        // Update cursor position on key events
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _updateCursorPosition();
        });
        return KeyEventResult.ignored;
      },
      child: GestureDetector(
        onTap: () {
          // Update cursor position on tap
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _updateCursorPosition();
          });
        },
        child: CodeTheme(
          data: CodeThemeData(
            styles: isDark ? highlightDarkTheme : highlightLightTheme,
          ),
          child: CodeField(
            controller: _controller!,
            textStyle: TextStyle(
              fontFamily: editorFontFamily.isEmpty
                  ? 'monospace'
                  : editorFontFamily,
              fontSize: editorFontSize,
              height: 1.5,
            ),
            lineNumberStyle: LineNumberStyle(
              textStyle: TextStyle(
                fontSize: editorFontSize - 2,
                color: theme.hintColor,
              ),
              width: 50,
              margin: 16,
            ),
            lineNumbers: true,
            onChanged: (text) {
              // Content change handled by controller listener
              _updateCursorPosition();
            },
            background: theme.colorScheme.surface,
          ),
        ),
      ),
    );
  }
}
