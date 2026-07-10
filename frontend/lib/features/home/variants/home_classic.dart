import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../auth/providers/auth_provider.dart';
import '../providers/home_provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/router/route_names.dart';
import '../../../core/utils/extensions.dart';
import '../../../core/widgets/loading_indicator.dart';

/// VARIANT A — Classic Home Screen
///
/// A simple placeholder demonstrating:
///   - Reading the current user from [currentUserProvider]
///   - Triggering logout via [authProvider.notifier]
class HomeClassicScreen extends ConsumerWidget {
  const HomeClassicScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final authState = ref.watch(authProvider);

    // While logout is processing, show a spinner.
    if (authState.isLoading) {
      return const Scaffold(body: AppLoadingIndicator());
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppStrings.appName,
          style: context.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          // Logout button
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            tooltip: AppStrings.logoutButton,
            onPressed: () async {
              await ref.read(authProvider.notifier).logout();
              if (context.mounted) context.go(RouteNames.login);
            },
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Welcome card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.primary, AppColors.primaryLight],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.waving_hand_rounded,
                      color: Colors.white,
                      size: 32,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '${AppStrings.welcomePrefix}${user?.name.isNotEmpty == true ? user!.name : 'there'}!',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    if (user?.email.isNotEmpty == true) ...[
                      const SizedBox(height: 4),
                      Text(
                        user!.email,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white.withValues(alpha: 0.8),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 40),

              // Placeholder for your actual content
              Text(
                'Your app content goes here',
                style: context.textTheme.bodyLarge?.copyWith(
                  color: AppColors.textMedium,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Replace this screen with your main feature.',
                style: context.textTheme.bodySmall?.copyWith(
                  color: AppColors.textMedium,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
