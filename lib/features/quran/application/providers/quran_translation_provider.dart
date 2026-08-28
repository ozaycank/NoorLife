import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/di/injection_container.dart';
import '../../domain/entities/quran_translation.dart';
import '../../domain/repositories/quran_translation_repository.dart';

final quranTranslationProvider =
    FutureProvider.family<Map<int, QuranTranslation>, int>(
  (ref, surahNumber) async {
    try {
      final repository = getIt<QuranTranslationRepository>();
      final list = await repository.getTranslationsForSurah(surahNumber);
      return {for (final t in list) t.ayahNumber: t};
    } catch (_) {
      return {};
    }
  },
);
