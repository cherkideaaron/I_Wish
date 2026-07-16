# Backend Setup Guide (Supabase, Firebase, Appwrite)

This guide explains what you need to do in the **consoles** of Supabase, Firebase, or Appwrite to prepare them to connect with this Flutter app. Once configured in the console, you will replace the mocked `AuthRepositoryImpl` with the specific SDK implementations.

---

## 1. Supabase (Recommended for relational data & simplicity)

Supabase provides a Postgres database with built-in Auth and real-time features.

### Console Instructions:
1. **Create Project**: Go to [database.new](https://database.new) and create a new project.
2. **Get Credentials**: Once the project is provisioned, go to **Project Settings > API**.
   - Copy the `Project URL` (this becomes your `Env.baseUrl`).
   - Copy the `anon` `public` key.
3. **Configure Auth Providers**: Go to **Authentication > Providers**.
   - Email/Password is enabled by default.
   - You can disable "Confirm email" if you want users to log in immediately without verifying their email first (useful for quick dev testing).
4. **App Integration**:
   - Add `supabase_flutter` to your `pubspec.yaml`.
   - Initialize it in `main.dart` with your URL and Anon Key.
   - Replace the `api_client.dart` calls in `AuthRepositoryImpl` with `Supabase.instance.client.auth.signInWithPassword(...)`.

---

## 2. Firebase (Classic NoSQL & comprehensive toolset)

Firebase is Google's massive suite. Great for NoSQL (Firestore) and comprehensive analytics.

### Console Instructions:
1. **Create Project**: Go to the [Firebase Console](https://console.firebase.google.com/) and create a project.
2. **Register App**: Click the Flutter icon (or Android/iOS icons) on the project overview page to register your app.
   - For Android, you need your package name (found in `android/app/build.gradle`).
   - For iOS, your bundle ID (found in Xcode).
3. **Download Config**: Download the `google-services.json` (Android) and `GoogleService-Info.plist` (iOS) and place them in the correct folders, OR use the `flutterfire_cli` to auto-configure everything (highly recommended).
4. **Enable Auth**: Go to **Authentication > Sign-in method** and enable **Email/Password**.
5. **App Integration**:
   - Add `firebase_core` and `firebase_auth` to `pubspec.yaml`.
   - Run `firebase_options.dart` generation via FlutterFire CLI.
   - In `main.dart`, call `Firebase.initializeApp()`.
   - Update `AuthRepositoryImpl` to use `FirebaseAuth.instance.signInWithEmailAndPassword(...)`.

---

## 3. Appwrite (Open-source Firebase alternative)

Appwrite is an open-source backend-as-a-service that you can self-host or use via their cloud.

### Console Instructions:
1. **Create Project**: Go to [Appwrite Cloud](https://cloud.appwrite.io/) (or your self-hosted instance) and create a project.
2. **Register Platform**: Click "Add Platform" and choose Flutter.
   - Enter your App Name and Package Name (e.g., `com.example.iwish`).
3. **Get Credentials**: Go to **Settings**.
   - Copy your `Project ID` and the `API Endpoint` (usually `https://cloud.appwrite.io/v1`).
4. **App Integration**:
   - Add `appwrite` to your `pubspec.yaml`.
   - Initialize the `Client` in your Dart code:
     ```dart
     Client client = Client()
         .setEndpoint('https://cloud.appwrite.io/v1')
         .setProject('YOUR_PROJECT_ID');
     ```
   - Pass this client to an `Account` service object.
   - Update `AuthRepositoryImpl` to use `account.createEmailSession(email: email, password: password)`.

---

## What to change in the Flutter code for any of these:

Because we used the **Repository Pattern**, swapping the backend is incredibly clean:

1. You **do not** touch the UI screens (`login_screen.dart`, etc.).
2. You **do not** touch `auth_provider.dart`.
3. You **only** rewrite `AuthRepositoryImpl` to use the SDK (Supabase/Firebase/Appwrite) instead of `ApiClient`, or you create a new class (e.g., `FirebaseAuthRepository implements AuthRepository`) and inject it in `auth_repository_provider.dart`.
