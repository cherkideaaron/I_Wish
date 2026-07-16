import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'register_lumora.dart';

class LoginLumora extends StatefulWidget {
  const LoginLumora({super.key});

  @override
  State<LoginLumora> createState() => _LoginLumoraState();
}

class _LoginLumoraState extends State<LoginLumora> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 1400));
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutExpo),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) {
          setState(() => _isLoading = false);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Welcome back ✨')),
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1C0F1A), Color(0xFF2C1B2A), Color(0xFF3A2A38)],
          ),
        ),
        child: Stack(
          children: [
            // Warm glow orb
            Positioned(
              top: 80,
              right: 40,
              child: Container(
                width: 220,
                height: 220,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [Colors.amber.withOpacity(0.25), Colors.transparent],
                  ),
                ),
              ),
            ),

            SafeArea(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 40),
                    child: Container(
                      constraints: const BoxConstraints(maxWidth: 400),
                      child: Column(
                        children: [
                          const SizedBox(height: 20),
                          // Logo
                          Container(
                            padding: const EdgeInsets.all(18),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: const LinearGradient(colors: [Color(0xFFD4A017), Color(0xFFB76E4D)]),
                              boxShadow: [
                                BoxShadow(color: Colors.amber.withOpacity(0.5), blurRadius: 40, spreadRadius: 8),
                              ],
                            ),
                            child: const Icon(Icons.star_rounded, size: 52, color: Colors.white),
                          ),
                          const SizedBox(height: 32),

                          Text(
                            "Good to see you",
                            style: GoogleFonts.outfit(
                              fontSize: 34,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              height: 1.1,
                            ),
                          ),
                          Text(
                            "again",
                            style: GoogleFonts.outfit(
                              fontSize: 34,
                              fontWeight: FontWeight.w300,
                              color: const Color(0xFFFFD8A8),
                            ),
                          ),

                          const SizedBox(height: 48),

                          // Card
                          Container(
                            padding: const EdgeInsets.all(32),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.06),
                              borderRadius: BorderRadius.circular(32),
                              border: Border.all(color: Colors.white.withOpacity(0.12), width: 1),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.4),
                                  blurRadius: 50,
                                  offset: const Offset(0, 20),
                                ),
                                BoxShadow(
                                  color: Colors.amber.withOpacity(0.08),
                                  blurRadius: 30,
                                  offset: const Offset(0, -10),
                                ),
                              ],
                            ),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  _buildLumoraField(
                                    controller: _emailController,
                                    label: "Email",
                                    icon: Icons.mail_outline,
                                    validator: (v) => v!.contains('@') ? null : "Valid email required",
                                  ),
                                  const SizedBox(height: 28),
                                  _buildLumoraField(
                                    controller: _passwordController,
                                    label: "Password",
                                    icon: Icons.lock_outline,
                                    obscureText: _obscurePassword,
                                    suffix: IconButton(
                                      icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility, color: Colors.white70),
                                      onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                                    ),
                                    validator: (v) => v!.length >= 6 ? null : "Password too short",
                                  ),

                                  const SizedBox(height: 16),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: TextButton(
                                      onPressed: () {},
                                      child: const Text("Forgot Password?", style: TextStyle(color: Color(0xFFFFD8A8))),
                                    ),
                                  ),

                                  const SizedBox(height: 40),

                                  // Animated Button
                                  GestureDetector(
                                    onTapDown: (_) => setState(() {}),
                                    onTapUp: (_) => _handleLogin(),
                                    child: AnimatedContainer(
                                      duration: const Duration(milliseconds: 150),
                                      width: double.infinity,
                                      height: 62,
                                      decoration: BoxDecoration(
                                        gradient: const LinearGradient(colors: [Color(0xFFD4A017), Color(0xFF9C5F2E)]),
                                        borderRadius: BorderRadius.circular(20),
                                        boxShadow: [
                                          BoxShadow(color: const Color(0xFFD4A017).withOpacity(0.5), blurRadius: 25, offset: const Offset(0, 12)),
                                        ],
                                      ),
                                      child: Center(
                                        child: _isLoading
                                            ? const CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5)
                                            : Text(
                                                "SIGN IN",
                                                style: GoogleFonts.outfit(
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.w700,
                                                  letterSpacing: 1.5,
                                                  color: Colors.white,
                                                ),
                                              ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(height: 40),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text("New here? ", style: TextStyle(color: Colors.white70)),
                              TextButton(
                                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RegisterLumora())),
                                child: const Text("Create account", style: TextStyle(color: Color(0xFFFFD8A8), fontWeight: FontWeight.w600)),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLumoraField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscureText = false,
    Widget? suffix,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.outfit(fontSize: 14, color: Colors.white70, fontWeight: FontWeight.w500)),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.08),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withOpacity(0.15)),
          ),
          child: TextFormField(
            controller: controller,
            obscureText: obscureText,
            validator: validator,
            style: const TextStyle(color: Colors.white, fontSize: 16),
            decoration: InputDecoration(
              prefixIcon: Icon(icon, color: Colors.white60),
              suffixIcon: suffix,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
            ),
          ),
        ),
      ],
    );
  }
}