import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/authentication/application/auth_providers.dart';
import '../../features/authentication/presentation/screens/email_verification_screen.dart';
import '../../features/authentication/presentation/screens/forgot_password_screen.dart';
import '../../features/authentication/presentation/screens/login_screen.dart';
import '../../features/authentication/presentation/screens/register_screen.dart';
import '../../features/authentication/presentation/screens/splash_auth_decision_screen.dart';
import '../../features/home/presentation/screens/home_placeholder_screen.dart';
import 'app_routes.dart';

class AppRouter {
  AppRouter._();

  static GoRouter createRouter(WidgetRef ref) {
    final authRepository = ref.read(authRepositoryProvider);

    return GoRouter(
      initialLocation: AppRoutes.splash,
      refreshListenable: GoRouterRefreshStream(
        authRepository.authStateChanges,
      ),
      redirect: (context, state) async {
        final (failure, user) = await authRepository.getCurrentUser();
        final isLoggedIn = failure == null && user != null;
        final currentPath = state.matchedLocation;

        final isAuthRoute = currentPath == AppRoutes.login ||
            currentPath == AppRoutes.register ||
            currentPath == AppRoutes.forgotPassword;

        if (currentPath == AppRoutes.splash) {
          return null;
        }

        if (!isLoggedIn && !isAuthRoute) {
          return AppRoutes.login;
        }

        if (isLoggedIn && isAuthRoute) {
          if (!user.isAnonymous && !user.isEmailVerified) {
            return AppRoutes.emailVerification;
          }
          return AppRoutes.home;
        }

        if (isLoggedIn &&
            !user.isAnonymous &&
            !user.isEmailVerified &&
            currentPath != AppRoutes.emailVerification) {
          return AppRoutes.emailVerification;
        }

        return null;
      },
      routes: [
        GoRoute(
          path: AppRoutes.splash,
          builder: (context, state) => const SplashAuthDecisionScreen(),
        ),
        GoRoute(
          path: AppRoutes.login,
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: AppRoutes.register,
          builder: (context, state) => const RegisterScreen(),
        ),
        GoRoute(
          path: AppRoutes.forgotPassword,
          builder: (context, state) => const ForgotPasswordScreen(),
        ),
        GoRoute(
          path: AppRoutes.emailVerification,
          builder: (context, state) => const EmailVerificationScreen(),
        ),
        GoRoute(
          path: AppRoutes.home,
          builder: (context, state) => const HomePlaceholderScreen(),
        ),
      ],
    );
  }
}
