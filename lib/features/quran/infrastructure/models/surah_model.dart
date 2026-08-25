import '../../domain/entities/revelation_type.dart';
import '../../domain/entities/surah.dart';
import 'ayah_model.dart';

class SurahModel extends Surah {
  const SurahModel({
    required super.number,
    required super.nameArabic,
    required super.nameTransliteration,
    required super.nameEnglish,
    required super.nameTurkish,
    required super.ayahCount,
    required super.revelationType,
    super.ayahs,
  });

  // AlQuran API'sinin veri formatına göre parse eder.
  factory SurahModel.fromJson(Map<String, dynamic> json) {
    return SurahModel(
      number: json['number'] as int,
      nameArabic: json['name'] ?? json['nameArabic'] as String? ?? '-',
      nameTransliteration:
          json['englishName'] ?? json['nameTransliteration'] as String? ?? '-',
      nameEnglish: json['englishNameTranslation'] ??
          json['nameEnglish'] as String? ??
          '-',
      nameTurkish: json['nameTurkish'] as String? ?? json['englishName'] ?? '-',
      ayahCount: (json['ayahs'] as List?)?.length ?? json['ayahCount'] ?? 0,
      revelationType:
          (json['revelationType']?.toString().toLowerCase() == 'medinan')
              ? RevelationType.madinah
              : RevelationType.makkah,
      ayahs: json['ayahs'] != null
          ? (json['ayahs'] as List).map((a) => AyahModel.fromJson(a)).toList()
          : null,
    );
  }
}
