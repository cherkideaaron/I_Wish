import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Template for interacting with Supabase Storage (Buckets).
///
/// HOW TO CALL THIS:
/// Similar to the Database, create a provider for this repository, 
/// and call it from a Notifier when you want to upload a file (e.g., a profile picture).
class SupabaseStorageRepository {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Change this to the name of your storage bucket in Supabase
  final String bucketName = 'avatars'; 

  /// Uploads a file and returns the public URL
  Future<String> uploadFile({
    required File file,
    required String fileName,
  }) async {
    // 1. Upload the file to the bucket
    await _supabase.storage.from(bucketName).upload(
          fileName,
          file,
          fileOptions: const FileOptions(cacheControl: '3600', upsert: true),
        );

    // 2. Get the public URL to save in the database or display in UI
    final publicUrl = _supabase.storage.from(bucketName).getPublicUrl(fileName);
    
    return publicUrl;
  }

  /// Deletes a file from the bucket
  Future<void> deleteFile(String fileName) async {
    await _supabase.storage.from(bucketName).remove([fileName]);
  }
}
