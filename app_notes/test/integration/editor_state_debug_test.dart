/// Detailed diagnostic test for EditorState
library;

import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app_notes/models/models.dart';
import 'package:app_notes/services/file_service.dart';
import 'package:app_notes/services/rust_service.dart';
import 'package:app_notes/state/state.dart';

void main() {
  group('EditorState Debug', () {
    setUpAll(() async {
      await RustService.instance.initialize();
    });

    test('Debug EditorState.openFile', () async {
      final container = ProviderContainer();
      final tempFile = File('${Directory.systemTemp.path}/debug_test.md');

      if (await tempFile.exists()) {
        await tempFile.delete();
      }

      await tempFile.create();
      await tempFile.writeAsString('# Debug Content');

      print('=== Before opening file ===');
      print('File path: ${tempFile.path}');
      print('File exists: ${await tempFile.exists()}');

      // Create a custom FileService and verify it works
      final fileService = FileService();
      final content = await fileService.readFile(tempFile.path);
      print('FileService.readFile result: "$content"');

      // Get EditorState notifier
      final editorNotifier = container.read(editorStateProvider.notifier);
      print('EditorState notifier created');

      // Check initial state
      final initialState = container.read(editorStateProvider);
      print('Initial state length: ${initialState.length}');

      // Open file
      print('Calling openFile...');
      await editorNotifier.openFile(tempFile.path);
      print('openFile completed');

      // Check state after open
      final afterOpenState = container.read(editorStateProvider);
      print('After open state length: ${afterOpenState.length}');
      print('After open state: $afterOpenState');

      // Cleanup
      await tempFile.delete();
      container.dispose();

      expect(afterOpenState.length, equals(1));
    });

    test('Direct state manipulation', () {
      final container = ProviderContainer();
      final editorNotifier = container.read(editorStateProvider.notifier);

      print('=== Direct state manipulation ===');

      // Initial state
      final initial = container.read(editorStateProvider);
      print('Initial state: ${initial.length} files');
      expect(initial.length, equals(0));

      // Try to add a dummy file manually
      final dummyFile = OpenFile(
        path: '/test/dummy.md',
        name: 'dummy.md',
        content: '# Test',
        originalContent: '# Test',
        isDirty: false,
      );

      // Access state directly
      editorNotifier.state = [dummyFile];

      // Check
      final after = container.read(editorStateProvider);
      print('After direct assignment: ${after.length} files');
      expect(after.length, equals(1));
      expect(after.first.path, equals('/test/dummy.md'));

      container.dispose();
    });
  });
}
