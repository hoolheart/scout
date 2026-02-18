/// Unit tests for Markdown preview widget.
library;

import 'package:app_notes/models/models.dart';
import 'package:app_notes/state/state.dart';
import 'package:app_notes/ui/widgets/markdown_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('MarkdownPreview', () {
    testWidgets('renders markdown content', (tester) async {
      const testFilePath = '/test/file.md';

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            editorStateProvider.overrideWith(() => _MockEditorState()),
          ],
          child: const MaterialApp(
            home: MarkdownPreview(filePath: testFilePath),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(Markdown), findsOneWidget);
      expect(find.textContaining('Test Content'), findsOneWidget);
    });

    testWidgets('shows empty state when file not found', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            editorStateProvider.overrideWith(() => _EmptyEditorState()),
          ],
          child: const MaterialApp(
            home: MarkdownPreview(filePath: '/nonexistent/file.md'),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('No file selected'), findsOneWidget);
    });

    testWidgets('renders headings correctly', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            editorStateProvider.overrideWith(
              () => _CustomContentState('# Heading 1\n## Heading 2'),
            ),
          ],
          child: const MaterialApp(
            home: MarkdownPreview(filePath: '/test/file.md'),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(Markdown), findsOneWidget);
      expect(find.textContaining('Heading 1'), findsOneWidget);
      expect(find.textContaining('Heading 2'), findsOneWidget);
    });

    testWidgets('renders code blocks', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            editorStateProvider.overrideWith(
              () => _CustomContentState('```dart\nprint("Hello");\n```'),
            ),
          ],
          child: const MaterialApp(
            home: MarkdownPreview(filePath: '/test/file.md'),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(Markdown), findsOneWidget);
    });

    testWidgets('renders links', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            editorStateProvider.overrideWith(
              () => _CustomContentState('[Link](https://example.com)'),
            ),
          ],
          child: const MaterialApp(
            home: MarkdownPreview(filePath: '/test/file.md'),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(Markdown), findsOneWidget);
    });
  });
}

// Mock implementations for testing
class _MockEditorState extends EditorState {
  @override
  List<OpenFile> build() => [
    const OpenFile(
      path: '/test/file.md',
      name: 'file.md',
      content: '# Test Content\n\nThis is a test paragraph.',
      originalContent: '# Test Content\n\nThis is a test paragraph.',
      isDirty: false,
    ),
  ];
}

class _EmptyEditorState extends EditorState {
  @override
  List<OpenFile> build() => [];
}

class _CustomContentState extends EditorState {
  final String content;

  _CustomContentState(this.content);

  @override
  List<OpenFile> build() => [
    OpenFile(
      path: '/test/file.md',
      name: 'file.md',
      content: content,
      originalContent: content,
      isDirty: false,
    ),
  ];
}
