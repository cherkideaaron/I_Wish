/// Spacing, sizing, and layout constants.
/// Using named constants keeps the UI consistent and easy to tweak globally.
class AppDimensions {
  AppDimensions._();

  // ─── Spacing / Padding ──────────────────────────────
  static const double paddingXSmall = 4.0;
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;
  static const double paddingXLarge = 40.0;

  // ─── Border Radius ──────────────────────────────────
  static const double radiusSmall = 8.0;
  static const double radiusMedium = 16.0;
  static const double radiusLarge = 24.0;
  static const double radiusCircle = 999.0;

  // ─── Buttons ────────────────────────────────────────
  static const double buttonHeight = 52.0;
  static const double buttonHeightSmall = 40.0;

  // ─── Icons ──────────────────────────────────────────
  static const double iconSizeSmall = 16.0;
  static const double iconSizeMedium = 24.0;
  static const double iconSizeLarge = 48.0;
  static const double logoSize = 80.0;

  // ─── Forms ──────────────────────────────────────────
  /// Max width of centered forms (login, register).
  static const double formMaxWidth = 420.0;
  static const double inputHeight = 56.0;

  // ─── Layout ─────────────────────────────────────────
  /// Width at which the "split" layout activates (tablet/desktop).
  static const double splitLayoutBreakpoint = 800.0;
}
