/// Unit tests for EditorArea widget.
library;

import 'package:app_notes/models/models.dart';
import 'package:app_notes/services/settings_service.dart';
import 'package:app_notes/state/app_state.dart';
import 'package:app_notes/state/state.dart';
import 'package:app_notes/ui/layout/editor_area.dart';
import 'package:app_notes/ui/widgets/markdown_editor.dart';
import 'package:app_notes/ui/widgets/markdown_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('EditorArea', () {
    setUp(() async {
      SharedPreferences.setMockInitialValues({});
    });

    testWidgets('shows empty state when no files open', (tester) async {
      final prefs = await SharedPreferences.getInstance();
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            editorStateProvider.overrideWith(() => _EmptyEditorState()),
            settingsServiceProvider.overrideWithValue(SettingsService(prefs)),
          ],
          child: const MaterialApp(home: EditorArea()),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Select a file to view or edit'), findsOneWidget);
      expect(find.byIcon(Icons.edit_note), findsOneWidget);
    });

    testWidgets('shows tab bar when files are open', (tester) async {
      final prefs = await SharedPreferences.getInstance();
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            editorStateProvider.overrideWith(() => _MockEditorState()),
            settingsServiceProvider.overrideWithValue(SettingsService(prefs)),
            editorPreviewRatioProvider.overrideWith(
              () => _MockEditorPreviewRatio(),
            ),
          ],
          child: const MaterialApp(home: EditorArea()),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('test.md'), findsOneWidget);
    });

    testWidgets('shows editor when file is active', (tester) async {
      final prefs = await SharedPreferences.getInstance();
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            editorStateProvider.overrideWith(() => _MockEditorState()),
            settingsServiceProvider.overrideWithValue(SettingsService(prefs)),
            editorPreviewRatioProvider.overrideWith(
              () => _MockEditorPreviewRatio(),
            ),
          ],
          child: const MaterialApp(home: EditorArea()),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(MarkdownEditor), findsOneWidget);
    });

    testWidgets('shows preview when enabled', (tester) async {
      final prefs = await SharedPreferences.getInstance();
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            editorStateProvider.overrideWith(() => _MockEditorState()),
            previewStateProvider.overrideWith(() => _EnabledPreviewState()),
            settingsServiceProvider.overrideWithValue(SettingsService(prefs)),
            editorPreviewRatioProvider.overrideWith(
              () => _MockEditorPreviewRatio(),
            ),
          ],
          child: const MaterialApp(home: EditorArea()),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(MarkdownEditor), findsOneWidget);
      expect(find.byType(MarkdownPreview), findsOneWidget);
    });

    testWidgets('hides preview when disabled', (tester) async {
      final prefs = await SharedPreferences.getInstance();
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            editorStateProvider.overrideWith(() => _MockEditorState()),
            previewStateProvider.overrideWith(() => _DisabledPreviewState()),
            settingsServiceProvider.overrideWithValue(SettingsService(prefs)),
            editorPreviewRatioProvider.overrideWith(
              () => _MockEditorPreviewRatio(),
            ),
          ],
          child: const MaterialApp(home: EditorArea()),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(MarkdownEditor), findsOneWidget);
      expect(find.byType(MarkdownPreview), findsNothing);
    });

    testWidgets('shows dirty indicator on unsaved changes', (tester) async {
      final prefs = await SharedPreferences.getInstance();
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            editorStateProvider.overrideWith(() => _DirtyEditorState()),
            settingsServiceProvider.overrideWithValue(SettingsService(prefs)),
            editorPreviewRatioProvider.overrideWith(
              () => _MockEditorPreviewRatio(),
            ),
          ],
          child: const MaterialApp(home: EditorArea()),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('●'), findsOneWidget);
    });

    testWidgets('can close tab', (tester) async {
      final prefs = await SharedPreferences.getInstance();
      final mockState = _MockEditorState();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            editorStateProvider.overrideWith(() => mockState),
            settingsServiceProvider.overrideWithValue(SettingsService(prefs)),
            editorPreviewRatioProvider.overrideWith(
              () => _MockEditorPreviewRatio(),
            ),
          ],
          child: const MaterialApp(home: EditorArea()),
        ),
      );

      await tester.pumpAndSettle();

      // Tap close button
      await tester.tap(find.byIcon(Icons.close));
      await tester.pumpAndSettle();

      expect(mockState.closedFiles, contains('/test/file.md'));
    });

    testWidgets('can switch active file by tapping tab', (tester) async {
      final prefs = await SharedPreferences.getInstance();
      final mockState = _MultiFileEditorState();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            editorStateProvider.overrideWith(() => mockState),
            settingsServiceProvider.overrideWithValue(SettingsService(prefs)),
            editorPreviewRatioProvider.overrideWith(
              () => _MockEditorPreviewRatio(),
            ),
          ],
          child: const MaterialApp(home: EditorArea()),
        ),
      );

      await tester.pumpAndSettle();

      // Tap on second file tab
      await tester.tap(find.text('file2.md'));
      await tester.pumpAndSettle();

      expect(mockState.activeFilePath, equals('/test/file2.md'));
    });

    testWidgets('save button enabled only on changes', (tester) async {
      final prefs = await SharedPreferences.getInstance();
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            editorStateProvider.overrideWith(() => _CleanEditorState()),
            settingsServiceProvider.overrideWithValue(SettingsService(prefs)),
            editorPreviewRatioProvider.overrideWith(
              () => _MockEditorPreviewRatio(),
            ),
          ],
          child: const MaterialApp(home: EditorArea()),
        ),
      );

      await tester.pumpAndSettle();

      // Save button should be disabled when no changes
      final saveButton = tester.widget<FilledButton>(
        find.widgetWithText(FilledButton, 'Save'),
      );
      expect(saveButton.onPressed, isNull);
    });

    testWidgets('save button enabled when changes exist', (tester) async {
      final prefs = await SharedPreferences.getInstance();
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            editorStateProvider.overrideWith(() => _DirtyEditorState()),
            settingsServiceProvider.overrideWithValue(SettingsService(prefs)),
            editorPreviewRatioProvider.overrideWith(
              () => _MockEditorPreviewRatio(),
            ),
          ],
          child: const MaterialApp(home: EditorArea()),
        ),
      );

      await tester.pumpAndSettle();

      // Save button should be enabled when changes exist
      final saveButton = tester.widget<FilledButton>(
        find.widgetWithText(FilledButton, 'Save'),
      );
      expect(saveButton.onPressed, isNotNull);
    });
  });
}

// Mock implementations for testing
class _EmptyEditorState extends EditorState {
  @override
  List<OpenFile> build() => [];
}

class _MockEditorState extends EditorState {
  final List<String> _closedFiles = [];

  @override
  List<OpenFile> build() => [
    const OpenFile(
      path: '/test/file.md',
      name: 'test.md',
      content: '# Test',
      originalContent: '# Test',
      isDirty: false,
    ),
  ];

  @override
  Future<void> closeFile(String filePath) async {
    _closedFiles.add(filePath);
    state = state.where((f) => f.path != filePath).toList();
  }

  List<String> get closedFiles => _closedFiles;

  @override
  OpenFile? get activeFile => state.isNotEmpty ? state.first : null;

  @override
  String? get activeFilePath => activeFile?.path;
}

class _DirtyEditorState extends EditorState {
  @override
  List<OpenFile> build() => [
    const OpenFile(
      path: '/test/file.md',
      name: 'dirty.md',
      content: '# Modified',
      originalContent: '# Original',
      isDirty: true,
    ),
  ];

  @override
  bool hasUnsavedChanges(String filePath) => true;
}

class _CleanEditorState extends EditorState {
  @override
  List<OpenFile> build() => [
    const OpenFile(
      path: '/test/file.md',
      name: 'clean.md',
      content: '# Content',
      originalContent: '# Content',
      isDirty: false,
    ),
  ];

  @override
  bool hasUnsavedChanges(String filePath) => false;
}

class _EnabledPreviewState extends PreviewState {
  @override
  bool build() => true;
}

class _DisabledPreviewState extends PreviewState {
  @override
  bool build() => false;
}

class _MockEditorPreviewRatio extends EditorPreviewRatio {
  @override
  double build() => 0.5;
}

class _MultiFileEditorState extends EditorState {
  String? _activeFilePath;

  @override
  List<OpenFile> build() => [
    const OpenFile(
      path: '/test/file1.md',
      name: 'file1.md',
      content: '# File 1',
      originalContent: '# File 1',
      isDirty: false,
    ),
    const OpenFile(
      path: '/test/file2.md',
      name: 'file2.md',
      content: '# File 2',
      originalContent: '# File 2',
      isDirty: false,
    ),
  ];

  @override
  void setActiveFile(String filePath) {
    _activeFilePath = filePath;
  }

  @override
  String? get activeFilePath => _activeFilePath ?? '/test/file1.md';
}
