import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/providers/default_location_provider.dart';
import '../../../../../shared/design_system/tokens/app_spacing.dart';
import '../../../../../shared/widgets/section_header.dart';
import '../../../prayer_times/application/providers/prayer_times_notifier.dart';
import '../../../prayer_times/presentation/widgets/prayer_card.dart';
import '../widgets/prayer_error_widget.dart';
import '../widgets/prayer_header.dart';
import 'prayer_loading_screen.dart';

class PrayerHomeScreen extends ConsumerWidget {
  const PrayerHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(prayerTimesNotifierProvider);
    final location = ref.watch(defaultLocationProvider);
    final l10n = context.l10n;

    if (state.isLoading && state.prayerDay == null) {
      return const PrayerLoadingScreen();
    }

    if (state.failure != null && state.prayerDay == null) {
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

    final day = state.prayerDay;

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
              if (day != null)
                PrayerHeader(
                  cityName: location.cityName,
                  countryName: location.countryName,
                  hijriDate: day.hijriDateFormatted,
                  nextPrayerName: day.nextPrayerName,
                  timeRemaining: day.timeRemainingFormatted,
                ),
              const SizedBox(height: AppSpacing.lg),
              SectionHeader(title: l10n.prayerTitle),
              if (day != null) PrayerCard(prayerTimes: day.prayerTimes),
              const SizedBox(height: AppSpacing.xxl),
            ],
          ),
        ),
      ),
    );
  }
}
