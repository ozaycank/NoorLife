import '../../domain/entities/quran_translation.dart';

/// Infrastructure representation of QuranTranslation.
/// Handles raw JSON parsing safely (supporting fawazahmed API schema), shielding the Domain layer.
class QuranTranslationModel {
  final int surahNumber;
  final int ayahNumber;
  final String text;
  final String languageCode;

  QuranTranslationModel({
    required this.surahNumber,
    required this.ayahNumber,
    required this.text,
    required this.languageCode,
  });

  factory QuranTranslationModel.fromJson(Map<String, dynamic> json) {
    // Fawaz Ahmed raw JSON uses 'chapter' and 'verse'.
    // Fallbacks provided for generic 'surahNumber' / 'ayahNumber' schemas.
    final surahRaw = json['chapter'] ?? json['surahNumber'];
    final ayahRaw = json['verse'] ?? json['ayahNumber'];
    final textRaw = json['text']?.toString() ?? '';
    final langRaw = json['languageCode']?.toString() ?? 'unknown';

    // Strict validation
    if (textRaw.trim().isEmpty) {
      throw Exception('Translation text cannot be empty');
    }

    int parsedSurah = 0;
    if (surahRaw is num) parsedSurah = surahRaw.toInt();
    if (parsedSurah < 1 || parsedSurah > 114) {
      throw Exception('Invalid Surah Number: $parsedSurah');
    }

    int parsedAyah = 0;
    if (ayahRaw is num) parsedAyah = ayahRaw.toInt();
    if (parsedAyah < 1) {
      throw Exception('Invalid Ayah Number: $parsedAyah');
    }

    return QuranTranslationModel(
      surahNumber: parsedSurah,
      ayahNumber: parsedAyah,
      text: textRaw,
      languageCode: langRaw,
    );
  }

  QuranTranslation toDomain() {
    return QuranTranslation(
      surahNumber: surahNumber,
      ayahNumber: ayahNumber,
      text: text,
      languageCode: languageCode,
    );
  }
}
