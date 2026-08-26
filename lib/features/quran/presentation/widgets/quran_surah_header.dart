import 'package:flutter/material.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../shared/design_system/tokens/app_spacing.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../domain/entities/revelation_type.dart';
import '../../domain/entities/surah.dart';

class QuranSurahHeader extends StatelessWidget {
  final Surah surah;

  const QuranSurahHeader({super.key, required this.surah});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colorScheme = context.colorScheme;
    final textTheme = context.textTheme;

    final displayName =
        l10n.localeName == 'tr' ? surah.nameTurkish : surah.nameTransliteration;

    final revelationStr = surah.revelationType == RevelationType.makkah
        ? l10n.quranMeccan
        : l10n.quranMedinan;

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: AppCard(
        padding: const EdgeInsets.symmetric(
          vertical: AppSpacing.xl,
          horizontal: AppSpacing.lg,
        ),
        child: Column(
          children: [
            Text(
              surah.nameArabic,
              style: textTheme.displaySmall?.copyWith(
                color: colorScheme.onSecondaryContainer,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              displayName,
              style: textTheme.titleLarge?.copyWith(
                color: colorScheme.onSecondaryContainer,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Divider(color: colorScheme.outlineVariant.withValues(alpha: 0.5)),
            const SizedBox(height: AppSpacing.md),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  revelationStr.toUpperCase(),
                  style: textTheme.labelLarge?.copyWith(
                    color: colorScheme.onSecondaryContainer,
                    letterSpacing: 1.5,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
                  child: Text('•'),
                ),
                Text(
                  l10n.quranAyahCount(surah.ayahCount).toUpperCase(),
                  style: textTheme.labelLarge?.copyWith(
                    color: colorScheme.onSecondaryContainer,
                    letterSpacing: 1.5,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
