/// Save status provider for displaying save state in UI.
library;

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'save_status.g.dart';

/// Represents the current save status for a file.
enum SaveStatus {
  /// Initial state, no save operation in progress.
  idle,

  /// File is currently being saved.
  saving,

  /// File was saved successfully.
  saved,

  /// Save operation failed.
  error,
}

/// Save status state for a specific file.
@riverpod
class FileSaveStatus extends _$FileSaveStatus {
  @override
  SaveStatus build(String filePath) => SaveStatus.idle;

  /// Set status to saving.
  void setSaving() {
    state = SaveStatus.saving;
  }

  /// Set status to saved.
  void setSaved() {
    state = SaveStatus.saved;
    // Auto-reset to idle after 2 seconds
    Future.delayed(const Duration(seconds: 2), () {
      if (state == SaveStatus.saved) {
        state = SaveStatus.idle;
      }
    });
  }

  /// Set status to error.
  void setError() {
    state = SaveStatus.error;
  }

  /// Reset to idle state.
  void reset() {
    state = SaveStatus.idle;
  }
}

/// Global save status messages for displaying error messages.
@riverpod
class SaveStatusMessage extends _$SaveStatusMessage {
  @override
  String? build() => null;

  /// Show an error message.
  void showError(String message) {
    state = message;
    // Auto-clear after 5 seconds
    Future.delayed(const Duration(seconds: 5), () {
      if (state == message) {
        state = null;
      }
    });
  }

  /// Clear the message.
  void clear() {
    state = null;
  }
}
