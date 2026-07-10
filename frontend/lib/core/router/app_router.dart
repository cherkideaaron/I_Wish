import 'package:go_router/go_router.dart';
import '../../features/splash/splash_screen.dart';
import '../../features/auth/login/login_screen.dart';
import '../../features/auth/register/register_screen.dart';
import '../../features/home/home_screen.dart';
import 'route_names.dart';

/// Application router.
///
/// Navigation is handled explicitly inside each screen using GoRouter:
///   context.go(RouteNames.home)    — replaces current history
///   context.push(RouteNames.register) — pushes onto history (back-navigable)
///   context.pop()                  — goes back
///
/// Auth redirect flow (see each screen for implementation):
///   Splash        → reads auth state → navigates to /login or /home
///   Login/Register → on success → context.go(RouteNames.home)
///   Home          → on logout   → context.go(RouteNames.login)
final appRouter = GoRouter(
  initialLocation: RouteNames.splash,
  routes: [
    GoRoute(
      path: RouteNames.splash,
      name: 'splash',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: RouteNames.login,
      name: 'login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: RouteNames.register,
      name: 'register',
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: RouteNames.home,
      name: 'home',
      builder: (context, state) => const HomeScreen(),
    ),
  ],
);
