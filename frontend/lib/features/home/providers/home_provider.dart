import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../features/auth/providers/auth_provider.dart';
import '../../../data/models/user_model.dart';

/// Exposes the currently logged-in user for the home feature.
/// Derived from [authProvider] so there is a single source of truth.
final currentUserProvider = Provider<UserModel?>((ref) {
  return ref.watch(authProvider).value;
});
