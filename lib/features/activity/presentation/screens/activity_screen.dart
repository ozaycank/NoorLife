import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../../shared/design_system/tokens/app_spacing.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/section_header.dart';
import '../../../../shared/widgets/error_state_widget.dart';
import '../../domain/activity_prayer_type.dart';
import '../../domain/activity_models.dart';
import '../../application/activity_provider.dart';
import '../../utils/activity_date_utils.dart';

class ActivityScreen extends ConsumerStatefulWidget {
  const ActivityScreen({super.key});

  @override
  ConsumerState<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends ConsumerState<ActivityScreen> {
  String _localizePrayerType(ActivityPrayerType type, AppLocalizations l10n) {
    switch (type) {
      case ActivityPrayerType.fajr:
        return l10n.prayerFajr;
      case ActivityPrayerType.dhuhr:
        return l10n.prayerDhuhr;
      case ActivityPrayerType.asr:
        return l10n.prayerAsr;
      case ActivityPrayerType.maghrib:
        return l10n.prayerMaghrib;
      case ActivityPrayerType.isha:
        return l10n.prayerIsha;
    }
  }

  Widget _buildStatCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
  ) {
    final colorScheme = context.colorScheme;
    final textTheme = context.textTheme;

    return Expanded(
      child: AppCard(
        child: Column(
          children: [
            Icon(icon, color: colorScheme.primary, size: 28),
            const SizedBox(height: AppSpacing.sm),
            Text(
              value,
              style:
                  textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              title,
              textAlign: TextAlign.center,
              style: textTheme.bodySmall
                  ?.copyWith(color: colorScheme.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryItem(BuildContext context, DailyActivity activity) {
    final l10n = context.l10n;
    final colorScheme = context.colorScheme;

    final parsedDate = DateTime.tryParse(activity.date) ?? DateTime.now();
    final displayDate = DateFormat.yMMMd(l10n.localeName).format(parsedDate);

    final completed = activity.completedPrayers.values.where((v) => v).length;

    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        padding: const EdgeInsets.all(AppSpacing.sm),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(Icons.calendar_today, size: 20, color: colorScheme.primary),
      ),
      title: Text(
        displayDate,
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
      subtitle: Text('$completed/5 ${l10n.activityPrayers}'),
      trailing: activity.quranReadingOccurred
          ? Icon(Icons.menu_book, color: colorScheme.primary, size: 20)
          : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colorScheme = context.colorScheme;
    final textTheme = context.textTheme;

    final state = ref.watch(activityNotifierProvider);
    final notifier = ref.read(activityNotifierProvider.notifier);

    final todayStr = DateFormat.yMMMMd(l10n.localeName).format(DateTime.now());
    const trackablePrayers = ActivityPrayerType.values;

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
                : RefreshIndicator(
                    onRefresh: () => notifier.loadToday(),
                    child: ListView(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      children: [
                        // TODAY'S ACTIVITY
                        SectionHeader(title: l10n.activityToday),
                        Text(
                          todayStr,
                          style: textTheme.titleMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xl),
                        AppCard(
                          padding: EdgeInsets.zero,
                          child: Column(
                            children: trackablePrayers.map((prayer) {
                              final isCompleted = state.dailyActivity
                                      ?.completedPrayers[prayer] ??
                                  false;
                              final isLast = prayer == trackablePrayers.last;

                              return Column(
                                children: [
                                  SwitchListTile(
                                    title: Text(
                                      _localizePrayerType(prayer, l10n),
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
                                    activeTrackColor: colorScheme.primary,
                                    onChanged: (val) =>
                                        notifier.togglePrayer(prayer),
                                  ),
                                  if (!isLast) const Divider(height: 1),
                                ],
                              );
                            }).toList(),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.md),
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
                        const SizedBox(height: AppSpacing.xxl),

                        // STATISTICS SUMMARY
                        SectionHeader(title: l10n.activityStatistics),
                        Row(
                          children: [
                            _buildStatCard(
                              context,
                              l10n.statsStreak,
                              l10n.statsDays(
                                state.statistics?.currentStreak ?? 0,
                              ),
                              Icons.local_fire_department,
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            _buildStatCard(
                              context,
                              l10n.statsAvgCompletion,
                              '${((state.statistics?.last7DaysCompletion ?? 0) * 100).toInt()}%',
                              Icons.pie_chart,
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            _buildStatCard(
                              context,
                              l10n.statsQuranDays,
                              l10n.statsDays(
                                state.statistics?.last7DaysQuran ?? 0,
                              ),
                              Icons.auto_stories,
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.xxl),

                        // HISTORY LIST
                        SectionHeader(title: l10n.activityHistory),
                        if (state.history
                            .where((r) => r.date != ActivityDateUtils.today())
                            .isEmpty)
                          Padding(
                            padding: const EdgeInsets.all(AppSpacing.lg),
                            child: Center(
                              child: Text(
                                l10n.activityEmptyHistory,
                                style: textTheme.bodyMedium?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ),
                          )
                        else
                          AppCard(
                            padding: EdgeInsets.zero,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.md,
                                vertical: AppSpacing.sm,
                              ),
                              child: Column(
                                children: state.history
                                    .where(
                                      (r) =>
                                          r.date != ActivityDateUtils.today(),
                                    )
                                    .take(
                                      10,
                                    ) // Render up to 10 past days to prevent huge lists rendering
                                    .map((r) => _buildHistoryItem(context, r))
                                    .toList(),
                              ),
                            ),
                          ),

                        const SizedBox(height: AppSpacing.xxl),
                      ],
                    ),
                  ),
      ),
    );
  }
}
