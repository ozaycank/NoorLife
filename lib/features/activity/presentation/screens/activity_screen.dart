import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../shared/design_system/tokens/app_spacing.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/section_header.dart';
import '../../../../shared/widgets/error_state_widget.dart';
import '../../../prayer/shared/presentation/utils/presentation_localizer.dart';
import '../../../prayer/prayer_times/domain/value_objects/prayer_name.dart';
import '../../application/activity_provider.dart';

class ActivityScreen extends ConsumerStatefulWidget {
  const ActivityScreen({super.key});

  @override
  ConsumerState<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends ConsumerState<ActivityScreen> {
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colorScheme = context.colorScheme;
    final textTheme = context.textTheme;

    final state = ref.watch(activityNotifierProvider);
    final notifier = ref.read(activityNotifierProvider.notifier);

    // Display formatted local date
    final todayStr = DateFormat.yMMMMd(l10n.localeName).format(DateTime.now());

    // Filter out Sunrise, we only track the 5 mandatory prayers
    final trackablePrayers =
        PrayerName.values.where((p) => p != PrayerName.sunrise).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.activityTitle),
      ),
      body: SafeArea(
        child: state.isLoading && state.dailyActivity == null
            ? const Center(child: CircularProgressIndicator())
            : state.failure != null && state.dailyActivity == null
                ? ErrorStateWidget(
                    title: l10n.errorStateDefaultTitle,
                    message: state.failure!.message,
                    retryText: l10n.retryButton,
                    onRetry: () => notifier.loadToday(),
                  )
                : ListView(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    children: [
                      SectionHeader(title: l10n.activityToday),
                      Text(
                        todayStr,
                        style: textTheme.titleMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xl),
                      SectionHeader(title: l10n.activityPrayers),
                      AppCard(
                        padding: EdgeInsets.zero,
                        child: Column(
                          children: trackablePrayers.map((prayer) {
                            final isCompleted =
                                state.dailyActivity?.completedPrayers[prayer] ??
                                    false;
                            final isLast = prayer == trackablePrayers.last;

                            return Column(
                              children: [
                                SwitchListTile(
                                  title: Text(
                                    PresentationLocalizer.localizePrayerNameRaw(
                                        context, prayer.name,),
                                    style: textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  subtitle: Text(
                                    isCompleted
                                        ? l10n.activityCompleted
                                        : l10n.activityNotCompleted,
                                    style: textTheme.bodySmall?.copyWith(
                                      color: isCompleted
                                          ? colorScheme.primary
                                          : colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                  value: isCompleted,
                                  activeThumbColor: colorScheme.primary,
                                  onChanged: (val) =>
                                      notifier.togglePrayer(prayer),
                                ),
                                if (!isLast) const Divider(height: 1),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xxl),
                      SectionHeader(title: l10n.activityQuranReading),
                      AppCard(
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(AppSpacing.md),
                              decoration: BoxDecoration(
                                color: (state.dailyActivity
                                            ?.quranReadingOccurred ??
                                        false)
                                    ? colorScheme.primaryContainer
                                    : colorScheme.surfaceContainerHighest,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.menu_book,
                                color: (state.dailyActivity
                                            ?.quranReadingOccurred ??
                                        false)
                                    ? colorScheme.onPrimaryContainer
                                    : colorScheme.onSurfaceVariant,
                              ),
                            ),
                            const SizedBox(width: AppSpacing.lg),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    l10n.activityQuranReading,
                                    style: textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: AppSpacing.xs),
                                  Text(
                                    (state.dailyActivity
                                                ?.quranReadingOccurred ??
                                            false)
                                        ? l10n.activityReadToday
                                        : l10n.activityNotRecorded,
                                    style: textTheme.bodyMedium?.copyWith(
                                      color: colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (!(state.dailyActivity?.quranReadingOccurred ??
                                false))
                              TextButton(
                                onPressed: () => notifier.markQuranRead(),
                                child: Text(l10n.activityMarkAsRead),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
      ),
    );
  }
}
