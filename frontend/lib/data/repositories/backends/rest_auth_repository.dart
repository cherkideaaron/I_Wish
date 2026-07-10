import '../auth_repository.dart';
import '../../models/user_model.dart';
import '../../models/auth_request_model.dart';
import '../../../core/network/api_client.dart';
import '../../../core/constants/api_endpoints.dart';

/// Concrete REST implementation of [AuthRepository].
/// Uses standard HTTP requests via Dio.
class RestAuthRepository implements AuthRepository {
  final ApiClient _client;

  const RestAuthRepository(this._client);

  @override
  Future<UserModel> login(LoginRequest request) async {
    final data = await _client.post(ApiEndpoints.login, data: request.toJson());
    return UserModel.fromJson(data as Map<String, dynamic>);
  }

  @override
  Future<UserModel> register(RegisterRequest request) async {
    final data = await _client.post(
      ApiEndpoints.register,
      data: request.toJson(),
    );
    return UserModel.fromJson(data as Map<String, dynamic>);
  }

  @override
  Future<void> logout() async {
    // Optional: notify the server to invalidate the token.
    // await _client.post(ApiEndpoints.logout);
  }
}
