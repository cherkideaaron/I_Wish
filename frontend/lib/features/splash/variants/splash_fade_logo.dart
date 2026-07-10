import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../auth/providers/auth_provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/router/route_names.dart';

/// VARIANT A — Fade-in Logo
///
/// Shows the app icon and name fading in, then navigates based on auth state.
///
/// To switch to Variant B, open splash_screen.dart and swap the import.
class SplashFadeLogoScreen extends ConsumerStatefulWidget {
  const SplashFadeLogoScreen({super.key});

  @override
  ConsumerState<SplashFadeLogoScreen> createState() =>
      _SplashFadeLogoScreenState();
}

class _SplashFadeLogoScreenState extends ConsumerState<SplashFadeLogoScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _opacity;
  bool _navigated = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _opacity = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _navigate(bool isLoggedIn) {
    if (_navigated || !mounted) return;
    _navigated = true;
    // Small delay so the animation finishes before navigating.
    Future.delayed(const Duration(milliseconds: 600), () {
      if (!mounted) return;
      context.go(isLoggedIn ? RouteNames.home : RouteNames.login);
    });
  }

  @override
  Widget build(BuildContext context) {
    // Listen to auth state; once it resolves (not loading), navigate.
    ref.listen(authProvider, (_, next) {
      next.whenOrNull(data: (user) => _navigate(user != null));
    });

    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: FadeTransition(
          opacity: _opacity,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: const Icon(
                  Icons.star_rounded,
                  size: 56,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                AppStrings.appName,
                style: const TextStyle(
                  fontSize: 38,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                AppStrings.tagline,
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.white.withValues(alpha: 0.75),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
