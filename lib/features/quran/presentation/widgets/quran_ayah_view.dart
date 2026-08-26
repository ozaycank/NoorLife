import 'package:flutter/material.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../shared/design_system/tokens/app_spacing.dart';
import '../../domain/entities/ayah.dart';
import '../constants/quran_reader_typography.dart';

class QuranAyahView extends StatelessWidget {
  final Ayah ayah;

  const QuranAyahView({super.key, required this.ayah});

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textTheme = context.textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Directionality(
            textDirection: TextDirection.rtl,
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: ayah.text,
                    style: textTheme.headlineSmall?.copyWith(
                      fontSize: QuranReaderTypography.arabicFontSize,
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
            ),
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
        number
            .toString(), // Standard localized numbers for immediate accessibility
        style: textTheme.labelLarge?.copyWith(
          color: colorScheme.primary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
