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

/// VARIANT B — Split layout
///
/// On wide screens (≥ [AppDimensions.splitLayoutBreakpoint]):
///   Left panel  → branding / illustration
///   Right panel → login form
///
/// On narrow screens (phone):
///   Falls back to the full-screen classic form (same UI as Variant A).
class LoginSplitScreen extends ConsumerStatefulWidget {
  const LoginSplitScreen({super.key});

  @override
  ConsumerState<LoginSplitScreen> createState() => _LoginSplitScreenState();
}

class _LoginSplitScreenState extends ConsumerState<LoginSplitScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    await ref
        .read(authProvider.notifier)
        .login(_emailCtrl.text.trim(), _passwordCtrl.text);
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
    final isWide = context.screenWidth >= AppDimensions.splitLayoutBreakpoint;

    return Scaffold(
      body: isWide
          ? _buildSplitLayout(isLoading)
          : _buildNarrowLayout(isLoading),
    );
  }

  Widget _buildSplitLayout(bool isLoading) {
    return Row(
      children: [
        // ─── Left: Branding panel ──────────────────────────────────────
        Expanded(
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppColors.primaryDark, AppColors.primary],
              ),
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(48),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.star_rounded,
                      size: 80,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      AppStrings.appName,
                      style: const TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      AppStrings.tagline,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white.withValues(alpha: 0.8),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),

        // ─── Right: Form panel ────────────────────────────────────────
        Expanded(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppDimensions.paddingXLarge),
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: AppDimensions.formMaxWidth,
                ),
                child: _buildForm(isLoading),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNarrowLayout(bool isLoading) {
    return SafeArea(
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppDimensions.paddingLarge),
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: AppDimensions.formMaxWidth,
            ),
            child: _buildForm(isLoading),
          ),
        ),
      ),
    );
  }

  Widget _buildForm(bool isLoading) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            AppStrings.loginTitle,
            style: context.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            AppStrings.loginSubtitle,
            style: context.textTheme.bodyMedium?.copyWith(
              color: AppColors.textMedium,
            ),
          ),
          const SizedBox(height: 36),
          AppTextField(
            controller: _emailCtrl,
            label: AppStrings.emailLabel,
            hint: AppStrings.emailHint,
            keyboardType: TextInputType.emailAddress,
            prefixIcon: const Icon(Icons.email_outlined),
            validator: Validators.email,
          ),
          const SizedBox(height: 16),
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
              onPressed: () =>
                  setState(() => _obscurePassword = !_obscurePassword),
            ),
            textInputAction: TextInputAction.done,
            onFieldSubmitted: (_) => _submit(),
            validator: Validators.password,
          ),
          const SizedBox(height: 28),
          AppButton(
            label: AppStrings.loginButton,
            onPressed: isLoading ? null : _submit,
            isLoading: isLoading,
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                AppStrings.dontHaveAccount,
                style: context.textTheme.bodyMedium,
              ),
              GestureDetector(
                onTap: () => context.push(RouteNames.register),
                child: const Text(
                  AppStrings.signUpLink,
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
    );
  }
}
