/// Unit tests for SaveStatus providers.
library;

import 'package:app_notes/state/save_status.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FileSaveStatus', () {
    test('should have idle state by default', () {
      final container = ProviderContainer();
      final status = container.read(fileSaveStatusProvider('/test/file.md'));

      expect(status, SaveStatus.idle);
    });

    test('should change to saving state', () {
      final container = ProviderContainer();
      final notifier = container.read(
        fileSaveStatusProvider('/test/file.md').notifier,
      );

      notifier.setSaving();

      expect(
        container.read(fileSaveStatusProvider('/test/file.md')),
        SaveStatus.saving,
      );
    });

    test('should change to saved state', () {
      final container = ProviderContainer();
      final notifier = container.read(
        fileSaveStatusProvider('/test/file.md').notifier,
      );

      notifier.setSaved();

      expect(
        container.read(fileSaveStatusProvider('/test/file.md')),
        SaveStatus.saved,
      );
    });

    test('should change to error state', () {
      final container = ProviderContainer();
      final notifier = container.read(
        fileSaveStatusProvider('/test/file.md').notifier,
      );

      notifier.setError();

      expect(
        container.read(fileSaveStatusProvider('/test/file.md')),
        SaveStatus.error,
      );
    });

    test('should reset to idle state', () {
      final container = ProviderContainer();
      final notifier = container.read(
        fileSaveStatusProvider('/test/file.md').notifier,
      );

      notifier.setSaving();
      notifier.reset();

      expect(
        container.read(fileSaveStatusProvider('/test/file.md')),
        SaveStatus.idle,
      );
    });

    test('should auto-reset from saved to idle after delay', () async {
      final container = ProviderContainer();
      final notifier = container.read(
        fileSaveStatusProvider('/test/file.md').notifier,
      );

      notifier.setSaved();
      expect(
        container.read(fileSaveStatusProvider('/test/file.md')),
        SaveStatus.saved,
      );

      // Wait for auto-reset
      await Future.delayed(const Duration(seconds: 3));

      expect(
        container.read(fileSaveStatusProvider('/test/file.md')),
        SaveStatus.idle,
      );
    });

    test('should maintain separate states for different files', () {
      final container = ProviderContainer();

      final notifier1 = container.read(
        fileSaveStatusProvider('/file1.md').notifier,
      );
      final notifier2 = container.read(
        fileSaveStatusProvider('/file2.md').notifier,
      );

      notifier1.setSaving();
      notifier2.setSaved();

      expect(
        container.read(fileSaveStatusProvider('/file1.md')),
        SaveStatus.saving,
      );
      expect(
        container.read(fileSaveStatusProvider('/file2.md')),
        SaveStatus.saved,
      );
    });
  });

  group('SaveStatusMessage', () {
    test('should have null message by default', () {
      final container = ProviderContainer();
      final message = container.read(saveStatusMessageProvider);

      expect(message, isNull);
    });

    test('should show error message', () {
      final container = ProviderContainer();
      final notifier = container.read(saveStatusMessageProvider.notifier);

      notifier.showError('Failed to save file');

      expect(container.read(saveStatusMessageProvider), 'Failed to save file');
    });

    test('should clear message', () {
      final container = ProviderContainer();
      final notifier = container.read(saveStatusMessageProvider.notifier);

      notifier.showError('Error');
      notifier.clear();

      expect(container.read(saveStatusMessageProvider), isNull);
    });

    test('should auto-clear message after delay', () async {
      final container = ProviderContainer();
      final notifier = container.read(saveStatusMessageProvider.notifier);

      notifier.showError('Temporary error');
      expect(container.read(saveStatusMessageProvider), 'Temporary error');

      // Wait for auto-clear
      await Future.delayed(const Duration(seconds: 6));

      expect(container.read(saveStatusMessageProvider), isNull);
    });
  });

  group('SaveStatus Enum', () {
    test('should have all required values', () {
      expect(SaveStatus.values.length, 4);
      expect(SaveStatus.values, contains(SaveStatus.idle));
      expect(SaveStatus.values, contains(SaveStatus.saving));
      expect(SaveStatus.values, contains(SaveStatus.saved));
      expect(SaveStatus.values, contains(SaveStatus.error));
    });
  });
}
