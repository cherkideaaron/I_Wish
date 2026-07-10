import 'package:flutter/material.dart';

/// Brand color palette. Prefer using [Theme.of(context).colorScheme] in widgets
/// so the theming system handles light/dark automatically.
/// Use these constants only when you need a color outside of the theme context.
class AppColors {
  AppColors._();

  // ─── Primary ────────────────────────────────────────
  static const Color primary = Color(0xFF4A6CF7); // Vibrant indigo-blue
  static const Color primaryLight = Color(0xFF7B95FF);
  static const Color primaryDark = Color(0xFF2A4BD7);

  // ─── Accent ─────────────────────────────────────────
  static const Color accent = Color(0xFFFF6B6B); // Warm coral

  // ─── Backgrounds ────────────────────────────────────
  static const Color background = Color(0xFFF7F8FC);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceDark = Color(0xFF1E1E2E);

  // ─── Text ───────────────────────────────────────────
  static const Color textDark = Color(0xFF1A1A2E);
  static const Color textMedium = Color(0xFF6B7280);
  static const Color textLight = Color(0xFFFFFFFF);

  // ─── State ──────────────────────────────────────────
  static const Color error = Color(0xFFEF4444);
  static const Color success = Color(0xFF22C55E);
  static const Color warning = Color(0xFFF59E0B);

  // ─── Misc ───────────────────────────────────────────
  static const Color divider = Color(0xFFE5E7EB);
  static const Color shimmer = Color(0xFFE0E0E0);
}
