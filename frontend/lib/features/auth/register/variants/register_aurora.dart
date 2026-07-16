// register_aurora.dart
//
// "Aurora" variant — Registration screen.
// Shares the exact visual language of login_aurora.dart: glass card,
// gradient blobs, staggered entrance, animated fields/buttons/checkbox.
//
// Usage:
//   MaterialApp(home: const RegisterAurora())
//
// Dependency (pubspec.yaml):
//   google_fonts: ^6.2.1

import 'package:flutter/material.dart';

import 'aurora_widgets.dart';

class RegisterAurora extends StatefulWidget {
  const RegisterAurora({super.key});

  @override
  State<RegisterAurora> createState() => _RegisterAuroraState();
}

class _RegisterAuroraState extends State<RegisterAurora> with SingleTickerProviderStateMixin {
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
      duration: const Duration(milliseconds: 1100),
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

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_agreedToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: AuroraPalette.bgBottom,
          content: Text('Please agree to the Terms & Privacy Policy', style: AuroraText.body),
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
                          end: 0.4,
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () => Navigator.of(context).maybePop(),
                                child: Container(
                                  height: 40,
                                  width: 40,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white.withOpacity(0.06),
                                    border: Border.all(color: Colors.white.withOpacity(0.14)),
                                  ),
                                  child: const Icon(
                                    Icons.arrow_back_ios_new_rounded,
                                    size: 16,
                                    color: AuroraPalette.textPrimary,
                                  ),
                                ),
                              ),
                              const Spacer(),
                              const AuroraLogoBadge(icon: Icons.person_add_alt_1_rounded),
                              const Spacer(),
                              const SizedBox(width: 40),
                            ],
                          ),
                        ),
                        const SizedBox(height: 22),
                        _staggered(
                          start: 0.05,
                          end: 0.48,
                          child: Text('Create account', style: AuroraText.display),
                        ),
                        const SizedBox(height: 8),
                        _staggered(
                          start: 0.1,
                          end: 0.5,
                          child: Text(
                            'Join us and start your journey today',
                            style: AuroraText.subtitle,
                          ),
                        ),
                        const SizedBox(height: 30),
                        _staggered(
                          start: 0.16,
                          end: 0.58,
                          child: AuroraTextField(
                            controller: _nameController,
                            label: 'Full name',
                            icon: Icons.person_outline_rounded,
                            validator: (v) {
                              if (v == null || v.trim().isEmpty) return 'Name is required';
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(height: 16),
                        _staggered(
                          start: 0.22,
                          end: 0.64,
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
                          end: 0.7,
                          child: AuroraTextField(
                            controller: _passwordController,
                            label: 'Password',
                            icon: Icons.lock_outline_rounded,
                            obscureText: _obscurePassword,
                            suffix: IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                                color: AuroraPalette.textMuted,
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
                        const SizedBox(height: 16),
                        _staggered(
                          start: 0.34,
                          end: 0.76,
                          child: AuroraTextField(
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
                                color: AuroraPalette.textMuted,
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
                          end: 0.8,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AuroraCheckbox(
                                value: _agreedToTerms,
                                onChanged: (v) => setState(() => _agreedToTerms = v),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text.rich(
                                  TextSpan(
                                    style: AuroraText.label,
                                    children: [
                                      const TextSpan(text: 'I agree to the '),
                                      TextSpan(text: 'Terms of Service', style: AuroraText.link),
                                      const TextSpan(text: ' and '),
                                      TextSpan(text: 'Privacy Policy', style: AuroraText.link),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 26),
                        _staggered(
                          start: 0.46,
                          end: 0.85,
                          child: AuroraButton(
                            label: 'Create Account',
                            loading: _loading,
                            onPressed: _handleRegister,
                          ),
                        ),
                        const SizedBox(height: 26),
                        _staggered(
                          start: 0.5,
                          end: 0.88,
                          child: const AuroraOrDivider(),
                        ),
                        const SizedBox(height: 22),
                        _staggered(
                          start: 0.54,
                          end: 0.92,
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
                        const SizedBox(height: 26),
                        _staggered(
                          start: 0.58,
                          end: 0.96,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Already have an account? ', style: AuroraText.subtitle),
                              GestureDetector(
                                onTap: () => Navigator.of(context).maybePop(),
                                child: Text('Sign in', style: AuroraText.link),
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