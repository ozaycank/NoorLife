import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/di/injection_container.dart';
import '../../domain/entities/quran_translation.dart';
import '../../domain/repositories/quran_translation_repository.dart';

// Provides a map of Ayah Number -> Translation for O(1) lookup on the UI.
final quranTranslationProvider =
    FutureProvider.family<Map<int, QuranTranslation>, int>(
  (ref, surahNumber) async {
    try {
      final repository = getIt<QuranTranslationRepository>();
      final resultList = await repository.getTranslationsForSurah(surahNumber);

      // Create an efficient lookup map
      return {for (final t in resultList) t.ayahNumber: t};
    } catch (e) {
      // If the file is missing or invalid, we safely return an empty map.
      // The UI will display "Translation unavailable".
      return {};
    }
  },
);
