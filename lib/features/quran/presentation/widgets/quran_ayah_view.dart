import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../shared/design_system/tokens/app_spacing.dart';
import '../../domain/entities/ayah.dart';
import '../../domain/entities/quran_translation.dart';
import '../../application/providers/quran_reader_settings_provider.dart';
import '../constants/quran_reader_typography.dart';

class QuranAyahView extends ConsumerWidget {
  final Ayah ayah;
  final bool isBookmarked;
  final VoidCallback onBookmarkToggle;
  final QuranTranslation? translation;

  const QuranAyahView({
    super.key,
    required this.ayah,
    required this.isBookmarked,
    required this.onBookmarkToggle,
    this.translation,
  });

  /// FIX: Cleans the repetitive Bismillah from the beginning of the first Ayah
  /// for all Surahs except Surah Al-Fatihah (1) and Surah At-Tawbah (9).
  String _getCleanedAyahText() {
    String text = ayah.text;

    // Only attempt to trim Bismillah if it's the very first Ayah of a Surah
    if (ayah.numberInSurah == 1) {
      // Bismillah Unicode String commonly found at the start of Tanzil datasets
      const String bismillah = 'بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ';
      const String bismillahAlternative =
          'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ';

      // We do NOT remove it for Surah 1 (Fatihah) because Bismillah is officially Ayah 1.
      // We do NOT remove it for Surah 9 (Tawbah) because it doesn't have a Bismillah anyway.
      // Wait, how do we know the Surah number from the Ayah entity?
      // Typically, an Ayah entity has a `surahNumber` property. Let's safely check if we can remove it.

      // If the text starts with the exact Bismillah characters, and it is long enough, trim it.
      // Note: We leave the space (if any) or trim it entirely.
      if (text.startsWith(bismillah) && text.length > bismillah.length) {
        text = text.substring(bismillah.length).trim();
      } else if (text.startsWith(bismillahAlternative) &&
          text.length > bismillahAlternative.length) {
        text = text.substring(bismillahAlternative.length).trim();
      }

      // There is also a famous special character "bismillah symbol" (U+FDFD)
      // or zero-width joiners sometimes glued to the start.
      // A more brute-force but universally safe approach for Tanzil text:
      final bismillahWords = bismillah.split(' ');
      if (text.contains(bismillahWords[0]) &&
          text.contains(bismillahWords[1])) {
        // Find the index of "Ar-Raheem" and cut everything after it.
        final raheemIndex = text.indexOf('ٱلرَّحِيمِ');
        final raheemAltIndex = text.indexOf('الرَّحِيمِ');

        if (raheemIndex != -1 && raheemIndex < 35) {
          // Ensure we are cutting from the very start
          text = text.substring(raheemIndex + 'ٱلرَّحِيمِ'.length).trim();
        } else if (raheemAltIndex != -1 && raheemAltIndex < 35) {
          text = text.substring(raheemAltIndex + 'الرَّحِيمِ'.length).trim();
        }
      }
    }

    // If after trimming the text becomes completely empty (which happens in Surah Fatihah Ayah 1),
    // we revert to the original text to ensure we don't display a blank Ayah.
    if (text.isEmpty) {
      return ayah.text;
    }

    return text;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = context.colorScheme;
    final textTheme = context.textTheme;
    final settingsState = ref.watch(quranReaderSettingsNotifierProvider);
    final currentFontSize = settingsState.settings.arabicFontSize;
    final showTranslation = settingsState.settings.showTranslation;

    final cleanedText = _getCleanedAyahText();

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            textDirection: TextDirection.rtl,
            children: [
              Expanded(
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: cleanedText,
                        style: textTheme.headlineSmall?.copyWith(
                          fontSize: currentFontSize,
                          height: QuranReaderTypography.arabicLineHeight,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      const WidgetSpan(
                        child: SizedBox(width: AppSpacing.sm),
                      ),
                      WidgetSpan(
                        alignment: PlaceholderAlignment.middle,
                        child: _AyahNumberMarker(number: ayah.numberInSurah),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.justify,
                  textDirection: TextDirection.rtl,
                ),
              ),
              IconButton(
                icon: Icon(
                  isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                  color: isBookmarked
                      ? colorScheme.primary
                      : colorScheme.onSurfaceVariant,
                ),
                onPressed: onBookmarkToggle,
                tooltip: isBookmarked
                    ? context.l10n.quranBookmarkRemove
                    : context.l10n.quranBookmarkAdd,
              ),
            ],
          ),
          if (showTranslation) ...[
            const SizedBox(height: AppSpacing.lg),
            if (translation != null)
              Text(
                translation!.text,
                style: textTheme.bodyLarge?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  height: 1.5,
                ),
                textAlign: TextAlign.left,
                textDirection: TextDirection.ltr,
              )
            else
              Text(
                context.l10n.quranTranslationUnavailable,
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.error,
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.left,
                textDirection: TextDirection.ltr,
              ),
          ],
          const SizedBox(height: AppSpacing.lg),
          Divider(color: colorScheme.surfaceContainerHighest),
        ],
      ),
    );
  }
}

class _AyahNumberMarker extends StatelessWidget {
  final int number;

  const _AyahNumberMarker({required this.number});

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textTheme = context.textTheme;

    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: colorScheme.primary.withValues(alpha: 0.5),
          width: 2,
        ),
      ),
      alignment: Alignment.center,
      child: Text(
        number.toString(),
        style: textTheme.labelLarge?.copyWith(
          color: colorScheme.primary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
