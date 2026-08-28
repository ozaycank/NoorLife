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

  factory QuranTranslation.fromJson(Map<String, dynamic> json) {
    final surahRaw = json['surahNumber'];
    final ayahRaw = json['ayahNumber'];

    return QuranTranslation(
      surahNumber: surahRaw is num ? surahRaw.toInt() : 0,
      ayahNumber: ayahRaw is num ? ayahRaw.toInt() : 0,
      text: json['text']?.toString() ?? '',
      languageCode: json['languageCode']?.toString() ?? 'unknown',
    );
  }

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
