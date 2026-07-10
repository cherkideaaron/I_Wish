import 'package:appwrite/appwrite.dart';

/// Template for interacting with Appwrite Databases (NoSQL).
///
/// HOW TO SET UP:
///   1. In Appwrite Console → Databases → Create a Database
///   2. Inside the database, create a Collection called "wishes"
///   3. Add attributes: title (string), description (string), user_id (string)
///   4. In the Collection → Settings → Permissions, allow users to read/create their docs
///   5. Paste the database ID and collection ID below
class AppwriteDatabaseRepository {
  // ─── Configuration ────────────────────────────────────────────────────────
  static const String _endpoint = 'https://156.67.26.89/v1';
  static const String _projectId = '6a4f84e0002c6f50e59a';
  static const String _databaseId = 'YOUR_DATABASE_ID'; // ← Paste here
  static const String _wishesCollectionId = 'YOUR_COLLECTION_ID'; // ← Paste here
  // ─────────────────────────────────────────────────────────────────────────

  late final Databases _databases;

  AppwriteDatabaseRepository() {
    final client = Client()
      ..setEndpoint(_endpoint)
      ..setProject(_projectId)
      ..setSelfSigned(status: true);
    _databases = Databases(client);
  }

  /// Fetch all wishes for a specific user
  Future<List<Map<String, dynamic>>> getWishes(String userId) async {
    try {
      final result = await _databases.listDocuments(
        databaseId: _databaseId,
        collectionId: _wishesCollectionId,
        queries: [Query.equal('user_id', userId)],
      );

      return result.documents.map((doc) {
        final data = Map<String, dynamic>.from(doc.data);
        data['id'] = doc.$id; // Inject document ID
        return data;
      }).toList();
    } on AppwriteException catch (e) {
      throw Exception('Failed to load wishes: ${e.message}');
    }
  }

  /// Create a new wish document
  Future<void> createWish({
    required String title,
    required String userId,
    String? description,
  }) async {
    try {
      await _databases.createDocument(
        databaseId: _databaseId,
        collectionId: _wishesCollectionId,
        documentId: ID.unique(),
        data: {
          'title': title,
          'description': description ?? '',
          'user_id': userId,
        },
      );
    } on AppwriteException catch (e) {
      throw Exception('Failed to create wish: ${e.message}');
    }
  }

  /// Delete a wish document
  Future<void> deleteWish(String wishId) async {
    try {
      await _databases.deleteDocument(
        databaseId: _databaseId,
        collectionId: _wishesCollectionId,
        documentId: wishId,
      );
    } on AppwriteException catch (e) {
      throw Exception('Failed to delete wish: ${e.message}');
    }
  }
}
