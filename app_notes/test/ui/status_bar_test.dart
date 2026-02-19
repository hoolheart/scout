/// Unit tests for StatusBar widget.
library;

import 'package:app_notes/models/app_settings.dart';
import 'package:app_notes/models/cursor_position.dart';
import 'package:app_notes/models/open_file.dart';
import 'package:app_notes/state/state.dart';
import 'package:app_notes/ui/layout/status_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('StatusBar', () {
    testWidgets('shows "No file selected" when no file is open', (
      tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [activeEditorFileProvider.overrideWith((ref) => null)],
          child: const MaterialApp(home: Scaffold(body: StatusBar())),
        ),
      );

      expect(find.text('No file selected'), findsOneWidget);
    });

    testWidgets('shows file path when file is open', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            activeEditorFileProvider.overrideWith((ref) => _mockOpenFile),
          ],
          child: const MaterialApp(home: Scaffold(body: StatusBar())),
        ),
      );

      expect(find.text('/workspace/document.md'), findsOneWidget);
    });

    testWidgets('shows saved status for clean file', (tester) async {
      const cleanFile = OpenFile(
        path: '/test.md',
        name: 'test.md',
        content: 'content',
        originalContent: 'content',
        isDirty: false,
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            activeEditorFileProvider.overrideWith((ref) => cleanFile),
          ],
          child: const MaterialApp(home: Scaffold(body: StatusBar())),
        ),
      );

      expect(find.text('Saved'), findsOneWidget);
    });

    testWidgets('shows unsaved status for dirty file', (tester) async {
      const dirtyFile = OpenFile(
        path: '/test.md',
        name: 'test.md',
        content: 'modified content',
        originalContent: 'original content',
        isDirty: true,
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            activeEditorFileProvider.overrideWith((ref) => dirtyFile),
          ],
          child: const MaterialApp(home: Scaffold(body: StatusBar())),
        ),
      );

      expect(find.text('Unsaved'), findsOneWidget);
    });

    testWidgets('shows saving status', (tester) async {
      const savingFile = OpenFile(
        path: '/test.md',
        name: 'test.md',
        content: 'content',
        isSaving: true,
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            activeEditorFileProvider.overrideWith((ref) => savingFile),
          ],
          child: const MaterialApp(home: Scaffold(body: StatusBar())),
        ),
      );

      expect(find.text('Saving...'), findsOneWidget);
    });

    testWidgets('shows error status when save fails', (tester) async {
      const errorFile = OpenFile(
        path: '/test.md',
        name: 'test.md',
        content: 'content',
        saveError: 'Permission denied',
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            activeEditorFileProvider.overrideWith((ref) => errorFile),
          ],
          child: const MaterialApp(home: Scaffold(body: StatusBar())),
        ),
      );

      expect(find.text('Save failed'), findsOneWidget);
    });

    testWidgets('shows cursor position', (tester) async {
      const fileWithCursor = OpenFile(
        path: '/test.md',
        name: 'test.md',
        content: 'Line 1\nLine 2',
        cursorPosition: CursorPosition(line: 1, column: 5),
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            activeEditorFileProvider.overrideWith((ref) => fileWithCursor),
          ],
          child: const MaterialApp(home: Scaffold(body: StatusBar())),
        ),
      );

      // Line 2, Column 6 (0-indexed + 1)
      expect(find.text('2:6'), findsOneWidget);
    });

    testWidgets('shows character count', (tester) async {
      const fileWithContent = OpenFile(
        path: '/test.md',
        name: 'test.md',
        content: 'Hello World',
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            activeEditorFileProvider.overrideWith((ref) => fileWithContent),
          ],
          child: const MaterialApp(home: Scaffold(body: StatusBar())),
        ),
      );

      expect(find.text('11 chars'), findsOneWidget);
    });

    testWidgets('shows UTF-8 encoding indicator', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            activeEditorFileProvider.overrideWith((ref) => _mockOpenFile),
          ],
          child: const MaterialApp(home: Scaffold(body: StatusBar())),
        ),
      );

      expect(find.text('UTF-8'), findsOneWidget);
    });

    testWidgets('shows LF line ending indicator', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            activeEditorFileProvider.overrideWith((ref) => _mockOpenFile),
          ],
          child: const MaterialApp(home: Scaffold(body: StatusBar())),
        ),
      );

      expect(find.text('LF'), findsOneWidget);
    });

    testWidgets('shows font size indicator', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            activeEditorFileProvider.overrideWith((ref) => _mockOpenFile),
            appStateProvider.overrideWith(() => _MockAppState(fontSize: 16)),
          ],
          child: const MaterialApp(home: Scaffold(body: StatusBar())),
        ),
      );

      expect(find.text('16px'), findsOneWidget);
    });

    testWidgets('has correct height', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(home: Scaffold(body: StatusBar())),
        ),
      );

      final statusBar = tester.widget<Container>(find.byType(StatusBar));
      expect(statusBar.constraints?.minHeight, 28);
    });
  });
}

const _mockOpenFile = OpenFile(
  path: '/workspace/document.md',
  name: 'document.md',
  content: 'Test content',
  originalContent: 'Test content',
  isDirty: false,
);

class _MockAppState extends AppState {
  final double fontSize;

  _MockAppState({required this.fontSize});

  @override
  AppSettings build() => AppSettings(editorFontSize: fontSize);
}
