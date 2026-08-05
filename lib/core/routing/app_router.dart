import 'package:go_router/go_router.dart';
import 'package:noor_life/core/routing/app_routes.dart';
import 'package:noor_life/features/authentication/presentation/screens/email_verification_screen.dart';
import 'package:noor_life/features/authentication/presentation/screens/forgot_password_screen.dart';
import 'package:noor_life/features/authentication/presentation/screens/login_screen.dart';
import 'package:noor_life/features/authentication/presentation/screens/register_screen.dart';
import 'package:noor_life/features/authentication/presentation/screens/splash_auth_decision_screen.dart';
import 'package:noor_life/features/home/presentation/home_placeholder_screen.dart';

class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.splash,
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
