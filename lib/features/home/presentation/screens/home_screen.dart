import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../../shared/design_system/tokens/app_spacing.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/error_state_widget.dart';
import '../../../../shared/widgets/section_header.dart';
import '../../../prayer/location/application/providers/location_notifier.dart';
import '../../../prayer/location/application/states/location_state.dart';
import '../../../prayer/prayer_times/application/providers/prayer_times_notifier.dart';
import '../../../prayer/prayer_times/presentation/providers/prayer_live_state_provider.dart';
import '../../../prayer/shared/presentation/utils/presentation_localizer.dart';
import '../../../prayer/shared/presentation/screens/prayer_loading_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  Future<void> _refreshData(BuildContext context, WidgetRef ref) async {
    final success = await ref
        .read(locationNotifierProvider.notifier)
        .acquireDeviceLocation();
    if (success && context.mounted) {
      await ref.read(prayerTimesNotifierProvider.notifier).refreshTimes();
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final colorScheme = context.colorScheme;
    final textTheme = context.textTheme;

    final prayerState = ref.watch(prayerTimesNotifierProvider);
    final locState = ref.watch(locationNotifierProvider);
    final liveState = ref.watch(prayerLiveStateProvider);

    if ((prayerState.isLoading ||
            locState.status == LocationStatus.requesting) &&
        prayerState.schedule == null) {
      return const PrayerLoadingScreen();
    }

    if (prayerState.failure != null && prayerState.schedule == null) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.homeTitle)),
        body: SafeArea(
          child: ErrorStateWidget(
            title: l10n.homePrayerError,
            message: prayerState.failure!.message,
            retryText: l10n.homePrayerRetry,
            onRetry: () => _refreshData(context, ref),
          ),
        ),
      );
    }

    final location = prayerState.location;
    final today = prayerState.schedule?.today;
    final rem = liveState.timeRemaining;
    final timeRemainingStr =
        '${rem.inHours.toString().padLeft(2, '0')}:${(rem.inMinutes % 60).toString().padLeft(2, '0')}';

    final formattedLocation = PresentationLocalizer.formatLocation(
      context: context,
      cityName: location?.cityName,
      subAdminArea: location?.countryName, // Generic sub assignment
      countryName: location?.countryName,
    );

    String formattedHijri = '-';
    if (today != null && today.hijriDateString != null) {
      final parts = today.hijriDateString!.split('-');
      if (parts.length == 3) {
        final day = parts[2];
        final monthIdx = int.tryParse(parts[1]);
        final year = parts[0];
        if (monthIdx != null) {
          final monthName =
              PresentationLocalizer.localizeHijriMonth(context, monthIdx);
          formattedHijri = '$day $monthName $year';
        }
      }
    }

    final nextPrayerLabel = liveState.nextPrayer != null
        ? PresentationLocalizer.localizePrayerNameRaw(
            context,
            liveState.nextPrayer!.name.name,
          )
        : '-';

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.homeTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => _refreshData(context, ref),
            tooltip: l10n.prayerRefreshButton,
          ),
        ],
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => _refreshData(context, ref),
          child: ListView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            children: [
              // 1. Header (Greeting & Location)
              Text(
                l10n.homeGreeting,
                style: textTheme.titleMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                formattedLocation,
                style: textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                formattedHijri,
                style: textTheme.titleMedium?.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),

              // 2. Next Prayer Hero
              AppCard(
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: Column(
                  children: [
                    Text(
                      l10n.nextPrayerHeader,
                      style: textTheme.titleSmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      nextPrayerLabel,
                      style: textTheme.displaySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      '${l10n.prayerRemainingTime}: $timeRemainingStr',
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),

              // 3. Quick Actions
              Row(
                children: [
                  Expanded(
                    child: _QuickActionCard(
                      icon: Icons.explore,
                      label: l10n.viewQibla,
                      onTap: () => context.push(AppRoutes.qibla),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: _QuickActionCard(
                      icon: Icons.settings,
                      label: l10n.openSettings,
                      onTap: () => context.push(AppRoutes.settings),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xxl),

              // 4. Today's Summary
              SectionHeader(title: l10n.homeToday),
              if (today != null)
                AppCard(
                  padding: EdgeInsets.zero,
                  child: Column(
                    children: today.prayerTimes.map((pt) {
                      final isNext = liveState.nextPrayer?.name == pt.name;
                      return ListTile(
                        title: Text(
                          PresentationLocalizer.localizePrayerNameRaw(
                            context,
                            pt.name.name,
                          ),
                          style: textTheme.bodyLarge?.copyWith(
                            fontWeight:
                                isNext ? FontWeight.bold : FontWeight.normal,
                            color: isNext ? colorScheme.primary : null,
                          ),
                        ),
                        trailing: Text(
                          '${pt.time.hour.toString().padLeft(2, '0')}:${pt.time.minute.toString().padLeft(2, '0')}',
                          style: textTheme.bodyLarge?.copyWith(
                            fontWeight:
                                isNext ? FontWeight.bold : FontWeight.w500,
                            color: isNext ? colorScheme.primary : null,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              const SizedBox(height: AppSpacing.xxl),

              // 5. Future Modules Indicator
              SectionHeader(title: l10n.homeComingSoon),
              AppCard(
                child: Row(
                  children: [
                    Icon(Icons.menu_book, color: colorScheme.onSurfaceVariant),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Text(
                        l10n.quranTitle,
                        style: textTheme.bodyLarge?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _QuickActionCard({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textTheme = context.textTheme;

    return AppCard(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 36, color: colorScheme.primary),
          const SizedBox(height: AppSpacing.sm),
          Text(
            label,
            textAlign: TextAlign.center,
            style: textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
