/// Riverpod provider for RustService.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:app_notes/services/rust_service.dart';

part 'rust_service_provider.g.dart';

/// Provider for the RustService singleton.
///
/// This provider initializes the Rust backend when first accessed.
///
/// Example usage:
/// ```dart
/// final rustService = ref.watch(rustServiceProvider);
/// ```
@riverpod
Future<RustService> rustService(RustServiceRef ref) async {
  final service = RustService.instance;
  if (!service.isInitialized) {
    await service.initialize();
  }
  return service;
}

/// Synchronous provider for RustService (for when initialization is done).
///
/// Use this only after [rustServiceProvider] has completed initialization.
///
/// Example usage:
/// ```dart
/// final rustService = ref.watch(rustServiceProviderSync);
/// ```
final rustServiceProviderSync = Provider<RustService>((ref) {
  return RustService.instance;
});

/// Provider for the Rust library version.
@riverpod
String rustVersion(RustVersionRef ref) {
  return ref.watch(rustServiceProviderSync).getRustVersion();
}
