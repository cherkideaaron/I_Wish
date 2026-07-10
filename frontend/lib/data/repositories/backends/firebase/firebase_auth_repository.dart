import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../auth_repository.dart';
import '../../../models/user_model.dart';
import '../../../models/auth_request_model.dart';

/// Firebase Implementation of AuthRepository.
///
/// This handles:
/// 1. Signing in/up via Firebase Authentication.
/// 2. Saving/Fetching user roles in Firestore (`users` collection).
class FirebaseAuthRepository implements AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<UserModel> login(LoginRequest request) async {
    try {
      final response = await _auth.signInWithEmailAndPassword(
        email: request.email,
        password: request.password,
      );
      final user = response.user;
      if (user == null) throw Exception('Login failed');

      // Fetch role & metadata from Firestore
      final doc = await _firestore.collection('users').doc(user.uid).get();
      final data = doc.data() ?? {};

      return UserModel(
        id: user.uid,
        email: user.email ?? '',
        name: data['name'] ?? user.displayName ?? '',
        token: await user.getIdToken() ?? '',
        role: data['role'] ?? 'user',
      );
    } on FirebaseAuthException catch (e) {
      throw Exception(_mapFirebaseError(e.code));
    } catch (e) {
      throw Exception('An unexpected error occurred.');
    }
  }

  @override
  Future<UserModel> register(RegisterRequest request) async {
    try {
      final response = await _auth.createUserWithEmailAndPassword(
        email: request.email,
        password: request.password,
      );
      final user = response.user;
      if (user == null) throw Exception('Registration failed');

      await user.updateDisplayName(request.name);

      // Save profile and default 'user' role to Firestore
      await _firestore.collection('users').doc(user.uid).set({
        'name': request.name,
        'email': request.email,
        'role': 'user',
        'created_at': FieldValue.serverTimestamp(),
      });

      return UserModel(
        id: user.uid,
        email: user.email ?? '',
        name: request.name,
        token: await user.getIdToken() ?? '',
        role: 'user',
      );
    } on FirebaseAuthException catch (e) {
      throw Exception(_mapFirebaseError(e.code));
    } catch (e) {
      throw Exception('An unexpected error occurred.');
    }
  }

  String _mapFirebaseError(String code) {
    switch (code) {
      case 'user-not-found':
      case 'invalid-credential':
      case 'wrong-password':
        return 'Incorrect email or password. Please try again.';
      case 'email-already-in-use':
        return 'An account already exists for that email.';
      case 'invalid-email':
        return 'Please provide a valid email address.';
      case 'weak-password':
        return 'Your password is too weak. Please use a stronger one.';
      case 'network-request-failed':
        return 'Network error. Please check your internet connection.';
      default:
        return 'Authentication failed. Please try again later.';
    }
  }

  @override
  Future<void> logout() async {
    await _auth.signOut();
  }
}
