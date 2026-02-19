/// Custom window title bar for desktop platforms.
library;

import 'package:app_notes/services/file_picker_service.dart';
import 'package:app_notes/state/app_state.dart';
import 'package:app_notes/state/editor_state.dart';
import 'package:app_notes/state/workspace_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:window_manager/window_manager.dart';

/// Custom window title bar with drag support and controls.
class WindowTitleBar extends ConsumerWidget {
  /// Creates the window title bar.
  const WindowTitleBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return GestureDetector(
      onPanStart: (_) => windowManager.startDragging(),
      onDoubleTap: () async {
        if (await windowManager.isMaximized()) {
          await windowManager.unmaximize();
        } else {
          await windowManager.maximize();
        }
      },
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          border: Border(
            bottom: BorderSide(color: theme.dividerColor.withAlpha(26)),
          ),
        ),
        child: Row(
          children: [
            const SizedBox(width: 16),
            // App icon/logo
            Icon(Icons.edit_note, size: 20, color: theme.colorScheme.primary),
            const SizedBox(width: 8),
            // Title
            Text(
              'AppNotes',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 24),
            // Menu bar
            _buildMenuBar(context, ref),
            const Spacer(),
            // Window controls
            _WindowButton(
              icon: Icons.remove,
              onPressed: windowManager.minimize,
            ),
            _WindowButton(
              icon: Icons.crop_square,
              onPressed: () async {
                if (await windowManager.isMaximized()) {
                  await windowManager.unmaximize();
                } else {
                  await windowManager.maximize();
                }
              },
            ),
            _WindowButton(
              icon: Icons.close,
              onPressed: windowManager.close,
              hoverColor: isDark ? Colors.red[700] : Colors.red[100],
              iconHoverColor: isDark ? Colors.white : Colors.red,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuBar(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final recentWorkspaces = ref.watch(recentWorkspacesProvider);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // File Menu
        _MenuButton(
          label: 'File',
          menuItems: [
            // Open File
            MenuItem(
              label: 'Open File...',
              shortcut: 'Ctrl+O',
              onTap: () async {
                final path = await FilePickerService.pickMarkdownFile();
                if (path != null && context.mounted) {
                  await ref.read(editorStateProvider.notifier).openFile(path);
                }
              },
            ),
            // Open Folder
            MenuItem(
              label: 'Open Folder...',
              shortcut: 'Ctrl+K Ctrl+O',
              onTap: () async {
                final path = await FilePickerService.pickWorkspaceFolder();
                if (path != null && context.mounted) {
                  await ref
                      .read(workspaceStateProvider.notifier)
                      .openWorkspace(path);
                }
              },
            ),
            // Recent Workspaces
            if (recentWorkspaces.isNotEmpty) ...[
              const MenuDivider(),
              MenuHeader(label: 'Recent Workspaces'),
              ...recentWorkspaces.take(5).map((path) {
                return MenuItem(
                  label: _truncatePath(path),
                  onTap: () async {
                    await ref
                        .read(workspaceStateProvider.notifier)
                        .openRecentWorkspace(path);
                  },
                );
              }),
            ],
            const MenuDivider(),
            // Save
            MenuItem(
              label: 'Save',
              shortcut: 'Ctrl+S',
              onTap: () async {
                final activePath = ref.read(activeEditorFilePathProvider);
                if (activePath != null) {
                  await ref
                      .read(editorStateProvider.notifier)
                      .saveFile(activePath);
                }
              },
            ),
            // Save As
            MenuItem(
              label: 'Save As...',
              shortcut: 'Ctrl+Shift+S',
              onTap: () async {
                final activeFile = ref.read(activeEditorFileProvider);
                final path = await FilePickerService.pickSaveLocation(
                  defaultFileName: activeFile?.name ?? 'untitled.md',
                );
                if (path != null && context.mounted) {
                  // TODO: Implement save as functionality
                }
              },
            ),
            const MenuDivider(),
            // Exit
            MenuItem(label: 'Exit', onTap: windowManager.close),
          ],
        ),
        const SizedBox(width: 4),
        // View Menu
        _MenuButton(
          label: 'View',
          menuItems: [
            MenuItem(
              label: 'Toggle Preview',
              shortcut: 'Ctrl+Shift+V',
              onTap: () {
                ref.read(appStateProvider.notifier).togglePreview();
              },
            ),
            const MenuDivider(),
            MenuItem(
              label: 'Light Theme',
              onTap: () {
                ref
                    .read(appStateProvider.notifier)
                    .setThemeMode(ThemeMode.light);
              },
            ),
            MenuItem(
              label: 'Dark Theme',
              onTap: () {
                ref
                    .read(appStateProvider.notifier)
                    .setThemeMode(ThemeMode.dark);
              },
            ),
          ],
        ),
      ],
    );
  }

  String _truncatePath(String path, {int maxLength = 40}) {
    if (path.length <= maxLength) return path;
    return '...${path.substring(path.length - maxLength + 3)}';
  }
}

/// Data class for menu items.
class MenuItem {
  /// Creates a menu item.
  const MenuItem({
    required this.label,
    this.shortcut,
    this.onTap,
    this.isEnabled = true,
  });

  /// Display label for the menu item.
  final String label;

  /// Keyboard shortcut text.
  final String? shortcut;

  /// Callback when the item is tapped.
  final VoidCallback? onTap;

  /// Whether the item is enabled.
  final bool isEnabled;
}

/// Data class for menu headers.
class MenuHeader {
  /// Creates a menu header.
  const MenuHeader({required this.label});

  /// Display label for the header.
  final String label;
}

/// Data class for menu dividers.
class MenuDivider {
  /// Creates a menu divider.
  const MenuDivider();
}

/// Menu button widget.
class _MenuButton extends StatelessWidget {
  /// Creates a menu button.
  const _MenuButton({required this.label, required this.menuItems});

  /// Button label.
  final String label;

  /// Menu items to display.
  final List<dynamic> menuItems;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return PopupMenuButton<dynamic>(
      tooltip: label,
      offset: const Offset(0, 40),
      constraints: const BoxConstraints(minWidth: 200),
      itemBuilder: (context) {
        final entries = <PopupMenuEntry<dynamic>>[];
        for (final item in menuItems) {
          if (item is MenuDivider) {
            entries.add(const PopupMenuDivider());
          } else if (item is MenuHeader) {
            entries.add(
              PopupMenuItem<dynamic>(
                enabled: false,
                height: 32,
                child: Text(
                  item.label,
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface.withAlpha(153),
                  ),
                ),
              ),
            );
          } else if (item is MenuItem) {
            entries.add(
              PopupMenuItem<dynamic>(
                enabled: item.isEnabled,
                onTap: item.onTap,
                height: 36,
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        item.label,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontSize: 13,
                        ),
                      ),
                    ),
                    if (item.shortcut != null)
                      Text(
                        item.shortcut!,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withAlpha(128),
                          fontSize: 11,
                        ),
                      ),
                  ],
                ),
              ),
            );
          }
        }
        return entries;
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(fontSize: 13),
        ),
      ),
    );
  }
}

class _WindowButton extends StatefulWidget {
  const _WindowButton({
    required this.icon,
    required this.onPressed,
    this.hoverColor,
    this.iconHoverColor,
  });

  final IconData icon;
  final VoidCallback onPressed;
  final Color? hoverColor;
  final Color? iconHoverColor;

  @override
  State<_WindowButton> createState() => _WindowButtonState();
}

class _WindowButtonState extends State<_WindowButton> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: GestureDetector(
        onTap: widget.onPressed,
        child: Container(
          width: 46,
          height: 40,
          decoration: BoxDecoration(
            color: _isHovering ? widget.hoverColor : null,
          ),
          child: Icon(
            widget.icon,
            size: 18,
            color: _isHovering && widget.iconHoverColor != null
                ? widget.iconHoverColor
                : theme.colorScheme.onSurface.withAlpha(204),
          ),
        ),
      ),
    );
  }
}
