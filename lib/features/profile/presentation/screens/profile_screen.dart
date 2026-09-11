import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:noor_life/core/extensions/context_extensions.dart';
import 'package:noor_life/core/routing/app_routes.dart';
import 'package:noor_life/shared/design_system/tokens/app_spacing.dart';
import 'package:noor_life/shared/widgets/app_card.dart';
import 'package:noor_life/shared/widgets/primary_button.dart';
import 'package:noor_life/shared/widgets/section_header.dart';
import 'package:noor_life/features/authentication/application/auth_providers.dart';
import 'package:noor_life/features/activity/application/activity_provider.dart';

final profileUserProvider = FutureProvider.autoDispose((ref) async {
  final authRepository = ref.read(authRepositoryProvider);
  final result = await authRepository.getCurrentUser();
  return result.$2; // User object, null if guest or missing
});

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final textTheme = context.textTheme;
    final colorScheme = context.colorScheme;

    final userAsync = ref.watch(profileUserProvider);
    final activityState = ref.watch(activityNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.profileTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => context.push(AppRoutes.settings),
            tooltip: l10n.settingsTitle,
          ),
          IconButton(
            icon: const Icon(Icons.logout_outlined),
            onPressed: () async {
              await ref.read(authControllerProvider.notifier).signOut();
              if (context.mounted) {
                context.go(AppRoutes.login);
              }
            },
            tooltip: l10n.logoutButton,
          ),
        ],
      ),
      body: SafeArea(
        child: userAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, __) => const Center(child: Text('Error loading profile')),
          data: (user) {
            final isGuest = user == null;
            final String safeName =
                user?.email?.split('@').first ?? 'IslamFull User';
            final displayName = isGuest ? l10n.profileGuest : safeName;
            final emailStr =
                isGuest ? l10n.profileGuestDesc : (user.email ?? '');

            return ListView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              children: [
                AppCard(
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 32,
                        backgroundColor: colorScheme.primaryContainer,
                        child: Icon(
                          isGuest ? Icons.person_outline : Icons.person,
                          size: 32,
                          color: colorScheme.onPrimaryContainer,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.lg),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              displayName,
                              style: textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: AppSpacing.xs),
                            Text(
                              emailStr,
                              style: textTheme.bodyMedium?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.xxl),
                SectionHeader(title: l10n.profileStatsSummary),
                AppCard(
                  child: Column(
                    children: [
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Icon(
                          Icons.local_fire_department,
                          color: colorScheme.primary,
                        ),
                        title: Text(
                          l10n.statsStreak,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        trailing: Text(
                          l10n.statsDays(
                            activityState.statistics?.currentStreak ?? 0,
                          ),
                          style: textTheme.titleMedium,
                        ),
                      ),
                      const Divider(height: 1),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Icon(
                          Icons.pie_chart,
                          color: colorScheme.primary,
                        ),
                        title: Text(
                          l10n.statsAvgCompletion,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        trailing: Text(
                          '${((activityState.statistics?.last7DaysCompletion ?? 0) * 100).toInt()}%',
                          style: textTheme.titleMedium,
                        ),
                      ),
                      const Divider(height: 1),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Icon(
                          Icons.auto_stories,
                          color: colorScheme.primary,
                        ),
                        title: Text(
                          l10n.statsQuranDays,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        trailing: Text(
                          l10n.statsDays(
                            activityState.statistics?.last7DaysQuran ?? 0,
                          ),
                          style: textTheme.titleMedium,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.xxl),
                if (isGuest)
                  PrimaryButton(
                    text: 'Sign Up / Sign In',
                    icon: Icons.login,
                    onPressed: () async {
                      await ref.read(authControllerProvider.notifier).signOut();
                      if (context.mounted) {
                        context.go(AppRoutes.register);
                      }
                    },
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
