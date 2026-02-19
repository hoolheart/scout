/// Global keyboard shortcuts handler for the application.
library;

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;

import 'package:app_notes/state/app_state.dart';
import 'package:app_notes/state/editor_state.dart';
import 'package:app_notes/state/workspace_state.dart';
import 'package:app_notes/services/file_picker_service.dart';

/// Global shortcuts widget that wraps the entire application.
class GlobalShortcuts extends ConsumerStatefulWidget {
  /// The child widget.
  final Widget child;

  /// Creates global shortcuts handler.
  const GlobalShortcuts({super.key, required this.child});

  @override
  ConsumerState<GlobalShortcuts> createState() => _GlobalShortcutsState();
}

class _GlobalShortcutsState extends ConsumerState<GlobalShortcuts> {
  @override
  Widget build(BuildContext context) {
    return Shortcuts(
      shortcuts: {
        // File operations
        LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyO):
            const OpenFileIntent(),
        LogicalKeySet(
          LogicalKeyboardKey.control,
          LogicalKeyboardKey.shift,
          LogicalKeyboardKey.keyO,
        ): const OpenFolderIntent(),
        LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyN):
            const NewFileIntent(),
        LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyS):
            const SaveFileIntent(),

        // Tab operations
        LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyW):
            const CloseTabIntent(),
        LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.tab):
            const NextTabIntent(),
        LogicalKeySet(
          LogicalKeyboardKey.control,
          LogicalKeyboardKey.shift,
          LogicalKeyboardKey.tab,
        ): const PreviousTabIntent(),

        // Preview toggle
        LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.backslash):
            const TogglePreviewIntent(),

        // Font zoom - Ctrl++ (equal key with shift) or Ctrl+=
        LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.equal):
            const ZoomInIntent(),
        LogicalKeySet(
          LogicalKeyboardKey.control,
          LogicalKeyboardKey.shift,
          LogicalKeyboardKey.equal,
        ): const ZoomInIntent(),
        LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.minus):
            const ZoomOutIntent(),
        LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.digit0):
            const ZoomResetIntent(),
      },
      child: Actions(
        actions: {
          OpenFileIntent: CallbackAction<OpenFileIntent>(
            onInvoke: (_) => _handleOpenFile(),
          ),
          OpenFolderIntent: CallbackAction<OpenFolderIntent>(
            onInvoke: (_) => _handleOpenFolder(),
          ),
          NewFileIntent: CallbackAction<NewFileIntent>(
            onInvoke: (_) => _handleNewFile(),
          ),
          SaveFileIntent: CallbackAction<SaveFileIntent>(
            onInvoke: (_) => _handleSaveFile(),
          ),
          CloseTabIntent: CallbackAction<CloseTabIntent>(
            onInvoke: (_) => _handleCloseTab(),
          ),
          NextTabIntent: CallbackAction<NextTabIntent>(
            onInvoke: (_) => _handleNextTab(),
          ),
          PreviousTabIntent: CallbackAction<PreviousTabIntent>(
            onInvoke: (_) => _handlePreviousTab(),
          ),
          TogglePreviewIntent: CallbackAction<TogglePreviewIntent>(
            onInvoke: (_) => _handleTogglePreview(),
          ),
          ZoomInIntent: CallbackAction<ZoomInIntent>(
            onInvoke: (_) => _handleZoomIn(),
          ),
          ZoomOutIntent: CallbackAction<ZoomOutIntent>(
            onInvoke: (_) => _handleZoomOut(),
          ),
          ZoomResetIntent: CallbackAction<ZoomResetIntent>(
            onInvoke: (_) => _handleZoomReset(),
          ),
        },
        child: widget.child,
      ),
    );
  }

  Future<void> _handleOpenFile() async {
    final path = await FilePickerService.pickMarkdownFile();
    if (path != null && mounted) {
      await ref.read(editorStateProvider.notifier).openFile(path);
    }
  }

  Future<void> _handleOpenFolder() async {
    final path = await FilePickerService.pickWorkspaceFolder();
    if (path != null && mounted) {
      await ref.read(workspaceStateProvider.notifier).openWorkspace(path);
    }
  }

  Future<void> _handleNewFile() async {
    // Get current workspace path or let user choose
    final currentWorkspace = ref.read(workspaceStateProvider);
    String? parentPath;

    if (currentWorkspace != null) {
      parentPath = currentWorkspace.path;
    } else {
      // No workspace open, ask user to select a folder
      parentPath = await FilePickerService.pickWorkspaceFolder();
      if (parentPath == null || !mounted) return;
    }

    // Show dialog to get filename
    if (mounted) {
      final fileName = await _showNewFileDialog(context);
      if (fileName != null && fileName.isNotEmpty) {
        // Ensure .md extension
        final actualFileName = fileName.endsWith('.md')
            ? fileName
            : '$fileName.md';
        final fullPath = p.join(parentPath!, actualFileName);

        // Create the file using Dart's File API
        try {
          final file = File(fullPath);
          await file.create(recursive: true);

          if (mounted) {
            // Open the newly created file
            await ref.read(editorStateProvider.notifier).openFile(fullPath);

            // Refresh file tree if workspace is open
            final wsNotifier = ref.read(workspaceStateProvider.notifier);
            if (ref.read(workspaceStateProvider) != null) {
              await wsNotifier.refreshFileTree();
            }
          }
        } catch (e) {
          debugPrint('Error creating file: $e');
        }
      }
    }
  }

  Future<String?> _showNewFileDialog(BuildContext context) async {
    final controller = TextEditingController();

    return showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('新建文件'),
          content: TextField(
            controller: controller,
            autofocus: true,
            decoration: const InputDecoration(
              labelText: '文件名',
              hintText: '输入文件名（自动添加 .md 扩展名）',
            ),
            onSubmitted: (value) => Navigator.of(context).pop(value),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('取消'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(controller.text),
              child: const Text('创建'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _handleSaveFile() async {
    final files = ref.read(editorStateProvider);
    final editorNotifier = ref.read(editorStateProvider.notifier);
    final activePath = editorNotifier.activeFilePath;

    if (activePath != null) {
      await editorNotifier.saveFile(activePath);
    }
  }

  void _handleCloseTab() {
    final editorNotifier = ref.read(editorStateProvider.notifier);
    final activePath = editorNotifier.activeFilePath;
    if (activePath != null) {
      editorNotifier.closeFile(activePath);
    }
  }

  void _handleNextTab() {
    final files = ref.read(editorStateProvider);
    final editorNotifier = ref.read(editorStateProvider.notifier);
    final activePath = editorNotifier.activeFilePath;

    if (files.isEmpty || activePath == null) return;

    final currentIndex = files.indexWhere((f) => f.path == activePath);
    if (currentIndex == -1) return;

    final nextIndex = (currentIndex + 1) % files.length;
    editorNotifier.setActiveFile(files[nextIndex].path);
  }

  void _handlePreviousTab() {
    final files = ref.read(editorStateProvider);
    final editorNotifier = ref.read(editorStateProvider.notifier);
    final activePath = editorNotifier.activeFilePath;

    if (files.isEmpty || activePath == null) return;

    final currentIndex = files.indexWhere((f) => f.path == activePath);
    if (currentIndex == -1) return;

    final prevIndex = (currentIndex - 1 + files.length) % files.length;
    editorNotifier.setActiveFile(files[prevIndex].path);
  }

  void _handleTogglePreview() {
    ref.read(appStateProvider.notifier).togglePreview();
  }

  void _handleZoomIn() {
    final currentSize = ref.read(appStateProvider).editorFontSize;
    ref.read(appStateProvider.notifier).setEditorFontSize(currentSize + 1);
  }

  void _handleZoomOut() {
    final currentSize = ref.read(appStateProvider).editorFontSize;
    ref.read(appStateProvider.notifier).setEditorFontSize(currentSize - 1);
  }

  void _handleZoomReset() {
    ref.read(appStateProvider.notifier).setEditorFontSize(16.0);
  }
}

// Intent classes for keyboard shortcuts

/// Intent to open a file.
class OpenFileIntent extends Intent {
  /// Creates an open file intent.
  const OpenFileIntent();
}

/// Intent to open a folder/workspace.
class OpenFolderIntent extends Intent {
  /// Creates an open folder intent.
  const OpenFolderIntent();
}

/// Intent to create a new file.
class NewFileIntent extends Intent {
  /// Creates a new file intent.
  const NewFileIntent();
}

/// Intent to save the current file.
class SaveFileIntent extends Intent {
  /// Creates a save file intent.
  const SaveFileIntent();
}

/// Intent to close the current tab.
class CloseTabIntent extends Intent {
  /// Creates a close tab intent.
  const CloseTabIntent();
}

/// Intent to switch to the next tab.
class NextTabIntent extends Intent {
  /// Creates a next tab intent.
  const NextTabIntent();
}

/// Intent to switch to the previous tab.
class PreviousTabIntent extends Intent {
  /// Creates a previous tab intent.
  const PreviousTabIntent();
}

/// Intent to toggle preview panel.
class TogglePreviewIntent extends Intent {
  /// Creates a toggle preview intent.
  const TogglePreviewIntent();
}

/// Intent to zoom in (increase font size).
class ZoomInIntent extends Intent {
  /// Creates a zoom in intent.
  const ZoomInIntent();
}

/// Intent to zoom out (decrease font size).
class ZoomOutIntent extends Intent {
  /// Creates a zoom out intent.
  const ZoomOutIntent();
}

/// Intent to reset zoom to default.
class ZoomResetIntent extends Intent {
  /// Creates a zoom reset intent.
  const ZoomResetIntent();
}
