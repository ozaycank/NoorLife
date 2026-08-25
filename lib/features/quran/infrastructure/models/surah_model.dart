import '../../domain/entities/revelation_type.dart';
import '../../domain/entities/surah.dart';

class SurahModel extends Surah {
  const SurahModel({
    required super.number,
    required super.nameArabic,
    required super.nameTransliteration,
    required super.nameEnglish,
    required super.nameTurkish,
    required super.ayahCount,
    required super.revelationType,
  });

  factory SurahModel.fromJson(Map<String, dynamic> json) {
    return SurahModel(
      number: json['number'] as int,
      nameArabic: json['nameArabic'] as String,
      nameTransliteration: json['nameTransliteration'] as String,
      nameEnglish: json['nameEnglish'] as String,
      nameTurkish: json['nameTurkish'] as String,
      ayahCount: json['ayahCount'] as int,
      revelationType: json['revelationType'] == 'medinan'
          ? RevelationType.madinah
          : RevelationType.makkah,
    );
  }
}
