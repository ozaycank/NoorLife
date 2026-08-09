import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../shared/design_system/tokens/app_spacing.dart';
import '../../../../../shared/widgets/section_header.dart';
import '../../../calculation_methods/presentation/widgets/calculation_method_card.dart';
import '../../../prayer_settings/presentation/widgets/prayer_settings_tile.dart';
import '../../../prayer_times/presentation/widgets/prayer_card.dart';
import '../../application/providers/prayer_providers.dart';
import '../widgets/prayer_error_widget.dart';
import '../widgets/prayer_header.dart';
import 'prayer_loading_screen.dart';

class PrayerHomeScreen extends ConsumerWidget {
  const PrayerHomeScreen({super.key});

  void _showCalculationMethodsModal(BuildContext context, WidgetRef ref) {
    final state = ref.read(prayerNotifierProvider);
    final l10n = context.l10n;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  l10n.prayerCalculationMethod,
                  style: context.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                ...state.calculationMethods.map((method) {
                  final isSelected =
                      method.id == state.selectedCalculationMethodId;
                  return CalculationMethodCard(
                    title: method.name,
                    subtitle: method.description,
                    isSelected: isSelected,
                    onTap: () {
                      ref
                          .read(prayerNotifierProvider.notifier)
                          .selectCalculationMethod(method.id);
                      Navigator.of(sheetContext).pop();
                    },
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showMadhabModal(BuildContext context, WidgetRef ref) {
    final state = ref.read(prayerNotifierProvider);
    final l10n = context.l10n;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  l10n.prayerMadhab,
                  style: context.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                ...state.madhabs.map((madhab) {
                  final isSelected = madhab.id == state.selectedMadhabId;
                  return CalculationMethodCard(
                    title: madhab.name,
                    isSelected: isSelected,
                    onTap: () {
                      ref
                          .read(prayerNotifierProvider.notifier)
                          .selectMadhab(madhab.id);
                      Navigator.of(sheetContext).pop();
                    },
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(prayerNotifierProvider);
    final l10n = context.l10n;

    if (state.isLoading && state.prayerDay == null) {
      return const PrayerLoadingScreen();
    }

    if (state.errorMessage != null && state.prayerDay == null) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.prayerTitle)),
        body: SafeArea(
          child: PrayerErrorWidget(
            message: state.errorMessage!,
            onRetry: () =>
                ref.read(prayerNotifierProvider.notifier).loadPrayerData(),
          ),
        ),
      );
    }

    final day = state.prayerDay;
    final loc = state.location;

    final currentMethodName = state.calculationMethods
        .firstWhere(
          (m) => m.id == state.selectedCalculationMethodId,
          orElse: () => state.calculationMethods.isNotEmpty
              ? state.calculationMethods.first
              : null as dynamic,
        )
        .name;

    final currentMadhabName = state.madhabs
        .firstWhere(
          (m) => m.id == state.selectedMadhabId,
          orElse: () =>
              state.madhabs.isNotEmpty ? state.madhabs.first : null as dynamic,
        )
        .name;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.prayerTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () =>
                ref.read(prayerNotifierProvider.notifier).refreshTimes(),
            tooltip: l10n.prayerRefreshButton,
          ),
        ],
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () =>
              ref.read(prayerNotifierProvider.notifier).refreshTimes(),
          child: ListView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            children: [
              if (loc != null && day != null)
                PrayerHeader(
                  cityName: loc.cityName,
                  countryName: loc.countryName,
                  hijriDate: day.hijriDateFormatted,
                  nextPrayerName: day.nextPrayerName,
                  timeRemaining: day.timeRemainingFormatted,
                ),
              const SizedBox(height: AppSpacing.lg),
              SectionHeader(title: l10n.prayerTitle),
              if (day != null) PrayerCard(prayerTimes: day.prayerTimes),
              const SizedBox(height: AppSpacing.lg),
              SectionHeader(title: l10n.prayerSettingsTitle),
              PrayerSettingsTile(
                title: l10n.prayerCalculationMethod,
                currentValue: currentMethodName,
                onTap: () => _showCalculationMethodsModal(context, ref),
              ),
              PrayerSettingsTile(
                title: l10n.prayerMadhab,
                currentValue: currentMadhabName,
                onTap: () => _showMadhabModal(context, ref),
              ),
              const SizedBox(height: AppSpacing.xxl),
            ],
          ),
        ),
      ),
    );
  }
}
