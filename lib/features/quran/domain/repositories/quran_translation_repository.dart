import '../entities/quran_translation.dart';

abstract class QuranTranslationRepository {
  Future<List<QuranTranslation>> getTranslationsForSurah(
    int surahNumber,
    String languageCode,
  );
}
