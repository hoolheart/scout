/// Tests for models.
library;

import 'package:app_notes/models/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FileEntry', () {
    test('should create FileEntry correctly', () {
      const entry = FileEntry(
        name: 'test.md',
        path: '/docs/test.md',
        isDirectory: false,
        size: 1024,
      );

      expect(entry.name, 'test.md');
      expect(entry.path, '/docs/test.md');
      expect(entry.isDirectory, false);
      expect(entry.size, 1024);
      expect(entry.isExpanded, false);
      expect(entry.children, isEmpty);
    });

    test('should detect markdown files correctly', () {
      const mdFile = FileEntry(
        name: 'readme.md',
        path: '/readme.md',
        isDirectory: false,
      );
      const txtFile = FileEntry(
        name: 'notes.txt',
        path: '/notes.txt',
        isDirectory: false,
      );
      const folder = FileEntry(name: 'docs', path: '/docs', isDirectory: true);

      expect(mdFile.isMarkdown, true);
      expect(txtFile.isMarkdown, false);
      expect(folder.isMarkdown, false);
    });

    test('should return correct extension', () {
      const file = FileEntry(
        name: 'document.md',
        path: '/document.md',
        isDirectory: false,
      );
      const folder = FileEntry(
        name: 'myfolder',
        path: '/myfolder',
        isDirectory: true,
      );

      expect(file.extension, 'md');
      expect(folder.extension, '');
    });

    test('should detect hasChildren correctly', () {
      const emptyFolder = FileEntry(
        name: 'empty',
        path: '/empty',
        isDirectory: true,
      );
      const folderWithChildren = FileEntry(
        name: 'parent',
        path: '/parent',
        isDirectory: true,
        children: [
          FileEntry(
            name: 'child.txt',
            path: '/parent/child.txt',
            isDirectory: false,
          ),
        ],
      );

      expect(emptyFolder.hasChildren, false);
      expect(folderWithChildren.hasChildren, true);
    });

    test('should support JSON serialization', () {
      const entry = FileEntry(
        name: 'test.md',
        path: '/docs/test.md',
        isDirectory: false,
        size: 1024,
      );

      final json = entry.toJson();
      final restored = FileEntry.fromJson(json);

      expect(restored.name, entry.name);
      expect(restored.path, entry.path);
      expect(restored.isDirectory, entry.isDirectory);
      expect(restored.size, entry.size);
    });
  });

  group('CursorPosition', () {
    test('should create with default values', () {
      const pos = CursorPosition();

      expect(pos.line, 0);
      expect(pos.column, 0);
    });

    test('should create with custom values', () {
      const pos = CursorPosition(line: 10, column: 5);

      expect(pos.line, 10);
      expect(pos.column, 5);
    });

    test('should display position correctly', () {
      const pos = CursorPosition(line: 9, column: 4);

      expect(pos.displayPosition, 'Ln 10, Col 5');
    });

    test('should support JSON serialization', () {
      const pos = CursorPosition(line: 5, column: 10);

      final json = pos.toJson();
      final restored = CursorPosition.fromJson(json);

      expect(restored.line, pos.line);
      expect(restored.column, pos.column);
    });
  });

  group('OpenFile', () {
    test('should create OpenFile correctly', () {
      const file = OpenFile(
        path: '/docs/test.md',
        name: 'test.md',
        content: 'Hello World',
      );

      expect(file.path, '/docs/test.md');
      expect(file.name, 'test.md');
      expect(file.content, 'Hello World');
      expect(file.isDirty, false);
      expect(file.originalContent, isNull);
      expect(file.cursorPosition, isNull);
    });

    test('should detect changes correctly', () {
      const unchangedFile = OpenFile(
        path: '/docs/test.md',
        name: 'test.md',
        content: 'Hello',
        originalContent: 'Hello',
      );
      const changedFile = OpenFile(
        path: '/docs/test.md',
        name: 'test.md',
        content: 'Hello World',
        originalContent: 'Hello',
        isDirty: true,
      );

      expect(unchangedFile.hasChanges, false);
      expect(changedFile.hasChanges, true);
    });

    test('should support JSON serialization', () {
      const file = OpenFile(
        path: '/docs/test.md',
        name: 'test.md',
        content: 'Hello',
        originalContent: 'Hello',
        isDirty: false,
        cursorPosition: CursorPosition(line: 1, column: 2),
      );

      final json = file.toJson();
      final restored = OpenFile.fromJson(json);

      expect(restored.path, file.path);
      expect(restored.name, file.name);
      expect(restored.content, file.content);
      expect(restored.isDirty, file.isDirty);
      expect(restored.cursorPosition?.line, 1);
      expect(restored.cursorPosition?.column, 2);
    });
  });

  group('Workspace', () {
    test('should create Workspace correctly', () {
      const workspace = Workspace(path: '/my/workspace', name: 'workspace');

      expect(workspace.path, '/my/workspace');
      expect(workspace.name, 'workspace');
      expect(workspace.root, isNull);
      expect(workspace.recentFiles, isEmpty);
    });

    test('should count recent files correctly', () {
      const workspace = Workspace(
        path: '/my/workspace',
        name: 'workspace',
        recentFiles: ['/file1.md', '/file2.md'],
      );

      expect(workspace.recentFilesCount, 2);
    });

    test('should support JSON serialization', () {
      final workspace = Workspace(
        path: '/my/workspace',
        name: 'workspace',
        root: const FileEntry(
          name: 'workspace',
          path: '/my/workspace',
          isDirectory: true,
        ),
        recentFiles: const ['/file1.md'],
      );

      final json = workspace.toJson();
      final restored = Workspace.fromJson(json);

      expect(restored.path, workspace.path);
      expect(restored.name, workspace.name);
      expect(restored.recentFiles, workspace.recentFiles);
    });
  });

  group('AppSettings', () {
    test('should create with default values', () {
      const settings = AppSettings();

      expect(settings.themeMode, ThemeMode.system);
      expect(settings.editorFontSize, 16.0);
      expect(settings.editorFontFamily, 'JetBrains Mono');
      expect(settings.recentWorkspaces, isEmpty);
      expect(settings.autoSave, true);
      expect(settings.autoSaveDelayMs, 2000);
      expect(settings.showPreview, true);
      expect(settings.sidebarWidth, 250.0);
    });

    test('should clamp font size', () {
      const smallSettings = AppSettings(editorFontSize: 5.0);
      const largeSettings = AppSettings(editorFontSize: 40.0);
      const normalSettings = AppSettings(editorFontSize: 14.0);

      expect(smallSettings.clampedFontSize, AppSettings.minFontSize);
      expect(largeSettings.clampedFontSize, AppSettings.maxFontSize);
      expect(normalSettings.clampedFontSize, 14.0);
    });

    test('should clamp sidebar width', () {
      const smallSettings = AppSettings(sidebarWidth: 100.0);
      const largeSettings = AppSettings(sidebarWidth: 600.0);
      const normalSettings = AppSettings(sidebarWidth: 300.0);

      expect(smallSettings.clampedSidebarWidth, AppSettings.minSidebarWidth);
      expect(largeSettings.clampedSidebarWidth, AppSettings.maxSidebarWidth);
      expect(normalSettings.clampedSidebarWidth, 300.0);
    });

    test('should detect recent workspaces', () {
      const emptySettings = AppSettings();
      const withWorkspaces = AppSettings(
        recentWorkspaces: ['/workspace1', '/workspace2'],
      );

      expect(emptySettings.hasRecentWorkspaces, false);
      expect(withWorkspaces.hasRecentWorkspaces, true);
    });

    test('should support JSON serialization', () {
      const settings = AppSettings(
        themeMode: ThemeMode.dark,
        editorFontSize: 18.0,
        autoSave: false,
      );

      final json = settings.toJson();
      final restored = AppSettings.fromJson(json);

      expect(restored.themeMode, settings.themeMode);
      expect(restored.editorFontSize, settings.editorFontSize);
      expect(restored.autoSave, settings.autoSave);
    });
  });
}
