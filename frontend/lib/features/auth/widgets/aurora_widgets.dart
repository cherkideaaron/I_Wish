// Paste your Aurora widgets code in this file!
// aurora_widgets.dart
//
// Shared building blocks for the "Aurora" auth template variant:
// a dark, glassmorphic, gradient-blob aesthetic with soft micro-animations.
//
// Dependency (add to pubspec.yaml):
//   google_fonts: ^6.2.1

import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// -----------------------------------------------------------------------
/// PALETTE
/// -----------------------------------------------------------------------
class AuroraPalette {
  AuroraPalette._();

  static const Color bgTop = Color(0xFF0A0B14);
  static const Color bgBottom = Color(0xFF161129);

  static const Color violet = Color(0xFF8B5CF6);
  static const Color magenta = Color(0xFFEC4899);
  static const Color teal = Color(0xFF2DD4BF);
  static const Color amber = Color(0xFFF6B860);

  static const Color textPrimary = Color(0xFFF7F5FF);
  static const Color textSecondary = Color(0xFFA7A4C8);
  static const Color textMuted = Color(0xFF6E6B94);

  static const Color glassBorder = Color(0x33FFFFFF);
  static const Color fieldFill = Color(0x0AFFFFFF);

  static const LinearGradient primaryButton = LinearGradient(
    colors: [violet, magenta],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const LinearGradient background = LinearGradient(
    colors: [bgTop, bgBottom],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

/// -----------------------------------------------------------------------
/// TEXT STYLES
/// -----------------------------------------------------------------------
class AuroraText {
  AuroraText._();

  static TextStyle display = GoogleFonts.outfit(
    fontSize: 30,
    fontWeight: FontWeight.w700,
    color: AuroraPalette.textPrimary,
    letterSpacing: -0.5,
  );

  static TextStyle subtitle = GoogleFonts.inter(
    fontSize: 15,
    fontWeight: FontWeight.w400,
    color: AuroraPalette.textSecondary,
    height: 1.4,
  );

  static TextStyle label = GoogleFonts.inter(
    fontSize: 13.5,
    fontWeight: FontWeight.w500,
    color: AuroraPalette.textSecondary,
  );

  static TextStyle body = GoogleFonts.inter(
    fontSize: 15,
    fontWeight: FontWeight.w400,
    color: AuroraPalette.textPrimary,
  );

  static TextStyle button = GoogleFonts.outfit(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Colors.white,
    letterSpacing: 0.3,
  );

  static TextStyle link = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AuroraPalette.violet,
  );
}

/// -----------------------------------------------------------------------
/// ANIMATED AURORA BACKGROUND
/// Slow-drifting blurred gradient blobs behind a glass foreground.
/// -----------------------------------------------------------------------
class AuroraBackground extends StatefulWidget {
  final Widget child;
  const AuroraBackground({super.key, required this.child});

  @override
  State<AuroraBackground> createState() => _AuroraBackgroundState();
}

class _AuroraBackgroundState extends State<AuroraBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 22),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _blob({
    double? top,
    double? left,
    double? right,
    double? bottom,
    required Color color,
    required double size,
  }) {
    return Positioned(
      top: top,
      left: left,
      right: right,
      bottom: bottom,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [color.withOpacity(0.55), color.withOpacity(0.0)],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return DecoratedBox(
      decoration: const BoxDecoration(gradient: AuroraPalette.background),
      child: Stack(
        fit: StackFit.expand,
        children: [
          AnimatedBuilder(
            animation: _controller,
            builder: (context, _) {
              final t = _controller.value * 2 * pi;
              return Stack(
                children: [
                  _blob(
                    top: size.height * 0.05 + 30 * sin(t),
                    left: -size.width * 0.25 + 40 * cos(t),
                    color: AuroraPalette.violet,
                    size: size.width * 0.9,
                  ),
                  _blob(
                    top: size.height * 0.35 + 25 * cos(t * 0.8),
                    right: -size.width * 0.3 + 30 * sin(t * 0.8),
                    color: AuroraPalette.magenta,
                    size: size.width * 0.85,
                  ),
                  _blob(
                    bottom: -size.height * 0.1 + 35 * sin(t * 1.15),
                    left: size.width * 0.1 + 25 * cos(t * 1.15),
                    color: AuroraPalette.teal,
                    size: size.width * 0.75,
                  ),
                ],
              );
            },
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 90, sigmaY: 90),
            child: Container(color: Colors.transparent),
          ),
          // subtle vignette so foreground text stays readable
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.center,
                radius: 1.2,
                colors: [Colors.transparent, Colors.black.withOpacity(0.35)],
              ),
            ),
          ),
          widget.child,
        ],
      ),
    );
  }
}

/// -----------------------------------------------------------------------
/// GLASS CARD
/// -----------------------------------------------------------------------
class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final double radius;

  const GlassCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.fromLTRB(28, 32, 28, 28),
    this.radius = 28,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radius),
            gradient: LinearGradient(
              colors: [
                Colors.white.withOpacity(0.09),
                Colors.white.withOpacity(0.02),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            border: Border.all(color: AuroraPalette.glassBorder, width: 1.2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.35),
                blurRadius: 40,
                offset: const Offset(0, 24),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}

/// -----------------------------------------------------------------------
/// AURORA TEXT FIELD — animated glow border on focus
/// -----------------------------------------------------------------------
class AuroraTextField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final bool obscureText;
  final Widget? suffix;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final TextInputAction textInputAction;

  const AuroraTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.icon,
    this.obscureText = false,
    this.suffix,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.textInputAction = TextInputAction.next,
  });

  @override
  State<AuroraTextField> createState() => _AuroraTextFieldState();
}

class _AuroraTextFieldState extends State<AuroraTextField> {
  late final FocusNode _focusNode;
  bool _focused = false;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode()
      ..addListener(() {
        setState(() => _focused = _focusNode.hasFocus);
      });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOut,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _focused ? AuroraPalette.violet : Colors.white.withOpacity(0.14),
          width: _focused ? 1.6 : 1,
        ),
        boxShadow: _focused
            ? [
                BoxShadow(
                  color: AuroraPalette.violet.withOpacity(0.35),
                  blurRadius: 18,
                  spreadRadius: 1,
                ),
              ]
            : [],
      ),
      child: TextFormField(
        controller: widget.controller,
        focusNode: _focusNode,
        obscureText: widget.obscureText,
        keyboardType: widget.keyboardType,
        textInputAction: widget.textInputAction,
        validator: widget.validator,
        style: AuroraText.body,
        cursorColor: AuroraPalette.violet,
        decoration: InputDecoration(
          labelText: widget.label,
          labelStyle: AuroraText.label.copyWith(
            color: _focused ? AuroraPalette.violet : AuroraPalette.textSecondary,
          ),
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          prefixIcon: Icon(
            widget.icon,
            size: 20,
            color: _focused ? AuroraPalette.violet : AuroraPalette.textMuted,
          ),
          suffixIcon: widget.suffix,
          filled: true,
          fillColor: AuroraPalette.fieldFill,
          contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          errorStyle: GoogleFonts.inter(fontSize: 12, color: AuroraPalette.amber),
        ),
      ),
    );
  }
}

/// -----------------------------------------------------------------------
/// AURORA PRIMARY BUTTON — gradient fill + tap-scale micro-animation
/// -----------------------------------------------------------------------
class AuroraButton extends StatefulWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool loading;

  const AuroraButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.loading = false,
  });

  @override
  State<AuroraButton> createState() => _AuroraButtonState();
}

class _AuroraButtonState extends State<AuroraButton> {
  double _scale = 1;

  void _setScale(double s) {
    if (widget.onPressed == null || widget.loading) return;
    setState(() => _scale = s);
  }

  @override
  Widget build(BuildContext context) {
    final disabled = widget.onPressed == null || widget.loading;
    return GestureDetector(
      onTapDown: (_) => _setScale(0.96),
      onTapUp: (_) => _setScale(1),
      onTapCancel: () => _setScale(1),
      onTap: disabled ? null : widget.onPressed,
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: 56,
          width: double.infinity,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: AuroraPalette.primaryButton,
            boxShadow: disabled
                ? []
                : [
                    BoxShadow(
                      color: AuroraPalette.magenta.withOpacity(0.35),
                      blurRadius: 22,
                      offset: const Offset(0, 10),
                    ),
                  ],
          ),
          child: widget.loading
              ? const SizedBox(
                  height: 22,
                  width: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.4,
                    valueColor: AlwaysStoppedAnimation(Colors.white),
                  ),
                )
              : Text(widget.label, style: AuroraText.button),
        ),
      ),
    );
  }
}

/// -----------------------------------------------------------------------
/// GLASS SOCIAL ICON BUTTON
/// -----------------------------------------------------------------------
class AuroraSocialButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  const AuroraSocialButton({super.key, required this.icon, this.onPressed});

  @override
  State<AuroraSocialButton> createState() => _AuroraSocialButtonState();
}

class _AuroraSocialButtonState extends State<AuroraSocialButton> {
  double _scale = 1;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _scale = 0.9),
      onTapUp: (_) => setState(() => _scale = 1),
      onTapCancel: () => setState(() => _scale = 1),
      onTap: widget.onPressed,
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 120),
        child: Container(
          height: 52,
          width: 52,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withOpacity(0.06),
            border: Border.all(color: Colors.white.withOpacity(0.14)),
          ),
          child: Icon(widget.icon, color: AuroraPalette.textPrimary, size: 20),
        ),
      ),
    );
  }
}

/// -----------------------------------------------------------------------
/// AURORA CHECKBOX — animated fill for "remember me" / "agree to terms"
/// -----------------------------------------------------------------------
class AuroraCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  const AuroraCheckbox({super.key, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        height: 20,
        width: 20,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          gradient: value ? AuroraPalette.primaryButton : null,
          color: value ? null : Colors.white.withOpacity(0.06),
          border: Border.all(
            color: value ? Colors.transparent : Colors.white.withOpacity(0.25),
          ),
        ),
        child: value
            ? const Icon(Icons.check_rounded, size: 15, color: Colors.white)
            : null,
      ),
    );
  }
}

/// -----------------------------------------------------------------------
/// OR DIVIDER
/// -----------------------------------------------------------------------
class AuroraOrDivider extends StatelessWidget {
  const AuroraOrDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Divider(color: Colors.white.withOpacity(0.12))),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Text('or continue with', style: AuroraText.label),
        ),
        Expanded(child: Divider(color: Colors.white.withOpacity(0.12))),
      ],
    );
  }
}

/// -----------------------------------------------------------------------
/// LOGO BADGE — glowing circular glass mark used on both screens
/// -----------------------------------------------------------------------
class AuroraLogoBadge extends StatelessWidget {
  final IconData icon;
  const AuroraLogoBadge({super.key, this.icon = Icons.auto_awesome_rounded});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      width: 64,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: AuroraPalette.primaryButton,
        boxShadow: [
          BoxShadow(
            color: AuroraPalette.violet.withOpacity(0.5),
            blurRadius: 28,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Icon(icon, color: Colors.white, size: 28),
    );
  }
}