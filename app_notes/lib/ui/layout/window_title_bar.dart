/// Custom window title bar for desktop platforms.
library;

import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

/// Custom window title bar with drag support and controls.
class WindowTitleBar extends StatelessWidget {
  /// Creates the window title bar.
  const WindowTitleBar({super.key});

  @override
  Widget build(BuildContext context) {
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
