import 'package:dio/dio.dart';

/// Unified error type thrown by [ApiClient].
///
/// Instead of catching raw [DioException] everywhere in your app,
/// all network errors are converted to [ApiException] so your business
/// logic only ever deals with one error type.
class ApiException implements Exception {
  final int? statusCode;
  final String message;
  final dynamic body; // raw response body for debugging

  const ApiException({this.statusCode, required this.message, this.body});

  /// Converts a [DioException] to a user-friendly [ApiException].
  factory ApiException.fromDio(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const ApiException(
          message: 'Request timed out. Check your connection and try again.',
        );
      case DioExceptionType.connectionError:
        return const ApiException(message: 'No internet connection.');
      case DioExceptionType.badResponse:
        final code = e.response?.statusCode;
        final body = e.response?.data;
        final msg = _extractMessage(body) ?? _fallbackMessage(code);
        return ApiException(statusCode: code, message: msg, body: body);
      case DioExceptionType.cancel:
        return const ApiException(message: 'Request was cancelled.');
      default:
        return ApiException(
          message: e.message ?? 'An unexpected error occurred.',
        );
    }
  }

  /// Tries to extract a human-readable message from common API response shapes.
  /// Extend this for your own API's error format.
  static String? _extractMessage(dynamic body) {
    if (body is Map<String, dynamic>) {
      // Common patterns: { "message": "..." } | { "error": "..." } | { "detail": "..." }
      return (body['message'] ?? body['error'] ?? body['detail'])?.toString();
    }
    return null;
  }

  static String _fallbackMessage(int? code) => switch (code) {
    400 => 'Bad request.',
    401 => 'Invalid credentials.',
    403 => "You don't have permission to do that.",
    404 => 'Resource not found.',
    409 => 'A conflict occurred (e.g. email already in use).',
    422 => 'Validation failed. Check your input.',
    429 => 'Too many requests. Please slow down.',
    500 => 'Server error. Please try again later.',
    502 => 'Bad gateway. The server may be down.',
    _ => 'Something went wrong (HTTP $code).',
  };

  @override
  String toString() => 'ApiException($statusCode): $message';
}
