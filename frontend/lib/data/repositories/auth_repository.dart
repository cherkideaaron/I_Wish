import '../models/user_model.dart';
import '../models/auth_request_model.dart';

/// Contract for auth operations.
/// 
/// The rest of the app only knows about this interface.
/// This allows you to completely swap out the backend (REST, Firebase, Supabase)
/// without changing a single line of UI code!
abstract class AuthRepository {
  Future<UserModel> login(LoginRequest request);
  Future<UserModel> register(RegisterRequest request);
  Future<void> logout();
}
