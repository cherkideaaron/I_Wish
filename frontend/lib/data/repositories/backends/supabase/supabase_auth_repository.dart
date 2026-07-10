import 'package:supabase_flutter/supabase_flutter.dart';
import '../../auth_repository.dart';
import '../../../models/user_model.dart';
import '../../../models/auth_request_model.dart';

/// Concrete Supabase implementation of [AuthRepository].
class SupabaseAuthRepository implements AuthRepository {
  final SupabaseClient _supabase = Supabase.instance.client;

  @override
  Future<UserModel> login(LoginRequest request) async {
    final response = await _supabase.auth.signInWithPassword(
      email: request.email,
      password: request.password,
    );
    final user = response.user;
    if (user == null) throw Exception('Login failed');
    
    return UserModel(
      id: user.id,
      email: user.email ?? '',
      name: user.userMetadata?['name'] ?? '',
      token: response.session?.accessToken ?? '',
      role: user.userMetadata?['role'] ?? 'user', // ← Extract role
    );
  }

  @override
  Future<UserModel> register(RegisterRequest request) async {
    final response = await _supabase.auth.signUp(
      email: request.email,
      password: request.password,
      // Save custom metadata, including a default role
      data: {
        'name': request.name,
        'role': 'user', // New users are 'user' by default
      }, 
    );
    final user = response.user;
    if (user == null) throw Exception('Registration failed');
    
    return UserModel(
      id: user.id,
      email: user.email ?? '',
      name: request.name,
      token: response.session?.accessToken ?? '',
      role: 'user', // Assigned by default on register
    );
  }

  @override
  Future<void> logout() async {
    await _supabase.auth.signOut();
  }
}
