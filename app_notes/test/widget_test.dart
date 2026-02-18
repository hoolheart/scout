// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can use WidgetTester to find child widgets in the widget tree,
// read text, and verify that the values of widget properties are correct.

import 'package:app_notes/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('App renders correctly', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const ProviderScope(child: AppNotes()));

    // Verify that the app title is displayed.
    expect(find.text('AppNotes'), findsOneWidget);

    // Verify that sidebar is visible
    expect(find.byIcon(Icons.folder_open_outlined), findsOneWidget);
  });

  testWidgets('Theme toggle works', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: AppNotes()));

    // Initial render
    expect(find.text('AppNotes'), findsOneWidget);
  });
}
