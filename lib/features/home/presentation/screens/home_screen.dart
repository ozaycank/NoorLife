import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

// Core & Shared
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../../shared/design_system/tokens/app_spacing.dart';

// Quran Providers
import '../../../quran/application/providers/quran_provider.dart';
import '../../../quran/application/providers/quran_progress_provider.dart';
import '../../../quran/application/providers/quran_bookmark_provider.dart';

// Prayer & Location Providers
import '../../../prayer/location/application/providers/location_notifier.dart';
import '../../../prayer/prayer_times/application/providers/prayer_times_notifier.dart';
import '../../../prayer/prayer_times/presentation/providers/prayer_live_state_provider.dart';

// Prayer Domain Entities
import '../../../prayer/prayer_times/domain/value_objects/prayer_name.dart';
import '../../../prayer/prayer_times/domain/entities/prayer_time.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.l10n.homeDailyOverview,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
        elevation: 0,
      ),
      body: SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: ListView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              children: const [
                _HomeHeader(),
                SizedBox(height: AppSpacing.xl),
                _NextPrayerHero(),
                SizedBox(height: AppSpacing.xl),
                _PrayerSummary(),
                SizedBox(height: AppSpacing.xl),
                _QuranContinueReading(),
                SizedBox(height: AppSpacing.md),
                _QuranBookmarkShortcut(),
                SizedBox(height: AppSpacing.xl),
                _QuickActions(),
                SizedBox(height: AppSpacing.xxl),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// 1. HEADER: Location and Dates
class _HomeHeader extends ConsumerWidget {
  const _HomeHeader();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final textTheme = context.textTheme;
    final colorScheme = context.colorScheme;

    final locationState = ref.watch(locationNotifierProvider);
    final prayerState = ref.watch(prayerTimesNotifierProvider);

    final now = DateTime.now();
    final gregorianDate = DateFormat.yMMMMd(l10n.localeName).format(now);
    final hijriDate = prayerState.schedule?.today.hijriDateString ?? '...';

    String locationText = l10n.homeLocationUnavailable;
    if (locationState.location != null) {
      final loc = locationState.location!;
      // Using safe fallback formatting depending on what PrayerLocation has.
      // Usually, it has latitude/longitude. If it has address/name properties, we print them.
      // Since 'city' was undefined, we use a generic string display.
      // If it implements a toString that shows coordinates/name, this will safely print it.
      locationText = loc
          .toString()
          .replaceAll('PrayerLocation', '')
          .replaceAll('(', '')
          .replaceAll(')', '')
          .trim();
    }

    final isLoading = locationState.status.toString().contains('requesting');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.location_on, color: colorScheme.primary, size: 20),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(
                isLoading ? '...' : locationText,
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          gregorianDate,
          style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          hijriDate,
          style: textTheme.titleMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

/// 2. PRIMARY HERO: Next Prayer
class _NextPrayerHero extends ConsumerWidget {
  const _NextPrayerHero();

  String _formatDuration(Duration d) {
    final hours = d.inHours.toString().padLeft(2, '0');
    final minutes = (d.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (d.inSeconds % 60).toString().padLeft(2, '0');

    if (d.inHours > 0) {
      return '$hours:$minutes:$seconds';
    }
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final textTheme = context.textTheme;
    final colorScheme = context.colorScheme;

    final liveState = ref.watch(prayerLiveStateProvider);

    if (liveState.nextPrayer == null) {
      return const SizedBox.shrink();
    }

    final nextPrayer = liveState.nextPrayer!;
    final remaining = liveState.timeRemaining;

    return Card(
      elevation: 0,
      color: colorScheme.primary,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.homeNextPrayer,
              style: textTheme.titleMedium?.copyWith(
                color: colorScheme.onPrimary.withValues(alpha: 0.8),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  _getLocalizedPrayerName(context, nextPrayer.name),
                  style: textTheme.displaySmall?.copyWith(
                    color: colorScheme.onPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  DateFormat.Hm().format(nextPrayer.time),
                  style: textTheme.headlineMedium?.copyWith(
                    color: colorScheme.onPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
              decoration: BoxDecoration(
                color: colorScheme.onPrimary.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.timer_outlined,
                    color: colorScheme.onPrimary,
                    size: 18,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    '${_formatDuration(remaining)} ${l10n.homeRemaining}',
                    style: textTheme.labelLarge?.copyWith(
                      color: colorScheme.onPrimary,
                      fontWeight: FontWeight.bold,
                    ),
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

/// 3. SECONDARY: Today's Prayers Summary
class _PrayerSummary extends ConsumerWidget {
  const _PrayerSummary();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final textTheme = context.textTheme;
    final colorScheme = context.colorScheme;

    final prayerState = ref.watch(prayerTimesNotifierProvider);
    final liveState = ref.watch(prayerLiveStateProvider);

    if (prayerState.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final prayers = prayerState.schedule?.today.prayerTimes ?? [];
    if (prayers.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.homePrayerTimes,
          style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: AppSpacing.md),
        Card(
          elevation: 0,
          color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: prayers.map((prayer) {
                final isNext = liveState.nextPrayer?.name == prayer.name;
                return _PrayerTimeItem(prayer: prayer, isNext: isNext);
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}

class _PrayerTimeItem extends StatelessWidget {
  final PrayerTime prayer;
  final bool isNext;

  const _PrayerTimeItem({required this.prayer, required this.isNext});

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    final colorScheme = context.colorScheme;

    return Column(
      children: [
        Text(
          _getLocalizedPrayerName(context, prayer.name),
          style: textTheme.labelMedium?.copyWith(
            color: isNext ? colorScheme.primary : colorScheme.onSurfaceVariant,
            fontWeight: isNext ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          DateFormat.Hm().format(prayer.time),
          style: textTheme.titleMedium?.copyWith(
            color: isNext ? colorScheme.primary : colorScheme.onSurface,
            fontWeight: isNext ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}

/// 4. QURAN: Continue Reading
class _QuranContinueReading extends ConsumerWidget {
  const _QuranContinueReading();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final colorScheme = context.colorScheme;
    final textTheme = context.textTheme;

    final progressState = ref.watch(quranProgressNotifierProvider);
    final quranState = ref.watch(quranNotifierProvider);

    final lastRead = progressState.lastRead;
    if (lastRead == null || quranState.surahs.isEmpty) {
      return const SizedBox.shrink();
    }

    final surah = quranState.surahs.firstWhere(
      (s) => s.number == lastRead.surahNumber,
      orElse: () => quranState.surahs.first,
    );

    final surahName =
        l10n.localeName == 'tr' ? surah.nameTurkish : surah.nameTransliteration;

    // Use ayahCount properly here
    double progressPercent = 0.0;
    if (surah.ayahCount > 0) {
      progressPercent = (lastRead.ayahNumber / surah.ayahCount).clamp(0.0, 1.0);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.homeContinueReading,
          style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: AppSpacing.md),
        InkWell(
          onTap: () {
            context.push('/quran/surah/${lastRead.surahNumber}');
          },
          borderRadius: BorderRadius.circular(16),
          child: Ink(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: colorScheme.secondaryContainer,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color:
                        colorScheme.onSecondaryContainer.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.menu_book_rounded,
                    color: colorScheme.onSecondaryContainer,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        surahName,
                        style: textTheme.titleMedium?.copyWith(
                          color: colorScheme.onSecondaryContainer,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        '${l10n.quranAyah} ${lastRead.ayahNumber} / ${surah.ayahCount}',
                        style: textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSecondaryContainer
                              .withValues(alpha: 0.8),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      LinearProgressIndicator(
                        value: progressPercent,
                        backgroundColor: colorScheme.onSecondaryContainer
                            .withValues(alpha: 0.2),
                        color: colorScheme.primary,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: colorScheme.onSecondaryContainer,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// 5. QURAN: Bookmark Shortcut
class _QuranBookmarkShortcut extends ConsumerWidget {
  const _QuranBookmarkShortcut();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final colorScheme = context.colorScheme;

    final bookmarkState = ref.watch(quranBookmarkNotifierProvider);
    final count = bookmarkState.bookmarks.length;

    if (count == 0) return const SizedBox.shrink();

    return ListTile(
      onTap: () => context.push('/quran/bookmarks'),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      tileColor: colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
      leading: Icon(Icons.bookmarks, color: colorScheme.primary),
      title: Text(
        l10n.homeBookmarks,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(l10n.homeSavedAyahs(count)),
      trailing: const Icon(Icons.chevron_right),
    );
  }
}

/// 6. QUICK ACTIONS: Qibla & Settings
class _QuickActions extends StatelessWidget {
  const _QuickActions();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Row(
      children: [
        Expanded(
          child: _QuickActionCard(
            icon: Icons.explore,
            label: l10n.homeQibla,
            onTap: () => context.push(AppRoutes.qibla),
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: _QuickActionCard(
            icon: Icons.settings,
            label: l10n.homeSettings,
            onTap: () => context.push(AppRoutes.settings),
          ),
        ),
      ],
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

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Ink(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Icon(icon, size: 28, color: colorScheme.onSurface),
            const SizedBox(height: AppSpacing.sm),
            Text(
              label,
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// HELPER: Safe Localization Mapping for Enums to prevent Raw String Leakage
// -----------------------------------------------------------------------------
String _getLocalizedPrayerName(BuildContext context, PrayerName name) {
  final l10n = context.l10n;
  switch (name) {
    case PrayerName.fajr:
      return l10n.homePrayerFajr;
    case PrayerName.sunrise:
      return l10n.homePrayerSunrise;
    case PrayerName.dhuhr:
      return l10n.homePrayerDhuhr;
    case PrayerName.asr:
      return l10n.homePrayerAsr;
    case PrayerName.maghrib:
      return l10n.homePrayerMaghrib;
    case PrayerName.isha:
      return l10n.homePrayerIsha;
  }
}
