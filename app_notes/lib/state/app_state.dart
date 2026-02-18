/// Application state management using Riverpod.
library;

import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:app_notes/models/app_settings.dart';

part 'app_state.g.dart';

/// App state for managing application settings.
@riverpod
class AppState extends _$AppState {
  @override
  AppSettings build() => const AppSettings();

  /// Set the theme mode.
  void setThemeMode(ThemeMode mode) {
    state = state.copyWith(themeMode: mode);
  }

  /// Toggle between light and dark mode.
  void toggleThemeMode() {
    final newMode = switch (state.themeMode) {
      ThemeMode.light => ThemeMode.dark,
      ThemeMode.dark => ThemeMode.light,
      ThemeMode.system => ThemeMode.light,
    };
    setThemeMode(newMode);
  }

  /// Set the editor font size.
  void setEditorFontSize(double size) {
    state = state.copyWith(
      editorFontSize: size.clamp(
        AppSettings.minFontSize,
        AppSettings.maxFontSize,
      ),
    );
  }

  /// Set the editor font family.
  void setEditorFontFamily(String family) {
    state = state.copyWith(editorFontFamily: family);
  }

  /// Add a recent workspace path.
  void addRecentWorkspace(String path) {
    final updated = [
      path,
      ...state.recentWorkspaces.where((p) => p != path),
    ].take(10).toList();
    state = state.copyWith(recentWorkspaces: updated);
  }

  /// Remove a recent workspace path.
  void removeRecentWorkspace(String path) {
    state = state.copyWith(
      recentWorkspaces: state.recentWorkspaces.where((p) => p != path).toList(),
    );
  }

  /// Clear all recent workspaces.
  void clearRecentWorkspaces() {
    state = state.copyWith(recentWorkspaces: []);
  }

  /// Toggle auto-save.
  void setAutoSave(bool enabled) {
    state = state.copyWith(autoSave: enabled);
  }

  /// Set auto-save delay.
  void setAutoSaveDelay(int delayMs) {
    state = state.copyWith(autoSaveDelayMs: delayMs.clamp(500, 10000));
  }

  /// Toggle preview visibility.
  void setShowPreview(bool show) {
    state = state.copyWith(showPreview: show);
  }

  /// Toggle preview visibility.
  void togglePreview() {
    state = state.copyWith(showPreview: !state.showPreview);
  }

  /// Set sidebar width.
  void setSidebarWidth(double width) {
    state = state.copyWith(
      sidebarWidth: width.clamp(
        AppSettings.minSidebarWidth,
        AppSettings.maxSidebarWidth,
      ),
    );
  }
}

/// Current theme mode provider (derived from AppState).
@riverpod
ThemeMode currentThemeMode(CurrentThemeModeRef ref) {
  return ref.watch(appStateProvider.select((s) => s.themeMode));
}

/// Whether dark mode is active (derived from AppState).
@riverpod
bool isDarkMode(IsDarkModeRef ref) {
  final themeMode = ref.watch(appStateProvider.select((s) => s.themeMode));
  if (themeMode == ThemeMode.system) {
    // In a real app, you would use MediaQuery to check system brightness
    // For now, we default to false (light mode)
    return false;
  }
  return themeMode == ThemeMode.dark;
}

/// Recent workspaces provider (derived from AppState).
@riverpod
List<String> recentWorkspaces(RecentWorkspacesRef ref) {
  return ref.watch(appStateProvider.select((s) => s.recentWorkspaces));
}
