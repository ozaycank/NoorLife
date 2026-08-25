import 'package:flutter/material.dart';
import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../shared/design_system/tokens/app_spacing.dart';
import '../utils/presentation_localizer.dart';

class PrayerHeader extends StatelessWidget {
  final String? cityName;
  final String? countryName;
  final String? subAdministrativeArea;
  final int? hijriMonthIndex;
  final int? hijriDay;
  final int? hijriYear;
  final String? customHijriString;
  final String? nextPrayerNameRaw;
  final String timeRemaining;

  const PrayerHeader({
    super.key,
    this.cityName,
    this.countryName,
    this.subAdministrativeArea,
    this.hijriMonthIndex,
    this.hijriDay,
    this.hijriYear,
    this.customHijriString,
    this.nextPrayerNameRaw,
    required this.timeRemaining,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final textTheme = context.textTheme;
    final colorScheme = context.colorScheme;

    final formattedLocation = PresentationLocalizer.formatLocation(
      context: context,
      cityName: cityName,
      subAdminArea: subAdministrativeArea,
      countryName: countryName,
    );

    String formattedHijri = customHijriString ?? '-';
    if (customHijriString == null &&
        hijriDay != null &&
        hijriMonthIndex != null &&
        hijriYear != null) {
      final monthName =
          PresentationLocalizer.localizeHijriMonth(context, hijriMonthIndex!);
      formattedHijri = '$hijriDay $monthName $hijriYear';
    }

    final localizedNextPrayer = nextPrayerNameRaw != null
        ? PresentationLocalizer.localizePrayerNameRaw(
            context,
            nextPrayerNameRaw!,
          )
        : '-';

    return Column(
      children: [
        Text(
          formattedLocation,
          style: textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          formattedHijri,
          style: textTheme.titleMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xl,
            vertical: AppSpacing.lg,
          ),
          decoration: BoxDecoration(
            color: colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              Text(
                l10n.prayerNextPrayer,
                style: textTheme.titleSmall?.copyWith(
                  color: colorScheme.onPrimaryContainer,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                localizedNextPrayer,
                style: textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onPrimaryContainer,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                '${l10n.prayerRemainingTime}: $timeRemaining',
                style: textTheme.bodyLarge?.copyWith(
                  color: colorScheme.onPrimaryContainer,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
