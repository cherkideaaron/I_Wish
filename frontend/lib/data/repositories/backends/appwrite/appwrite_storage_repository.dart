import 'dart:io';
import 'package:appwrite/appwrite.dart';

/// Template for uploading/downloading files via Appwrite Storage.
///
/// HOW TO SET UP:
///   1. In Appwrite Console → Storage → Create a Bucket (e.g. "avatars")
///   2. In the Bucket → Settings → Permissions, allow users to create files
///   3. Paste your Bucket ID below
class AppwriteStorageRepository {
  // ─── Configuration ────────────────────────────────────────────────────────
  static const String _endpoint = 'https://156.67.26.89/v1';
  static const String _projectId = '6a4f84e0002c6f50e59a';
  static const String _avatarBucketId = 'YOUR_BUCKET_ID'; // ← Paste here
  // ─────────────────────────────────────────────────────────────────────────

  late final Storage _storage;
  late final Client _client;

  AppwriteStorageRepository() {
    _client = Client()
      ..setEndpoint(_endpoint)
      ..setProject(_projectId)
      ..setSelfSigned(status: true);
    _storage = Storage(_client);
  }

  /// Uploads a file to the avatars bucket and returns the public view URL
  Future<String> uploadAvatar(File file, String userId) async {
    try {
      final result = await _storage.createFile(
        bucketId: _avatarBucketId,
        fileId: userId, // Use the user ID so it always overwrites the same file
        file: InputFile.fromPath(path: file.path),
      );

      // Build the public URL to this file
      final url = '$_endpoint/storage/buckets/$_avatarBucketId/files/${result.$id}/view'
          '?project=$_projectId';
      return url;
    } on AppwriteException catch (e) {
      throw Exception('Failed to upload avatar: ${e.message}');
    }
  }

  /// Delete a file from storage
  Future<void> deleteFile(String fileId) async {
    try {
      await _storage.deleteFile(
        bucketId: _avatarBucketId,
        fileId: fileId,
      );
    } on AppwriteException catch (e) {
      throw Exception('Failed to delete file: ${e.message}');
    }
  }
}
