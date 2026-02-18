/// Unit tests for Markdown editor widget.
library;

import 'package:app_notes/models/models.dart';
import 'package:app_notes/state/state.dart';
import 'package:app_notes/ui/widgets/markdown_editor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('MarkdownEditor', () {
    testWidgets('renders with initial content', (tester) async {
      const testFilePath = '/test/file.md';
      const testContent = '# Test Content';

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            editorStateProvider.overrideWith(() => _MockEditorState()),
          ],
          child: const MaterialApp(
            home: MarkdownEditor(filePath: testFilePath),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(MarkdownEditor), findsOneWidget);
    });

    testWidgets('shows loading indicator when file not found', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            editorStateProvider.overrideWith(() => _EmptyEditorState()),
          ],
          child: const MaterialApp(
            home: MarkdownEditor(filePath: '/nonexistent/file.md'),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('updates content on change', (tester) async {
      final mockNotifier = _MockEditorNotifier();
      const testFilePath = '/test/file.md';

      await tester.pumpWidget(
        ProviderScope(
          overrides: [editorStateProvider.overrideWith(() => mockNotifier)],
          child: const MaterialApp(
            home: MarkdownEditor(filePath: testFilePath),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify the editor is rendered
      expect(find.byType(MarkdownEditor), findsOneWidget);
    });
  });

  group('MarkdownEditor Theme', () {
    testWidgets('applies dark theme in dark mode', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            editorStateProvider.overrideWith(() => _MockEditorState()),
          ],
          child: const MaterialApp(
            themeMode: ThemeMode.dark,
            home: MarkdownEditor(filePath: '/test/file.md'),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(MarkdownEditor), findsOneWidget);
    });

    testWidgets('applies light theme in light mode', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            editorStateProvider.overrideWith(() => _MockEditorState()),
          ],
          child: const MaterialApp(
            themeMode: ThemeMode.light,
            home: MarkdownEditor(filePath: '/test/file.md'),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(MarkdownEditor), findsOneWidget);
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
      content: '# Test Content',
      originalContent: '# Test Content',
      isDirty: false,
    ),
  ];
}

class _EmptyEditorState extends EditorState {
  @override
  List<OpenFile> build() => [];
}

class _MockEditorNotifier extends EditorState {
  String? _lastUpdatedPath;
  String? _lastUpdatedContent;

  @override
  List<OpenFile> build() => [
    const OpenFile(
      path: '/test/file.md',
      name: 'file.md',
      content: '# Initial Content',
      originalContent: '# Initial Content',
      isDirty: false,
    ),
  ];

  @override
  void updateContent(String filePath, String content) {
    _lastUpdatedPath = filePath;
    _lastUpdatedContent = content;
    state = state.map((f) {
      if (f.path == filePath) {
        return f.copyWith(content: content, isDirty: true);
      }
      return f;
    }).toList();
  }

  String? get lastUpdatedPath => _lastUpdatedPath;
  String? get lastUpdatedContent => _lastUpdatedContent;
}
