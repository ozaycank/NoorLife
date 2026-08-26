import 'package:flutter/material.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../shared/design_system/tokens/app_spacing.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../domain/entities/quran_reading_progress.dart';
import '../../domain/entities/surah.dart';

class ContinueReadingCard extends StatelessWidget {
  final QuranReadingProgress progress;
  final List<Surah> surahs;
  final VoidCallback onTap;

  const ContinueReadingCard({
    super.key,
    required this.progress,
    required this.surahs,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colorScheme = context.colorScheme;
    final textTheme = context.textTheme;

    final targetSurah = surahs.firstWhere(
      (s) => s.number == progress.surahNumber,
      orElse: () => surahs.first,
    );

    final surahName = l10n.localeName == 'tr'
        ? targetSurah.nameTurkish
        : targetSurah.nameTransliteration;

    return AppCard(
      onTap: onTap,
      padding: const EdgeInsets.all(AppSpacing.xl),
      // DÜZELTME BURADA: color parametresi silindi, AppCard kendi default rengini alacak.
      // Dilersek dışına Material/Container atıp renklendirebiliriz ama şu an sade tutuyoruz.
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.menu_book,
                      size: 16,
                      color: colorScheme.primary,
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    Text(
                      l10n.quranContinueReading,
                      style: textTheme.labelLarge?.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  surahName,
                  style: textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  '${l10n.quranAyah} ${progress.ayahNumber}',
                  style: textTheme.bodyLarge?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.chevron_right,
            size: 32,
            color: colorScheme.onSurfaceVariant,
          ),
        ],
      ),
    );
  }
}
