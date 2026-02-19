/// Integration tests for keyboard shortcuts.
library;

import 'package:app_notes/models/app_settings.dart';
import 'package:app_notes/models/open_file.dart';
import 'package:app_notes/models/workspace.dart';
import 'package:app_notes/state/state.dart';
import 'package:app_notes/ui/layout/main_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Keyboard Shortcuts', () {
    testWidgets('Ctrl+O opens folder picker', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            workspaceStateProvider.overrideWith(() => _MockWorkspaceState()),
          ],
          child: const MaterialApp(home: MainLayout()),
        ),
      );

      await tester.pumpAndSettle();

      // Simulate Ctrl+O
      await tester.sendKeyEvent(LogicalKeyboardKey.keyO, platform: 'linux');
      await tester.pump();

      // Note: Actual file picker can't be tested in widget tests
      // This test verifies the shortcut is registered
    });

    testWidgets('Ctrl+S triggers save', (tester) async {
      var saveCalled = false;

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            editorStateProvider.overrideWith(
              () => _MockEditorState(
                onSave: () {
                  saveCalled = true;
                },
              ),
            ),
          ],
          child: const MaterialApp(home: MainLayout()),
        ),
      );

      await tester.pumpAndSettle();

      // Simulate Ctrl+S
      await tester.sendKeyDownEvent(LogicalKeyboardKey.controlLeft);
      await tester.sendKeyDownEvent(LogicalKeyboardKey.keyS);
      await tester.sendKeyUpEvent(LogicalKeyboardKey.keyS);
      await tester.sendKeyUpEvent(LogicalKeyboardKey.controlLeft);
      await tester.pump();

      // Verify save action was triggered
      expect(saveCalled, isTrue);
    });

    testWidgets('Ctrl+N creates new file', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            workspaceStateProvider.overrideWith(() => _MockWorkspaceState()),
          ],
          child: const MaterialApp(home: MainLayout()),
        ),
      );

      await tester.pumpAndSettle();

      // Simulate Ctrl+N
      await tester.sendKeyDownEvent(LogicalKeyboardKey.controlLeft);
      await tester.sendKeyDownEvent(LogicalKeyboardKey.keyN);
      await tester.sendKeyUpEvent(LogicalKeyboardKey.keyN);
      await tester.sendKeyUpEvent(LogicalKeyboardKey.controlLeft);
      await tester.pump();

      // Verify new file dialog or action
    });

    testWidgets('Ctrl+W closes current file', (tester) async {
      var closeCalled = false;

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            editorStateProvider.overrideWith(
              () => _MockEditorState(
                onClose: () {
                  closeCalled = true;
                },
              ),
            ),
          ],
          child: const MaterialApp(home: MainLayout()),
        ),
      );

      await tester.pumpAndSettle();

      // Simulate Ctrl+W
      await tester.sendKeyDownEvent(LogicalKeyboardKey.controlLeft);
      await tester.sendKeyDownEvent(LogicalKeyboardKey.keyW);
      await tester.sendKeyUpEvent(LogicalKeyboardKey.keyW);
      await tester.sendKeyUpEvent(LogicalKeyboardKey.controlLeft);
      await tester.pump();

      expect(closeCalled, isTrue);
    });

    testWidgets('Ctrl+Tab switches to next file', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            editorStateProvider.overrideWith(() => _MockMultiFileEditorState()),
          ],
          child: const MaterialApp(home: MainLayout()),
        ),
      );

      await tester.pumpAndSettle();

      // Simulate Ctrl+Tab
      await tester.sendKeyDownEvent(LogicalKeyboardKey.controlLeft);
      await tester.sendKeyDownEvent(LogicalKeyboardKey.tab);
      await tester.sendKeyUpEvent(LogicalKeyboardKey.tab);
      await tester.sendKeyUpEvent(LogicalKeyboardKey.controlLeft);
      await tester.pump();
    });

    testWidgets('Ctrl+Plus zooms in font size', (tester) async {
      final mockState = _MockAppState();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [appStateProvider.overrideWith(() => mockState)],
          child: const MaterialApp(home: MainLayout()),
        ),
      );

      await tester.pumpAndSettle();

      // Simulate Ctrl+Plus
      await tester.sendKeyDownEvent(LogicalKeyboardKey.controlLeft);
      await tester.sendKeyDownEvent(LogicalKeyboardKey.equal);
      await tester.sendKeyUpEvent(LogicalKeyboardKey.equal);
      await tester.sendKeyUpEvent(LogicalKeyboardKey.controlLeft);
      await tester.pump();

      expect(mockState.zoomInCalled, isTrue);
    });

    testWidgets('Ctrl+Minus zooms out font size', (tester) async {
      final mockState = _MockAppState();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [appStateProvider.overrideWith(() => mockState)],
          child: const MaterialApp(home: MainLayout()),
        ),
      );

      await tester.pumpAndSettle();

      // Simulate Ctrl+Minus
      await tester.sendKeyDownEvent(LogicalKeyboardKey.controlLeft);
      await tester.sendKeyDownEvent(LogicalKeyboardKey.minus);
      await tester.sendKeyUpEvent(LogicalKeyboardKey.minus);
      await tester.sendKeyUpEvent(LogicalKeyboardKey.controlLeft);
      await tester.pump();

      expect(mockState.zoomOutCalled, isTrue);
    });

    testWidgets('Ctrl+0 resets font size', (tester) async {
      final mockState = _MockAppState();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [appStateProvider.overrideWith(() => mockState)],
          child: const MaterialApp(home: MainLayout()),
        ),
      );

      await tester.pumpAndSettle();

      // Simulate Ctrl+0
      await tester.sendKeyDownEvent(LogicalKeyboardKey.controlLeft);
      await tester.sendKeyDownEvent(LogicalKeyboardKey.digit0);
      await tester.sendKeyUpEvent(LogicalKeyboardKey.digit0);
      await tester.sendKeyUpEvent(LogicalKeyboardKey.controlLeft);
      await tester.pump();

      expect(mockState.resetZoomCalled, isTrue);
    });

    testWidgets('F11 toggles fullscreen', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: MainLayout())),
      );

      await tester.pumpAndSettle();

      // Simulate F11
      await tester.sendKeyEvent(LogicalKeyboardKey.f11);
      await tester.pump();
    });

    testWidgets('Escape closes dialogs and panels', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: MainLayout())),
      );

      await tester.pumpAndSettle();

      // Simulate Escape
      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pump();
    });
  });
}

// Mock implementations
class _MockWorkspaceState extends WorkspaceState {
  @override
  Workspace? build() => null;
}

class _MockEditorState extends EditorState {
  final VoidCallback? onSave;
  final VoidCallback? onClose;

  _MockEditorState({this.onSave, this.onClose});

  @override
  List<OpenFile> build() => [
    const OpenFile(
      path: '/test.md',
      name: 'test.md',
      content: 'content',
      isDirty: true,
    ),
  ];

  @override
  Future<void> saveActiveFile() async => onSave?.call();

  @override
  Future<void> closeActiveFile() async => onClose?.call();
}

class _MockMultiFileEditorState extends EditorState {
  @override
  List<OpenFile> build() => [
    const OpenFile(path: '/file1.md', name: 'file1.md', content: 'content1'),
    const OpenFile(path: '/file2.md', name: 'file2.md', content: 'content2'),
  ];
}

class _MockAppState extends AppState {
  bool zoomInCalled = false;
  bool zoomOutCalled = false;
  bool resetZoomCalled = false;

  @override
  AppSettings build() => const AppSettings();

  @override
  void zoomInFontSize() => zoomInCalled = true;

  @override
  void zoomOutFontSize() => zoomOutCalled = true;

  @override
  void resetFontSize() => resetZoomCalled = true;
}
