// login_prisma.dart
//
// "Prisma" variant — Login screen.
// Light liquid-glass, glossy pill controls, spring/elastic entrance
// (distinct from a slide-fade), shimmer-sweep primary button.
//
// Usage:
//   MaterialApp(home: const LoginPrisma())
//
// Dependency (pubspec.yaml):
//   google_fonts: ^6.2.1

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'prisma_widgets.dart';
import 'register_prisma.dart';

class LoginPrisma extends StatefulWidget {
  const LoginPrisma({super.key});

  @override
  State<LoginPrisma> createState() => _LoginPrismaState();
}

class _LoginPrismaState extends State<LoginPrisma> with SingleTickerProviderStateMixin {
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
      duration: const Duration(milliseconds: 900),
    )..forward();
  }

  @override
  void dispose() {
    _entrance.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Spring-style staggered entrance: fade + gentle scale pop, distinct
  // from Aurora's slide-up so the two variants don't feel interchangeable.
  Widget _staggered({required double start, required double end, required Widget child}) {
    final curved = CurvedAnimation(
      parent: _entrance,
      curve: Interval(start, end, curve: Curves.easeOutBack),
    );
    return AnimatedBuilder(
      animation: curved,
      builder: (context, _) {
        final v = curved.value.clamp(-0.2, 1.2);
        return Opacity(
          opacity: v.clamp(0.0, 1.0),
          child: Transform.scale(scale: 0.9 + (0.1 * v), child: child),
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
      body: PrismaBackground(
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: Form(
                  key: _formKey,
                  child: PrismaPanel(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _staggered(
                          start: 0.0,
                          end: 0.4,
                          child: const Center(child: PrismaLogoBadge()),
                        ),
                        const SizedBox(height: 20),
                        _staggered(
                          start: 0.05,
                          end: 0.45,
                          child: Text('Good to see you', style: PrismaText.display),
                        ),
                        const SizedBox(height: 8),
                        _staggered(
                          start: 0.1,
                          end: 0.5,
                          child: Text(
                            'Sign in to pick up right where you left off',
                            style: PrismaText.subtitle,
                          ),
                        ),
                        const SizedBox(height: 30),
                        _staggered(
                          start: 0.2,
                          end: 0.6,
                          child: PrismaField(
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
                        const SizedBox(height: 14),
                        _staggered(
                          start: 0.28,
                          end: 0.68,
                          child: PrismaField(
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
                                color: PrismaPalette.inkFaint,
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
                          start: 0.34,
                          end: 0.72,
                          child: Row(
                            children: [
                              PrismaCheckbox(
                                value: _rememberMe,
                                onChanged: (v) => setState(() => _rememberMe = v),
                              ),
                              const SizedBox(width: 10),
                              Text('Remember me', style: PrismaText.label),
                              const Spacer(),
                              GestureDetector(
                                onTap: () {},
                                child: Text('Forgot password?', style: PrismaText.link),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 26),
                        _staggered(
                          start: 0.4,
                          end: 0.78,
                          child: PrismaButton(
                            label: 'Sign In',
                            loading: _loading,
                            onPressed: _handleLogin,
                          ),
                        ),
                        const SizedBox(height: 24),
                        _staggered(
                          start: 0.46,
                          end: 0.84,
                          child: const PrismaOrDivider(),
                        ),
                        const SizedBox(height: 20),
                        _staggered(
                          start: 0.52,
                          end: 0.9,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              PrismaSocialButton(icon: Icons.g_mobiledata_rounded, onPressed: () {}),
                              const SizedBox(width: 14),
                              PrismaSocialButton(icon: Icons.apple_rounded, onPressed: () {}),
                              const SizedBox(width: 14),
                              PrismaSocialButton(icon: Icons.facebook_rounded, onPressed: () {}),
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
                              Text("New here? ", style: PrismaText.subtitle),
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(
                                    PageRouteBuilder(
                                      transitionDuration: const Duration(milliseconds: 450),
                                      pageBuilder: (_, anim, __) => const RegisterPrisma(),
                                      transitionsBuilder: (_, anim, __, child) => FadeTransition(
                                        opacity: anim,
                                        child: ScaleTransition(
                                          scale: Tween<double>(begin: 0.96, end: 1)
                                              .animate(CurvedAnimation(parent: anim, curve: Curves.easeOutCubic)),
                                          child: child,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                child: Text('Create an account', style: PrismaText.link),
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