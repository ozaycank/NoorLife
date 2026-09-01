import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/activity/presentation/screens/activity_screen.dart';
import '../../features/authentication/application/auth_providers.dart';
import '../../features/authentication/presentation/screens/email_verification_screen.dart';
import '../../features/authentication/presentation/screens/forgot_password_screen.dart';
import '../../features/authentication/presentation/screens/login_screen.dart';
import '../../features/authentication/presentation/screens/register_screen.dart';
import '../../features/authentication/presentation/screens/splash_auth_decision_screen.dart';
import '../../features/prayer/shared/presentation/screens/prayer_home_screen.dart';
import '../../features/profile/presentation/screens/profile_placeholder_screen.dart';
import '../../features/shell/presentation/screens/app_shell_screen.dart';
import '../../features/settings/presentation/screens/settings_screen.dart';
import '../di/injection_container.dart';
import '../logging/logger_service.dart';
import 'app_navigation_observer.dart';
import 'app_routes.dart';
import '../../features/prayer/qibla/presentation/qibla_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/quran/presentation/screens/quran_home_screen.dart';
import '../../features/quran/presentation/screens/surah_detail_placeholder_screen.dart';
import '../../features/quran/presentation/screens/quran_bookmarks_screen.dart';

class AppRouter {
  AppRouter._();

  static final GlobalKey<NavigatorState> _rootNavigatorKey =
      GlobalKey<NavigatorState>();

  static GoRouter createRouter(WidgetRef ref) {
    final authRepository = ref.read(authRepositoryProvider);

    return GoRouter(
      navigatorKey: _rootNavigatorKey,
      initialLocation: AppRoutes.splash,
      observers: [
        AppNavigationObserver(getIt<LoggerService>()),
      ],
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
          parentNavigatorKey: _rootNavigatorKey,
          path: AppRoutes.settings,
          builder: (context, state) => const SettingsScreen(),
        ),
        GoRoute(
          parentNavigatorKey: _rootNavigatorKey,
          path: AppRoutes.qibla,
          builder: (context, state) => const QiblaScreen(),
        ),
        StatefulShellRoute.indexedStack(
          builder: (context, state, navigationShell) {
            return AppShellScreen(navigationShell: navigationShell);
          },
          branches: [
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: AppRoutes.home,
                  builder: (context, state) => const HomeScreen(),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: AppRoutes.prayer,
                  builder: (context, state) => const PrayerHomeScreen(),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: AppRoutes.quran,
                  builder: (context, state) => const QuranHomeScreen(),
                  routes: [
                    GoRoute(
                      path: 'bookmarks',
                      builder: (context, state) => const QuranBookmarksScreen(),
                    ),
                    GoRoute(
                      path: 'surah/:id',
                      builder: (context, state) {
                        final idStr = state.pathParameters['id'];
                        final id = int.tryParse(idStr ?? '1') ?? 1;
                        final ayah = int.tryParse(
                          state.uri.queryParameters['ayah'] ?? '',
                        );

                        return SurahDetailPlaceholderScreen(
                          surahNumber: id,
                          jumpToAyah: ayah,
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: AppRoutes.activity,
                  builder: (context, state) => const ActivityScreen(),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: AppRoutes.profile,
                  builder: (context, state) => const ProfilePlaceholderScreen(),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
