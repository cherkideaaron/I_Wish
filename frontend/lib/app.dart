import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/constants/app_strings.dart';

/// Root application widget.
/// Reads the router from Riverpod so auth state changes can trigger
/// navigation (via ref.listen inside screens).
class IWishApp extends ConsumerWidget {
  const IWishApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: AppStrings.appName,
      debugShowCheckedModeBanner: false,

      // ─── Theme ──────────────────────────────────────────────────────
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,

      // ─── Router ─────────────────────────────────────────────────────
      routerConfig: appRouter,
    );
  }
}
