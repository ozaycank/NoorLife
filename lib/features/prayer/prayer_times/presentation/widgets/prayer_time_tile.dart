import 'package:flutter/material.dart';
import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../shared/design_system/tokens/app_border_radius.dart';
import '../../../../../shared/design_system/tokens/app_spacing.dart';
import '../../domain/value_objects/prayer_name.dart';

class PrayerTimeTile extends StatelessWidget {
  final PrayerName name;
  final String formattedTime;
  final bool isNext;

  const PrayerTimeTile({
    super.key,
    required this.name,
    required this.formattedTime,
    required this.isNext,
  });

  String _getPrayerLabel(BuildContext context) {
    final l10n = context.l10n;
    switch (name) {
      case PrayerName.fajr:
        return l10n.prayerFajr;
      case PrayerName.sunrise:
        return l10n.prayerSunrise;
      case PrayerName.dhuhr:
        return l10n.prayerDhuhr;
      case PrayerName.asr:
        return l10n.prayerAsr;
      case PrayerName.maghrib:
        return l10n.prayerMaghrib;
      case PrayerName.isha:
        return l10n.prayerIsha;
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    final colorScheme = context.colorScheme;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: isNext
            ? colorScheme.primaryContainer.withValues(alpha: 0.5)
            : colorScheme.surfaceContainerLow,
        borderRadius: AppBorderRadius.medium,
        border: isNext
            ? Border.all(color: colorScheme.primary, width: 2)
            : Border.all(color: Colors.transparent),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              if (isNext) ...[
                Icon(
                  Icons.access_time_filled,
                  color: colorScheme.primary,
                  size: 20,
                ),
                const SizedBox(width: AppSpacing.sm),
              ],
              Text(
                _getPrayerLabel(context),
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: isNext ? FontWeight.bold : FontWeight.normal,
                  color: isNext ? colorScheme.primary : colorScheme.onSurface,
                ),
              ),
            ],
          ),
          Text(
            formattedTime,
            style: textTheme.titleMedium?.copyWith(
              fontWeight: isNext ? FontWeight.bold : FontWeight.w600,
              color: isNext ? colorScheme.primary : colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
