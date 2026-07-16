// login_rivet.dart
//
// "Rivet" variant — Login screen.
// Neo-brutalist: flat blocks, thick borders, hard offset shadows, a
// press-in CTA, and a tilt-and-settle staggered entrance (distinct from
// both the slide-fade and the spring-scale used in other variants).
//
// Usage:
//   MaterialApp(home: const LoginRivet())
//
// Dependency (pubspec.yaml):
//   google_fonts: ^6.2.1

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'rivet_widgets.dart';
import 'register_rivet.dart';

class LoginRivet extends StatefulWidget {
  const LoginRivet({super.key});

  @override
  State<LoginRivet> createState() => _LoginRivetState();
}

class _LoginRivetState extends State<LoginRivet> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  late final AnimationController _entrance;
  bool _obscure = true;
  bool _rememberMe = false;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _entrance = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 950),
    )..forward();
  }

  @override
  void dispose() {
    _entrance.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Each element enters slightly tilted and offset, then settles flat —
  // a "stuck-on sticker" feel that matches the brutalist panel treatment.
  Widget _staggered({required double start, required double end, required Widget child}) {
    final curved = CurvedAnimation(
      parent: _entrance,
      curve: Interval(start, end, curve: Curves.easeOutCubic),
    );
    return AnimatedBuilder(
      animation: curved,
      builder: (context, _) {
        final v = curved.value.clamp(0.0, 1.0);
        return Opacity(
          opacity: v,
          child: Transform.translate(
            offset: Offset(0, (1 - v) * 18),
            child: Transform.rotate(angle: (1 - v) * -0.03, child: child),
          ),
        );
      },
      child: child,
    );
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    // TODO: replace with real authentication call.
    await Future.delayed(const Duration(milliseconds: 1400));
    if (!mounted) return;
    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: RivetBackground(
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: Form(
                  key: _formKey,
                  child: RivetPanel(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _staggered(
                          start: 0.0,
                          end: 0.4,
                          child: const Center(child: RivetLogoBadge()),
                        ),
                        const SizedBox(height: 20),
                        _staggered(
                          start: 0.05,
                          end: 0.45,
                          child: Text('LOG IN', style: RivetText.display),
                        ),
                        const SizedBox(height: 6),
                        _staggered(
                          start: 0.1,
                          end: 0.5,
                          child: Text(
                            'Enter your details to access your account',
                            style: RivetText.subtitle,
                          ),
                        ),
                        const SizedBox(height: 28),
                        _staggered(
                          start: 0.2,
                          end: 0.6,
                          child: RivetField(
                            controller: _emailController,
                            label: 'Email address',
                            icon: Icons.mail_outline_rounded,
                            keyboardType: TextInputType.emailAddress,
                            validator: (v) {
                              if (v == null || v.trim().isEmpty) return 'Email is required';
                              if (!v.contains('@')) return 'Enter a valid email';
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(height: 16),
                        _staggered(
                          start: 0.28,
                          end: 0.68,
                          child: RivetField(
                            controller: _passwordController,
                            label: 'Password',
                            icon: Icons.lock_outline_rounded,
                            obscureText: _obscure,
                            textInputAction: TextInputAction.done,
                            suffix: IconButton(
                              icon: Icon(
                                _obscure
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                                color: RivetPalette.ink,
                                size: 20,
                              ),
                              onPressed: () => setState(() => _obscure = !_obscure),
                            ),
                            validator: (v) {
                              if (v == null || v.isEmpty) return 'Password is required';
                              if (v.length < 6) return 'Minimum 6 characters';
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(height: 16),
                        _staggered(
                          start: 0.34,
                          end: 0.72,
                          child: Row(
                            children: [
                              RivetCheckbox(
                                value: _rememberMe,
                                onChanged: (v) => setState(() => _rememberMe = v),
                              ),
                              const SizedBox(width: 10),
                              Text('REMEMBER ME', style: RivetText.label),
                              const Spacer(),
                              GestureDetector(
                                onTap: () {},
                                child: Text('Forgot password?', style: RivetText.link),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 26),
                        _staggered(
                          start: 0.4,
                          end: 0.78,
                          child: RivetButton(
                            label: 'Sign In',
                            loading: _loading,
                            onPressed: _handleLogin,
                          ),
                        ),
                        const SizedBox(height: 24),
                        _staggered(
                          start: 0.46,
                          end: 0.84,
                          child: const RivetOrDivider(),
                        ),
                        const SizedBox(height: 20),
                        _staggered(
                          start: 0.52,
                          end: 0.9,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              RivetSocialButton(icon: Icons.g_mobiledata_rounded, onPressed: () {}),
                              const SizedBox(width: 14),
                              RivetSocialButton(icon: Icons.apple_rounded, onPressed: () {}),
                              const SizedBox(width: 14),
                              RivetSocialButton(icon: Icons.facebook_rounded, onPressed: () {}),
                            ],
                          ),
                        ),
                        const SizedBox(height: 26),
                        _staggered(
                          start: 0.58,
                          end: 0.96,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Don't have an account? ", style: RivetText.subtitle),
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(
                                    PageRouteBuilder(
                                      transitionDuration: const Duration(milliseconds: 400),
                                      pageBuilder: (_, anim, __) => const RegisterRivet(),
                                      transitionsBuilder: (_, anim, __, child) => FadeTransition(
                                        opacity: anim,
                                        child: SlideTransition(
                                          position: Tween<Offset>(
                                            begin: const Offset(0, 0.04),
                                            end: Offset.zero,
                                          ).animate(CurvedAnimation(parent: anim, curve: Curves.easeOutCubic)),
                                          child: child,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                child: Text('Sign up', style: RivetText.link),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}