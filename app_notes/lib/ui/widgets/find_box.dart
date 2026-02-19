/// Find box widget for text search in the editor.
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:app_notes/state/editor_state.dart';
import 'package:app_notes/state/search_state.dart';

/// Find box widget displayed above the editor.
class FindBox extends ConsumerStatefulWidget {
  /// Creates a new find box.
  const FindBox({super.key});

  @override
  ConsumerState<FindBox> createState() => _FindBoxState();
}

class _FindBoxState extends ConsumerState<FindBox> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    // Request focus when the find box is shown
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final searchState = ref.watch(searchControllerProvider);
    final activeFile = ref.watch(activeEditorFileProvider);

    // Update search when text changes
    if (activeFile != null) {
      ref
          .read(searchControllerProvider.notifier)
          .updateQuery(searchState.query, activeFile.content);
    }

    return Focus(
      onKeyEvent: (node, event) {
        if (event is KeyDownEvent &&
            event.logicalKey == LogicalKeyboardKey.escape) {
          ref.read(searchControllerProvider.notifier).hide();
          return KeyEventResult.handled;
        }
        return KeyEventResult.ignored;
      },
      child: Container(
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest.withAlpha(51),
          border: Border(bottom: BorderSide(color: theme.dividerColor)),
        ),
        child: Row(
          children: [
            // Search icon
            Icon(
              Icons.search,
              size: 18,
              color: theme.colorScheme.onSurface.withAlpha(153),
            ),
            const SizedBox(width: 8),
            // Search input
            Expanded(
              child: TextField(
                controller: _controller,
                focusNode: _focusNode,
                decoration: InputDecoration(
                  hintText: 'Find...',
                  hintStyle: TextStyle(
                    color: theme.colorScheme.onSurface.withAlpha(102),
                    fontSize: 14,
                  ),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                ),
                style: const TextStyle(fontSize: 14),
                onChanged: (value) {
                  if (activeFile != null) {
                    ref
                        .read(searchControllerProvider.notifier)
                        .setQuery(value, activeFile.content);
                  }
                },
                onSubmitted: (value) {
                  // Check if shift key is pressed
                  final isShiftPressed =
                      HardwareKeyboard.instance.isShiftPressed;
                  if (isShiftPressed) {
                    _findPrevious();
                  } else {
                    _findNext();
                  }
                },
              ),
            ),
            // Match count
            if (searchState.hasMatches) ...[
              const SizedBox(width: 12),
              Text(
                searchState.matchCountText,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withAlpha(153),
                ),
              ),
            ],
            const SizedBox(width: 8),
            // Previous button
            _FindBoxButton(
              icon: Icons.arrow_upward,
              tooltip: 'Previous match (Shift+Enter)',
              onPressed: searchState.hasMatches ? _findPrevious : null,
            ),
            // Next button
            _FindBoxButton(
              icon: Icons.arrow_downward,
              tooltip: 'Next match (Enter)',
              onPressed: searchState.hasMatches ? _findNext : null,
            ),
            const SizedBox(width: 8),
            // Close button
            _FindBoxButton(
              icon: Icons.close,
              tooltip: 'Close (Esc)',
              onPressed: () =>
                  ref.read(searchControllerProvider.notifier).hide(),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void didUpdateWidget(FindBox oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Request focus when the find box becomes visible
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  void _findNext() {
    ref.read(searchControllerProvider.notifier).nextMatch();
  }

  void _findPrevious() {
    ref.read(searchControllerProvider.notifier).previousMatch();
  }
}

/// Button for the find box with consistent styling.
class _FindBoxButton extends StatelessWidget {
  const _FindBoxButton({
    required this.icon,
    required this.tooltip,
    this.onPressed,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isEnabled = onPressed != null;

    return Tooltip(
      message: tooltip,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(4),
          child: Container(
            padding: const EdgeInsets.all(6),
            child: Icon(
              icon,
              size: 18,
              color: isEnabled
                  ? theme.colorScheme.onSurface.withAlpha(178)
                  : theme.colorScheme.onSurface.withAlpha(51),
            ),
          ),
        ),
      ),
    );
  }
}

/// Widget that wraps the editor and adds find functionality.
class EditorWithFind extends ConsumerWidget {
  /// Creates a new editor with find functionality.
  const EditorWithFind({super.key, required this.child});

  /// The editor widget to wrap.
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFindVisible = ref.watch(isFindBoxVisibleProvider);

    return Column(
      children: [
        // Find box (shown/hidden based on state)
        AnimatedSize(
          duration: const Duration(milliseconds: 200),
          child: isFindVisible ? const FindBox() : const SizedBox.shrink(),
        ),
        // Editor content
        Expanded(child: child),
      ],
    );
  }
}
