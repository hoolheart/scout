/// Settings persistence service for saving/loading app preferences.
library;

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:app_notes/models/app_settings.dart';

part 'settings_service.g.dart';

/// Provider for the settings service instance.
@Riverpod(keepAlive: true)
SettingsService settingsService(SettingsServiceRef ref) {
  throw UnimplementedError('SettingsService must be initialized before use');
}

/// Service for persisting application settings using SharedPreferences.
///
/// This service provides a type-safe interface for loading and saving
/// user preferences with automatic persistence.
class SettingsService {
  /// Creates a new settings service with the given preferences instance.
  SettingsService(this._prefs);

  final SharedPreferences _prefs;

  // Keys for SharedPreferences
  static const String _keyThemeMode = 'themeMode';
  static const String _keyEditorFontSize = 'editorFontSize';
  static const String _keyEditorFontFamily = 'editorFontFamily';
  static const String _keyRecentWorkspaces = 'recentWorkspaces';
  static const String _keyAutoSave = 'autoSave';
  static const String _keyAutoSaveDelayMs = 'autoSaveDelayMs';
  static const String _keyShowPreview = 'showPreview';
  static const String _keySidebarWidth = 'sidebarWidth';
  static const String _keyEditorPreviewRatio = 'editorPreviewRatio';

  /// Loads all settings from persistent storage.
  ///
  /// Returns default settings if no settings have been saved yet.
  AppSettings loadSettings() {
    final themeMode = _loadThemeMode();
    final editorFontSize = _prefs.getDouble(_keyEditorFontSize) ?? 16.0;
    final editorFontFamily =
        _prefs.getString(_keyEditorFontFamily) ?? 'JetBrains Mono';
    final recentWorkspaces = _prefs.getStringList(_keyRecentWorkspaces) ?? [];
    final autoSave = _prefs.getBool(_keyAutoSave) ?? true;
    final autoSaveDelayMs = _prefs.getInt(_keyAutoSaveDelayMs) ?? 2000;
    final showPreview = _prefs.getBool(_keyShowPreview) ?? true;
    final sidebarWidth = _prefs.getDouble(_keySidebarWidth) ?? 250.0;

    return AppSettings(
      themeMode: themeMode,
      editorFontSize: editorFontSize,
      editorFontFamily: editorFontFamily,
      recentWorkspaces: recentWorkspaces,
      autoSave: autoSave,
      autoSaveDelayMs: autoSaveDelayMs,
      showPreview: showPreview,
      sidebarWidth: sidebarWidth,
    );
  }

  /// Saves all settings to persistent storage.
  ///
  /// This method should be called when settings change.
  Future<void> saveSettings(AppSettings settings) async {
    await Future.wait([
      _saveThemeMode(settings.themeMode),
      _prefs.setDouble(_keyEditorFontSize, settings.editorFontSize),
      _prefs.setString(_keyEditorFontFamily, settings.editorFontFamily),
      _prefs.setStringList(_keyRecentWorkspaces, settings.recentWorkspaces),
      _prefs.setBool(_keyAutoSave, settings.autoSave),
      _prefs.setInt(_keyAutoSaveDelayMs, settings.autoSaveDelayMs),
      _prefs.setBool(_keyShowPreview, settings.showPreview),
      _prefs.setDouble(_keySidebarWidth, settings.sidebarWidth),
    ]);

    if (kDebugMode) {
      debugPrint('Settings saved: ${settings.toJson()}');
    }
  }

  /// Saves the theme mode.
  Future<void> saveThemeMode(ThemeMode mode) => _saveThemeMode(mode);

  /// Saves the editor font size.
  Future<void> saveEditorFontSize(double size) =>
      _prefs.setDouble(_keyEditorFontSize, size);

  /// Saves the editor font family.
  Future<void> saveEditorFontFamily(String family) =>
      _prefs.setString(_keyEditorFontFamily, family);

  /// Saves the recent workspaces list.
  Future<void> saveRecentWorkspaces(List<String> workspaces) =>
      _prefs.setStringList(_keyRecentWorkspaces, workspaces);

  /// Saves the auto-save setting.
  Future<void> saveAutoSave(bool enabled) =>
      _prefs.setBool(_keyAutoSave, enabled);

  /// Saves the auto-save delay.
  Future<void> saveAutoSaveDelay(int delayMs) =>
      _prefs.setInt(_keyAutoSaveDelayMs, delayMs);

  /// Saves the show preview setting.
  Future<void> saveShowPreview(bool show) =>
      _prefs.setBool(_keyShowPreview, show);

  /// Saves the sidebar width.
  Future<void> saveSidebarWidth(double width) =>
      _prefs.setDouble(_keySidebarWidth, width);

  /// Saves the editor/preview ratio (0.0 to 1.0).
  ///
  /// 0.5 means equal split, < 0.5 means more space for preview,
  /// > 0.5 means more space for editor.
  Future<void> saveEditorPreviewRatio(double ratio) =>
      _prefs.setDouble(_keyEditorPreviewRatio, ratio.clamp(0.1, 0.9));

  /// Loads the editor/preview ratio.
  double loadEditorPreviewRatio() =>
      _prefs.getDouble(_keyEditorPreviewRatio) ?? 0.5;

  /// Resets all settings to defaults.
  Future<void> resetSettings() async {
    await _prefs.clear();
    debugPrint('Settings reset to defaults');
  }

  // Private helper methods

  ThemeMode _loadThemeMode() {
    final value = _prefs.getString(_keyThemeMode);
    switch (value) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      case 'system':
      default:
        return ThemeMode.system;
    }
  }

  Future<bool> _saveThemeMode(ThemeMode mode) {
    String value;
    switch (mode) {
      case ThemeMode.light:
        value = 'light';
      case ThemeMode.dark:
        value = 'dark';
      case ThemeMode.system:
        value = 'system';
    }
    return _prefs.setString(_keyThemeMode, value);
  }
}

/// Provider for the editor/preview split ratio.
@Riverpod(keepAlive: true)
class EditorPreviewRatio extends _$EditorPreviewRatio {
  @override
  double build() {
    // Get the ratio from settings service
    final service = ref.read(settingsServiceProvider);
    return service.loadEditorPreviewRatio();
  }

  /// Sets the split ratio (0.0 to 1.0).
  ///
  /// 0.5 means equal split, < 0.5 means more space for preview,
  /// > 0.5 means more space for editor.
  void setRatio(double ratio) {
    final clampedRatio = ratio.clamp(0.2, 0.8);
    state = clampedRatio;
    // Persist the change
    final service = ref.read(settingsServiceProvider);
    unawaited(service.saveEditorPreviewRatio(clampedRatio));
  }

  /// Resets the ratio to equal split.
  void reset() => setRatio(0.5);
}
