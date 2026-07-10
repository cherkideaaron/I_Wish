import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'storage_service.dart';

/// Provides the singleton [StorageService] instance to the Riverpod tree.
final storageServiceProvider = Provider<StorageService>((ref) {
  return StorageService();
});
