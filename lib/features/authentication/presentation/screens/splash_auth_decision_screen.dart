import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../../shared/widgets/loading_indicator.dart';
import '../../application/auth_providers.dart';

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
    _decideNavigation();
  }

  Future<void> _decideNavigation() async {
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
      loading: () {},
      error: (_, __) {
        if (mounted) {
          context.go(AppRoutes.login);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
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
