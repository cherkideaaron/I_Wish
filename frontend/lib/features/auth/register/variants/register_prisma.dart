// register_prisma.dart
//
// "Prisma" variant — Registration screen.
// Shares the visual language of login_prisma.dart: bright glass panel,
// glossy pill fields/buttons, spring entrance, shimmer-sweep CTA.
//
// Usage:
//   MaterialApp(home: const RegisterPrisma())
//
// Dependency (pubspec.yaml):
//   google_fonts: ^6.2.1

import 'package:flutter/material.dart';

import 'prisma_widgets.dart';

class RegisterPrisma extends StatefulWidget {
  const RegisterPrisma({super.key});

  @override
  State<RegisterPrisma> createState() => _RegisterPrismaState();
}

class _RegisterPrismaState extends State<RegisterPrisma> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  late final AnimationController _entrance;
  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _agreedToTerms = false;
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
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

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

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_agreedToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: PrismaPalette.ink,
          content: Text(
            'Please agree to the Terms & Privacy Policy',
            style: PrismaText.body.copyWith(color: Colors.white),
          ),
        ),
      );
      return;
    }
    setState(() => _loading = true);
    // TODO: replace with real registration call.
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
                          end: 0.35,
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () => Navigator.of(context).maybePop(),
                                child: Container(
                                  height: 40,
                                  width: 40,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white,
                                    border: Border.all(color: const Color(0xFFE7E4F3)),
                                    boxShadow: [
                                      BoxShadow(
                                        color: PrismaPalette.ink.withOpacity(0.05),
                                        blurRadius: 8,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: const Icon(
                                    Icons.arrow_back_ios_new_rounded,
                                    size: 16,
                                    color: PrismaPalette.ink,
                                  ),
                                ),
                              ),
                              const Spacer(),
                              const PrismaLogoBadge(icon: Icons.person_add_alt_1_rounded),
                              const Spacer(),
                              const SizedBox(width: 40),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        _staggered(
                          start: 0.05,
                          end: 0.42,
                          child: Text('Let\'s get you set up', style: PrismaText.display),
                        ),
                        const SizedBox(height: 8),
                        _staggered(
                          start: 0.1,
                          end: 0.46,
                          child: Text(
                            'Create an account in under a minute',
                            style: PrismaText.subtitle,
                          ),
                        ),
                        const SizedBox(height: 28),
                        _staggered(
                          start: 0.16,
                          end: 0.54,
                          child: PrismaField(
                            controller: _nameController,
                            label: 'Full name',
                            icon: Icons.person_outline_rounded,
                            validator: (v) {
                              if (v == null || v.trim().isEmpty) return 'Name is required';
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(height: 14),
                        _staggered(
                          start: 0.22,
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
                          end: 0.66,
                          child: PrismaField(
                            controller: _passwordController,
                            label: 'Password',
                            icon: Icons.lock_outline_rounded,
                            obscureText: _obscurePassword,
                            suffix: IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                                color: PrismaPalette.inkFaint,
                                size: 20,
                              ),
                              onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
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
                          child: PrismaField(
                            controller: _confirmController,
                            label: 'Confirm password',
                            icon: Icons.lock_outline_rounded,
                            obscureText: _obscureConfirm,
                            textInputAction: TextInputAction.done,
                            suffix: IconButton(
                              icon: Icon(
                                _obscureConfirm
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                                color: PrismaPalette.inkFaint,
                                size: 20,
                              ),
                              onPressed: () => setState(() => _obscureConfirm = !_obscureConfirm),
                            ),
                            validator: (v) {
                              if (v == null || v.isEmpty) return 'Please confirm your password';
                              if (v != _passwordController.text) return 'Passwords do not match';
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(height: 18),
                        _staggered(
                          start: 0.4,
                          end: 0.76,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              PrismaCheckbox(
                                value: _agreedToTerms,
                                onChanged: (v) => setState(() => _agreedToTerms = v),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text.rich(
                                  TextSpan(
                                    style: PrismaText.label,
                                    children: [
                                      const TextSpan(text: 'I agree to the '),
                                      TextSpan(text: 'Terms of Service', style: PrismaText.link),
                                      const TextSpan(text: ' and '),
                                      TextSpan(text: 'Privacy Policy', style: PrismaText.link),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        _staggered(
                          start: 0.46,
                          end: 0.82,
                          child: PrismaButton(
                            label: 'Create Account',
                            loading: _loading,
                            onPressed: _handleRegister,
                          ),
                        ),
                        const SizedBox(height: 24),
                        _staggered(
                          start: 0.52,
                          end: 0.86,
                          child: const PrismaOrDivider(),
                        ),
                        const SizedBox(height: 20),
                        _staggered(
                          start: 0.56,
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
                        const SizedBox(height: 24),
                        _staggered(
                          start: 0.6,
                          end: 0.96,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Already have an account? ', style: PrismaText.subtitle),
                              GestureDetector(
                                onTap: () => Navigator.of(context).maybePop(),
                                child: Text('Sign in', style: PrismaText.link),
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