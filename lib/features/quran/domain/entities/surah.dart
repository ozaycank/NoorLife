import 'revelation_type.dart';

class Surah {
  final int number;
  final String nameArabic;
  final String nameTransliteration;
  final String nameEnglish;
  final String nameTurkish;
  final int ayahCount;
  final RevelationType revelationType;

  const Surah({
    required this.number,
    required this.nameArabic,
    required this.nameTransliteration,
    required this.nameEnglish,
    required this.nameTurkish,
    required this.ayahCount,
    required this.revelationType,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Surah &&
          runtimeType == other.runtimeType &&
          number == other.number;

  @override
  int get hashCode => number.hashCode;
}
