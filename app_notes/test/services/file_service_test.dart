/// Tests for FileService.
library;

import 'dart:io';

import 'package:app_notes/services/file_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as path;

void main() {
  group('FileService', () {
    late FileService service;
    late Directory tempDir;

    setUp(() async {
      service = FileService();
      tempDir = await Directory.systemTemp.createTemp('file_service_test_');
    });

    tearDown(() async {
      try {
        await tempDir.delete(recursive: true);
      } catch (_) {
        // Ignore cleanup errors
      }
    });

    group('readFile', () {
      test('should read existing file', () async {
        final testFile = File(path.join(tempDir.path, 'test.txt'));
        await testFile.writeAsString('Hello, World!');

        final content = await service.readFile(testFile.path);

        expect(content, 'Hello, World!');
      });

      test('should return null for non-existent file', () async {
        final content = await service.readFile(
          path.join(tempDir.path, 'nonexistent.txt'),
        );

        expect(content, isNull);
      });
    });

    group('writeFile', () {
      test('should write file content', () async {
        final testFile = path.join(tempDir.path, 'test.txt');

        final result = await service.writeFile(testFile, 'Test content');

        expect(result, isTrue);
        expect(await File(testFile).readAsString(), 'Test content');
      });

      test('should create parent directories', () async {
        final testFile = path.join(tempDir.path, 'nested', 'dir', 'test.txt');

        final result = await service.writeFile(testFile, 'Test content');

        expect(result, isTrue);
        expect(await File(testFile).exists(), isTrue);
      });
    });

    group('createFile', () {
      test('should create new file', () async {
        final testFile = path.join(tempDir.path, 'newfile.txt');

        final result = await service.createFile(tempDir.path, 'newfile.txt');

        expect(result, isTrue);
        expect(await File(testFile).exists(), isTrue);
      });
    });

    group('createFolder', () {
      test('should create new folder', () async {
        final result = await service.createFolder(tempDir.path, 'newfolder');
        final newFolder = Directory(path.join(tempDir.path, 'newfolder'));

        expect(result, isTrue);
        expect(await newFolder.exists(), isTrue);
      });
    });

    group('readDirectory', () {
      test('should read directory contents', () async {
        // Create test files and folders
        await File(path.join(tempDir.path, 'file1.txt')).create();
        await File(path.join(tempDir.path, 'file2.md')).create();
        await Directory(path.join(tempDir.path, 'subdir')).create();

        final entries = await service.readDirectory(tempDir.path);

        expect(entries.length, 3);
        // Directories should come first
        expect(entries[0].isDirectory, isTrue);
      });

      test('should sort entries correctly', () async {
        // Create files in reverse alphabetical order
        await File(path.join(tempDir.path, 'z.txt')).create();
        await File(path.join(tempDir.path, 'a.txt')).create();
        await Directory(path.join(tempDir.path, 'b_folder')).create();
        await Directory(path.join(tempDir.path, 'a_folder')).create();

        final entries = await service.readDirectory(tempDir.path);

        expect(entries.length, 4);
        // Directories first
        expect(entries[0].isDirectory, isTrue);
        expect(entries[0].name, 'a_folder');
        expect(entries[1].isDirectory, isTrue);
        expect(entries[1].name, 'b_folder');
        // Then files
        expect(entries[2].isDirectory, isFalse);
        expect(entries[2].name, 'a.txt');
        expect(entries[3].isDirectory, isFalse);
        expect(entries[3].name, 'z.txt');
      });

      test('should return empty list for non-existent directory', () async {
        final entries = await service.readDirectory(
          path.join(tempDir.path, 'nonexistent'),
        );

        expect(entries, isEmpty);
      });
    });

    group('rename', () {
      test('should rename file', () async {
        final oldFile = File(path.join(tempDir.path, 'old.txt'));
        await oldFile.writeAsString('content');

        final result = await service.rename(oldFile.path, 'new.txt');
        final newFile = File(path.join(tempDir.path, 'new.txt'));

        expect(result, isTrue);
        expect(await oldFile.exists(), isFalse);
        expect(await newFile.exists(), isTrue);
        expect(await newFile.readAsString(), 'content');
      });

      test('should rename folder', () async {
        final oldFolder = Directory(path.join(tempDir.path, 'old_folder'));
        await oldFolder.create();
        await File(
          path.join(oldFolder.path, 'file.txt'),
        ).writeAsString('content');

        final result = await service.rename(oldFolder.path, 'new_folder');
        final newFolder = Directory(path.join(tempDir.path, 'new_folder'));

        expect(result, isTrue);
        expect(await oldFolder.exists(), isFalse);
        expect(await newFolder.exists(), isTrue);
        expect(
          await File(path.join(newFolder.path, 'file.txt')).exists(),
          isTrue,
        );
      });
    });

    group('delete', () {
      test('should delete file', () async {
        final testFile = File(path.join(tempDir.path, 'delete.txt'));
        await testFile.writeAsString('content');

        final result = await service.delete(testFile.path);

        expect(result, isTrue);
        expect(await testFile.exists(), isFalse);
      });

      test('should delete folder recursively', () async {
        final testFolder = Directory(path.join(tempDir.path, 'delete_folder'));
        await testFolder.create();
        await File(
          path.join(testFolder.path, 'file.txt'),
        ).writeAsString('content');

        final result = await service.delete(testFolder.path);

        expect(result, isTrue);
        expect(await testFolder.exists(), isFalse);
      });
    });

    group('exists', () {
      test('should return true for existing file', () async {
        final testFile = File(path.join(tempDir.path, 'exists.txt'));
        await testFile.writeAsString('content');

        expect(service.exists(testFile.path), isTrue);
      });

      test('should return true for existing directory', () {
        expect(service.exists(tempDir.path), isTrue);
      });

      test('should return false for non-existent path', () {
        expect(service.exists(path.join(tempDir.path, 'nonexistent')), isFalse);
      });
    });
  });
}
