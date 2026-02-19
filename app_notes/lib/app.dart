/// Main app widget with theme and window configuration.
library;

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:window_manager/window_manager.dart';

import 'package:app_notes/models/app_settings.dart';
import 'package:app_notes/state/app_state.dart';
import 'package:app_notes/ui/layout/main_layout.dart';
import 'package:app_notes/ui/shortcuts/global_shortcuts.dart';

/// AppNotes application widget.
class AppNotes extends ConsumerWidget {
  /// Creates the app widget.
  const AppNotes({super.key, this.initialSettings});

  /// Initial settings loaded from persistent storage.
  final AppSettings? initialSettings;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(currentThemeModeProvider);
    final accentColor = ref.watch(accentColorProvider);

    return MaterialApp(
      title: 'AppNotes',
      debugShowCheckedModeBanner: false,
      theme: _buildLightTheme(accentColor),
      darkTheme: _buildDarkTheme(accentColor),
      themeMode: themeMode,
      home: const GlobalShortcuts(child: MainLayout()),
    );
  }

  ThemeData _buildLightTheme(Color accentColor) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: accentColor,
      brightness: Brightness.light,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: colorScheme,
      appBarTheme: const AppBarTheme(centerTitle: false, elevation: 0),
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      dividerTheme: const DividerThemeData(space: 1),
      // Editor-specific theming
      textTheme: _buildTextTheme(Brightness.light),
      // Custom scrollbar theme
      scrollbarTheme: ScrollbarThemeData(
        thumbColor: WidgetStateProperty.all(
          colorScheme.onSurface.withAlpha(128),
        ),
        trackColor: WidgetStateProperty.all(
          colorScheme.onSurface.withAlpha(26),
        ),
      ),
    );
  }

  ThemeData _buildDarkTheme(Color accentColor) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: accentColor,
      brightness: Brightness.dark,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: colorScheme,
      appBarTheme: const AppBarTheme(centerTitle: false, elevation: 0),
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      dividerTheme: const DividerThemeData(space: 1),
      // Editor-specific theming
      textTheme: _buildTextTheme(Brightness.dark),
      // Custom scrollbar theme
      scrollbarTheme: ScrollbarThemeData(
        thumbColor: WidgetStateProperty.all(
          colorScheme.onSurface.withAlpha(128),
        ),
        trackColor: WidgetStateProperty.all(
          colorScheme.onSurface.withAlpha(26),
        ),
      ),
    );
  }

  TextTheme _buildTextTheme(Brightness brightness) {
    final baseTextTheme = brightness == Brightness.light
        ? ThemeData.light().textTheme
        : ThemeData.dark().textTheme;

    return baseTextTheme.copyWith(
      bodySmall: baseTextTheme.bodySmall?.copyWith(fontSize: 12, height: 1.4),
      bodyMedium: baseTextTheme.bodyMedium?.copyWith(fontSize: 14, height: 1.5),
      bodyLarge: baseTextTheme.bodyLarge?.copyWith(fontSize: 16, height: 1.6),
    );
  }
}

/// Initialize window manager settings.
Future<void> initializeWindowManager() async {
  await windowManager.ensureInitialized();

  const windowOptions = WindowOptions(
    size: Size(1200, 800),
    minimumSize: Size(800, 600),
    center: true,
    title: 'AppNotes - Markdown Editor',
    backgroundColor: Colors.transparent,
    skipTaskbar: false,
    titleBarStyle: TitleBarStyle.hidden,
  );

  await windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });
}
