/// Application entry point.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:app_notes/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize window manager for desktop
  await initializeWindowManager();

  runApp(const ProviderScope(child: AppNotes()));
}
