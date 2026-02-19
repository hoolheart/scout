/// Unit tests for FilePickerService.
library;

import 'package:app_notes/services/file_picker_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FilePickerService', () {
    group('isMarkdownFile', () {
      test('returns true for .md files', () {
        expect(FilePickerService.isMarkdownFile('/path/to/file.md'), isTrue);
        expect(FilePickerService.isMarkdownFile('document.md'), isTrue);
      });

      test('returns true for .markdown files', () {
        expect(
          FilePickerService.isMarkdownFile('/path/to/file.markdown'),
          isTrue,
        );
      });

      test('returns true for .mdown files', () {
        expect(FilePickerService.isMarkdownFile('/path/to/file.mdown'), isTrue);
      });

      test('returns false for non-markdown files', () {
        expect(FilePickerService.isMarkdownFile('/path/to/file.txt'), isFalse);
        expect(FilePickerService.isMarkdownFile('/path/to/file.dart'), isFalse);
        expect(FilePickerService.isMarkdownFile('/path/to/file.json'), isFalse);
      });

      test('is case insensitive', () {
        expect(FilePickerService.isMarkdownFile('/path/to/file.MD'), isTrue);
        expect(FilePickerService.isMarkdownFile('/path/to/file.Md'), isTrue);
        expect(
          FilePickerService.isMarkdownFile('/path/to/file.MARKDOWN'),
          isTrue,
        );
      });
    });

    group('getDisplayName', () {
      test('returns basename without extension for markdown files', () {
        expect(
          FilePickerService.getDisplayName('/path/to/document.md'),
          'document',
        );
      });

      test('returns full basename for non-markdown files', () {
        expect(
          FilePickerService.getDisplayName('/path/to/script.dart'),
          'script.dart',
        );
        expect(
          FilePickerService.getDisplayName('/path/to/archive.tar.gz'),
          'archive.tar.gz',
        );
      });

      test('handles paths without directories', () {
        expect(FilePickerService.getDisplayName('readme.md'), 'readme');
        expect(FilePickerService.getDisplayName('file.txt'), 'file.txt');
      });
    });

    group('ensureMarkdownExtension', () {
      test('returns path unchanged if already has markdown extension', () {
        expect(
          FilePickerService.ensureMarkdownExtension('/path/to/file.md'),
          '/path/to/file.md',
        );
      });

      test('adds .md extension if no markdown extension', () {
        expect(
          FilePickerService.ensureMarkdownExtension('/path/to/file'),
          '/path/to/file.md',
        );
        expect(
          FilePickerService.ensureMarkdownExtension('/path/to/file.txt'),
          '/path/to/file.txt.md',
        );
      });

      test('handles paths with multiple dots', () {
        expect(
          FilePickerService.ensureMarkdownExtension('/path/to/archive.tar.gz'),
          '/path/to/archive.tar.gz.md',
        );
      });
    });

    group('FilePickerException', () {
      test('stores message correctly', () {
        const exception = FilePickerException('Test error message');
        expect(exception.message, 'Test error message');
      });

      test('toString includes message', () {
        const exception = FilePickerException('Test error');
        expect(exception.toString(), 'FilePickerException: Test error');
      });
    });
  });
}
