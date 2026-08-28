import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../shared/design_system/tokens/app_spacing.dart';
import '../../domain/entities/ayah.dart';
import '../../application/providers/quran_reader_settings_provider.dart';
import '../constants/quran_reader_typography.dart';

class QuranAyahView extends ConsumerWidget {
  final Ayah ayah;
  final bool isBookmarked;
  final VoidCallback onBookmarkToggle;

  const QuranAyahView({
    super.key,
    required this.ayah,
    required this.isBookmarked,
    required this.onBookmarkToggle,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = context.colorScheme;
    final textTheme = context.textTheme;
    final settingsState = ref.watch(quranReaderSettingsNotifierProvider);
    final currentFontSize = settingsState.settings.arabicFontSize;

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
                        text: ayah.text,
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
                  color: isBookmarked ? colorScheme.primary : colorScheme.onSurfaceVariant,
                ),
                onPressed: onBookmarkToggle,
                tooltip: isBookmarked ? context.l10n.quranBookmarkRemove : context.l10n.quranBookmarkAdd,
              ),
            ],
          ),
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