/// App settings model for application preferences.
library;

import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_settings.freezed.dart';
part 'app_settings.g.dart';

/// Represents application-wide settings and preferences.
@Freezed(toJson: true, fromJson: true)
class AppSettings with _$AppSettings {
  /// Creates new app settings.
  const factory AppSettings({
    /// Current theme mode (light, dark, or system).
    @Default(ThemeMode.system) ThemeMode themeMode,

    /// Font size for the editor.
    @Default(16.0) double editorFontSize,

    /// Font family for the editor.
    @Default('JetBrains Mono') String editorFontFamily,

    /// List of recently opened workspace paths.
    @Default([]) List<String> recentWorkspaces,

    /// Whether auto-save is enabled.
    @Default(true) bool autoSave,

    /// Auto-save delay in milliseconds.
    @Default(2000) int autoSaveDelayMs,

    /// Whether the preview panel is visible.
    @Default(true) bool showPreview,

    /// Width of the sidebar in pixels.
    @Default(250.0) double sidebarWidth,
  }) = _AppSettings;

  const AppSettings._();

  /// Minimum allowed font size.
  static const double minFontSize = 10.0;

  /// Maximum allowed font size.
  static const double maxFontSize = 24.0;

  /// Default font size.
  static const double defaultFontSize = 16.0;

  /// Font size step for zoom in/out.
  static const double fontSizeStep = 2.0;

  /// Minimum allowed sidebar width.
  static const double minSidebarWidth = 200.0;

  /// Maximum allowed sidebar width.
  static const double maxSidebarWidth = 500.0;

  /// Returns true if there are recent workspaces.
  bool get hasRecentWorkspaces => recentWorkspaces.isNotEmpty;

  /// Returns clamped font size within valid range.
  double get clampedFontSize => editorFontSize.clamp(minFontSize, maxFontSize);

  /// Returns clamped sidebar width within valid range.
  double get clampedSidebarWidth =>
      sidebarWidth.clamp(minSidebarWidth, maxSidebarWidth);
}
