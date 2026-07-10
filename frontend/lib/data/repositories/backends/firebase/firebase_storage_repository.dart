import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

/// Template for handling file uploads (images, PDFs, etc.) to Firebase Storage.
class FirebaseStorageRepository {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  /// Uploads a file and returns the public download URL
  Future<String> uploadAvatar(File file, String userId) async {
    try {
      // 1. Create a reference to the location you want to upload to
      // Example: avatars/123e4567-e89b-12d3.jpg
      final extension = file.path.split('.').last;
      final ref = _storage.ref().child('avatars').child('$userId.$extension');

      // 2. Upload the file
      final uploadTask = await ref.putFile(file);

      // 3. Get the public URL to save in your database
      final downloadUrl = await uploadTask.ref.getDownloadURL();
      return downloadUrl;
      
    } catch (e) {
      throw Exception('Failed to upload file: $e');
    }
  }
}
