/// Tests for find functionality.
library;

import 'package:app_notes/state/search_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SearchController', () {
    late ProviderContainer container;
    late SearchController controller;

    setUp(() {
      container = ProviderContainer();
      controller = container.read(searchControllerProvider.notifier);
    });

    tearDown(() {
      container.dispose();
    });

    test('should toggle visibility', () {
      expect(container.read(searchControllerProvider).isVisible, false);

      controller.toggleVisibility();
      expect(container.read(searchControllerProvider).isVisible, true);

      controller.toggleVisibility();
      expect(container.read(searchControllerProvider).isVisible, false);
    });

    test('should show and hide', () {
      controller.show();
      expect(container.read(searchControllerProvider).isVisible, true);

      controller.hide();
      expect(container.read(searchControllerProvider).isVisible, false);
    });

    test('should find matches', () {
      const text = 'Hello world. Hello everyone. Hello!';
      controller.setQuery('Hello', text);

      final state = container.read(searchControllerProvider);
      expect(state.query, 'Hello');
      expect(state.matches.length, 3);
      expect(state.hasMatches, true);
      expect(state.matchCountText, '1/3');
    });

    test('should navigate between matches', () {
      const text = 'Hello world. Hello everyone. Hello!';
      controller.setQuery('Hello', text);

      expect(container.read(searchControllerProvider).currentMatchIndex, 0);

      controller.nextMatch();
      expect(container.read(searchControllerProvider).currentMatchIndex, 1);

      controller.nextMatch();
      expect(container.read(searchControllerProvider).currentMatchIndex, 2);

      controller.nextMatch();
      expect(container.read(searchControllerProvider).currentMatchIndex, 0);

      controller.previousMatch();
      expect(container.read(searchControllerProvider).currentMatchIndex, 2);
    });

    test('should clear search', () {
      const text = 'Hello world';
      controller.setQuery('Hello', text);
      expect(container.read(searchControllerProvider).hasMatches, true);

      controller.clear();
      final state = container.read(searchControllerProvider);
      expect(state.query, '');
      expect(state.matches.isEmpty, true);
      expect(state.currentMatchIndex, null);
      expect(state.isVisible, false);
    });

    test('should handle empty query', () {
      const text = 'Hello world';
      controller.setQuery('', text);

      final state = container.read(searchControllerProvider);
      expect(state.matches.isEmpty, true);
      expect(state.hasMatches, false);
    });

    test('should handle no matches', () {
      const text = 'Hello world';
      controller.setQuery('xyz', text);

      final state = container.read(searchControllerProvider);
      expect(state.matches.isEmpty, true);
      expect(state.hasMatches, false);
      expect(state.matchCountText, '0/0');
    });

    test('should be case insensitive', () {
      const text = 'Hello WORLD hello';
      controller.setQuery('hello', text);

      final state = container.read(searchControllerProvider);
      expect(state.matches.length, 2);
    });

    test('should calculate correct line and column', () {
      const text = 'Line 1\nLine 2\nHello world';
      controller.setQuery('Hello', text);

      final state = container.read(searchControllerProvider);
      expect(state.matches.length, 1);
      expect(state.matches.first.line, 2); // 0-indexed
      expect(state.matches.first.column, 0);
    });
  });

  group('SearchState', () {
    test('should create default state', () {
      const state = SearchState();
      expect(state.isVisible, false);
      expect(state.query, '');
      expect(state.matches, isEmpty);
      expect(state.currentMatchIndex, null);
    });

    test('should copy with new values', () {
      const state = SearchState();
      final newState = state.copyWith(
        isVisible: true,
        query: 'test',
        matches: [const SearchMatch(start: 0, end: 4, line: 0, column: 0)],
        currentMatchIndex: 0,
      );

      expect(newState.isVisible, true);
      expect(newState.query, 'test');
      expect(newState.matches.length, 1);
      expect(newState.currentMatchIndex, 0);
    });

    test('should preserve unchanged values when copying', () {
      const state = SearchState(isVisible: true, query: 'test');
      final newState = state.copyWith(currentMatchIndex: 0);

      expect(newState.isVisible, true);
      expect(newState.query, 'test');
      expect(newState.currentMatchIndex, 0);
    });
  });
}
