/// Tests for RustService and FFI integration.
library;

import 'package:app_notes/services/rust_service.dart';
import 'package:app_notes/src/rust/api/api.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('RustService', () {
    late RustService service;

    setUpAll(() async {
      service = RustService.instance;
      await service.initialize();
    });

    tearDown(() async {
      // Cleanup if needed
    });

    group('Singleton Pattern', () {
      test('should return same instance', () {
        final instance1 = RustService.instance;
        final instance2 = RustService.instance;

        expect(identical(instance1, instance2), isTrue);
      });
    });

    group('Initialization', () {
      test('should be initialized after setUpAll', () {
        expect(service.isInitialized, isTrue);
      });

      test('getRustVersion should work after initialization', () {
        final version = service.getRustVersion();

        expect(version, isA<String>());
        expect(version.isNotEmpty, isTrue);
        expect(version, '0.1.0'); // Stub returns this value
      });
    });

    group('File Operations - Stub', () {
      // These tests verify that the API is correctly structured
      // but will throw UnimplementedError when called without
      // proper FFI integration.

      test('readFile should throw RustException without FFI', () async {
        expect(
          () => service.readFile('/test.txt'),
          throwsA(isA<RustException>()),
        );
      });

      test('writeFile should throw RustException without FFI', () async {
        expect(
          () => service.writeFile('/test.txt', 'content'),
          throwsA(isA<RustException>()),
        );
      });

      test('readDirectory should throw RustException without FFI', () async {
        expect(() => service.readDirectory('/'), throwsA(isA<RustException>()));
      });
    });

    group('Error Handling', () {
      test('RustException should format correctly', () {
        const exception = RustException('Test error');

        expect(exception.toString(), 'RustException: Test error');
        expect(exception.message, 'Test error');
      });
    });
  });

  group('FileEntryDto', () {
    test('should create from JSON correctly', () {
      final json = {
        'name': 'test.txt',
        'path': '/path/to/test.txt',
        'is_directory': false,
        'size': 100,
        'modified_time': 1234567890000,
      };

      final dto = FileEntryDto.fromJson(json);

      expect(dto.name, 'test.txt');
      expect(dto.path, '/path/to/test.txt');
      expect(dto.isDirectory, false);
      expect(dto.size, 100);
      expect(dto.modifiedTime, 1234567890000);
    });

    test('should convert to JSON correctly', () {
      const dto = FileEntryDto(
        name: 'test.txt',
        path: '/path/to/test.txt',
        isDirectory: false,
        size: 100,
        modifiedTime: 1234567890000,
      );

      final json = dto.toJson();

      expect(json['name'], 'test.txt');
      expect(json['path'], '/path/to/test.txt');
      expect(json['is_directory'], false);
      expect(json['size'], 100);
      expect(json['modified_time'], 1234567890000);
    });

    test('should handle null modified_time', () {
      final json = {
        'name': 'test.txt',
        'path': '/path/to/test.txt',
        'is_directory': false,
        'size': 100,
        'modified_time': null,
      };

      final dto = FileEntryDto.fromJson(json);

      expect(dto.modifiedTime, isNull);
    });
  });
}
