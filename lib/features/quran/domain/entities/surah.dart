import 'ayah.dart';
import 'revelation_type.dart';

class Surah {
  final int number;
  final String nameArabic;
  final String nameTransliteration;
  final String nameEnglish;
  final String nameTurkish;
  final int ayahCount;
  final RevelationType revelationType;
  final List<Ayah>? ayahs;

  const Surah({
    required this.number,
    required this.nameArabic,
    required this.nameTransliteration,
    required this.nameEnglish,
    required this.nameTurkish,
    required this.ayahCount,
    required this.revelationType,
    this.ayahs,
  });

  Surah copyWith({
    int? number,
    String? nameArabic,
    String? nameTransliteration,
    String? nameEnglish,
    String? nameTurkish,
    int? ayahCount,
    RevelationType? revelationType,
    List<Ayah>? ayahs,
  }) {
    return Surah(
      number: number ?? this.number,
      nameArabic: nameArabic ?? this.nameArabic,
      nameTransliteration: nameTransliteration ?? this.nameTransliteration,
      nameEnglish: nameEnglish ?? this.nameEnglish,
      nameTurkish: nameTurkish ?? this.nameTurkish,
      ayahCount: ayahCount ?? this.ayahCount,
      revelationType: revelationType ?? this.revelationType,
      ayahs: ayahs ?? this.ayahs,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Surah &&
          runtimeType == other.runtimeType &&
          number == other.number;

  @override
  int get hashCode => number.hashCode;
}
