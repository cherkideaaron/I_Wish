import 'dart:ui';
import 'package:flutter/material.dart';

import '../../auth/login/login_screen.dart';

/// =====================================================================
/// VARIANT: "AURORA GLASS"
/// -----------------------------------------------------------------------
/// A premium splash experience built around a layered gradient-mesh
/// background, frosted glassmorphic surfaces, and a staggered logo
/// entrance animation driven by a single AnimationController.
/// Beneath the logo block sits a horizontally scrollable row of 4
/// glass "capability" cards — ideal for a big-company / SaaS template
/// where the brand wants to tease its core value props before login.
///
/// Auto-navigates to LoginScreen() 3 seconds after launch, with a
/// smooth cross-fade transition.
/// =====================================================================
class AuroraGlassSplashScreen extends StatefulWidget {
  const AuroraGlassSplashScreen({super.key});

  @override
  State<AuroraGlassSplashScreen> createState() =>
      _AuroraGlassSplashScreenState();
}

class _AuroraGlassSplashScreenState extends State<AuroraGlassSplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _bgController;
  late final AnimationController _introController;

  late final Animation<double> _logoScale;
  late final Animation<double> _logoFade;
  late final Animation<double> _titleFade;
  late final Animation<Offset> _titleSlide;
  late final Animation<double> _taglineFade;
  late final Animation<double> _cardsFade;
  late final Animation<Offset> _cardsSlide;

  static const List<_FeatureCardData> _features = [
    _FeatureCardData(
      icon: Icons.shield_outlined,
      title: 'Enterprise Security',
      subtitle: 'Bank-grade encryption on every transaction.',
    ),
    _FeatureCardData(
      icon: Icons.insights_outlined,
      title: 'Real-Time Analytics',
      subtitle: 'Live dashboards that turn data into decisions.',
    ),
    _FeatureCardData(
      icon: Icons.public_outlined,
      title: 'Global Infrastructure',
      subtitle: 'Consistent performance across 40+ regions.',
    ),
    _FeatureCardData(
      icon: Icons.headset_mic_outlined,
      title: 'Premium Support',
      subtitle: 'A dedicated team, available around the clock.',
    ),
  ];

  @override
  void initState() {
    super.initState();

    _bgController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat(reverse: true);

    _introController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    );

    _logoScale = CurvedAnimation(
      parent: _introController,
      curve: const Interval(0.0, 0.5, curve: Curves.easeOutBack),
    );

    _logoFade = CurvedAnimation(
      parent: _introController,
      curve: const Interval(0.0, 0.4, curve: Curves.easeIn),
    );

    _titleFade = CurvedAnimation(
      parent: _introController,
      curve: const Interval(0.3, 0.65, curve: Curves.easeIn),
    );

    _titleSlide = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _introController,
      curve: const Interval(0.3, 0.65, curve: Curves.easeOutCubic),
    ));

    _taglineFade = CurvedAnimation(
      parent: _introController,
      curve: const Interval(0.5, 0.8, curve: Curves.easeIn),
    );

    _cardsFade = CurvedAnimation(
      parent: _introController,
      curve: const Interval(0.6, 1.0, curve: Curves.easeIn),
    );
    

    _cardsSlide = Tween<Offset>(
      begin: const Offset(0, 0.4),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _introController,
      curve: const Interval(0.6, 1.0, curve: Curves.easeOutCubic),
    ));

    _introController.forward();

    Future.delayed(const Duration(milliseconds: 3000), () {
      if (mounted) _goToLogin();
    });
  }

  void _goToLogin() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 600),
        pageBuilder: (_, animation, __) => const LoginScreen(),
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(
            opacity: CurvedAnimation(parent: animation, curve: Curves.easeInOut),
            child: child,
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _bgController.dispose();
    _introController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          _buildBackground(size),
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 12),
                Expanded(flex: 5, child: Center(child: _buildLogoBlock())),
                Expanded(flex: 4, child: _buildFeatureCards()),
                _buildProgressFooter(),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------
  // Background: gradient mesh + drifting blurred orbs
  // ---------------------------------------------------------------------
  Widget _buildBackground(Size size) {
    return AnimatedBuilder(
      animation: _bgController,
      builder: (context, child) {
        final t = _bgController.value;
        return Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF0B0F24),
                Color(0xFF1C1F3E),
                Color(0xFF2E1A47),
              ],
              stops: [0.0, 0.55, 1.0],
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                top: -80 + (t * 40),
                left: -60,
                child: _blurOrb(220, const Color(0xFF6C63FF).withOpacity(0.35)),
              ),
              Positioned(
                bottom: -100 - (t * 30),
                right: -80,
                child: _blurOrb(260, const Color(0xFF00E5C7).withOpacity(0.25)),
              ),
              Positioned(
                top: size.height * 0.35 + (t * 20),
                right: -50,
                child: _blurOrb(160, const Color(0xFFB967FF).withOpacity(0.2)),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _blurOrb(double diameter, Color color) {
    return ClipOval(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 80, sigmaY: 80),
        child: Container(
          width: diameter,
          height: diameter,
          decoration: BoxDecoration(shape: BoxShape.circle, color: color),
        ),
      ),
    );
  }

  

  // ---------------------------------------------------------------------
  // Logo + wordmark + tagline
  // ---------------------------------------------------------------------
  Widget _buildLogoBlock() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ScaleTransition(
          scale: _logoScale,
          child: FadeTransition(opacity: _logoFade, child: _buildGlassLogo()),
        ),
        const SizedBox(height: 28),
        SlideTransition(
          position: _titleSlide,
          child: FadeTransition(
            opacity: _titleFade,
            child: const Text(
              'NIMBUS',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w700,
                letterSpacing: 8,
                color: Colors.white,
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        FadeTransition(
          opacity: _taglineFade,
          child: Text(
            'Enterprise, reimagined.',
            style: TextStyle(
              fontSize: 14,
              letterSpacing: 1.2,
              color: Colors.white.withOpacity(0.65),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGlassLogo() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          width: 96,
          height: 96,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withOpacity(0.18),
                Colors.white.withOpacity(0.05),
              ],
            ),
            border: Border.all(color: Colors.white.withOpacity(0.25), width: 1.2),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF6C63FF).withOpacity(0.4),
                blurRadius: 40,
                spreadRadius: 2,
              ),
            ],
          ),
          // Swap this Icon for your Image.asset('assets/logo.png') logo mark.
          child: const Icon(Icons.diamond_outlined, size: 44, color: Colors.white),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------
  // Scrollable glass feature cards (4)
  // ---------------------------------------------------------------------
  Widget _buildFeatureCards() {
    return FadeTransition(
      opacity: _cardsFade,
      child: SlideTransition(
        position: _cardsSlide,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 24, bottom: 12),
              child: Text(
                'BUILT FOR SCALE',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.4,
                  color: Colors.white.withOpacity(0.55),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: _features.length,
                itemBuilder: (context, index) =>
                    _GlassFeatureCard(data: _features[index]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  

  Widget _buildProgressFooter() {
    return FadeTransition(
      opacity: _taglineFade,
      child: SizedBox(
        width: 120,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            minHeight: 3,
            backgroundColor: Colors.white.withOpacity(0.1),
            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF00E5C7)),
          ),
        ),
      ),
    );
  }
}

class _FeatureCardData {
  final IconData icon;
  final String title;
  final String subtitle;
  const _FeatureCardData({
    required this.icon,
    required this.title,
    required this.subtitle,
  });
}

class _GlassFeatureCard extends StatelessWidget {
  final _FeatureCardData data;
  const _GlassFeatureCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 190,
      margin: const EdgeInsets.only(right: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
          child: Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withOpacity(0.10),
                  Colors.white.withOpacity(0.03),
                ],
              ),
              border: Border.all(color: Colors.white.withOpacity(0.14)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFF6C63FF).withOpacity(0.18),
                  ),
                  child: Icon(data.icon, color: const Color(0xFF00E5C7), size: 22),
                ),
                const SizedBox(height: 14),
                Text(
                  data.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  data.subtitle,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.6),
                    fontSize: 12,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}