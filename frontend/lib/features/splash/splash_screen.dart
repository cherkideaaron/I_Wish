// ┌─────────────────────────────────────────────────────────────────────────┐
// │  SPLASH SCREEN BARREL                                                   │
// │                                                                         │
// │  HOW TO SWITCH VARIANTS:                                                │
// │    1. Comment out the active import & class reference below.            │
// │    2. Uncomment the one you want.                                       │
// │    3. That's it — nothing else needs to change.                         │
// └─────────────────────────────────────────────────────────────────────────┘

import 'package:flutter/material.dart';

// ─── Active variant ──────────────────────────────────────────────────────────
import 'variants/splash_fade_logo.dart';
// import 'variants/splash_slide_in.dart';   // ← Variant B: slide-up text

/// Entry point for the splash feature.
/// The router points to this class; it delegates to the active variant.
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) => const SplashFadeLogoScreen(); // ← Variant A
  //  const SplashSlideInScreen();     // ← Variant B
}
