// ┌─────────────────────────────────────────────────────────────────────────┐
// │  LOGIN SCREEN BARREL                                                    │
// │                                                                         │
// │  HOW TO SWITCH VARIANTS:                                                │
// │    1. Swap the import and the class name in build() below.              │
// │    2. That's it — the router and everything else stays the same.        │
// │                                                                         │
// │  Available variants:                                                    │
// │    A: LoginClassicScreen  → centered card, works on all screen sizes    │
// │    B: LoginSplitScreen    → split panel (great for tablet/web/desktop)  │
// └─────────────────────────────────────────────────────────────────────────┘
import 'package:flutter/material.dart';

// ─── Active variant ──────────────────────────────────────────────────────────
import 'variants/login_classic.dart';
// import 'variants/login_split.dart';   // ← Variant B: split panel
//import 'variants/login_glass.dart';     // ← Variant C: glassmorphism

/// Router entry-point for the login feature.
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) =>
      const LoginClassicScreen(); // ← Variant A
}
