import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Wraps [FlutterSecureStorage] for all token and session persistence.
///
/// Use this class for ANYTHING you need to persist securely across app restarts:
///   - JWT access token
///   - Refresh token
///   - User ID
///
/// Do NOT store sensitive data in SharedPreferences or plain local storage.
class StorageService {
  final FlutterSecureStorage _storage;

  // Storage keys — keep them private to avoid typos across the codebase.
  static const _keyToken = 'auth_token';
  static const _keyUserId = 'user_id';
  static const _keyRefreshToken = 'refresh_token';

  StorageService({FlutterSecureStorage? storage})
    : _storage =
          storage ??
          const FlutterSecureStorage(
            // Windows: uses Windows Credential Manager (no extra setup)
            // Android: uses EncryptedSharedPreferences
            // iOS/macOS: uses Keychain
            wOptions: WindowsOptions(),
            aOptions: AndroidOptions(),
          );

  // ─── Auth Token ──────────────────────────────────────────────────
  Future<void> saveToken(String token) =>
      _storage.write(key: _keyToken, value: token);

  Future<String?> getToken() => _storage.read(key: _keyToken);

  Future<void> deleteToken() => _storage.delete(key: _keyToken);

  // ─── Refresh Token ───────────────────────────────────────────────
  Future<void> saveRefreshToken(String token) =>
      _storage.write(key: _keyRefreshToken, value: token);

  Future<String?> getRefreshToken() => _storage.read(key: _keyRefreshToken);

  // ─── User ID ─────────────────────────────────────────────────────
  Future<void> saveUserId(String id) =>
      _storage.write(key: _keyUserId, value: id);

  Future<String?> getUserId() => _storage.read(key: _keyUserId);

  // ─── Clear (Logout) ──────────────────────────────────────────────
  /// Wipes ALL secure storage — call on logout.
  Future<void> clearAll() => _storage.deleteAll();
}
