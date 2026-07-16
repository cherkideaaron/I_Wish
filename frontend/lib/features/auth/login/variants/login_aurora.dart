// login_aurora.dart
//
// "Aurora" variant — Login screen.
// Dark glassmorphism, drifting gradient blobs, staggered entrance animation,
// animated focus glow on fields, tap-scale gradient button.
//
// Usage:
//   MaterialApp(home: const LoginAurora())
//
// Dependency (pubspec.yaml):
//   google_fonts: ^6.2.1

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'aurora_widgets.dart';
import 'register_aurora.dart';

class LoginAurora extends StatefulWidget {
  const LoginAurora({super.key});

  @override
  State<LoginAurora> createState() => _LoginAuroraState();
}

class _LoginAuroraState extends State<LoginAurora> with SingleTickerProviderStateMixin {
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
      duration: const Duration(milliseconds: 1100),
    )..forward();
  }

  @override
  void dispose() {
    _entrance.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Staggers a child's fade + slide-up entrance based on [start]-[end]
  // fractions of the overall entrance timeline.
  Widget _staggered({required double start, required double end, required Widget child}) {
    final curved = CurvedAnimation(
      parent: _entrance,
      curve: Interval(start, end, curve: Curves.easeOutCubic),
    );
    return AnimatedBuilder(
      animation: curved,
      builder: (context, _) {
        return Opacity(
          opacity: curved.value.clamp(0.0, 1.0),
          child: Transform.translate(
            offset: Offset(0, (1 - curved.value) * 22),
            child: child,
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
      body: AuroraBackground(
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: Form(
                  key: _formKey,
                  child: GlassCard(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _staggered(
                          start: 0.0,
                          end: 0.45,
                          child: const Center(child: AuroraLogoBadge()),
                        ),
                        const SizedBox(height: 22),
                        _staggered(
                          start: 0.05,
                          end: 0.5,
                          child: Text('Welcome back', style: AuroraText.display),
                        ),
                        const SizedBox(height: 8),
                        _staggered(
                          start: 0.1,
                          end: 0.55,
                          child: Text(
                            'Sign in to continue to your account',
                            style: AuroraText.subtitle,
                          ),
                        ),
                        const SizedBox(height: 32),
                        _staggered(
                          start: 0.2,
                          end: 0.65,
                          child: AuroraTextField(
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
                          end: 0.72,
                          child: AuroraTextField(
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
                                color: AuroraPalette.textMuted,
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
                        const SizedBox(height: 14),
                        _staggered(
                          start: 0.32,
                          end: 0.75,
                          child: Row(
                            children: [
                              AuroraCheckbox(
                                value: _rememberMe,
                                onChanged: (v) => setState(() => _rememberMe = v),
                              ),
                              const SizedBox(width: 10),
                              Text('Remember me', style: AuroraText.label),
                              const Spacer(),
                              GestureDetector(
                                onTap: () {},
                                child: Text('Forgot password?', style: AuroraText.link),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 26),
                        _staggered(
                          start: 0.4,
                          end: 0.8,
                          child: AuroraButton(
                            label: 'Sign In',
                            loading: _loading,
                            onPressed: _handleLogin,
                          ),
                        ),
                        const SizedBox(height: 26),
                        _staggered(
                          start: 0.45,
                          end: 0.85,
                          child: const AuroraOrDivider(),
                        ),
                        const SizedBox(height: 22),
                        _staggered(
                          start: 0.5,
                          end: 0.9,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              AuroraSocialButton(icon: Icons.g_mobiledata_rounded, onPressed: () {}),
                              const SizedBox(width: 16),
                              AuroraSocialButton(icon: Icons.apple_rounded, onPressed: () {}),
                              const SizedBox(width: 16),
                              AuroraSocialButton(icon: Icons.facebook_rounded, onPressed: () {}),
                            ],
                          ),
                        ),
                        const SizedBox(height: 28),
                        _staggered(
                          start: 0.55,
                          end: 0.95,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Don't have an account? ", style: AuroraText.subtitle),
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(
                                    PageRouteBuilder(
                                      transitionDuration: const Duration(milliseconds: 500),
                                      pageBuilder: (_, anim, __) => const RegisterAurora(),
                                      transitionsBuilder: (_, anim, __, child) => FadeTransition(
                                        opacity: anim,
                                        child: SlideTransition(
                                          position: Tween<Offset>(
                                            begin: const Offset(0.05, 0),
                                            end: Offset.zero,
                                          ).animate(CurvedAnimation(parent: anim, curve: Curves.easeOutCubic)),
                                          child: child,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                child: Text('Create one', style: AuroraText.link),
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

/// -----------------------------------------------------------------------
/// Optional standalone demo entry point.
/// Remove or replace with your app's own main() when integrating this
/// template into an existing project.
/// -----------------------------------------------------------------------
