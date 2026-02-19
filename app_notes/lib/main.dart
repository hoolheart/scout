/// Application entry point.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:app_notes/app.dart';
import 'package:app_notes/services/settings_service.dart';
import 'package:app_notes/state/app_state.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize SharedPreferences and SettingsService
  final prefs = await SharedPreferences.getInstance();
  final settingsService = SettingsService(prefs);

  // Load saved settings
  final savedSettings = settingsService.loadSettings();

  // Initialize window manager for desktop
  await initializeWindowManager();

  runApp(
    ProviderScope(
      overrides: [
        // Override settingsServiceProvider with initialized instance
        settingsServiceProvider.overrideWithValue(settingsService),
        // Override initialSettingsProvider with loaded settings
        initialSettingsProvider.overrideWithValue(savedSettings),
      ],
      child: const AppNotes(),
    ),
  );
}
