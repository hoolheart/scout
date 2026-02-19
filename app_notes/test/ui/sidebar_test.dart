/// Unit tests for Sidebar widget.
library;

import 'package:app_notes/models/file_entry.dart';
import 'package:app_notes/models/workspace.dart';
import 'package:app_notes/state/state.dart';
import 'package:app_notes/ui/layout/sidebar.dart';
import 'package:app_notes/ui/widgets/file_tree_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Sidebar', () {
    testWidgets('shows empty state when no workspace is open', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            workspaceStateProvider.overrideWith(() => _EmptyWorkspaceState()),
          ],
          child: const MaterialApp(home: Scaffold(body: Sidebar())),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('No folder opened'), findsOneWidget);
      expect(find.byIcon(Icons.folder_open), findsWidgets);
      expect(find.text('Open Folder'), findsOneWidget);
    });

    testWidgets('shows workspace header when folder is open', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            workspaceStateProvider.overrideWith(() => _MockWorkspaceState()),
            fileTreeRootProvider.overrideWith((ref) => _mockFileTree),
          ],
          child: const MaterialApp(home: Scaffold(body: Sidebar())),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('myworkspace'), findsOneWidget);
      expect(find.byIcon(Icons.folder), findsWidgets);
    });

    testWidgets('shows toolbar with action buttons', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            workspaceStateProvider.overrideWith(() => _MockWorkspaceState()),
            fileTreeRootProvider.overrideWith((ref) => _mockFileTree),
          ],
          child: const MaterialApp(home: Scaffold(body: Sidebar())),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.folder_open_outlined), findsOneWidget);
      expect(find.byIcon(Icons.note_add_outlined), findsOneWidget);
      expect(find.byIcon(Icons.create_new_folder_outlined), findsOneWidget);
      expect(find.byIcon(Icons.refresh), findsOneWidget);
    });

    testWidgets('shows FileTreeView when workspace is open', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            workspaceStateProvider.overrideWith(() => _MockWorkspaceState()),
            fileTreeRootProvider.overrideWith((ref) => _mockFileTree),
          ],
          child: const MaterialApp(home: Scaffold(body: Sidebar())),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(FileTreeView), findsOneWidget);
    });

    testWidgets('has resizable sidebar handle', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            workspaceStateProvider.overrideWith(() => _MockWorkspaceState()),
          ],
          child: const MaterialApp(home: Scaffold(body: Sidebar())),
        ),
      );

      await tester.pumpAndSettle();

      // The resizer should be present
      expect(find.byType(MouseRegion), findsWidgets);
    });

    testWidgets('new file button is disabled without workspace', (
      tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            workspaceStateProvider.overrideWith(() => _EmptyWorkspaceState()),
          ],
          child: const MaterialApp(home: Scaffold(body: Sidebar())),
        ),
      );

      await tester.pumpAndSettle();

      final newFileButton = tester.widget<IconButton>(
        find.byIcon(Icons.note_add_outlined),
      );
      expect(newFileButton.onPressed, isNull);
    });

    testWidgets('new folder button is disabled without workspace', (
      tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            workspaceStateProvider.overrideWith(() => _EmptyWorkspaceState()),
          ],
          child: const MaterialApp(home: Scaffold(body: Sidebar())),
        ),
      );

      await tester.pumpAndSettle();

      final newFolderButton = tester.widget<IconButton>(
        find.byIcon(Icons.create_new_folder_outlined),
      );
      expect(newFolderButton.onPressed, isNull);
    });

    testWidgets('refresh button is disabled without workspace', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            workspaceStateProvider.overrideWith(() => _EmptyWorkspaceState()),
          ],
          child: const MaterialApp(home: Scaffold(body: Sidebar())),
        ),
      );

      await tester.pumpAndSettle();

      final refreshButton = tester.widget<IconButton>(
        find.byIcon(Icons.refresh),
      );
      expect(refreshButton.onPressed, isNull);
    });

    testWidgets('displays selected file path in tree', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            workspaceStateProvider.overrideWith(() => _MockWorkspaceState()),
            fileTreeRootProvider.overrideWith((ref) => _mockFileTree),
            activeEditorFilePathProvider.overrideWith(
              (ref) => '/workspace/note.md',
            ),
          ],
          child: const MaterialApp(home: Scaffold(body: Sidebar())),
        ),
      );

      await tester.pumpAndSettle();

      // FileTreeView should be rendered with selected path
      expect(find.byType(FileTreeView), findsOneWidget);
    });
  });
}

// Mock implementations
class _EmptyWorkspaceState extends WorkspaceState {
  @override
  Workspace? build() => null;
}

class _MockWorkspaceState extends WorkspaceState {
  @override
  Workspace? build() =>
      const Workspace(path: '/home/user/myworkspace', name: 'myworkspace');
}

final _mockFileTree = FileEntry(
  name: 'myworkspace',
  path: '/home/user/myworkspace',
  isDirectory: true,
  isExpanded: true,
  children: const [
    FileEntry(
      name: 'note.md',
      path: '/home/user/myworkspace/note.md',
      isDirectory: false,
    ),
    FileEntry(
      name: 'docs',
      path: '/home/user/myworkspace/docs',
      isDirectory: true,
      isExpanded: false,
    ),
  ],
);
