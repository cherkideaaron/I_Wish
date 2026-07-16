import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RegisterEchelon extends StatefulWidget {
  const RegisterEchelon({super.key});

  @override
  State<RegisterEchelon> createState() => _RegisterEchelonState();
}

class _RegisterEchelonState extends State<RegisterEchelon> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 1100));
    _slideAnimation = Tween<double>(begin: 80, end: 0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleRegister() {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) {
          setState(() => _isLoading = false);
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Account created ✓")));
          Navigator.pop(context);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: Stack(
        children: [
          // Subtle vertical neon lines
          Positioned.fill(
            child: Opacity(
              opacity: 0.08,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.transparent, Colors.cyan.withOpacity(0.6), Colors.transparent],
                    stops: const [0.2, 0.5, 0.8],
                  ),
                ),
              ),
            ),
          ),

          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 420),
                  child: Column(
                    children: [
                      const SizedBox(height: 40),
                      // Logo
                      Container(
                        height: 68,
                        width: 68,
                        decoration: BoxDecoration(
                          border: Border.all(color: const Color(0xFF00F5FF), width: 2.5),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: const Center(
                          child: Text(
                            "E",
                            style: TextStyle(fontSize: 42, fontWeight: FontWeight.w900, color: Color(0xFF00F5FF)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 48),

                      Text(
                        "Join Echelon",
                        style: GoogleFonts.inter(
                          fontSize: 36,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          letterSpacing: -1.2,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Create an account to continue",
                        style: GoogleFonts.inter(fontSize: 16, color: Colors.white60),
                      ),

                      const SizedBox(height: 60),

                      AnimatedBuilder(
                        animation: _slideAnimation,
                        builder: (context, child) {
                          return Transform.translate(
                            offset: Offset(0, _slideAnimation.value),
                            child: Opacity(
                              opacity: 1 - (_slideAnimation.value / 80),
                              child: Container(
                                padding: const EdgeInsets.all(36),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.03),
                                  borderRadius: BorderRadius.circular(24),
                                  border: Border.all(color: Colors.white.withOpacity(0.08)),
                                ),
                                child: Form(
                                  key: _formKey,
                                  child: Column(
                                    children: [
                                      _buildEchelonField(
                                        controller: _nameController,
                                        label: "FULL NAME",
                                        icon: Icons.person_outline,
                                        validator: (v) => v!.isEmpty ? "Name is required" : null,
                                      ),
                                      const SizedBox(height: 28),
                                      _buildEchelonField(
                                        controller: _emailController,
                                        label: "EMAIL",
                                        icon: Icons.alternate_email,
                                        validator: (v) => v!.contains('@') ? null : "Invalid email",
                                      ),
                                      const SizedBox(height: 28),
                                      _buildEchelonField(
                                        controller: _passwordController,
                                        label: "PASSWORD",
                                        icon: Icons.lock_outline,
                                        obscureText: _obscurePassword,
                                        suffix: IconButton(
                                          icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility, color: Colors.white54),
                                          onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                                        ),
                                        validator: (v) => v!.length >= 6 ? null : "Too short",
                                      ),

                                      const SizedBox(height: 40),

                                      // Neon Button
                                      GestureDetector(
                                        onTap: _isLoading ? null : _handleRegister,
                                        child: AnimatedContainer(
                                          duration: const Duration(milliseconds: 200),
                                          width: double.infinity,
                                          height: 64,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(20),
                                            gradient: const LinearGradient(
                                              colors: [Color(0xFF00F5FF), Color(0xFF9D4EDD)],
                                            ),
                                            boxShadow: [
                                              BoxShadow(color: const Color(0xFF00F5FF).withOpacity(0.6), blurRadius: 30, spreadRadius: 2),
                                            ],
                                          ),
                                          child: Center(
                                            child: _isLoading
                                                ? const SizedBox(width: 26, height: 26, child: CircularProgressIndicator(color: Colors.black87, strokeWidth: 3))
                                                : Text(
                                                    "CREATE ACCOUNT",
                                                    style: GoogleFonts.inter(
                                                      fontSize: 17,
                                                      fontWeight: FontWeight.w700,
                                                      color: Colors.black87,
                                                      letterSpacing: 2,
                                                    ),
                                                  ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 48),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Already have an account? ", style: GoogleFonts.inter(color: Colors.white60)),
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text("Sign in", style: GoogleFonts.inter(color: const Color(0xFF00F5FF), fontWeight: FontWeight.w600)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEchelonField({
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
        Text(label, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, letterSpacing: 1.5, color: Colors.white70)),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.04),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: TextFormField(
            controller: controller,
            obscureText: obscureText,
            validator: validator,
            style: const TextStyle(color: Colors.white, fontSize: 16),
            decoration: InputDecoration(
              prefixIcon: Icon(icon, color: const Color(0xFF00F5FF)),
              suffixIcon: suffix,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            ),
          ),
        ),
      ],
    );
  }
}
