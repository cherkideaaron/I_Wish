import 'package:cloud_firestore/cloud_firestore.dart';

/// Template for interacting with Firebase Cloud Firestore (NoSQL).
/// 
/// HOW TO CALL THIS FROM YOUR SCREENS:
///   1. Create a Riverpod provider for this repository:
///      `final firebaseDbProvider = Provider((ref) => FirebaseDatabaseRepository());`
///   2. Create a FutureProvider or AsyncNotifier in your `features/` folder.
///   3. `ref.watch` that state provider in your UI!
class FirebaseDatabaseRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // The name of your collection in Firestore
  final String collectionName = 'wishes'; 

  /// Fetch a list of items for a specific user
  Future<List<Map<String, dynamic>>> getWishes(String userId) async {
    try {
      final snapshot = await _firestore
          .collection(collectionName)
          .where('user_id', isEqualTo: userId)
          .orderBy('created_at', descending: true)
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id; // Inject the document ID
        return data;
      }).toList();
    } catch (e) {
      throw Exception('Failed to load wishes: $e');
    }
  }

  /// Create a new item in the database
  Future<void> createWish({
    required String title,
    required String userId,
    String? description,
  }) async {
    try {
      await _firestore.collection(collectionName).add({
        'title': title,
        'description': description,
        'user_id': userId,
        'created_at': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to create wish: $e');
    }
  }

  /// Delete an item
  Future<void> deleteWish(String wishId) async {
    try {
      await _firestore.collection(collectionName).doc(wishId).delete();
    } catch (e) {
      throw Exception('Failed to delete wish: $e');
    }
  }
}
