lib/
├── main.dart
├── app.dart                          # MaterialApp.router, theme, ProviderScope wiring
│
├── config/
│   └── env.dart                      # dev/prod base URLs, flags
│
├── core/
│   ├── constants/
│   │   ├── app_colors.dart
│   │   ├── app_strings.dart
│   │   ├── app_dimensions.dart
│   │   └── api_endpoints.dart
│   ├── theme/
│   │   ├── app_theme.dart
│   │   └── text_styles.dart
│   ├── router/
│   │   ├── app_router.dart           # GoRouter instance + all routes
│   │   └── route_names.dart          # route path constants
│   ├── network/
│   │   ├── api_client.dart           # Dio instance, base config
│   │   ├── api_exceptions.dart
│   │   └── dio_provider.dart         # riverpod provider exposing Dio
│   ├── utils/
│   │   ├── validators.dart
│   │   ├── extensions.dart
│   │   └── formatters.dart
│   └── widgets/                      # generic, non-variant helpers
│       ├── loading_indicator.dart
│       └── error_view.dart
│
├── data/
│   ├── models/
│   │   ├── user_model.dart
│   │   └── ...
│   ├── repositories/
│   │   ├── auth_repository.dart
│   │   └── ...
│   └── providers/
│       ├── auth_repository_provider.dart
│       └── ...
│
├── features/
│   ├── splash/
│   │   ├── splash_screen.dart        # picks active variant, nothing else
│   │   └── variants/
│   │       ├── splash_fade_logo.dart
│   │       ├── splash_animated.dart
│   │       └── splash_lottie.dart
│   │
│   ├── auth/
│   │   ├── login/
│   │   │   ├── login_screen.dart
│   │   │   └── variants/
│   │   │       ├── login_classic.dart
│   │   │       ├── login_social.dart
│   │   │       └── login_minimal.dart
│   │   ├── register/
│   │   │   ├── register_screen.dart
│   │   │   └── variants/
│   │   │       ├── register_classic.dart
│   │   │       └── register_stepper.dart
│   │   └── providers/
│   │       └── auth_provider.dart    # riverpod StateNotifier for auth state
│   │
│   └── home/
│       ├── home_screen.dart
│       └── providers/
│           └── home_provider.dart
│
├── shared/
│   └── widgets/
│       ├── navigation/
│       │   ├── bottom_nav/
│       │   │   ├── bottom_nav_v1.dart
│       │   │   └── bottom_nav_v2.dart
│       │   └── drawer/
│       │       ├── drawer_v1.dart
│       │       └── drawer_v2.dart
│       ├── cards/
│       │   ├── card_v1.dart
│       │   └── card_v2.dart
│       ├── buttons/
│       │   ├── primary_button.dart
│       │   └── outline_button.dart
│       └── toasts/
│           └── app_toast.dart        # one call site, swap impl inside
│
└── test/                             # keep, add tests later