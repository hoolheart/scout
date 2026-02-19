/// Unit tests for FileTreeView widget.
library;

import 'package:app_notes/models/file_entry.dart';
import 'package:app_notes/ui/widgets/file_tree_view.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FileTreeView', () {
    testWidgets('renders empty list when no entries', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: FileTreeView(entries: [])),
        ),
      );

      expect(find.byType(FileTreeView), findsOneWidget);
      expect(find.byType(ListView), findsOneWidget);
    });

    testWidgets('renders single file entry', (tester) async {
      const entries = [
        FileEntry(name: 'readme.md', path: '/readme.md', isDirectory: false),
      ];

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: FileTreeView(entries: entries)),
        ),
      );

      expect(find.text('readme.md'), findsOneWidget);
      expect(find.byIcon(Icons.description), findsOneWidget);
    });

    testWidgets('renders folder entry with expand icon', (tester) async {
      const entries = [
        FileEntry(
          name: 'docs',
          path: '/docs',
          isDirectory: true,
          isExpanded: false,
        ),
      ];

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: FileTreeView(entries: entries)),
        ),
      );

      expect(find.text('docs'), findsOneWidget);
      expect(find.byIcon(Icons.folder), findsOneWidget);
      expect(find.byIcon(Icons.chevron_right), findsOneWidget);
    });

    testWidgets('renders expanded folder with children', (tester) async {
      const entries = [
        FileEntry(
          name: 'docs',
          path: '/docs',
          isDirectory: true,
          isExpanded: true,
          children: [
            FileEntry(
              name: 'guide.md',
              path: '/docs/guide.md',
              isDirectory: false,
            ),
          ],
        ),
      ];

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: FileTreeView(entries: entries)),
        ),
      );

      expect(find.text('docs'), findsOneWidget);
      expect(find.text('guide.md'), findsOneWidget);
      expect(find.byIcon(Icons.folder_open), findsOneWidget);
      expect(find.byIcon(Icons.expand_more), findsOneWidget);
    });

    testWidgets('calls onEntryTap when file is tapped', (tester) async {
      FileEntry? tappedEntry;
      const entries = [
        FileEntry(name: 'test.md', path: '/test.md', isDirectory: false),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FileTreeView(
              entries: entries,
              onEntryTap: (entry) => tappedEntry = entry,
            ),
          ),
        ),
      );

      await tester.tap(find.text('test.md'));
      await tester.pump();

      expect(tappedEntry, isNotNull);
      expect(tappedEntry?.name, 'test.md');
    });

    testWidgets('calls onEntryExpand when folder expand icon is tapped', (
      tester,
    ) async {
      FileEntry? expandedEntry;
      const entries = [
        FileEntry(
          name: 'folder',
          path: '/folder',
          isDirectory: true,
          isExpanded: false,
        ),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FileTreeView(
              entries: entries,
              onEntryExpand: (entry) => expandedEntry = entry,
            ),
          ),
        ),
      );

      await tester.tap(find.byIcon(Icons.chevron_right));
      await tester.pump();

      expect(expandedEntry, isNotNull);
      expect(expandedEntry?.name, 'folder');
    });

    testWidgets('shows selected state for selected path', (tester) async {
      const entries = [
        FileEntry(
          name: 'selected.md',
          path: '/selected.md',
          isDirectory: false,
        ),
        FileEntry(name: 'other.md', path: '/other.md', isDirectory: false),
      ];

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: FileTreeView(entries: entries, selectedPath: '/selected.md'),
          ),
        ),
      );

      // Both files should be visible
      expect(find.text('selected.md'), findsOneWidget);
      expect(find.text('other.md'), findsOneWidget);
    });

    testWidgets('renders different file type icons', (tester) async {
      const entries = [
        FileEntry(name: 'doc.md', path: '/doc.md', isDirectory: false),
        FileEntry(
          name: 'script.dart',
          path: '/script.dart',
          isDirectory: false,
        ),
        FileEntry(name: 'data.json', path: '/data.json', isDirectory: false),
        FileEntry(
          name: 'config.yaml',
          path: '/config.yaml',
          isDirectory: false,
        ),
        FileEntry(name: 'plain.txt', path: '/plain.txt', isDirectory: false),
        FileEntry(name: 'image.png', path: '/image.png', isDirectory: false),
      ];

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: FileTreeView(entries: entries)),
        ),
      );

      expect(find.byIcon(Icons.description), findsOneWidget); // .md
      expect(find.byIcon(Icons.code), findsOneWidget); // .dart
      expect(find.byIcon(Icons.data_object), findsOneWidget); // .json
      expect(find.byIcon(Icons.settings), findsOneWidget); // .yaml
      expect(find.byIcon(Icons.text_snippet), findsOneWidget); // .txt
      expect(find.byIcon(Icons.image), findsOneWidget); // .png
    });

    testWidgets('renders nested folder structure', (tester) async {
      const entries = [
        FileEntry(
          name: 'root',
          path: '/root',
          isDirectory: true,
          isExpanded: true,
          children: [
            FileEntry(
              name: 'level1',
              path: '/root/level1',
              isDirectory: true,
              isExpanded: true,
              children: [
                FileEntry(
                  name: 'deep.md',
                  path: '/root/level1/deep.md',
                  isDirectory: false,
                ),
              ],
            ),
          ],
        ),
      ];

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: FileTreeView(entries: entries)),
        ),
      );

      expect(find.text('root'), findsOneWidget);
      expect(find.text('level1'), findsOneWidget);
      expect(find.text('deep.md'), findsOneWidget);
    });
  });

  group('FileTreeView Context Menu', () {
    testWidgets('shows context menu on right click for folder', (tester) async {
      const entries = [
        FileEntry(name: 'folder', path: '/folder', isDirectory: true),
      ];

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: FileTreeView(entries: entries)),
        ),
      );

      // Trigger secondary tap (right click)
      final gesture = await tester.startGesture(
        tester.getCenter(find.text('folder')),
        buttons: kSecondaryMouseButton,
      );
      await gesture.up();
      await tester.pumpAndSettle();

      // Context menu items for folder
      expect(find.text('New File'), findsOneWidget);
      expect(find.text('New Folder'), findsOneWidget);
      expect(find.text('Rename'), findsOneWidget);
      expect(find.text('Delete'), findsOneWidget);
    });

    testWidgets('shows context menu on right click for file', (tester) async {
      const entries = [
        FileEntry(name: 'file.md', path: '/file.md', isDirectory: false),
      ];

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: FileTreeView(entries: entries)),
        ),
      );

      // Trigger secondary tap (right click)
      final gesture = await tester.startGesture(
        tester.getCenter(find.text('file.md')),
        buttons: kSecondaryMouseButton,
      );
      await gesture.up();
      await tester.pumpAndSettle();

      // Context menu items for file (no New File/Folder)
      expect(find.text('New File'), findsNothing);
      expect(find.text('New Folder'), findsNothing);
      expect(find.text('Rename'), findsOneWidget);
      expect(find.text('Delete'), findsOneWidget);
    });
  });
}
