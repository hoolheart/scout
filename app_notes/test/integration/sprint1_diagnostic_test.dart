/// Diagnostic test for Sprint 1 Integration Tests
library;

import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app_notes/services/file_service.dart';
import 'package:app_notes/services/rust_service.dart';
import 'package:app_notes/state/state.dart';

void main() {
  group('Sprint 1 Integration Tests - Diagnostic', () {
    late ProviderContainer container;

    setUpAll(() async {
      // Initialize RustService for tests
      await RustService.instance.initialize();
      print('RustService initialized: ${RustService.instance.isInitialized}');
    });

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('FileService can read and write files', () async {
      final fileService = container.read(fileServiceProvider);
      final tempFile = File(
        '${Directory.systemTemp.path}/test_file_service.md',
      );

      // Cleanup
      if (await tempFile.exists()) {
        await tempFile.delete();
      }

      try {
        // Write
        final writeResult = await fileService.writeFile(
          tempFile.path,
          '# Test Content',
        );
        print('Write result: $writeResult');
        expect(writeResult, isTrue);

        // Read
        final content = await fileService.readFile(tempFile.path);
        print('Read content: $content');
        expect(content, equals('# Test Content'));
      } finally {
        if (await tempFile.exists()) {
          await tempFile.delete();
        }
      }
    });

    test('EditorState can open file', () async {
      final tempFile = File(
        '${Directory.systemTemp.path}/test_editor_state.md',
      );

      // Cleanup
      if (await tempFile.exists()) {
        await tempFile.delete();
      }

      try {
        // Create file
        await tempFile.create();
        await tempFile.writeAsString('# Test Content');
        print('File created at: ${tempFile.path}');
        print('File exists: ${await tempFile.exists()}');

        // Open via EditorState
        final editorNotifier = container.read(editorStateProvider.notifier);
        print('Opening file...');
        await editorNotifier.openFile(tempFile.path);
        print('File opened');

        // Check state
        final openFiles = container.read(editorStateProvider);
        print('Open files count: ${openFiles.length}');
        print('Open files: $openFiles');

        expect(openFiles.length, equals(1));
      } finally {
        if (await tempFile.exists()) {
          await tempFile.delete();
        }
      }
    });

    test('EditorState openFile with direct FileService', () async {
      final tempFile = File('${Directory.systemTemp.path}/test_direct.md');

      // Cleanup
      if (await tempFile.exists()) {
        await tempFile.delete();
      }

      try {
        // Create file directly
        await tempFile.create();
        await tempFile.writeAsString('# Direct Test');

        // Create FileService manually
        final fileService = FileService();
        final content = await fileService.readFile(tempFile.path);
        print('FileService read content: $content');

        expect(content, isNotNull);
        expect(content, equals('# Direct Test'));
      } finally {
        if (await tempFile.exists()) {
          await tempFile.delete();
        }
      }
    });
  });
}
