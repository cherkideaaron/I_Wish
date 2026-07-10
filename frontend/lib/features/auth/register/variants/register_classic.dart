import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/auth_provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/utils/validators.dart';
import '../../../../shared/widgets/buttons/app_button.dart';
import '../../../../shared/widgets/cards/app_text_field.dart';

/// VARIANT A — Classic stacked card
///
/// All fields on one page: Name → Email → Password → Confirm.
class RegisterClassicScreen extends ConsumerStatefulWidget {
  const RegisterClassicScreen({super.key});

  @override
  ConsumerState<RegisterClassicScreen> createState() =>
      _RegisterClassicScreenState();
}

class _RegisterClassicScreenState extends ConsumerState<RegisterClassicScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    await ref.read(authProvider.notifier).register(
          _nameCtrl.text.trim(),
          _emailCtrl.text.trim(),
          _passwordCtrl.text,
        );
        
    if (mounted && !ref.read(authProvider).hasError) {
      context.showSnackbar('Registration successful! Please log in.');
      context.pop(); // Return to Login
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(authProvider, (_, next) {
      next.whenOrNull(
        data: (user) {
          if (user != null) context.go(RouteNames.home);
        },
        error: (e, _) => context.showSnackbar(e.toString(), isError: true),
      );
    });

    final isLoading = ref.watch(authProvider).isLoading;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppDimensions.paddingLarge),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: AppDimensions.formMaxWidth,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // ─── Logo ─────────────────────────────────────────
                    Center(
                      child: Container(
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Icon(
                          Icons.star_rounded,
                          size: 40,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    Text(
                      AppStrings.registerTitle,
                      style: context.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      AppStrings.registerSubtitle,
                      style: context.textTheme.bodyMedium?.copyWith(
                        color: AppColors.textMedium,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),

                    // ─── Name ─────────────────────────────────────────
                    AppTextField(
                      controller: _nameCtrl,
                      label: AppStrings.nameLabel,
                      hint: AppStrings.nameHint,
                      keyboardType: TextInputType.name,
                      prefixIcon: const Icon(Icons.person_outline),
                      validator: Validators.name,
                    ),
                    const SizedBox(height: 16),

                    // ─── Email ────────────────────────────────────────
                    AppTextField(
                      controller: _emailCtrl,
                      label: AppStrings.emailLabel,
                      hint: AppStrings.emailHint,
                      keyboardType: TextInputType.emailAddress,
                      prefixIcon: const Icon(Icons.email_outlined),
                      validator: Validators.email,
                    ),
                    const SizedBox(height: 16),

                    // ─── Password ─────────────────────────────────────
                    AppTextField(
                      controller: _passwordCtrl,
                      label: AppStrings.passwordLabel,
                      hint: AppStrings.passwordHint,
                      obscureText: _obscurePassword,
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                        ),
                        onPressed: () => setState(
                          () => _obscurePassword = !_obscurePassword,
                        ),
                      ),
                      validator: Validators.password,
                    ),
                    const SizedBox(height: 16),

                    // ─── Confirm Password ─────────────────────────────
                    AppTextField(
                      controller: _confirmCtrl,
                      label: AppStrings.confirmPasswordLabel,
                      hint: AppStrings.confirmPasswordHint,
                      obscureText: _obscureConfirm,
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureConfirm
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                        ),
                        onPressed: () =>
                            setState(() => _obscureConfirm = !_obscureConfirm),
                      ),
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (_) => _submit(),
                      validator: (v) =>
                          Validators.confirmPassword(v, _passwordCtrl.text),
                    ),
                    const SizedBox(height: 28),

                    AppButton(
                      label: AppStrings.registerButton,
                      onPressed: isLoading ? null : _submit,
                      isLoading: isLoading,
                    ),
                    const SizedBox(height: 20),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          AppStrings.alreadyHaveAccount,
                          style: context.textTheme.bodyMedium,
                        ),
                        GestureDetector(
                          onTap: () => context.pop(),
                          child: const Text(
                            AppStrings.signInLink,
                            style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
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
    );
  }
}
