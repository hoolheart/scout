/// Main layout with sidebar and editor area.
library;

import 'package:app_notes/ui/layout/editor_area.dart';
import 'package:app_notes/ui/layout/sidebar.dart';
import 'package:app_notes/ui/layout/status_bar.dart';
import 'package:app_notes/ui/layout/window_title_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Main application layout.
class MainLayout extends ConsumerWidget {
  /// Creates the main layout.
  const MainLayout({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // For now, we always show sidebar.
    // Sidebar visibility can be toggled via settings in future.
    const isSidebarVisible = true;

    return Scaffold(
      body: Column(
        children: [
          const WindowTitleBar(),
          Expanded(
            child: Row(
              children: [
                if (isSidebarVisible) const Sidebar(),
                const VerticalDivider(width: 1),
                const Expanded(
                  child: Column(
                    children: [
                      Expanded(child: EditorArea()),
                      StatusBar(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
