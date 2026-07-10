import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repositories/auth_repository.dart';
// import '../../core/network/api_client.dart';

// ─── Backend Implementations ──────────────────────────────────────────────────
// import '../repositories/backends/rest_auth_repository.dart';
// import '../repositories/backends/supabase/supabase_auth_repository.dart';
// import '../repositories/backends/firebase/firebase_auth_repository.dart';
import '../repositories/backends/appwrite/appwrite_auth_repository.dart';
// import '../repositories/backends/custom_auth_repository.dart';

// ┌─────────────────────────────────────────────────────────────────────────┐
// │  BACKEND SELECTOR                                                       │
// │                                                                         │
// │  HOW TO SWITCH BACKENDS:                                                │
// │    1. Uncomment the import for your backend above.                      │
// │    2. Change the return statement below to use that repository.         │
// │    3. The rest of the app (UI, State) doesn't need to change at all!    │
// └─────────────────────────────────────────────────────────────────────────┘
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  
  // 1. DEFAULT REST API (Using Dio ApiClient)
  // return RestAuthRepository(ref.watch(apiClientProvider));

  // 2. SUPABASE (Requires `supabase_flutter` package)
  // return SupabaseAuthRepository();

  // 3. FIREBASE (Requires `firebase_core` & `firebase_auth` packages)
  // return FirebaseAuthRepository();

  // 4. APPWRITE (Requires `appwrite` package)
  return AppwriteAuthRepository();

  // 5. CUSTOM BACKEND (Template for any random API/Language)
  // return CustomBackendAuthRepository();
});
