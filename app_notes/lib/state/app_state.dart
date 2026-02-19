/// Application state management using Riverpod.
library;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:app_notes/models/app_settings.dart';
import 'package:app_notes/services/settings_service.dart';

part 'app_state.g.dart';

/// Provider for initial settings (set during app initialization).
final initialSettingsProvider = Provider<AppSettings?>(
  (ref) => null, // Will be overridden in main.dart
);

/// App state for managing application settings.
@riverpod
class AppState extends _$AppState {
  @override
  AppSettings build() {
    // Get initial settings from provider
    final initial = ref.read(initialSettingsProvider);
    return initial ?? const AppSettings();
  }

  /// Set the theme mode.
  void setThemeMode(ThemeMode mode) {
    state = state.copyWith(themeMode: mode);
    final service = ref.read(settingsServiceProvider);
    unawaited(service.saveThemeMode(mode));
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
    final clamped = size.clamp(
      AppSettings.minFontSize,
      AppSettings.maxFontSize,
    );
    state = state.copyWith(editorFontSize: clamped);
    final service = ref.read(settingsServiceProvider);
    unawaited(service.saveEditorFontSize(clamped));
  }

  /// Zoom in editor font size.
  void zoomInFontSize() {
    final newSize = state.editorFontSize + AppSettings.fontSizeStep;
    setEditorFontSize(newSize);
  }

  /// Zoom out editor font size.
  void zoomOutFontSize() {
    final newSize = state.editorFontSize - AppSettings.fontSizeStep;
    setEditorFontSize(newSize);
  }

  /// Reset editor font size to default.
  void resetFontSize() {
    setEditorFontSize(AppSettings.defaultFontSize);
  }

  /// Set the editor font family.
  void setEditorFontFamily(String family) {
    state = state.copyWith(editorFontFamily: family);
    final service = ref.read(settingsServiceProvider);
    unawaited(service.saveEditorFontFamily(family));
  }

  /// Add a recent workspace path.
  void addRecentWorkspace(String path) {
    final updated = [
      path,
      ...state.recentWorkspaces.where((p) => p != path),
    ].take(10).toList();
    state = state.copyWith(recentWorkspaces: updated);
    final service = ref.read(settingsServiceProvider);
    unawaited(service.saveRecentWorkspaces(updated));
  }

  /// Remove a recent workspace path.
  void removeRecentWorkspace(String path) {
    final updated = state.recentWorkspaces.where((p) => p != path).toList();
    state = state.copyWith(recentWorkspaces: updated);
    final service = ref.read(settingsServiceProvider);
    unawaited(service.saveRecentWorkspaces(updated));
  }

  /// Clear all recent workspaces.
  void clearRecentWorkspaces() {
    state = state.copyWith(recentWorkspaces: []);
    final service = ref.read(settingsServiceProvider);
    unawaited(service.saveRecentWorkspaces([]));
  }

  /// Toggle auto-save.
  void setAutoSave(bool enabled) {
    state = state.copyWith(autoSave: enabled);
    final service = ref.read(settingsServiceProvider);
    unawaited(service.saveAutoSave(enabled));
  }

  /// Set auto-save delay.
  void setAutoSaveDelay(int delayMs) {
    final clamped = delayMs.clamp(500, 10000);
    state = state.copyWith(autoSaveDelayMs: clamped);
    final service = ref.read(settingsServiceProvider);
    unawaited(service.saveAutoSaveDelay(clamped));
  }

  /// Toggle preview visibility.
  void setShowPreview(bool show) {
    state = state.copyWith(showPreview: show);
    final service = ref.read(settingsServiceProvider);
    unawaited(service.saveShowPreview(show));
  }

  /// Toggle preview visibility.
  void togglePreview() {
    final newShowPreview = !state.showPreview;
    state = state.copyWith(showPreview: newShowPreview);
    final service = ref.read(settingsServiceProvider);
    unawaited(service.saveShowPreview(newShowPreview));
  }

  /// Set sidebar width.
  void setSidebarWidth(double width) {
    final clamped = width.clamp(
      AppSettings.minSidebarWidth,
      AppSettings.maxSidebarWidth,
    );
    state = state.copyWith(sidebarWidth: clamped);
    final service = ref.read(settingsServiceProvider);
    unawaited(service.saveSidebarWidth(clamped));
  }

  /// Save all current settings to persistent storage.
  Future<void> saveAll() async {
    final service = ref.read(settingsServiceProvider);
    await service.saveSettings(state);
  }
}

/// Current theme mode provider (derived from AppState).
///
/// This provider also considers the system theme when themeMode is set to system.
@riverpod
ThemeMode currentThemeMode(CurrentThemeModeRef ref) {
  final appSettings = ref.watch(appStateProvider);

  if (appSettings.themeMode == ThemeMode.system) {
    // Check system brightness using SchedulerBinding
    final brightness =
        SchedulerBinding.instance.platformDispatcher.platformBrightness;
    return brightness == Brightness.dark ? ThemeMode.dark : ThemeMode.light;
  }

  return appSettings.themeMode;
}

/// Whether dark mode is active (derived from AppState).
///
/// This properly handles the system theme mode by checking actual system brightness.
@riverpod
bool isDarkMode(IsDarkModeRef ref) {
  final themeMode = ref.watch(appStateProvider.select((s) => s.themeMode));

  if (themeMode == ThemeMode.system) {
    // Use SchedulerBinding to get the actual system brightness
    final brightness =
        SchedulerBinding.instance.platformDispatcher.platformBrightness;
    return brightness == Brightness.dark;
  }

  return themeMode == ThemeMode.dark;
}

/// Recent workspaces provider (derived from AppState).
@riverpod
List<String> recentWorkspaces(RecentWorkspacesRef ref) {
  return ref.watch(appStateProvider.select((s) => s.recentWorkspaces));
}

/// Provider for the accent color.
///
/// This can be updated to be configurable in the future.
final accentColorProvider = Provider<Color>((ref) {
  // For now, use a fixed accent color.
  // This can be made configurable in the future by adding accentColor to AppSettings.
  return const Color(0xFF2196F3); // Material Blue
});
