# I Wish — Flutter Template Guide

> This README lives at `lib/README.md`.  
> It explains **folder structure**, **how to swap screen variants**, and the **complete data-flow** from form → API → UI.

---

## 📁 Folder Structure

```
lib/
├── main.dart                    ← App entry point (ProviderScope → IWishApp)
├── app.dart                     ← MaterialApp.router with theme & router config
│
├── config/                      ← ⚠️  DEPRECATED — moved to core/config/
│
├── core/                        ← Framework-level code (NOT feature-specific)
│   ├── config/
│   │   └── env.dart             ← Base URL & environment flags (dart-define)
│   ├── constants/
│   │   ├── api_endpoints.dart   ← All API paths (/login, /register, etc.)
│   │   ├── app_colors.dart      ← Brand color palette
│   │   ├── app_dimensions.dart  ← Spacing, radius, button height, etc.
│   │   └── app_strings.dart     ← ALL user-visible strings (no hardcoding)
│   ├── network/
│   │   ├── api_client.dart      ← Thin Dio wrapper (get/post/put/delete)
│   │   ├── api_exceptions.dart  ← ApiException — unified error type
│   │   └── dio_provider.dart    ← Riverpod Provider<Dio> with interceptors
│   ├── router/
│   │   ├── app_router.dart      ← GoRouter config (all 4 routes)
│   │   └── route_names.dart     ← Route path constants ('/login', '/home', …)
│   ├── storage/
│   │   ├── storage_service.dart ← flutter_secure_storage wrapper (tokens)
│   │   └── storage_provider.dart← Riverpod Provider<StorageService>
│   ├── theme/
│   │   ├── app_theme.dart       ← Light & dark ThemeData
│   │   └── text_styles.dart     ← Named TextStyle constants
│   ├── utils/
│   │   ├── extensions.dart      ← BuildContext & String extensions
│   │   ├── formatters.dart      ← TextInputFormatter helpers
│   │   └── validators.dart      ← Form field validators
│   └── widgets/
│       ├── error_view.dart      ← AppErrorView (icon + message + retry)
│       └── loading_indicator.dart← AppLoadingIndicator (centered spinner)
│
├── data/                        ← Data layer (models + repositories + providers)
│   ├── models/
│   │   ├── auth_request_model.dart ← LoginRequest / RegisterRequest DTOs
│   │   └── user_model.dart         ← UserModel (id, name, email, token)
│   ├── providers/
│   │   └── auth_repository_provider.dart ← Provider<AuthRepository>
│   └── repositories/
│       └── auth_repository.dart    ← Abstract + Impl (calls ApiClient)
│
├── features/                    ← Feature-first UI code
│   ├── auth/
│   │   ├── providers/
│   │   │   └── auth_provider.dart  ← AuthNotifier (THE auth state)
│   │   ├── login/
│   │   │   ├── login_screen.dart   ← Barrel (swap variant here)
│   │   │   └── variants/
│   │   │       ├── login_classic.dart  ← Variant A: centered card
│   │   │       └── login_split.dart   ← Variant B: split panel
│   │   └── register/
│   │       ├── register_screen.dart  ← Barrel (swap variant here)
│   │       └── variants/
│   │           ├── register_classic.dart ← Variant A: single page
│   │           └── register_stepper.dart ← Variant B: 2-step form
│   ├── home/
│   │   ├── home_screen.dart     ← Authenticated home (replace with your content)
│   │   └── providers/
│   │       └── home_provider.dart   ← currentUserProvider
│   └── splash/
│       ├── splash_screen.dart   ← Barrel (swap variant here)
│       └── variants/
│           ├── splash_fade_logo.dart ← Variant A: fade-in logo
│           └── splash_slide_in.dart  ← Variant B: slide-up text + gradient
│
└── shared/                      ← Reusable widgets used across features
    └── widgets/
        ├── buttons/
        │   └── app_button.dart  ← Primary button with loading state
        └── cards/
            └── app_text_field.dart ← Styled TextFormField wrapper
```

---

## 🔄 Switching Screen Variants

Each screen has a **barrel file** that is the only thing the router imports.  
The barrel delegates to one variant. **You only change one line.**

### Example — switching the login screen

Open [`lib/features/auth/login/login_screen.dart`](features/auth/login/login_screen.dart):

```dart
// Before (Variant A — classic card):
import 'variants/login_classic.dart';
// import 'variants/login_split.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) => const LoginClassicScreen(); // ← A
  // Widget build(BuildContext context) => const LoginSplitScreen(); // ← B
}

// After (Variant B — split panel):
// import 'variants/login_classic.dart';
import 'variants/login_split.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) => const LoginSplitScreen(); // ← B
}
```

The router, auth provider, and everything else **stays untouched**.  
Same pattern for `splash_screen.dart` and `register_screen.dart`.

### Variant Quick Reference

| Screen    | Barrel file              | Variant A               | Variant B                         |
|-----------|--------------------------|-------------------------|-----------------------------------|
| Splash    | `splash/splash_screen.dart`    | `SplashFadeLogoScreen` — fade-in logo | `SplashSlideInScreen` — slide-up text + gradient |
| Login     | `auth/login/login_screen.dart`   | `LoginClassicScreen` — centered card  | `LoginSplitScreen` — branding panel + form |
| Register  | `auth/register/register_screen.dart` | `RegisterClassicScreen` — one-page form | `RegisterStepperScreen` — 2-step wizard |

---

## 🌐 Setting the API Base URL

The base URL lives in [`core/config/env.dart`](core/config/env.dart) and is injected at build time.

```bash
# Development (default: Android emulator localhost)
flutter run

# Specific local server
flutter run --dart-define=BASE_URL=http://192.168.1.10:8000

# Production build
flutter build apk \
  --dart-define=BASE_URL=https://api.myapp.com \
  --dart-define=PRODUCTION=true
```

> For iOS simulator change the default in `env.dart` to `http://127.0.0.1:8000`.

---

## 🔀 Data Flow — Step-by-Step

This section traces exactly what happens when a user fills the login form and taps **"Sign In"**.  
Use this as your debugging map.

### Login flow

```
User taps "Sign In"
│
▼ 1. LoginClassicScreen._submit()          [login_classic.dart]
│     Validates the form (Validators.email, Validators.password)
│     Calls: ref.read(authProvider.notifier).login(email, password)
│
▼ 2. AuthNotifier.login()                  [auth_provider.dart]
│     Sets state = AsyncLoading()          ← spinner appears in UI
│     Creates LoginRequest { email, password }
│     Calls: authRepositoryProvider.login(request)
│
▼ 3. AuthRepositoryImpl.login()            [auth_repository.dart]
│     Creates the request payload: request.toJson()
│     Calls: _client.post('/login', data: { email, password })
│
▼ 4. ApiClient.post()                      [api_client.dart]
│     Calls: _dio.post(baseUrl + '/login', data: {...})
│     Catches DioException → throws ApiException
│
▼ 5. Dio (HTTP layer)                      [dio_provider.dart]
│     Auth interceptor attaches Bearer token (if any)
│     Sends: POST https://api.example.com/login
│              Body: { "email": "...", "password": "..." }
│
│                ← Server responds:
│              200 OK  { "id": "1", "name": "Jane", "email": "...", "token": "..." }
│          or  401     { "message": "Invalid credentials" }
│
▼ 6. Back up: ApiClient receives Dio response
│     Returns response.data (the Map)
│
▼ 7. Back in AuthRepositoryImpl
│     UserModel.fromJson(data)  ← parses JSON into UserModel
│     Returns UserModel
│
▼ 8. Back in AuthNotifier
│     Saves token: storageService.saveToken(user.token)
│     Sets state = AsyncData(user)
│
▼ 9. LoginClassicScreen reacts via ref.listen(authProvider, ...)
│     on AsyncData(user ≠ null)  → context.go(RouteNames.home)
│     on AsyncError(e, _)        → context.showSnackbar(e.message, isError: true)
│
▼ 10. HomeScreen renders
       ref.watch(currentUserProvider)  ← reads user from auth state
       Displays: "Welcome, Jane!"
```

### Register flow

Identical to login, except:
- Step 1: `RegisterClassicScreen` (or `RegisterStepperScreen`) collects name + email + password
- Step 3: `AuthRepositoryImpl.register()` calls `POST /register` with `{ name, email, password }`
- Step 8: Same — saves token and sets `AsyncData(user)`

### Logout flow

```
User taps logout icon in HomeScreen
│
▼ ref.read(authProvider.notifier).logout()    [home_screen.dart]
│
▼ AuthNotifier.logout()                       [auth_provider.dart]
│   storageService.clearAll()   ← wipes token from secure storage
│   state = AsyncData(null)     ← user is now null
│
▼ HomeScreen detects null user → context.go(RouteNames.login)
```

### Auto-login on cold start

```
App starts → ProviderScope initializes → AuthNotifier.build() runs
│
▼ storageService.getToken()   ← reads from flutter_secure_storage
│
│  Token found?
│   Yes → state = AsyncData(UserModel with token)  → Splash navigates to /home
│   No  → state = AsyncData(null)                  → Splash navigates to /login
```

---

## 🐛 Debugging Guide

| Symptom | Where to look |
|---|---|
| Wrong base URL | `core/config/env.dart` → check `defaultValue` or your `--dart-define` |
| Request not reaching server | `core/network/dio_provider.dart` → LogInterceptor prints `[DIO]` lines in debug console |
| Auth header missing | `dio_provider.dart` → auth interceptor calls `storageService.getToken()` |
| JSON parse error | `data/models/user_model.dart` → check field names match your API response |
| 401 Unauthorized | `api_exceptions.dart` `_fallbackMessage` → `ApiException.message` shown via snackbar |
| Form not submitting | Form key `.validate()` returned false → check validator logic in `core/utils/validators.dart` |
| Screen not navigating after login | `auth_provider.dart` `login()` → check `state` in DevTools; `login_classic.dart` `ref.listen` |
| Token not persisted | `storage_service.dart` `saveToken()` → on Windows check Credential Manager |

---

## ➕ Adding a New Feature

1. Create `lib/features/<feature_name>/`
2. Add a `<feature_name>_screen.dart` (barrel pattern is optional but recommended)
3. If the feature needs state: add `providers/<feature_name>_provider.dart`
4. If the feature needs API calls: add a model in `data/models/`, a repository in `data/repositories/`, and its provider in `data/providers/`
5. Add the route to `core/router/app_router.dart` and `core/router/route_names.dart`
