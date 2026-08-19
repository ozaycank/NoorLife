import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../../shared/widgets/loading_indicator.dart';
import '../../application/auth_providers.dart';
import '../../domain/entities/auth_user.dart';

class SplashAuthDecisionScreen extends ConsumerStatefulWidget {
  const SplashAuthDecisionScreen({super.key});

  @override
  ConsumerState<SplashAuthDecisionScreen> createState() =>
      _SplashAuthDecisionScreenState();
}

class _SplashAuthDecisionScreenState
    extends ConsumerState<SplashAuthDecisionScreen> {
  bool _isNavigating = false;

  void _handleNavigation(AsyncValue<AuthUser?> state) {
    if (_isNavigating || !mounted) return;

    state.whenOrNull(
      data: (user) {
        _isNavigating = true;
        if (user == null) {
          context.go(AppRoutes.login);
        } else if (!user.isAnonymous && !user.isEmailVerified) {
          context.go(AppRoutes.emailVerification);
        } else {
          context.go(AppRoutes.home);
        }
      },
      error: (_, __) {
        _isNavigating = true;
        context.go(AppRoutes.login);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // 1. Listen for any future state changes continuously
    ref.listen<AsyncValue<AuthUser?>>(
      authStateChangesProvider,
      (_, next) => _handleNavigation(next),
    );

    // 2. Safely capture the exact immediate state if it's already resolved upon drawing
    final authState = ref.watch(authStateChangesProvider);
    if (!authState.isLoading) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _handleNavigation(authState);
      });
    }

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.mosque, size: 80, color: Colors.green),
            const SizedBox(height: 24),
            Text(
              'NoorLife',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 32),
            const LoadingIndicator(),
          ],
        ),
      ),
    );
  }
}
