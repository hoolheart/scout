/// Preview state management using Riverpod.
library;

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'preview_state.g.dart';

/// Preview state for managing the preview panel visibility.
@riverpod
class PreviewState extends _$PreviewState {
  @override
  bool build() => true;

  /// Toggle preview visibility.
  void toggle() {
    state = !state;
  }

  /// Set preview visibility explicitly.
  void setVisible(bool visible) {
    state = visible;
  }

  /// Show the preview panel.
  void show() {
    state = true;
  }

  /// Hide the preview panel.
  void hide() {
    state = false;
  }
}

/// Whether preview is visible (derived from PreviewState).
@riverpod
bool isPreviewVisible(IsPreviewVisibleRef ref) {
  return ref.watch(previewStateProvider);
}
