import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../config/env.dart';
import '../constants/api_endpoints.dart';
import '../storage/storage_provider.dart';

/// Provides a configured [Dio] instance for the entire app.
///
/// Features:
///   - Base URL from [Env.baseUrl]
///   - 15-second timeouts
///   - Auth interceptor: auto-attaches Bearer token from secure storage
///   - Logging interceptor in dev builds only
final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: ApiEndpoints.baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      sendTimeout: const Duration(seconds: 15),
      headers: const {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );

  // ─── Auth Interceptor ──────────────────────────────────────────────
  // Reads the token from secure storage on every request.
  // This means you never need to restart the app after login.
  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await ref.read(storageServiceProvider).getToken();
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        handler.next(options);
      },
    ),
  );

  // ─── Logging Interceptor (dev only) ───────────────────────────────
  if (Env.enableLogs) {
    dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        requestHeader: false,
        responseHeader: false,
        error: true,
        logPrint: (o) => debugPrint('[DIO] $o'),
      ),
    );
  }

  return dio;
});
