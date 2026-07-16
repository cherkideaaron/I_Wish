// splash_aurora.dart
//
// SplashAurora — a premium, animated splash screen variant.
//
// Features:
// • Living aurora gradient background (slow animated color drift)
// • Floating soft-blur glow orbs for depth
// • Glassmorphic logo card with border glow
// • Staggered entrance animation: scale + fade + slide for logo,
//   delayed fade+slide for title & tagline, and a fading progress indicator
// • Auto-navigates to LoginScreen() after animation completes (~3s)
//   using a smooth custom fade+scale page transition
//
// Drop this file into your project as `splash_aurora.dart`.
// Assumes `LoginScreen()` is already defined/imported elsewhere.

import 'dart:ui';
import 'package:flutter/material.dart';

import '../../auth/login/login_screen.dart';

class SplashAurora extends StatefulWidget {
  const SplashAurora({super.key});

  @override
  State<SplashAurora> createState() => _SplashAuroraState();
}

class _SplashAuroraState extends State<SplashAurora>
    with TickerProviderStateMixin {
  // Master controller for the entrance choreography.
  late final AnimationController _entranceController;

  // Slow, looping controller for the ambient background drift.
  late final AnimationController _bgController;

  // --- Staggered animations (all derived from _entranceController) ---
  late final Animation<double> _logoScale;
  late final Animation<double> _logoFade;
  late final Animation<double> _logoRotate;

  late final Animation<Offset> _titleSlide;
  late final Animation<double> _titleFade;

  late final Animation<Offset> _taglineSlide;
  late final Animation<double> _taglineFade;

  late final Animation<double> _loaderFade;

  static const _totalDuration = Duration(milliseconds: 3000);

  @override
  void initState() {
    super.initState();

    _bgController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat(reverse: true);

    _entranceController = AnimationController(
      vsync: this,
      duration: _totalDuration,
    );

    // Logo: scale + fade + gentle rotation settle — 0% -> 55%
    _logoScale = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 0.4, end: 1.08)
            .chain(CurveTween(curve: Curves.easeOutBack)),
        weight: 70,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 1.08, end: 1.0)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 30,
      ),
    ]).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.0, 0.55, curve: Curves.linear),
      ),
    );

    _logoFade = CurvedAnimation(
      parent: _entranceController,
      curve: const Interval(0.0, 0.35, curve: Curves.easeOut),
    );

    _logoRotate = Tween<double>(begin: -0.15, end: 0.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.0, 0.55, curve: Curves.easeOutCubic),
      ),
    );

    // Title: slide up + fade — 30% -> 65%
    _titleSlide = Tween<Offset>(
      begin: const Offset(0, 0.4),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.30, 0.65, curve: Curves.easeOutCubic),
      ),
    );
    _titleFade = CurvedAnimation(
      parent: _entranceController,
      curve: const Interval(0.30, 0.65, curve: Curves.easeOut),
    );

    // Tagline: slide up + fade — 45% -> 80%
    _taglineSlide = Tween<Offset>(
      begin: const Offset(0, 0.4),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.45, 0.80, curve: Curves.easeOutCubic),
      ),
    );
    _taglineFade = CurvedAnimation(
      parent: _entranceController,
      curve: const Interval(0.45, 0.80, curve: Curves.easeOut),
    );

    // Loader: fades in last — 65% -> 100%
    _loaderFade = CurvedAnimation(
      parent: _entranceController,
      curve: const Interval(0.65, 1.0, curve: Curves.easeOut),
    );

    _entranceController.forward();

    // Navigate after the full duration.
    Future.delayed(_totalDuration, _goToLogin);
  }

  void _goToLogin() {
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 700),
        pageBuilder: (context, animation, secondaryAnimation) =>
            const LoginScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final fade = CurvedAnimation(
            parent: animation,
            curve: Curves.easeInOut,
          );
          final scale = Tween<double>(begin: 1.04, end: 1.0).animate(fade);
          return FadeTransition(
            opacity: fade,
            child: ScaleTransition(scale: scale, child: child),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _entranceController.dispose();
    _bgController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFF0B0A18),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // ---------- Animated aurora gradient background ----------
          AnimatedBuilder(
            animation: _bgController,
            builder: (context, _) {
              final t = _bgController.value;
              return Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment(-1 + t * 0.4, -1 + t * 0.2),
                    end: Alignment(1 - t * 0.3, 1 - t * 0.4),
                    colors: const [
                      Color(0xFF0B0A18), // near-black navy
                      Color(0xFF1B1035), // deep violet
                      Color(0xFF3A1358), // plum
                      Color(0xFF6A1B9A), // magenta-violet
                    ],
                    stops: const [0.0, 0.35, 0.7, 1.0],
                  ),
                ),
              );
            },
          ),

          // ---------- Floating glow orbs (depth) ----------
          AnimatedBuilder(
            animation: _bgController,
            builder: (context, _) {
              final t = _bgController.value;
              return Stack(
                children: [
                  Positioned(
                    top: -80 + (t * 30),
                    left: -60 + (t * 20),
                    child: _glowOrb(
                      size: size.width * 0.7,
                      color: const Color(0xFF8E24AA).withOpacity(0.35),
                    ),
                  ),
                  Positioned(
                    bottom: -100 - (t * 20),
                    right: -70 - (t * 15),
                    child: _glowOrb(
                      size: size.width * 0.8,
                      color: const Color(0xFF3F51B5).withOpacity(0.30),
                    ),
                  ),
                  Positioned(
                    top: size.height * 0.35 + (t * 15),
                    right: -40,
                    child: _glowOrb(
                      size: size.width * 0.45,
                      color: const Color(0xFFEC4899).withOpacity(0.22),
                    ),
                  ),
                ],
              );
            },
          ),

          // Subtle vignette for contrast/focus.
          Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.center,
                radius: 1.1,
                colors: [
                  Colors.transparent,
                  const Color(0xFF0B0A18).withOpacity(0.55),
                ],
                stops: const [0.5, 1.0],
              ),
            ),
          ),

          // ---------- Foreground content ----------
          SafeArea(
            child: Column(
              children: [
                const Spacer(flex: 3),

                // Logo card (glassmorphism)
                AnimatedBuilder(
                  animation: _entranceController,
                  builder: (context, child) {
                    return Opacity(
                      opacity: _logoFade.value.clamp(0.0, 1.0),
                      child: Transform.rotate(
                        angle: _logoRotate.value,
                        child: Transform.scale(
                          scale: _logoScale.value,
                          child: child,
                        ),
                      ),
                    );
                  },
                  child: _GlassLogoCard(),
                ),

                const SizedBox(height: 36),

                // Title
                ClipRect(
                  child: AnimatedBuilder(
                    animation: _entranceController,
                    builder: (context, child) {
                      return FadeTransition(
                        opacity: _titleFade,
                        child: SlideTransition(
                          position: _titleSlide,
                          child: child,
                        ),
                      );
                    },
                    child: ShaderMask(
                      shaderCallback: (bounds) => const LinearGradient(
                        colors: [
                          Color(0xFFF8F8FF),
                          Color(0xFFE0C3FC),
                        ],
                      ).createShader(bounds),
                      child: const Text(
                        'AURORA',
                        style: TextStyle(
                          fontSize: 34,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 8,
                          color: Colors.white,
                          height: 1.1,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                // Tagline
                ClipRect(
                  child: AnimatedBuilder(
                    animation: _entranceController,
                    builder: (context, child) {
                      return FadeTransition(
                        opacity: _taglineFade,
                        child: SlideTransition(
                          position: _taglineSlide,
                          child: child,
                        ),
                      );
                    },
                    child: Text(
                      'DESIGNED FOR THE FUTURE',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 4,
                        color: Colors.white.withOpacity(0.55),
                      ),
                    ),
                  ),
                ),

                const Spacer(flex: 3),

                // Loader
                FadeTransition(
                  opacity: _loaderFade,
                  child: const _PulsingLoader(),
                ),

                const SizedBox(height: 48),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _glowOrb({required double size, required Color color}) {
    return ClipOval(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [color, color.withOpacity(0.0)],
            ),
          ),
        ),
      ),
    );
  }
}

/// Frosted-glass card housing the app logo/icon, with a soft glowing border.
class _GlassLogoCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 128,
      height: 128,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF9C27B0).withOpacity(0.45),
            blurRadius: 40,
            spreadRadius: 2,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(32),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withOpacity(0.18),
                  Colors.white.withOpacity(0.05),
                ],
              ),
              border: Border.all(
                color: Colors.white.withOpacity(0.35),
                width: 1.2,
              ),
            ),
            alignment: Alignment.center,
            child: ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(
                colors: [Color(0xFFE0C3FC), Color(0xFF8EC5FC)],
              ).createShader(bounds),
              child: const Icon(
                Icons.auto_awesome_rounded,
                size: 56,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// A minimal, elegant pulsing-dot loader used at the bottom of the splash.
class _PulsingLoader extends StatefulWidget {
  const _PulsingLoader();

  @override
  State<_PulsingLoader> createState() => _PulsingLoaderState();
}

class _PulsingLoaderState extends State<_PulsingLoader>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 10,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(3, (i) {
              final t = (_controller.value - (i * 0.2)) % 1.0;
              final scale = 0.6 + 0.5 * (1 - (t - 0.5).abs() * 2).clamp(0.0, 1.0);
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Transform.scale(
                  scale: scale,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.85),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFE0C3FC).withOpacity(0.6),
                          blurRadius: 8,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          );
        },
      ),
    );
  }
}