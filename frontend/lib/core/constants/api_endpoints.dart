import '../config/env.dart';

/// All REST API endpoint paths.
///
/// Usage:
///   final url = ApiEndpoints.baseUrl + ApiEndpoints.login;
///
/// If your API has a version prefix (e.g. /api/v1) add it here,
/// not inside each path string.
class ApiEndpoints {
  ApiEndpoints._();

  static String get baseUrl => Env.baseUrl;

  // ─── Auth ──────────────────────────────────────────
  static const String login = '/login';
  static const String register = '/register';
  static const String logout = '/auth/logout';
  static const String refreshToken = '/auth/refresh';

  // ─── User ──────────────────────────────────────────
  static const String profile = '/user/profile';
}
