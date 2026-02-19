/// Search state management for find functionality in the editor.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'search_state.g.dart';

/// Represents a search match with its position in the text.
class SearchMatch {
  /// Creates a new search match.
  const SearchMatch({
    required this.start,
    required this.end,
    required this.line,
    required this.column,
  });

  /// Start position in the text.
  final int start;

  /// End position in the text.
  final int end;

  /// Line number (0-indexed).
  final int line;

  /// Column number (0-indexed).
  final int column;

  @override
  String toString() =>
      'SearchMatch(start: $start, end: $end, line: $line, col: $column)';
}

/// Search state for managing find functionality.
@riverpod
class SearchController extends _$SearchController {
  @override
  SearchState build() => const SearchState();

  /// Toggle the visibility of the find box.
  void toggleVisibility() {
    state = state.copyWith(isVisible: !state.isVisible);
  }

  /// Show the find box.
  void show() {
    state = state.copyWith(isVisible: true);
  }

  /// Hide the find box.
  void hide() {
    state = state.copyWith(isVisible: false);
  }

  /// Set the search query and find matches.
  void setQuery(String query, String text) {
    final matches = _findMatches(query, text);
    state = state.copyWith(
      query: query,
      matches: matches,
      currentMatchIndex: matches.isNotEmpty ? 0 : null,
    );
  }

  /// Update search query without changing text (for when text changes externally).
  void updateQuery(String query, String text) {
    if (query != state.query) {
      setQuery(query, text);
    } else {
      // Re-search if text changed
      final matches = _findMatches(query, text);
      state = state.copyWith(matches: matches);
      if (state.currentMatchIndex != null &&
          state.currentMatchIndex! >= matches.length) {
        state = state.copyWith(
          currentMatchIndex: matches.isNotEmpty ? matches.length - 1 : null,
        );
      }
    }
  }

  /// Go to the next match.
  void nextMatch() {
    if (state.matches.isEmpty) return;
    final nextIndex = state.currentMatchIndex == null
        ? 0
        : (state.currentMatchIndex! + 1) % state.matches.length;
    state = state.copyWith(currentMatchIndex: nextIndex);
  }

  /// Go to the previous match.
  void previousMatch() {
    if (state.matches.isEmpty) return;
    final prevIndex = state.currentMatchIndex == null
        ? state.matches.length - 1
        : (state.currentMatchIndex! - 1 + state.matches.length) %
              state.matches.length;
    state = state.copyWith(currentMatchIndex: prevIndex);
  }

  /// Clear the search.
  void clear() {
    state = const SearchState();
  }

  /// Find all matches of query in text.
  List<SearchMatch> _findMatches(String query, String text) {
    if (query.isEmpty) return [];

    final matches = <SearchMatch>[];
    final lowerQuery = query.toLowerCase();
    final lowerText = text.toLowerCase();

    var startIndex = 0;
    while (true) {
      final index = lowerText.indexOf(lowerQuery, startIndex);
      if (index == -1) break;

      // Calculate line and column
      final textBeforeMatch = text.substring(0, index);
      final lines = textBeforeMatch.split('\n');
      final line = lines.length - 1;
      final column = lines.last.length;

      matches.add(
        SearchMatch(
          start: index,
          end: index + query.length,
          line: line,
          column: column,
        ),
      );

      startIndex = index + 1;
    }

    return matches;
  }
}

/// Immutable state for search functionality.
@immutable
class SearchState {
  /// Creates a new search state.
  const SearchState({
    this.isVisible = false,
    this.query = '',
    this.matches = const [],
    this.currentMatchIndex,
  });

  /// Whether the find box is visible.
  final bool isVisible;

  /// Current search query.
  final String query;

  /// List of all matches found.
  final List<SearchMatch> matches;

  /// Index of the currently highlighted match.
  final int? currentMatchIndex;

  /// Returns the current match if any.
  SearchMatch? get currentMatch {
    if (currentMatchIndex == null || matches.isEmpty) return null;
    if (currentMatchIndex! < 0 || currentMatchIndex! >= matches.length) {
      return null;
    }
    return matches[currentMatchIndex!];
  }

  /// Returns the match count display (e.g., "2/5").
  String get matchCountText {
    if (matches.isEmpty) return '0/0';
    return '${(currentMatchIndex ?? 0) + 1}/${matches.length}';
  }

  /// Returns true if there are matches.
  bool get hasMatches => matches.isNotEmpty;

  /// Returns true if currently at the first match.
  bool get isAtFirstMatch => currentMatchIndex == 0;

  /// Returns true if currently at the last match.
  bool get isAtLastMatch =>
      currentMatchIndex != null && currentMatchIndex == matches.length - 1;

  /// Copy with new values.
  SearchState copyWith({
    bool? isVisible,
    String? query,
    List<SearchMatch>? matches,
    int? currentMatchIndex,
  }) {
    return SearchState(
      isVisible: isVisible ?? this.isVisible,
      query: query ?? this.query,
      matches: matches ?? this.matches,
      currentMatchIndex: currentMatchIndex ?? this.currentMatchIndex,
    );
  }
}

/// Provider for checking if find box is visible.
@riverpod
bool isFindBoxVisible(Ref ref) {
  return ref.watch(searchControllerProvider.select((s) => s.isVisible));
}

/// Provider for current search query.
@riverpod
String searchQuery(Ref ref) {
  return ref.watch(searchControllerProvider.select((s) => s.query));
}

/// Provider for search matches.
@riverpod
List<SearchMatch> searchMatches(Ref ref) {
  return ref.watch(searchControllerProvider.select((s) => s.matches));
}

/// Provider for current match index.
@riverpod
int? currentMatchIndex(Ref ref) {
  return ref.watch(searchControllerProvider.select((s) => s.currentMatchIndex));
}

/// Provider for match count text.
@riverpod
String matchCountText(Ref ref) {
  return ref.watch(searchControllerProvider.select((s) => s.matchCountText));
}
