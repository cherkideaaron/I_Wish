import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../auth/providers/auth_provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/router/route_names.dart';

/// VARIANT B — Slide-up Text
///
/// App name slides up from the bottom while the background transitions from
/// primary → dark. Good for apps with a bold typographic identity.
///
/// To use this variant, open splash_screen.dart and swap the import.
class SplashSlideInScreen extends ConsumerStatefulWidget {
  const SplashSlideInScreen({super.key});

  @override
  ConsumerState<SplashSlideInScreen> createState() =>
      _SplashSlideInScreenState();
}

class _SplashSlideInScreenState extends ConsumerState<SplashSlideInScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _slide;
  late final Animation<double> _fade;
  bool _navigated = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.6),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _fade = Tween<double>(
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
    Future.delayed(const Duration(milliseconds: 500), () {
      if (!mounted) return;
      context.go(isLoggedIn ? RouteNames.home : RouteNames.login);
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(authProvider, (_, next) {
      next.whenOrNull(data: (user) => _navigate(user != null));
    });

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.primaryDark,
              AppColors.primary,
              Color(0xFF6B48FF),
            ],
          ),
        ),
        child: Center(
          child: SlideTransition(
            position: _slide,
            child: FadeTransition(
              opacity: _fade,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.star_rounded, size: 72, color: Colors.white),
                  const SizedBox(height: 16),
                  Text(
                    AppStrings.appName.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 42,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      letterSpacing: 6,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    AppStrings.tagline,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withValues(alpha: 0.7),
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
