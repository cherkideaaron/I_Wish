// ┌─────────────────────────────────────────────────────────────────────────┐
// │  HOME SCREEN (ROLE ROUTER)                                              │
// │                                                                         │
// │  HOW IT WORKS:                                                          │
// │    This screen looks at the current user's role and returns             │
// │    a completely different screen variant based on who they are!         │
// └─────────────────────────────────────────────────────────────────────────┘
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'providers/home_provider.dart';
import 'variants/home_classic.dart';   // Used for regular users
import 'variants/home_dashboard.dart'; // Used for admins

/// Router entry-point for the home feature based on RBAC.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. Get the current logged-in user
    final user = ref.watch(currentUserProvider);

    // 2. Check their role and route to the correct variant!
    if (user?.role == 'admin') {
      return const HomeDashboardScreen(); // Admins see the Dashboard Grid
    } else {
      return const HomeClassicScreen();   // Regular users see the Classic Card
    }
  }
}
