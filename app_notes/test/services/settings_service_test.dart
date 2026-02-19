/// Tests for SettingsService.
library;

import 'package:app_notes/models/app_settings.dart';
import 'package:app_notes/services/settings_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('SettingsService', () {
    late SettingsService service;

    setUp(() async {
      // Initialize SharedPreferences with empty values
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      service = SettingsService(prefs);
    });

    test('should load default settings when no settings saved', () {
      final settings = service.loadSettings();

      expect(settings.themeMode, ThemeMode.system);
      expect(settings.editorFontSize, 16.0);
      expect(settings.editorFontFamily, 'JetBrains Mono');
      expect(settings.recentWorkspaces, isEmpty);
      expect(settings.autoSave, true);
      expect(settings.autoSaveDelayMs, 2000);
      expect(settings.showPreview, true);
      expect(settings.sidebarWidth, 250.0);
    });

    test('should save and load theme mode', () async {
      await service.saveThemeMode(ThemeMode.dark);
      final settings = service.loadSettings();

      expect(settings.themeMode, ThemeMode.dark);
    });

    test('should save and load editor font size', () async {
      await service.saveEditorFontSize(20.0);
      final settings = service.loadSettings();

      expect(settings.editorFontSize, 20.0);
    });

    test('should save and load recent workspaces', () async {
      final workspaces = ['/home/user/workspace1', '/home/user/workspace2'];
      await service.saveRecentWorkspaces(workspaces);
      final settings = service.loadSettings();

      expect(settings.recentWorkspaces, workspaces);
    });

    test('should save and load auto save setting', () async {
      await service.saveAutoSave(false);
      final settings = service.loadSettings();

      expect(settings.autoSave, false);
    });

    test('should save and load show preview setting', () async {
      await service.saveShowPreview(false);
      final settings = service.loadSettings();

      expect(settings.showPreview, false);
    });

    test('should save and load sidebar width', () async {
      await service.saveSidebarWidth(300.0);
      final settings = service.loadSettings();

      expect(settings.sidebarWidth, 300.0);
    });

    test('should save and load editor preview ratio', () async {
      await service.saveEditorPreviewRatio(0.7);
      final ratio = service.loadEditorPreviewRatio();

      expect(ratio, 0.7);
    });

    test('should clamp editor preview ratio to valid range', () async {
      // Test minimum clamp
      await service.saveEditorPreviewRatio(0.05);
      expect(service.loadEditorPreviewRatio(), 0.1);

      // Test maximum clamp
      await service.saveEditorPreviewRatio(0.95);
      expect(service.loadEditorPreviewRatio(), 0.9);
    });

    test('should save all settings at once', () async {
      final settings = const AppSettings(
        themeMode: ThemeMode.light,
        editorFontSize: 18.0,
        editorFontFamily: 'Fira Code',
        recentWorkspaces: ['/path/to/workspace'],
        autoSave: false,
        autoSaveDelayMs: 1000,
        showPreview: false,
        sidebarWidth: 350.0,
      );

      await service.saveSettings(settings);
      final loaded = service.loadSettings();

      expect(loaded.themeMode, settings.themeMode);
      expect(loaded.editorFontSize, settings.editorFontSize);
      expect(loaded.editorFontFamily, settings.editorFontFamily);
      expect(loaded.recentWorkspaces, settings.recentWorkspaces);
      expect(loaded.autoSave, settings.autoSave);
      expect(loaded.autoSaveDelayMs, settings.autoSaveDelayMs);
      expect(loaded.showPreview, settings.showPreview);
      expect(loaded.sidebarWidth, settings.sidebarWidth);
    });

    test('should reset settings to defaults', () async {
      // Save some custom settings first
      await service.saveThemeMode(ThemeMode.dark);
      await service.saveSidebarWidth(400.0);

      // Reset settings
      await service.resetSettings();
      final settings = service.loadSettings();

      // Should be back to defaults
      expect(settings.themeMode, ThemeMode.system);
      expect(settings.sidebarWidth, 250.0);
    });
  });
}
