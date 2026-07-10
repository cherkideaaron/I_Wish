import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'api_exceptions.dart';
import 'dio_provider.dart';

/// Thin Dio wrapper that:
///   1. Provides typed helper methods (get, post, put, delete).
///   2. Catches [DioException] and rethrows as [ApiException].
///
/// Repositories inject [ApiClient] and call these methods directly.
/// They never touch Dio or handle [DioException].
class ApiClient {
  final Dio _dio;

  const ApiClient(this._dio);

  Future<dynamic> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final res = await _dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
      );
      return res.data;
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  Future<dynamic> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final res = await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return res.data;
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  Future<dynamic> put(String path, {dynamic data, Options? options}) async {
    try {
      final res = await _dio.put(path, data: data, options: options);
      return res.data;
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  Future<dynamic> delete(String path, {Options? options}) async {
    try {
      final res = await _dio.delete(path, options: options);
      return res.data;
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }
}

/// Riverpod provider for [ApiClient].
final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient(ref.watch(dioProvider));
});
