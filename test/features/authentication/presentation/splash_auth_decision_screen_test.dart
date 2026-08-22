import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:noor_life/core/routing/app_routes.dart';
import 'package:noor_life/features/authentication/application/auth_providers.dart';
import 'package:noor_life/features/authentication/domain/entities/auth_user.dart';
import 'package:noor_life/features/authentication/presentation/screens/splash_auth_decision_screen.dart';
import 'package:noor_life/shared/widgets/loading_indicator.dart';

void main() {
  Widget createTestWidget(AsyncValue<AuthUser?> authState, GoRouter router) {
    return ProviderScope(
      overrides: [
        authStateChangesProvider.overrideWith(
          (ref) => authState.when<Stream<AuthUser?>>(
            data: Stream.value,
            loading: Stream.empty,
            error: Stream.error,
          ),
        ),
      ],
      child: MaterialApp.router(
        routerConfig: router,
      ),
    );
  }

  GoRouter createRouter(String initialLocation) {
    return GoRouter(
      initialLocation: initialLocation,
      routes: [
        GoRoute(
          path: AppRoutes.splash,
          builder: (context, state) => const SplashAuthDecisionScreen(),
        ),
        GoRoute(
          path: AppRoutes.login,
          builder: (context, state) => const Scaffold(body: Text('Login')),
        ),
        GoRoute(
          path: AppRoutes.home,
          builder: (context, state) => const Scaffold(body: Text('Home')),
        ),
        GoRoute(
          path: AppRoutes.emailVerification,
          builder: (context, state) => const Scaffold(body: Text('Verify')),
        ),
      ],
    );
  }

  group('SplashAuthDecisionScreen Reactive Navigation Tests', () {
    testWidgets('Loading state keeps splash visible', (tester) async {
      final router = createRouter(AppRoutes.splash);
      await tester.pumpWidget(
        createTestWidget(const AsyncValue.loading(), router),
      );

      expect(find.byType(LoadingIndicator), findsOneWidget);
      expect(find.text('Login'), findsNothing);
    });

    testWidgets('Null user navigates to Login', (tester) async {
      final router = createRouter(AppRoutes.splash);
      await tester.pumpWidget(
        createTestWidget(const AsyncValue.data(null), router),
      );
      await tester.pumpAndSettle();

      expect(find.text('Login'), findsOneWidget);
    });

    testWidgets('Anonymous user navigates to Home', (tester) async {
      final router = createRouter(AppRoutes.splash);
      const user = AuthUser(id: '1', isAnonymous: true, isEmailVerified: false);
      await tester.pumpWidget(
        createTestWidget(const AsyncValue.data(user), router),
      );
      await tester.pumpAndSettle();

      expect(find.text('Home'), findsOneWidget);
    });

    testWidgets('Verified user navigates to Home', (tester) async {
      final router = createRouter(AppRoutes.splash);
      const user = AuthUser(id: '1', isAnonymous: false, isEmailVerified: true);
      await tester.pumpWidget(
        createTestWidget(const AsyncValue.data(user), router),
      );
      await tester.pumpAndSettle();

      expect(find.text('Home'), findsOneWidget);
    });

    testWidgets('Unverified user navigates to Verification', (tester) async {
      final router = createRouter(AppRoutes.splash);
      const user = AuthUser(
        id: '1',
        isAnonymous: false,
        isEmailVerified: false,
      );
      await tester.pumpWidget(
        createTestWidget(const AsyncValue.data(user), router),
      );
      await tester.pumpAndSettle();

      expect(find.text('Verify'), findsOneWidget);
    });

    testWidgets('Error state navigates to Login', (tester) async {
      final router = createRouter(AppRoutes.splash);
      await tester.pumpWidget(
        createTestWidget(
          const AsyncValue.error('err', StackTrace.empty),
          router,
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Login'), findsOneWidget);
    });
  });
}
