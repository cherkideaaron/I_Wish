import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as aw;
import '../../auth_repository.dart';
import '../../../models/user_model.dart';
import '../../../models/auth_request_model.dart';

/// Appwrite Implementation of AuthRepository.
///
/// HOW TO SET UP:
///   1. Visit your Appwrite console at http://156.67.26.89
///   2. Create a project and paste the Project ID into [projectId] below
///   3. In your project → Auth → Settings, enable "Email/Password" sign-in
///
/// HOW TO SWITCH TO THIS BACKEND:
///   In lib/data/providers/auth_repository_provider.dart, set:
///   `return AppwriteAuthRepository();`
class AppwriteAuthRepository implements AuthRepository {
  // ─── Configuration ────────────────────────────────────────────────────────
  // TODO: Replace with your actual Project ID from Appwrite Console
  static const String _endpoint = 'https://156.67.26.89/v1';
  static const String _projectId = '6a4f84e0002c6f50e59a';
  // ─────────────────────────────────────────────────────────────────────────

  late final Client _client;
  late final Account _account;

  AppwriteAuthRepository() {
    _client = Client()
      ..setEndpoint(_endpoint)
      ..setProject(_projectId)
      ..setSelfSigned(status: true); // Required for self-hosted Appwrite
    _account = Account(_client);
  }

  @override
  Future<UserModel> login(LoginRequest request) async {
    try {
      // 1. Create a session (login)
      await _account.createEmailPasswordSession(
        email: request.email,
        password: request.password,
      );

      // 2. Get the logged-in user's details
      final aw.User user = await _account.get();

      return UserModel(
        id: user.$id,
        email: user.email,
        name: user.name,
        token: '', // Appwrite uses session cookies, not JWT by default
        role: user.labels.contains('admin') ? 'admin' : 'user',
      );
    } on AppwriteException catch (e) {
      throw Exception(_mapAppwriteError(e));
    }
  }

  @override
  Future<UserModel> register(RegisterRequest request) async {
    try {
      // CLEAR ANY LINGERING SESSIONS FIRST
      // If the Appwrite SDK has a cached cookie, it blocks new registrations
      try {
        await _account.deleteSession(sessionId: 'current');
      } catch (_) {
        // Ignore errors if there was no session
      }

      final customUserId = ID.unique();
      print('APPWRITE REGISTER ATTEMPT:');
      print('  userId: $customUserId');
      print('  email: ${request.email}');
      print('  name: ${request.name}');
      
      // 1. Create the account
      await _account.create(
        userId: customUserId,
        email: request.email,
        password: request.password,
        name: request.name,
      );

      // 2. Do NOT auto-login — let them go to the Login screen
      return UserModel(
        id: '',
        email: request.email,
        name: request.name,
        token: '',
        role: 'user',
      );
    } on AppwriteException catch (e) {
      throw Exception(_mapAppwriteError(e));
    }
  }

  @override
  Future<void> logout() async {
    try {
      await _account.deleteSession(sessionId: 'current');
    } on AppwriteException catch (e) {
      throw Exception(_mapAppwriteError(e));
    }
  }

  String _mapAppwriteError(AppwriteException e) {
    print('APPWRITE ERROR: type=${e.type}, code=${e.code}, message=${e.message}');
    switch (e.type) {
      case 'user_already_exists':
        return 'An account already exists for that email.';
      case 'user_invalid_credentials':
      case 'user_not_found':
        return 'Incorrect email or password. Please try again.';
      case 'user_invalid_token':
        return 'Your session has expired. Please log in again.';
      case 'network_request_failed':
        return 'Network error. Please check your internet connection.';
      default:
        return 'Error: ${e.message} (Type: ${e.type})';
    }
  }
}
