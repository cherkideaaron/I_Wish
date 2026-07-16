// rivet_widgets.dart
//
// "Rivet" variant — shared building blocks.
// Aesthetic: neo-brutalism — flat color blocks, thick black borders, hard
// offset shadows (no blur), bold condensed type, punchy "press-in" tap
// animation. A deliberate counterpoint to the glass/blur variants: no
// transparency, no gradients-as-glow, high graphic contrast.
//
// Dependency (pubspec.yaml):
//   google_fonts: ^6.2.1

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// -----------------------------------------------------------------------
/// PALETTE
/// -----------------------------------------------------------------------
class RivetPalette {
  RivetPalette._();

  static const Color paper = Color(0xFFF5F2EA);
  static const Color ink = Color(0xFF14130F);
  static const Color inkSoft = Color(0xFF57544A);

  static const Color lime = Color(0xFFD8FF3E);
  static const Color coral = Color(0xFFFF5C6C);
  static const Color blue = Color(0xFF3B7AFF);
  static const Color violet = Color(0xFFB18CFF);

  static const Color surface = Color(0xFFFFFFFF);
}

/// -----------------------------------------------------------------------
/// TEXT STYLES — bold condensed display, uppercase labels
/// -----------------------------------------------------------------------
class RivetText {
  RivetText._();

  static TextStyle display = GoogleFonts.spaceGrotesk(
    fontSize: 34,
    fontWeight: FontWeight.w700,
    color: RivetPalette.ink,
    letterSpacing: -0.5,
    height: 1.05,
  );

  static TextStyle subtitle = GoogleFonts.spaceGrotesk(
    fontSize: 15,
    fontWeight: FontWeight.w500,
    color: RivetPalette.inkSoft,
    height: 1.4,
  );

  static TextStyle label = GoogleFonts.spaceGrotesk(
    fontSize: 12,
    fontWeight: FontWeight.w700,
    color: RivetPalette.ink,
    letterSpacing: 0.6,
  );

  static TextStyle body = GoogleFonts.spaceGrotesk(
    fontSize: 15.5,
    fontWeight: FontWeight.w500,
    color: RivetPalette.ink,
  );

  static TextStyle button = GoogleFonts.spaceGrotesk(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: RivetPalette.ink,
    letterSpacing: 0.2,
  );

  static TextStyle link = GoogleFonts.spaceGrotesk(
    fontSize: 14,
    fontWeight: FontWeight.w700,
    color: RivetPalette.ink,
    decoration: TextDecoration.underline,
    decorationThickness: 2,
    decorationColor: RivetPalette.lime,
  );
}

/// -----------------------------------------------------------------------
/// BACKGROUND — flat paper color, faint dot grid, a couple of static
/// "sticker" shapes that idle-rotate very slightly for personality.
/// -----------------------------------------------------------------------
class RivetBackground extends StatefulWidget {
  final Widget child;
  const RivetBackground({super.key, required this.child});

  @override
  State<RivetBackground> createState() => _RivetBackgroundState();
}

class _RivetBackgroundState extends State<RivetBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _sticker({
    double? top,
    double? left,
    double? right,
    double? bottom,
    required Color color,
    required double size,
    required IconData icon,
    required double baseRotation,
  }) {
    return Positioned(
      top: top,
      left: left,
      right: right,
      bottom: bottom,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          final wobble = (_controller.value - 0.5) * 0.12;
          return Transform.rotate(
            angle: baseRotation + wobble,
            child: Container(
              height: size,
              width: size,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                border: Border.all(color: RivetPalette.ink, width: 2.5),
              ),
              child: Icon(icon, color: RivetPalette.ink, size: size * 0.4),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Container(
      color: RivetPalette.paper,
      child: Stack(
        fit: StackFit.expand,
        children: [
          CustomPaint(size: Size(size.width, size.height), painter: _DotGridPainter()),
          _sticker(
            top: size.height * 0.08,
            left: -18,
            color: RivetPalette.lime,
            size: 74,
            icon: Icons.bolt_rounded,
            baseRotation: -0.18,
          ),
          _sticker(
            top: size.height * 0.14,
            right: -20,
            color: RivetPalette.coral,
            size: 58,
            icon: Icons.star_rounded,
            baseRotation: 0.22,
          ),
          _sticker(
            bottom: size.height * 0.1,
            right: -16,
            color: RivetPalette.blue,
            size: 66,
            icon: Icons.favorite_rounded,
            baseRotation: -0.15,
          ),
          widget.child,
        ],
      ),
    );
  }
}

class _DotGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = RivetPalette.ink.withOpacity(0.08);
    const spacing = 26.0;
    for (double y = 0; y < size.height; y += spacing) {
      for (double x = 0; x < size.width; x += spacing) {
        canvas.drawCircle(Offset(x, y), 1.4, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// -----------------------------------------------------------------------
/// PANEL — white block, thick black border, hard offset shadow (no blur)
/// -----------------------------------------------------------------------
class RivetPanel extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final double radius;

  const RivetPanel({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.fromLTRB(26, 30, 26, 26),
    this.radius = 20,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: RivetPalette.surface,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: RivetPalette.ink, width: 3),
        boxShadow: const [
          BoxShadow(
            color: RivetPalette.ink,
            offset: Offset(9, 9),
            blurRadius: 0,
          ),
        ],
      ),
      child: child,
    );
  }
}

/// -----------------------------------------------------------------------
/// FIELD — flat bordered box; focus swaps border to accent + tightens
/// a small hard shadow underneath (a "sticking" tactile cue).
/// -----------------------------------------------------------------------
class RivetField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final bool obscureText;
  final Widget? suffix;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final TextInputAction textInputAction;

  const RivetField({
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
  State<RivetField> createState() => _RivetFieldState();
}

class _RivetFieldState extends State<RivetField> {
  late final FocusNode _focusNode;
  bool _focused = false;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode()
      ..addListener(() => setState(() => _focused = _focusNode.hasFocus));
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.label.toUpperCase(), style: RivetText.label),
        const SizedBox(height: 8),
        AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          curve: Curves.easeOut,
          decoration: BoxDecoration(
            color: RivetPalette.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: RivetPalette.ink,
              width: _focused ? 3 : 2,
            ),
            boxShadow: [
              BoxShadow(
                color: _focused ? RivetPalette.blue : RivetPalette.ink.withOpacity(0.0),
                offset: const Offset(4, 4),
                blurRadius: 0,
              ),
            ],
          ),
          child: TextFormField(
            controller: widget.controller,
            focusNode: _focusNode,
            obscureText: widget.obscureText,
            keyboardType: widget.keyboardType,
            textInputAction: widget.textInputAction,
            validator: widget.validator,
            style: RivetText.body,
            cursorColor: RivetPalette.ink,
            decoration: InputDecoration(
              prefixIcon: Icon(widget.icon, size: 20, color: RivetPalette.ink),
              suffixIcon: widget.suffix,
              filled: false,
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 14),
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              errorStyle: GoogleFonts.spaceGrotesk(
                fontSize: 11.5,
                fontWeight: FontWeight.w600,
                color: RivetPalette.coral,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// -----------------------------------------------------------------------
/// PRIMARY BUTTON — solid fill, thick border, hard shadow that the
/// button "presses into" on tap (shadow shrinks, button shifts toward it).
/// -----------------------------------------------------------------------
class RivetButton extends StatefulWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool loading;
  final Color fill;

  const RivetButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.loading = false,
    this.fill = RivetPalette.lime,
  });

  @override
  State<RivetButton> createState() => _RivetButtonState();
}

class _RivetButtonState extends State<RivetButton> {
  bool _pressed = false;

  void _setPressed(bool p) {
    if (widget.onPressed == null || widget.loading) return;
    setState(() => _pressed = p);
  }

  @override
  Widget build(BuildContext context) {
    final disabled = widget.onPressed == null || widget.loading;
    return GestureDetector(
      onTapDown: (_) => _setPressed(true),
      onTapUp: (_) => _setPressed(false),
      onTapCancel: () => _setPressed(false),
      onTap: disabled ? null : widget.onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 90),
        curve: Curves.easeOut,
        transform: Matrix4.translationValues(_pressed ? 6 : 0, _pressed ? 6 : 0, 0),
        height: 58,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: disabled ? RivetPalette.ink.withOpacity(0.15) : widget.fill,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: RivetPalette.ink, width: 3),
          boxShadow: [
            BoxShadow(
              color: disabled ? Colors.transparent : RivetPalette.ink,
              offset: _pressed ? Offset.zero : const Offset(6, 6),
              blurRadius: 0,
            ),
          ],
        ),
        child: widget.loading
            ? const SizedBox(
                height: 22,
                width: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.6,
                  valueColor: AlwaysStoppedAnimation(RivetPalette.ink),
                ),
              )
            : Text(widget.label.toUpperCase(), style: RivetText.button),
      ),
    );
  }
}

/// -----------------------------------------------------------------------
/// SOCIAL BUTTON — square block, same press-in behavior as the CTA
/// -----------------------------------------------------------------------
class RivetSocialButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  const RivetSocialButton({super.key, required this.icon, this.onPressed});

  @override
  State<RivetSocialButton> createState() => _RivetSocialButtonState();
}

class _RivetSocialButtonState extends State<RivetSocialButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      onTap: widget.onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 90),
        transform: Matrix4.translationValues(_pressed ? 4 : 0, _pressed ? 4 : 0, 0),
        height: 52,
        width: 52,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: RivetPalette.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: RivetPalette.ink, width: 2.5),
          boxShadow: [
            BoxShadow(
              color: RivetPalette.ink,
              offset: _pressed ? Offset.zero : const Offset(4, 4),
              blurRadius: 0,
            ),
          ],
        ),
        child: Icon(widget.icon, color: RivetPalette.ink, size: 20),
      ),
    );
  }
}

/// -----------------------------------------------------------------------
/// CHECKBOX — flat square, hard-edge bounce-in check
/// -----------------------------------------------------------------------
class RivetCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  const RivetCheckbox({super.key, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 140),
        height: 24,
        width: 24,
        decoration: BoxDecoration(
          color: value ? RivetPalette.ink : RivetPalette.surface,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: RivetPalette.ink, width: 2.5),
        ),
        child: AnimatedScale(
          scale: value ? 1 : 0,
          duration: const Duration(milliseconds: 160),
          curve: Curves.easeOutBack,
          child: const Icon(Icons.check_rounded, size: 16, color: RivetPalette.lime),
        ),
      ),
    );
  }
}

/// -----------------------------------------------------------------------
/// OR DIVIDER
/// -----------------------------------------------------------------------
class RivetOrDivider extends StatelessWidget {
  const RivetOrDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Container(height: 2.5, color: RivetPalette.ink.withOpacity(0.15))),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Text('OR CONTINUE WITH', style: RivetText.label.copyWith(color: RivetPalette.inkSoft)),
        ),
        Expanded(child: Container(height: 2.5, color: RivetPalette.ink.withOpacity(0.15))),
      ],
    );
  }
}

/// -----------------------------------------------------------------------
/// LOGO BADGE — flat square mark with a slight fixed tilt (sticker feel)
/// -----------------------------------------------------------------------
class RivetLogoBadge extends StatelessWidget {
  final IconData icon;
  const RivetLogoBadge({super.key, this.icon = Icons.bolt_rounded});

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: -0.06,
      child: Container(
        height: 60,
        width: 60,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: RivetPalette.lime,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: RivetPalette.ink, width: 3),
          boxShadow: const [
            BoxShadow(color: RivetPalette.ink, offset: Offset(5, 5), blurRadius: 0),
          ],
        ),
        child: Icon(icon, color: RivetPalette.ink, size: 26),
      ),
    );
  }
}