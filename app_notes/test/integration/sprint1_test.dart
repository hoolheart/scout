/// Sprint 1 Integration Tests
///
/// These tests verify the end-to-end file operations workflow
/// including opening, editing, and saving files.
library;

import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app_notes/models/models.dart';
import 'package:app_notes/state/state.dart';
import 'package:app_notes/services/rust_service.dart';

void main() {
  group('Sprint 1 Integration Tests', () {
    late ProviderContainer container;

    setUpAll(() async {
      // Initialize RustService for tests
      await RustService.instance.initialize();
    });

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('完整的文件操作流程', () async {
      // 1. 创建临时文件
      final tempDir = Directory.systemTemp;
      final testFile = File('${tempDir.path}/test_sprint1.md');

      // 清理：确保文件不存在
      if (await testFile.exists()) {
        await testFile.delete();
      }

      try {
        // 2. 写入初始内容 (使用 Dart File API 准备测试数据)
        final initialContent = '# Test Document\n\nHello World!';
        await testFile.create(recursive: true);
        await testFile.writeAsString(initialContent);

        // 验证文件已创建
        expect(
          await testFile.exists(),
          isTrue,
          reason: 'File should exist after creation',
        );
        final fileContent = await testFile.readAsString();
        expect(
          fileContent,
          equals(initialContent),
          reason: 'File should contain initial content',
        );

        // 3. 通过 EditorState 打开文件
        final editorNotifier = container.read(editorStateProvider.notifier);
        await editorNotifier.openFile(testFile.path);

        // 4. 验证文件已打开
        final openFiles = container.read(editorStateProvider);
        expect(openFiles.length, equals(1), reason: 'Should have 1 open file');
        expect(
          openFiles.first.path,
          equals(testFile.path),
          reason: 'Path should match',
        );
        expect(
          openFiles.first.content,
          equals(initialContent),
          reason: 'Content should match',
        );
        expect(
          openFiles.first.isDirty,
          isFalse,
          reason: 'New file should not be dirty',
        );
        expect(
          openFiles.first.name,
          equals('test_sprint1.md'),
          reason: 'Name should be basename',
        );

        // 5. 更新内容
        final newContent =
            '# Updated Document\n\nHello World!\n\nNew paragraph.';
        editorNotifier.updateContent(testFile.path, newContent);

        // 6. 验证内容已更新且标记为脏
        final updatedFiles = container.read(editorStateProvider);
        expect(
          updatedFiles.first.content,
          equals(newContent),
          reason: 'Content should be updated',
        );
        expect(
          updatedFiles.first.isDirty,
          isTrue,
          reason: 'Modified file should be dirty',
        );

        // 7. 保存文件
        final saveResult = await editorNotifier.saveFile(testFile.path);
        expect(saveResult, isTrue, reason: 'Save should succeed');

        // 8. 验证文件已保存且不再脏
        final savedFiles = container.read(editorStateProvider);
        expect(
          savedFiles.first.isDirty,
          isFalse,
          reason: 'Saved file should not be dirty',
        );
        expect(
          savedFiles.first.originalContent,
          equals(newContent),
          reason: 'Original content should be updated',
        );

        // 9. 再次读取文件验证持久化
        final savedContent = await testFile.readAsString();
        expect(
          savedContent,
          equals(newContent),
          reason: 'File on disk should be updated',
        );

        // 10. 验证活动文件设置
        expect(
          editorNotifier.activeFilePath,
          equals(testFile.path),
          reason: 'Should be active file',
        );
        expect(
          editorNotifier.activeFile,
          isNotNull,
          reason: 'Active file should not be null',
        );
        expect(
          editorNotifier.activeFile!.path,
          equals(testFile.path),
          reason: 'Active file path should match',
        );
      } finally {
        // 清理
        if (await testFile.exists()) {
          await testFile.delete();
        }
      }
    });

    test('可以同时打开多个文件', () async {
      final tempDir = Directory.systemTemp;
      final file1 = File('${tempDir.path}/test1.md');
      final file2 = File('${tempDir.path}/test2.md');

      // 清理
      for (final file in [file1, file2]) {
        if (await file.exists()) {
          await file.delete();
        }
      }

      try {
        // 创建测试文件
        await file1.create();
        await file1.writeAsString('# File 1');
        await file2.create();
        await file2.writeAsString('# File 2');

        final editorNotifier = container.read(editorStateProvider.notifier);
        await editorNotifier.openFile(file1.path);
        await editorNotifier.openFile(file2.path);

        final openFiles = container.read(editorStateProvider);
        expect(openFiles.length, equals(2), reason: 'Should have 2 open files');
        expect(
          openFiles.any((f) => f.path == file1.path),
          isTrue,
          reason: 'Should contain file1',
        );
        expect(
          openFiles.any((f) => f.path == file2.path),
          isTrue,
          reason: 'Should contain file2',
        );

        // 验证第一个文件是活动文件（默认行为）
        expect(
          editorNotifier.activeFilePath,
          equals(file1.path),
          reason: 'First file should be active',
        );
      } finally {
        // 清理
        for (final file in [file1, file2]) {
          if (await file.exists()) {
            await file.delete();
          }
        }
      }
    });

    test('关闭文件后可以从列表移除', () async {
      final tempDir = Directory.systemTemp;
      final file = File('${tempDir.path}/test_close.md');

      // 清理
      if (await file.exists()) {
        await file.delete();
      }

      try {
        await file.create();
        await file.writeAsString('# Test');

        final editorNotifier = container.read(editorStateProvider.notifier);
        await editorNotifier.openFile(file.path);
        expect(
          container.read(editorStateProvider).length,
          equals(1),
          reason: 'Should have 1 file',
        );

        await editorNotifier.closeFile(file.path);
        expect(
          container.read(editorStateProvider).length,
          equals(0),
          reason: 'Should have 0 files after closing',
        );
        expect(
          editorNotifier.activeFilePath,
          isNull,
          reason: 'Active file should be null',
        );
      } finally {
        // 清理
        if (await file.exists()) {
          await file.delete();
        }
      }
    });

    test('切换活动文件', () async {
      final tempDir = Directory.systemTemp;
      final file1 = File('${tempDir.path}/test_active1.md');
      final file2 = File('${tempDir.path}/test_active2.md');

      // 清理
      for (final f in [file1, file2]) {
        if (await f.exists()) {
          await f.delete();
        }
      }

      try {
        await file1.create();
        await file1.writeAsString('# File 1');
        await file2.create();
        await file2.writeAsString('# File 2');

        final editorNotifier = container.read(editorStateProvider.notifier);
        await editorNotifier.openFile(file1.path);
        await editorNotifier.openFile(file2.path);

        // 默认第一个文件是活动文件
        expect(
          editorNotifier.activeFilePath,
          equals(file1.path),
          reason: 'First file should be active initially',
        );

        // 切换到第二个文件
        editorNotifier.setActiveFile(file2.path);
        expect(
          editorNotifier.activeFilePath,
          equals(file2.path),
          reason: 'Second file should be active after switching',
        );

        // 验证 get 方法
        final activeFile = editorNotifier.activeFile;
        expect(activeFile, isNotNull, reason: 'Active file should not be null');
        expect(
          activeFile!.path,
          equals(file2.path),
          reason: 'Active file path should match file2',
        );
        expect(
          activeFile.content,
          equals('# File 2'),
          reason: 'Active file content should match',
        );
      } finally {
        // 清理
        for (final f in [file1, file2]) {
          if (await f.exists()) {
            await f.delete();
          }
        }
      }
    });

    test('文件脏状态检测', () async {
      final tempDir = Directory.systemTemp;
      final file = File('${tempDir.path}/test_dirty.md');

      // 清理
      if (await file.exists()) {
        await file.delete();
      }

      try {
        await file.create();
        await file.writeAsString('# Original');

        final editorNotifier = container.read(editorStateProvider.notifier);
        await editorNotifier.openFile(file.path);

        // 初始状态：不脏
        expect(
          editorNotifier.hasUnsavedChanges(file.path),
          isFalse,
          reason: 'New file should not have unsaved changes',
        );
        expect(
          editorNotifier.hasAnyUnsavedChanges,
          isFalse,
          reason: 'Should not have any unsaved changes initially',
        );

        // 修改后：变脏
        editorNotifier.updateContent(file.path, '# Modified');
        expect(
          editorNotifier.hasUnsavedChanges(file.path),
          isTrue,
          reason: 'Modified file should have unsaved changes',
        );
        expect(
          editorNotifier.hasAnyUnsavedChanges,
          isTrue,
          reason: 'Should have unsaved changes after modification',
        );

        // 验证状态中的 isDirty 标志
        final openFiles = container.read(editorStateProvider);
        expect(openFiles.length, equals(1), reason: 'Should have 1 open file');
        final openFile = openFiles.first;
        expect(openFile.isDirty, isTrue, reason: 'isDirty should be true');
        expect(
          openFile.content,
          equals('# Modified'),
          reason: 'Content should be updated',
        );
        expect(
          openFile.originalContent,
          equals('# Original'),
          reason: 'Original content should be preserved',
        );
      } finally {
        // 清理
        if (await file.exists()) {
          await file.delete();
        }
      }
    });

    test('保存所有文件', () async {
      final tempDir = Directory.systemTemp;
      final file1 = File('${tempDir.path}/test_saveall1.md');
      final file2 = File('${tempDir.path}/test_saveall2.md');

      // 清理
      for (final f in [file1, file2]) {
        if (await f.exists()) {
          await f.delete();
        }
      }

      try {
        await file1.create();
        await file1.writeAsString('# File 1');
        await file2.create();
        await file2.writeAsString('# File 2');

        final editorNotifier = container.read(editorStateProvider.notifier);
        await editorNotifier.openFile(file1.path);
        await editorNotifier.openFile(file2.path);

        // 修改两个文件
        editorNotifier.updateContent(file1.path, '# File 1 Modified');
        editorNotifier.updateContent(file2.path, '# File 2 Modified');

        // 验证都脏了
        expect(
          container.read(editorStateProvider).every((f) => f.isDirty),
          isTrue,
          reason: 'All files should be dirty',
        );
        expect(
          editorNotifier.hasAnyUnsavedChanges,
          isTrue,
          reason: 'Should have unsaved changes',
        );

        // 保存所有文件
        await editorNotifier.saveAll();

        // 验证都不脏了
        expect(
          container.read(editorStateProvider).every((f) => !f.isDirty),
          isTrue,
          reason: 'All files should be clean after save',
        );
        expect(
          editorNotifier.hasAnyUnsavedChanges,
          isFalse,
          reason: 'Should have no unsaved changes after save',
        );

        // 验证持久化
        expect(
          await file1.readAsString(),
          equals('# File 1 Modified'),
          reason: 'File1 should be saved',
        );
        expect(
          await file2.readAsString(),
          equals('# File 2 Modified'),
          reason: 'File2 should be saved',
        );
      } finally {
        // 清理
        for (final f in [file1, file2]) {
          if (await f.exists()) {
            await f.delete();
          }
        }
      }
    });

    test('关闭所有文件', () async {
      final tempDir = Directory.systemTemp;
      final file1 = File('${tempDir.path}/test_closeall1.md');
      final file2 = File('${tempDir.path}/test_closeall2.md');

      // 清理
      for (final f in [file1, file2]) {
        if (await f.exists()) {
          await f.delete();
        }
      }

      try {
        await file1.create();
        await file1.writeAsString('# File 1');
        await file2.create();
        await file2.writeAsString('# File 2');

        final editorNotifier = container.read(editorStateProvider.notifier);
        await editorNotifier.openFile(file1.path);
        await editorNotifier.openFile(file2.path);

        expect(
          container.read(editorStateProvider).length,
          equals(2),
          reason: 'Should have 2 files',
        );
        expect(
          editorNotifier.activeFilePath,
          isNotNull,
          reason: 'Should have active file',
        );

        // 关闭所有文件
        editorNotifier.closeAll();

        expect(
          container.read(editorStateProvider).length,
          equals(0),
          reason: 'Should have 0 files after closeAll',
        );
        expect(
          editorNotifier.activeFilePath,
          isNull,
          reason: 'Active file should be null',
        );
        expect(
          editorNotifier.activeFile,
          isNull,
          reason: 'activeFile getter should return null',
        );
      } finally {
        // 清理
        for (final f in [file1, file2]) {
          if (await f.exists()) {
            await f.delete();
          }
        }
      }
    });

    test('重复打开同一文件不重复添加', () async {
      final tempDir = Directory.systemTemp;
      final file = File('${tempDir.path}/test_duplicate.md');

      // 清理
      if (await file.exists()) {
        await file.delete();
      }

      try {
        await file.create();
        await file.writeAsString('# Test');

        final editorNotifier = container.read(editorStateProvider.notifier);
        await editorNotifier.openFile(file.path);
        await editorNotifier.openFile(file.path); // 第二次打开同一文件
        await editorNotifier.openFile(file.path); // 第三次

        // 应该只打开一次
        expect(
          container.read(editorStateProvider).length,
          equals(1),
          reason: 'Same file should not be added multiple times',
        );
      } finally {
        // 清理
        if (await file.exists()) {
          await file.delete();
        }
      }
    });
  });
}
