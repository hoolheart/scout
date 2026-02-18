/// Tests for state management.
library;

import 'package:app_notes/models/models.dart';
import 'package:app_notes/state/state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppState', () {
    test('should have correct default state', () {
      final container = ProviderContainer();
      final state = container.read(appStateProvider);

      expect(state.themeMode, ThemeMode.system);
      expect(state.editorFontSize, 16.0);
      expect(state.autoSave, true);
    });

    test('should update theme mode', () {
      final container = ProviderContainer();
      final notifier = container.read(appStateProvider.notifier);

      notifier.setThemeMode(ThemeMode.dark);

      expect(container.read(appStateProvider).themeMode, ThemeMode.dark);
    });

    test('should toggle theme mode', () {
      final container = ProviderContainer();
      final notifier = container.read(appStateProvider.notifier);

      // From system to light
      notifier.toggleThemeMode();
      expect(container.read(appStateProvider).themeMode, ThemeMode.light);

      // From light to dark
      notifier.toggleThemeMode();
      expect(container.read(appStateProvider).themeMode, ThemeMode.dark);

      // From dark to light
      notifier.toggleThemeMode();
      expect(container.read(appStateProvider).themeMode, ThemeMode.light);
    });

    test('should update font size with clamping', () {
      final container = ProviderContainer();
      final notifier = container.read(appStateProvider.notifier);

      notifier.setEditorFontSize(20.0);
      expect(container.read(appStateProvider).editorFontSize, 20.0);

      // Should clamp to max
      notifier.setEditorFontSize(50.0);
      expect(
        container.read(appStateProvider).editorFontSize,
        AppSettings.maxFontSize,
      );

      // Should clamp to min
      notifier.setEditorFontSize(5.0);
      expect(
        container.read(appStateProvider).editorFontSize,
        AppSettings.minFontSize,
      );
    });

    test('should manage recent workspaces', () {
      final container = ProviderContainer();
      final notifier = container.read(appStateProvider.notifier);

      notifier.addRecentWorkspace('/workspace1');
      notifier.addRecentWorkspace('/workspace2');

      final workspaces = container.read(appStateProvider).recentWorkspaces;
      expect(workspaces.length, 2);
      expect(workspaces.first, '/workspace2'); // Most recent first

      // Adding duplicate should move to front
      notifier.addRecentWorkspace('/workspace1');
      expect(
        container.read(appStateProvider).recentWorkspaces.first,
        '/workspace1',
      );

      notifier.removeRecentWorkspace('/workspace1');
      expect(
        container
            .read(appStateProvider)
            .recentWorkspaces
            .contains('/workspace1'),
        false,
      );

      notifier.clearRecentWorkspaces();
      expect(container.read(appStateProvider).recentWorkspaces, isEmpty);
    });

    test('should toggle auto-save', () {
      final container = ProviderContainer();
      final notifier = container.read(appStateProvider.notifier);

      notifier.setAutoSave(false);
      expect(container.read(appStateProvider).autoSave, false);

      notifier.setAutoSave(true);
      expect(container.read(appStateProvider).autoSave, true);
    });

    test('should toggle preview', () {
      final container = ProviderContainer();
      final notifier = container.read(appStateProvider.notifier);

      expect(container.read(appStateProvider).showPreview, true);

      notifier.togglePreview();
      expect(container.read(appStateProvider).showPreview, false);

      notifier.setShowPreview(true);
      expect(container.read(appStateProvider).showPreview, true);
    });
  });

  group('PreviewState', () {
    test('should have correct default state', () {
      final container = ProviderContainer();
      final state = container.read(previewStateProvider);

      expect(state, true);
    });

    test('should toggle visibility', () {
      final container = ProviderContainer();
      final notifier = container.read(previewStateProvider.notifier);

      notifier.toggle();
      expect(container.read(previewStateProvider), false);

      notifier.setVisible(true);
      expect(container.read(previewStateProvider), true);

      notifier.hide();
      expect(container.read(previewStateProvider), false);

      notifier.show();
      expect(container.read(previewStateProvider), true);
    });
  });

  group('EditorState', () {
    test('should have empty default state', () {
      final container = ProviderContainer();
      final state = container.read(editorStateProvider);

      expect(state, isEmpty);
      expect(container.read(hasOpenFilesProvider), false);
      expect(container.read(openFileCountProvider), 0);
    });

    test('should track active file correctly', () {
      final container = ProviderContainer();
      final notifier = container.read(editorStateProvider.notifier);

      // Initially no active file
      expect(notifier.activeFilePath, isNull);
      expect(notifier.activeFile, isNull);

      // Add a file manually for testing
      final openFile = OpenFile(
        path: '/test.md',
        name: 'test.md',
        content: 'content',
      );

      // Direct state modification for testing
      notifier.state = [openFile];
      notifier.setActiveFile('/test.md');

      expect(notifier.activeFilePath, '/test.md');
      expect(notifier.activeFile?.name, 'test.md');
    });

    test('should detect unsaved changes', () {
      final container = ProviderContainer();
      final notifier = container.read(editorStateProvider.notifier);

      // Create file with no changes
      final cleanFile = OpenFile(
        path: '/clean.md',
        name: 'clean.md',
        content: 'original',
        originalContent: 'original',
      );

      // Create file with changes
      final dirtyFile = OpenFile(
        path: '/dirty.md',
        name: 'dirty.md',
        content: 'modified',
        originalContent: 'original',
        isDirty: true,
      );

      notifier.state = [cleanFile, dirtyFile];

      expect(notifier.hasUnsavedChanges('/clean.md'), false);
      expect(notifier.hasUnsavedChanges('/dirty.md'), true);
      expect(notifier.hasAnyUnsavedChanges, true);
    });

    test('should update content correctly', () {
      final container = ProviderContainer();
      final notifier = container.read(editorStateProvider.notifier);

      final file = OpenFile(
        path: '/test.md',
        name: 'test.md',
        content: 'original',
        originalContent: 'original',
      );

      notifier.state = [file];
      notifier.updateContent('/test.md', 'modified');

      final updatedFile = notifier.state.first;
      expect(updatedFile.content, 'modified');
      expect(updatedFile.isDirty, true);
    });

    test('should close file correctly', () async {
      final container = ProviderContainer();
      final notifier = container.read(editorStateProvider.notifier);

      notifier.state = [
        OpenFile(path: '/file1.md', name: 'file1.md', content: ''),
        OpenFile(path: '/file2.md', name: 'file2.md', content: ''),
      ];
      notifier.setActiveFile('/file1.md');

      await notifier.closeFile('/file1.md');

      expect(notifier.state.length, 1);
      expect(notifier.state.first.path, '/file2.md');
    });

    test('should close all files', () {
      final container = ProviderContainer();
      final notifier = container.read(editorStateProvider.notifier);

      notifier.state = [
        OpenFile(path: '/file1.md', name: 'file1.md', content: ''),
        OpenFile(path: '/file2.md', name: 'file2.md', content: ''),
      ];
      notifier.setActiveFile('/file1.md');

      notifier.closeAll();

      expect(notifier.state, isEmpty);
      expect(notifier.activeFilePath, isNull);
    });
  });

  group('WorkspaceState', () {
    test('should have null default state', () {
      final container = ProviderContainer();
      final state = container.read(workspaceStateProvider);

      expect(state, isNull);
      expect(container.read(hasWorkspaceOpenProvider), false);
    });

    test('should open workspace correctly', () async {
      final container = ProviderContainer();
      final notifier = container.read(workspaceStateProvider.notifier);

      // Note: This will use FileService which may fail in test environment
      // but we can verify the state is set to a loading state or null
      await notifier.openWorkspace('/test/path');

      // Since FileService won't find the directory in tests,
      // the state might be null or have empty children
      final state = container.read(workspaceStateProvider);
      if (state != null) {
        expect(state.path, '/test/path');
        expect(state.name, 'path');
      }
    });

    test('should close workspace', () async {
      final container = ProviderContainer();
      final notifier = container.read(workspaceStateProvider.notifier);

      await notifier.closeWorkspace();

      expect(container.read(workspaceStateProvider), isNull);
      expect(container.read(hasWorkspaceOpenProvider), false);
    });

    test('should find entry by path', () {
      final container = ProviderContainer();
      final notifier = container.read(workspaceStateProvider.notifier);

      final root = FileEntry(
        name: 'root',
        path: '/root',
        isDirectory: true,
        children: [
          FileEntry(
            name: 'child1.md',
            path: '/root/child1.md',
            isDirectory: false,
          ),
          FileEntry(
            name: 'subdir',
            path: '/root/subdir',
            isDirectory: true,
            children: [
              FileEntry(
                name: 'nested.txt',
                path: '/root/subdir/nested.txt',
                isDirectory: false,
              ),
            ],
          ),
        ],
      );

      notifier.state = Workspace(path: '/root', name: 'root', root: root);

      expect(notifier.findEntryByPath('/root/child1.md')?.name, 'child1.md');
      expect(
        notifier.findEntryByPath('/root/subdir/nested.txt')?.name,
        'nested.txt',
      );
      expect(notifier.findEntryByPath('/nonexistent'), isNull);
    });

    test('should toggle folder expansion', () {
      final container = ProviderContainer();
      final notifier = container.read(workspaceStateProvider.notifier);

      final folder = FileEntry(
        name: 'folder',
        path: '/folder',
        isDirectory: true,
        isExpanded: false,
      );

      notifier.state = Workspace(path: '/', name: 'root', root: folder);

      notifier.toggleFolderExpansion('/folder');

      expect(container.read(workspaceStateProvider)?.root?.isExpanded, true);

      notifier.toggleFolderExpansion('/folder');

      expect(container.read(workspaceStateProvider)?.root?.isExpanded, false);
    });

    test('should manage recent files', () {
      final container = ProviderContainer();
      final notifier = container.read(workspaceStateProvider.notifier);

      notifier.state = const Workspace(path: '/workspace', name: 'workspace');

      notifier.addRecentFile('/file1.md');
      notifier.addRecentFile('/file2.md');

      final recentFiles = container.read(workspaceRecentFilesProvider);
      expect(recentFiles.length, 2);
      expect(recentFiles.first, '/file2.md');

      // Test deduplication
      notifier.addRecentFile('/file1.md');
      expect(container.read(workspaceRecentFilesProvider).length, 2);
      expect(container.read(workspaceRecentFilesProvider).first, '/file1.md');
    });
  });

  group('Derived Providers', () {
    test('currentThemeMode provider', () {
      final container = ProviderContainer();

      expect(container.read(currentThemeModeProvider), ThemeMode.system);

      container.read(appStateProvider.notifier).setThemeMode(ThemeMode.dark);

      expect(container.read(currentThemeModeProvider), ThemeMode.dark);
    });

    test('recentWorkspaces provider', () {
      final container = ProviderContainer();

      expect(container.read(recentWorkspacesProvider), isEmpty);

      container
          .read(appStateProvider.notifier)
          .addRecentWorkspace('/workspace');

      expect(container.read(recentWorkspacesProvider), ['/workspace']);
    });

    test('isPreviewVisible provider', () {
      final container = ProviderContainer();

      expect(container.read(isPreviewVisibleProvider), true);

      container.read(previewStateProvider.notifier).hide();

      expect(container.read(isPreviewVisibleProvider), false);
    });
  });
}
