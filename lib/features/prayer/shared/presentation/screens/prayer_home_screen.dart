import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../shared/design_system/tokens/app_spacing.dart';
import '../../../../../shared/widgets/section_header.dart';
import '../../../prayer_times/application/providers/prayer_times_notifier.dart';
import '../../../prayer_times/presentation/providers/prayer_live_state_provider.dart';
import '../../../prayer_times/presentation/widgets/prayer_card.dart';
import '../widgets/prayer_error_widget.dart';
import '../widgets/prayer_header.dart';
import 'prayer_loading_screen.dart';

class PrayerHomeScreen extends ConsumerWidget {
  const PrayerHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(prayerTimesNotifierProvider);
    final liveState = ref.watch(prayerLiveStateProvider);
    final l10n = context.l10n;

    if (state.isLoading && state.schedule == null) {
      return const PrayerLoadingScreen();
    }

    if (state.failure != null && state.schedule == null) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.prayerTitle)),
        body: SafeArea(
          child: PrayerErrorWidget(
            message: state.failure!.message,
            onRetry: () =>
                ref.read(prayerTimesNotifierProvider.notifier).loadTimes(),
          ),
        ),
      );
    }

    final today = state.schedule?.today;
    final location = state.location;

    final rem = liveState.timeRemaining;
    final timeRemainingStr =
        '${rem.inHours.toString().padLeft(2, '0')}:${(rem.inMinutes % 60).toString().padLeft(2, '0')}';

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.prayerTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () =>
                ref.read(prayerTimesNotifierProvider.notifier).refreshTimes(),
            tooltip: l10n.prayerRefreshButton,
          ),
        ],
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () =>
              ref.read(prayerTimesNotifierProvider.notifier).refreshTimes(),
          child: ListView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            children: [
              if (today != null && location != null)
                PrayerHeader(
                  cityName: location.cityName,
                  countryName: location.countryName,
                  hijriDate: today.hijriDateString ?? '-',
                  nextPrayerName: liveState.nextPrayer?.name.name.toUpperCase(),
                  timeRemaining: timeRemainingStr,
                ),
              const SizedBox(height: AppSpacing.lg),
              SectionHeader(title: l10n.prayerTitle),
              if (today != null)
                PrayerCard(
                  prayerTimes: today.prayerTimes,
                  liveState: liveState,
                ),
              const SizedBox(height: AppSpacing.xxl),
            ],
          ),
        ),
      ),
    );
  }
}
