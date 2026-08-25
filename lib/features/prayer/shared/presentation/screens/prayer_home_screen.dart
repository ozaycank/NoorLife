import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/routing/app_routes.dart';
import '../../../../../shared/design_system/tokens/app_spacing.dart';
import '../../../../../shared/widgets/section_header.dart';
import '../../../location/application/providers/location_notifier.dart';
import '../../../location/application/states/location_state.dart';
import '../../../prayer_times/application/providers/prayer_times_notifier.dart';
import '../../../prayer_times/presentation/providers/prayer_live_state_provider.dart';
import '../../../prayer_times/presentation/widgets/prayer_card.dart';
import '../utils/presentation_localizer.dart';
import '../widgets/prayer_error_widget.dart';
import '../widgets/prayer_header.dart';
import 'prayer_loading_screen.dart';

class PrayerHomeScreen extends ConsumerWidget {
  const PrayerHomeScreen({super.key});

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
    final state = ref.watch(prayerTimesNotifierProvider);
    final liveState = ref.watch(prayerLiveStateProvider);
    final locState = ref.watch(locationNotifierProvider);
    final l10n = context.l10n;

    if ((state.isLoading || locState.status == LocationStatus.requesting) &&
        state.schedule == null) {
      return const PrayerLoadingScreen();
    }

    if (state.failure != null && state.schedule == null) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.prayerTitle)),
        body: SafeArea(
          child: PrayerErrorWidget(
            message: state.failure!.message,
            onRetry: () => _refreshData(context, ref),
          ),
        ),
      );
    }

    final today = state.schedule?.today;
    final location = state.location;

    final rem = liveState.timeRemaining;
    final timeRemainingStr =
        '${rem.inHours.toString().padLeft(2, '0')}:${(rem.inMinutes % 60).toString().padLeft(2, '0')}:${(rem.inSeconds % 60).toString().padLeft(2, '0')}';

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.prayerTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.explore_outlined),
            onPressed: () => context.push(AppRoutes.qibla),
            tooltip: l10n.qiblaTitle,
          ),
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
              if (today != null && location != null)
                PrayerHeader(
                  cityName: location.cityName,
                  countryName: location.countryName,
                  subAdministrativeArea: location.countryName,
                  hijriYear: null,
                  hijriMonthIndex: null,
                  hijriDay: null,
                  customHijriString: PresentationLocalizer.formatSmartHijri(
                    context,
                    today.hijriDateString,
                  ),
                  nextPrayerNameRaw: liveState.nextPrayer?.name.name,
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
