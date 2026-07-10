import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/user_model.dart';
import '../../../data/models/auth_request_model.dart';
import '../../../data/providers/auth_repository_provider.dart';
import '../../../core/storage/storage_provider.dart';

/// ─────────────────────────────────────────────────────────────────────────────
/// AUTH STATE — Single Source of Truth
/// ─────────────────────────────────────────────────────────────────────────────
///
/// State semantics:
///   AsyncLoading()        → login/register/startup check in progress
///   AsyncData(null)       → not authenticated (show login/register)
///   AsyncData(UserModel)  → authenticated (show home/app content)
///   AsyncError(e, s)      → login/register failed (show error to user)
///
/// How to use in a widget:
///   final authState = ref.watch(authProvider);
///   authState.when(
///     loading: () => LoadingIndicator(),
///     data: (user) => user != null ? HomeScreen() : LoginScreen(),
///     error: (e, _) => ErrorView(message: e.toString()),
///   );
///
/// How to trigger actions:
///   ref.read(authProvider.notifier).login(email, password);
///   ref.read(authProvider.notifier).register(name, email, password);
///   ref.read(authProvider.notifier).logout();
/// ─────────────────────────────────────────────────────────────────────────────
class AuthNotifier extends AsyncNotifier<UserModel?> {
  @override
  Future<UserModel?> build() async {
    // On cold start: check if a token already exists in secure storage.
    // If yes, the user was previously logged in.
    //
    // 🔧 TODO (optional): call GET /user/profile here to validate the token
    //    and get fresh user data. For now we return a placeholder.
    final storage = ref.read(storageServiceProvider);
    final token = await storage.getToken();

    if (token != null && token.isNotEmpty) {
      // Token found → treat as logged in.
      // Replace this with a real profile fetch if your API supports it.
      return UserModel(
        id: await storage.getUserId() ?? '',
        name: '',
        email: '',
        token: token,
      );
    }

    return null; // Not logged in
  }

  // ─── Login ────────────────────────────────────────────────────────────────
  Future<void> login(String email, String password) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final user = await ref
          .read(authRepositoryProvider)
          .login(LoginRequest(email: email, password: password));

      // Persist token so the user stays logged in across restarts.
      final storage = ref.read(storageServiceProvider);
      await storage.saveToken(user.token);
      await storage.saveUserId(user.id);

      return user;
    });
  }

  // ─── Register ─────────────────────────────────────────────────────────────
  Future<void> register(String name, String email, String password) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref
          .read(authRepositoryProvider)
          .register(
            RegisterRequest(name: name, email: email, password: password),
          );

      // Do NOT log them in automatically. Stay as 'null'.
      // They must proceed to the Login screen.
      return null;
    });
  }

  // ─── Logout ───────────────────────────────────────────────────────────────
  Future<void> logout() async {
    await ref.read(storageServiceProvider).clearAll();
    state = const AsyncData(null);
  }
}

/// The global auth provider. Watch this anywhere in the app to react to auth changes.
final authProvider = AsyncNotifierProvider<AuthNotifier, UserModel?>(
  AuthNotifier.new,
);
