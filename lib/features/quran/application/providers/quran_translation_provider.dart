import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/di/injection_container.dart';
import '../../domain/entities/quran_translation.dart';
import '../../domain/repositories/quran_translation_repository.dart';

// Typedef to handle multiple parameters in FutureProvider.family
typedef TranslationRequest = ({int surahNumber, String languageCode});

// Provides a map of Ayah Number -> Translation for O(1) lookup on the UI.
final quranTranslationProvider =
    FutureProvider.family<Map<int, QuranTranslation>, TranslationRequest>(
  (ref, request) async {
    try {
      final repository = getIt<QuranTranslationRepository>();
      final resultList = await repository.getTranslationsForSurah(
        request.surahNumber,
        request.languageCode,
      );

      // Create an efficient lookup map
      return {for (final t in resultList) t.ayahNumber: t};
    } catch (e) {
      // If the file is missing or invalid, we safely return an empty map.
      return {};
    }
  },
);
