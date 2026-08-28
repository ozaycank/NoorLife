/// Pure Domain Entity representing a translated Quran Ayah.
/// Contains NO JSON or Flutter dependencies.
class QuranTranslation {
  final int surahNumber;
  final int ayahNumber;
  final String text;
  final String languageCode;

  const QuranTranslation({
    required this.surahNumber,
    required this.ayahNumber,
    required this.text,
    required this.languageCode,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QuranTranslation &&
          runtimeType == other.runtimeType &&
          surahNumber == other.surahNumber &&
          ayahNumber == other.ayahNumber &&
          text == other.text &&
          languageCode == other.languageCode;

  @override
  int get hashCode =>
      surahNumber.hashCode ^
      ayahNumber.hashCode ^
      text.hashCode ^
      languageCode.hashCode;
}
