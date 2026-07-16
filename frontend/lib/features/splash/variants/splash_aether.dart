// splash_aether.dart
// SplashAether - Minimalist Luminous Typography with Soft Neumorphism & Shimmer

import 'package:flutter/material.dart';
import 'dart:async';
import '../../auth/login/login_screen.dart';

class SplashAether extends StatefulWidget {
  const SplashAether({super.key});

  @override
  State<SplashAether> createState() => _SplashAetherState();
}

class _SplashAetherState extends State<SplashAether>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;
  late Animation<double> _shimmerAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 2400),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.7, curve: Curves.easeOut),
      ),
    );

    _slideAnimation = Tween<double>(begin: 40.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.2, 0.9, curve: Curves.easeOutCubic),
      ),
    );

    _shimmerAnimation = Tween<double>(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _controller.forward();

    // Auto navigate after 3 seconds
    Timer(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const LoginScreen(),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0F172A), // Slate dark
              Color(0xFF1E2937),
              Color(0xFF334155),
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo with soft neumorphism
                AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(0, _slideAnimation.value),
                      child: Opacity(
                        opacity: _fadeAnimation.value,
                        child: Container(
                          width: 132,
                          height: 132,
                          decoration: BoxDecoration(
                            color: const Color(0xFF1E2937),
                            shape: BoxShape.circle,
                            boxShadow: [
                              // Neumorphic highlight
                              BoxShadow(
                                color: Colors.white.withOpacity(0.08),
                                blurRadius: 20,
                                offset: const Offset(-8, -8),
                              ),
                              // Neumorphic shadow
                              BoxShadow(
                                color: Colors.black.withOpacity(0.6),
                                blurRadius: 20,
                                offset: const Offset(8, 8),
                              ),
                            ],
                            border: Border.all(
                              color: Colors.white.withOpacity(0.1),
                              width: 1,
                            ),
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.star_rounded,
                              size: 72,
                              color: Color(0xFF60A5FA),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 48),

                // Main Title with shimmer
                AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return ShaderMask(
                      shaderCallback: (Rect bounds) {
                        return LinearGradient(
                          colors: const [
                            Colors.white,
                            Color(0xFF60A5FA),
                            Colors.white,
                          ],
                          stops: [
                            0.0,
                            _shimmerAnimation.value.clamp(0.0, 1.0),
                            1.0
                          ],
                          begin: const Alignment(-1.0, -0.3),
                          end: const Alignment(2.0, 0.3),
                        ).createShader(bounds);
                      },
                      child: const Text(
                        "AETHER",
                        style: TextStyle(
                          fontSize: 58,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 8,
                          color: Colors.white,
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 12),

                // Subtitle with staggered fade
                AnimatedBuilder(
                  animation: _fadeAnimation,
                  builder: (context, child) {
                    return Opacity(
                      opacity: _fadeAnimation.value,
                      child: const Text(
                        "ELEVATE • INSPIRE • TRANSCEND",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          letterSpacing: 4.5,
                          color: Color(0xFF94A3B8),
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 80),

                // Subtle loading indicator
                AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return Opacity(
                      opacity: _fadeAnimation.value * 0.6,
                      child: SizedBox(
                        width: 28,
                        height: 28,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            Color(0xFF60A5FA),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}