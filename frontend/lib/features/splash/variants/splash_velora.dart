// splash_velora.dart
//
// SplashVelora — a soft, neumorphic premium splash screen variant.
//
// Features:
// • Warm neumorphic base (soft dual-shadow "pressed/embossed" surfaces)
// • Breathing (subtle pulse) embossed logo disc
// • Staggered letter-by-letter title reveal + fade-in tagline
// • Neumorphic "pressed" progress bar that fills as the timer elapses
// • Auto-navigates to LoginScreen() after ~3s via a soft fade+slide transition
//
// Drop this file into your project as `splash_velora.dart`.
// Assumes `LoginScreen()` is already defined/imported elsewhere.

import 'package:flutter/material.dart';

import '../../auth/login/login_screen.dart';

class SplashVelora extends StatefulWidget {
  const SplashVelora({super.key});

  @override
  State<SplashVelora> createState() => _SplashVeloraState();
}

class _SplashVeloraState extends State<SplashVelora>
    with TickerProviderStateMixin {
  static const _base = Color(0xFFF1EDE9); // warm off-white
  static const _accent = Color(0xFFB8845B); // warm terracotta
  static const _ink = Color(0xFF3E362F); // soft dark ink

  static const _title = 'VELORA';
  static const _totalDuration = Duration(milliseconds: 3000);

  late final AnimationController _entranceController; // 0 -> 1 over 3s
  late final AnimationController _breatheController; // looping pulse

  late final Animation<double> _diskScale;
  late final Animation<double> _diskFade;

  @override
  void initState() {
    super.initState();

    _entranceController = AnimationController(
      vsync: this,
      duration: _totalDuration,
    )..forward();

    _breatheController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);

    _diskScale = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 0.6, end: 1.05)
            .chain(CurveTween(curve: Curves.easeOutBack)),
        weight: 65,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 1.05, end: 1.0)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 35,
      ),
    ]).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.0, 0.45, curve: Curves.linear),
      ),
    );

    _diskFade = CurvedAnimation(
      parent: _entranceController,
      curve: const Interval(0.0, 0.3, curve: Curves.easeOut),
    );

    Future.delayed(_totalDuration, _goToLogin);
  }

  void _goToLogin() {
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 650),
        pageBuilder: (context, animation, secondaryAnimation) =>
            const LoginScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final fade = CurvedAnimation(parent: animation, curve: Curves.easeInOut);
          final slide = Tween<Offset>(
            begin: const Offset(0, 0.04),
            end: Offset.zero,
          ).animate(fade);
          return FadeTransition(
            opacity: fade,
            child: SlideTransition(position: slide, child: child),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _entranceController.dispose();
    _breatheController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _base,
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(flex: 3),

            // Logo disc: entrance scale/fade + continuous gentle breathing
            AnimatedBuilder(
              animation: Listenable.merge([_entranceController, _breatheController]),
              builder: (context, child) {
                final breathe = 1.0 + (_breatheController.value * 0.03);
                final settled = _entranceController.value >= 0.45;
                final scale = settled ? breathe : _diskScale.value;
                return Opacity(
                  opacity: _diskFade.value.clamp(0.0, 1.0),
                  child: Transform.scale(scale: scale, child: child),
                );
              },
              child: const _NeumorphicDisc(
                base: _base,
                accent: _accent,
                ink: _ink,
              ),
            ),

            const SizedBox(height: 40),

            // Letter-by-letter title reveal
            _StaggeredTitle(
              text: _title,
              controller: _entranceController,
              startInterval: 0.32,
              endInterval: 0.68,
              color: _ink,
            ),

            const SizedBox(height: 12),

            // Tagline fade
            FadeTransition(
              opacity: CurvedAnimation(
                parent: _entranceController,
                curve: const Interval(0.55, 0.85, curve: Curves.easeOut),
              ),
              child: Text(
                'CRAFTED WITH INTENTION',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 3,
                  color: _ink.withOpacity(0.45),
                ),
              ),
            ),

            const Spacer(flex: 3),

            // Neumorphic pressed progress bar, fills over the full duration
            FadeTransition(
              opacity: CurvedAnimation(
                parent: _entranceController,
                curve: const Interval(0.5, 0.7, curve: Curves.easeOut),
              ),
              child: _NeumorphicProgressBar(
                controller: _entranceController,
                base: _base,
                accent: _accent,
              ),
            ),

            const SizedBox(height: 56),
          ],
        ),
      ),
    );
  }
}

/// A soft neumorphic circular disc housing the logo icon, with an
/// embossed inner ring for extra tactility.
class _NeumorphicDisc extends StatelessWidget {
  final Color base;
  final Color accent;
  final Color ink;

  const _NeumorphicDisc({
    required this.base,
    required this.accent,
    required this.ink,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 132,
      height: 132,
      decoration: BoxDecoration(
        color: base,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.white.withOpacity(0.9),
            offset: const Offset(-8, -8),
            blurRadius: 18,
          ),
          BoxShadow(
            color: ink.withOpacity(0.18),
            offset: const Offset(10, 10),
            blurRadius: 22,
          ),
        ],
      ),
      alignment: Alignment.center,
      child: Container(
        width: 92,
        height: 92,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: base,
          boxShadow: [
            BoxShadow(
              color: ink.withOpacity(0.12),
              offset: const Offset(3, 3),
              blurRadius: 6,
              spreadRadius: -2,
            ),
            BoxShadow(
              color: Colors.white.withOpacity(0.8),
              offset: const Offset(-3, -3),
              blurRadius: 6,
              spreadRadius: -2,
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Icon(
          Icons.spa_rounded,
          size: 40,
          color: accent,
        ),
      ),
    );
  }
}

/// Reveals [text] one letter at a time, each with its own fade + rise,
/// staggered across the interval [startInterval, endInterval] of [controller].
class _StaggeredTitle extends StatelessWidget {
  final String text;
  final AnimationController controller;
  final double startInterval;
  final double endInterval;
  final Color color;

  const _StaggeredTitle({
    required this.text,
    required this.controller,
    required this.startInterval,
    required this.endInterval,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final letters = text.split('');
    final span = endInterval - startInterval;
    final perLetter = span / letters.length;

    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(letters.length, (i) {
            final start = startInterval + (perLetter * i);
            final end = (start + perLetter * 1.6).clamp(0.0, 1.0);
            final curved = CurvedAnimation(
              parent: controller,
              curve: Interval(start, end, curve: Curves.easeOutCubic),
            );
            final opacity = curved.value.clamp(0.0, 1.0);
            final dy = (1 - opacity) * 10;

            return Transform.translate(
              offset: Offset(0, dy),
              child: Opacity(
                opacity: opacity,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 1.5),
                  child: Text(
                    letters[i],
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 2,
                      color: color,
                    ),
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}

/// A neumorphic "pressed" track with an embossed fill that grows
/// in sync with [controller]'s progress.
class _NeumorphicProgressBar extends StatelessWidget {
  final AnimationController controller;
  final Color base;
  final Color accent;

  const _NeumorphicProgressBar({
    required this.controller,
    required this.base,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      height: 10,
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: base,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.white.withOpacity(0.85),
            offset: const Offset(-2, -2),
            blurRadius: 4,
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            offset: const Offset(2, 2),
            blurRadius: 4,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: AnimatedBuilder(
          animation: controller,
          builder: (context, _) {
            return Align(
              alignment: Alignment.centerLeft,
              child: FractionallySizedBox(
                widthFactor: controller.value.clamp(0.0, 1.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    gradient: LinearGradient(
                      colors: [accent.withOpacity(0.85), accent],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}