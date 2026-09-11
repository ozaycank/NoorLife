import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:noor_life/core/routing/app_routes.dart';
import 'package:noor_life/features/authentication/application/auth_providers.dart';
import 'package:noor_life/shared/design_system/tokens/app_spacing.dart';
import 'package:noor_life/shared/widgets/loading_indicator.dart';

class SplashAuthDecisionScreen extends ConsumerStatefulWidget {
  const SplashAuthDecisionScreen({super.key});

  @override
  ConsumerState<SplashAuthDecisionScreen> createState() =>
      _SplashAuthDecisionScreenState();
}

class _SplashAuthDecisionScreenState
    extends ConsumerState<SplashAuthDecisionScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    // Minimum splash screen duration for brand visibility
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    final authState = ref.read(authStateChangesProvider);

    authState.when(
      data: (user) {
        if (user == null) {
          context.go(AppRoutes.login);
        } else if (!user.isAnonymous && !user.isEmailVerified) {
          context.go(AppRoutes.emailVerification);
        } else {
          context.go(AppRoutes.home);
        }
      },
      loading: () {}, // Let the UI spin
      error: (_, __) => context.go(AppRoutes.login),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.mosque,
              size: 80,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'IslamFull',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: AppSpacing.xxl),
            const LoadingIndicator(),
          ],
        ),
      ),
    );
  }
}
