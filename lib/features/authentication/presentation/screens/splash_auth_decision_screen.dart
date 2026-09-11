import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:noor_life/core/routing/app_routes.dart';
import 'package:noor_life/features/authentication/application/auth_providers.dart';
import 'package:noor_life/features/authentication/domain/entities/auth_user.dart';
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
  bool _isNavigating = false;
  bool _minTimeElapsed = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  Future<void> _startTimer() async {
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      _minTimeElapsed = true;
      _checkAndNavigate(ref.read(authStateChangesProvider));
    }
  }

  void _checkAndNavigate(AsyncValue<AuthUser?> state) {
    if (_isNavigating || !_minTimeElapsed || !mounted) return;

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
    ref.listen<AsyncValue<AuthUser?>>(
      authStateChangesProvider,
      (_, next) => _checkAndNavigate(next),
    );

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
