import 'dart:convert';
import 'package:http/http.dart' as http;

import '../auth_repository.dart';
import '../../models/user_model.dart';
import '../../models/auth_request_model.dart';

/// Concrete implementation for a completely custom backend.
/// 
/// You can just change the endpoints here to whatever your server expects!
/// e.g. Node.js, Python/Django, Go, Ruby on Rails, etc.
class CustomBackendAuthRepository implements AuthRepository {
  
  // Change your base URL here
  final String _baseUrl = 'https://api.yourcustomserver.com/v1';

  @override
  Future<UserModel> login(LoginRequest request) async {
    // 1. Specify your endpoint
    final url = Uri.parse('$_baseUrl/auth/signin'); // ← Change me

    // 2. Make the request
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      // 3. Map the fields to what your specific server expects
      body: jsonEncode({
        'user_email': request.email,     // Server expects 'user_email' instead of 'email'
        'user_password': request.password, 
      }),
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final data = jsonDecode(response.body);
      
      // 4. Map the server response back to the standard UserModel
      return UserModel(
        id: data['id']?.toString() ?? '',
        email: data['user_email'] ?? '',
        name: data['full_name'] ?? '',
        token: data['access_token'] ?? '',
      );
    } else {
      throw Exception('Failed to login: ${response.body}');
    }
  }

  @override
  Future<UserModel> register(RegisterRequest request) async {
    // 1. Specify your endpoint
    final url = Uri.parse('$_baseUrl/auth/signup'); // ← Change me

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'full_name': request.name,
        'user_email': request.email,
        'user_password': request.password,
      }),
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final data = jsonDecode(response.body);
      
      return UserModel(
        id: data['id']?.toString() ?? '',
        email: data['user_email'] ?? '',
        name: data['full_name'] ?? '',
        token: data['access_token'] ?? '',
      );
    } else {
      throw Exception('Failed to register: ${response.body}');
    }
  }

  @override
  Future<void> logout() async {
    // Optional: Hit a custom logout endpoint if required
    // await http.post(Uri.parse('$_baseUrl/auth/logout'));
  }
}
