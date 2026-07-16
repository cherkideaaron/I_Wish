// splash_orbit.dart
//
// SplashOrbit — a kinetic, geometric premium splash screen variant.
//
// Features:
// • Multiple concentric rings rotating independently (custom painter)
// • Particle dots riding along the ring paths
// • Pulsing core logo mark (scale + glow breathing)
// • Staggered entrance: rings sweep in, core pulses in, title/tagline
//   fade+track in, thin progress line fills
// • Auto-navigates to LoginScreen() after ~3s via a radial-wipe transition
//
// Drop this file into your project as `splash_orbit.dart`.
// Assumes `LoginScreen()` is already defined/imported elsewhere.

import 'dart:math' as math;
import 'package:flutter/material.dart';

import '../../auth/login/login_screen.dart';

class SplashOrbit extends StatefulWidget {
  const SplashOrbit({super.key});

  @override
  State<SplashOrbit> createState() => _SplashOrbitState();
}

class _SplashOrbitState extends State<SplashOrbit>
    with TickerProviderStateMixin {
  static const _bg = Color(0xFF060709);
  static const _accent = Color(0xFF2DE0C9); // electric teal
  static const _accent2 = Color(0xFF6C7CFF); // secondary violet-blue

  static const _totalDuration = Duration(milliseconds: 3000);

  late final AnimationController _entranceController; // 0 -> 1 over 3s
  late final AnimationController _orbitController; // continuous rotation
  late final AnimationController _pulseController; // core breathing

  late final Animation<double> _ringsIn; // 0 -> 0.5
  late final Animation<double> _coreScale;
  late final Animation<double> _coreFade;
  late final Animation<double> _titleFade;
  late final Animation<double> _progress;

  @override
  void initState() {
    super.initState();

    _entranceController = AnimationController(
      vsync: this,
      duration: _totalDuration,
    )..forward();

    _orbitController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);

    _ringsIn = CurvedAnimation(
      parent: _entranceController,
      curve: const Interval(0.0, 0.5, curve: Curves.easeOutCubic),
    );

    _coreScale = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 0.3, end: 1.1)
            .chain(CurveTween(curve: Curves.easeOutBack)),
        weight: 70,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 1.1, end: 1.0)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 30,
      ),
    ]).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.15, 0.55, curve: Curves.linear),
      ),
    );

    _coreFade = CurvedAnimation(
      parent: _entranceController,
      curve: const Interval(0.15, 0.4, curve: Curves.easeOut),
    );

    _titleFade = CurvedAnimation(
      parent: _entranceController,
      curve: const Interval(0.5, 0.8, curve: Curves.easeOut),
    );

    _progress = CurvedAnimation(
      parent: _entranceController,
      curve: const Interval(0.55, 1.0, curve: Curves.linear),
    );

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
          return AnimatedBuilder(
            animation: animation,
            builder: (context, _) {
              return ClipPath(
                clipper: _RadialWipeClipper(progress: animation.value),
                child: child,
              );
            },
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _entranceController.dispose();
    _orbitController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: _bg,
      body: Stack(
        alignment: Alignment.center,
        children: [
          // Faint radial glow behind everything
          Container(
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.center,
                radius: 0.9,
                colors: [Color(0xFF10131A), _bg],
              ),
            ),
          ),

          // Orbit rings + particles
          Center(
            child: SizedBox(
              width: size.width * 0.85,
              height: size.width * 0.85,
              child: AnimatedBuilder(
                animation: Listenable.merge(
                    [_orbitController, _entranceController]),
                builder: (context, _) {
                  return CustomPaint(
                    painter: _OrbitPainter(
                      progress: _orbitController.value,
                      entrance: _ringsIn.value,
                      accent: _accent,
                      accent2: _accent2,
                    ),
                  );
                },
              ),
            ),
          ),

          // Core logo mark
          AnimatedBuilder(
            animation: Listenable.merge(
                [_entranceController, _pulseController]),
            builder: (context, child) {
              final breathe = _entranceController.value >= 0.55
                  ? 1.0 + (_pulseController.value * 0.06)
                  : 1.0;
              return Opacity(
                opacity: _coreFade.value.clamp(0.0, 1.0),
                child: Transform.scale(
                  scale: _coreScale.value * breathe,
                  child: child,
                ),
              );
            },
            child: Container(
              width: 74,
              height: 74,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _bg,
                border: Border.all(color: _accent, width: 1.4),
                boxShadow: [
                  BoxShadow(
                    color: _accent.withOpacity(0.55),
                    blurRadius: 24,
                    spreadRadius: 1,
                  ),
                ],
              ),
              alignment: Alignment.center,
              child: const Icon(
                Icons.hexagon_outlined,
                color: _accent,
                size: 32,
              ),
            ),
          ),

          // Bottom content: title, tagline, progress line
          Positioned(
            bottom: 64,
            left: 0,
            right: 0,
            child: FadeTransition(
              opacity: _titleFade,
              child: Column(
                children: [
                  const Text(
                    'O R B I T',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 6,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'PRECISION IN MOTION',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.4),
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 3,
                    ),
                  ),
                  const SizedBox(height: 28),
                  AnimatedBuilder(
                    animation: _progress,
                    builder: (context, _) {
                      return _ProgressLine(
                        value: _progress.value,
                        accent: _accent,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Paints 3 concentric dashed/solid rings at independent rotation speeds,
/// each carrying a small particle dot, sweeping in via [entrance] (0->1).
class _OrbitPainter extends CustomPainter {
  final double progress; // continuous 0..1 loop
  final double entrance; // 0..1 one-shot sweep-in
  final Color accent;
  final Color accent2;

  _OrbitPainter({
    required this.progress,
    required this.entrance,
    required this.accent,
    required this.accent2,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final maxRadius = size.width / 2;

    final ringsConfig = [
      // radiusFactor, speedMultiplier, color, strokeWidth, sweep(true=partial arc)
      (0.98, 1.0, accent.withOpacity(0.35), 1.0, true),
      (0.74, -1.6, accent2.withOpacity(0.3), 1.0, true),
      (0.50, 2.1, accent.withOpacity(0.45), 1.2, false),
    ];

    for (final ring in ringsConfig) {
      final radius = maxRadius * ring.$1 * entrance;
      if (radius <= 0) continue;

      final paint = Paint()
        ..color = ring.$3
        ..style = PaintingStyle.stroke
        ..strokeWidth = ring.$4;

      final rect = Rect.fromCircle(center: center, radius: radius);
      final rotation = progress * 2 * math.pi * ring.$2;

      if (ring.$5) {
        // Partial arc ring (270°) rotating
        canvas.drawArc(
          rect,
          rotation,
          math.pi * 1.5 * entrance,
          false,
          paint,
        );
      } else {
        // Full faint ring
        canvas.drawCircle(center, radius, paint..color = ring.$3.withOpacity(ring.$3.opacity * 0.5));
      }

      // Particle dot riding the ring
      final dotAngle = rotation + (ring.$2 > 0 ? 0 : math.pi);
      final dotOffset = Offset(
        center.dx + radius * math.cos(dotAngle),
        center.dy + radius * math.sin(dotAngle),
      );
      final dotPaint = Paint()..color = ring.$3.withOpacity(1.0);
      canvas.drawCircle(dotOffset, 3.2, dotPaint);
      // Glow behind the dot
      canvas.drawCircle(
        dotOffset,
        7,
        Paint()
          ..color = ring.$3.withOpacity(0.35)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _OrbitPainter oldDelegate) => true;
}

/// A thin horizontal line that fills left-to-right as [value] goes 0->1,
/// with a bright leading tip.
class _ProgressLine extends StatelessWidget {
  final double value;
  final Color accent;

  const _ProgressLine({required this.value, required this.accent});

  @override
  Widget build(BuildContext context) {
    const width = 120.0;
    return SizedBox(
      width: width,
      height: 6,
      child: Stack(
        children: [
          Container(
            height: 1,
            margin: const EdgeInsets.only(top: 2.5),
            color: Colors.white.withOpacity(0.12),
          ),
          Positioned(
            left: 0,
            child: Container(
              width: width * value.clamp(0.0, 1.0),
              height: 1,
              color: accent,
            ),
          ),
          Positioned(
            left: (width * value.clamp(0.0, 1.0)) - 3,
            child: Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: accent,
                boxShadow: [
                  BoxShadow(
                    color: accent.withOpacity(0.8),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Clips a circular "iris wipe" that expands from the center outward,
/// used as the exit transition into LoginScreen().
class _RadialWipeClipper extends CustomClipper<Path> {
  final double progress; // 0..1

  _RadialWipeClipper({required this.progress});

  @override
  Path getClip(Size size) {
    final center = size.center(Offset.zero);
    final maxRadius = size.longestSide * 0.75;
    final radius = maxRadius * Curves.easeInOutCubic.transform(progress);
    return Path()
      ..addOval(Rect.fromCircle(center: center, radius: radius));
  }

  @override
  bool shouldReclip(covariant _RadialWipeClipper oldClipper) =>
      oldClipper.progress != progress;
}