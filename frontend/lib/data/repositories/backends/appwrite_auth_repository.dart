import '../auth_repository.dart';
import '../../models/user_model.dart';
import '../../models/auth_request_model.dart';

// TODO: Run `flutter pub add appwrite` and uncomment:
// import 'package:appwrite/appwrite.dart';
// import 'package:appwrite/models.dart' as appwrite_models;

/// Concrete Appwrite implementation of [AuthRepository].
class AppwriteAuthRepository implements AuthRepository {
  // final Account _account;
  // const AppwriteAuthRepository(this._account);

  @override
  Future<UserModel> login(LoginRequest request) async {
    /*
    // In Appwrite, you create an email session to log in
    await _account.createEmailPasswordSession(
      email: request.email,
      password: request.password,
    );
    
    // Then get the currently logged in user info
    final user = await _account.get();
    
    return UserModel(
      id: user.$id,
      email: user.email,
      name: user.name,
      // Appwrite manages tokens automatically in the SDK via cookies/local storage.
      // We pass a dummy token if the app architecture strictly requires it.
      token: 'appwrite_managed_token', 
    );
    */
    throw UnimplementedError('Appwrite login not yet wired up');
  }

  @override
  Future<UserModel> register(RegisterRequest request) async {
    /*
    // 1. Create the user
    final user = await _account.create(
      userId: ID.unique(),
      email: request.email,
      password: request.password,
      name: request.name,
    );
    
    // 2. Automatically log them in after registration
    await _account.createEmailPasswordSession(
      email: request.email,
      password: request.password,
    );
    
    return UserModel(
      id: user.$id,
      email: user.email,
      name: user.name,
      token: 'appwrite_managed_token',
    );
    */
    throw UnimplementedError('Appwrite register not yet wired up');
  }

  @override
  Future<void> logout() async {
    // Delete the current session
    // await _account.deleteSession(sessionId: 'current');
  }
}
