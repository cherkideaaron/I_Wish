// ┌─────────────────────────────────────────────────────────────────────────┐
// │  REGISTER SCREEN BARREL                                                 │
// │                                                                         │
// │  HOW TO SWITCH VARIANTS:                                                │
// │    1. Swap the import and class name in build() below.                  │
// │    2. Nothing else changes.                                             │
// │                                                                         │
// │  Available variants:                                                    │
// │    A: RegisterClassicScreen  → all fields on one scrollable page        │
// │    B: RegisterStepperScreen  → 2-step form (personal info → security)   │
// └─────────────────────────────────────────────────────────────────────────┘
import 'package:flutter/material.dart';

// ─── Active variant ──────────────────────────────────────────────────────────
// import 'variants/register_classic.dart';
// import 'variants/register_stepper.dart';   // ← Variant B: multi-step
import 'variants/register_glass.dart';     // ← Variant C: glassmorphism

/// Router entry-point for the register feature.
class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) =>
      const RegisterGlassScreen(); // ← Variant C
}
