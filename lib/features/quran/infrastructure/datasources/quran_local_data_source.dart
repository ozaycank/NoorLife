import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/revelation_type.dart';
import '../../domain/entities/surah.dart';

abstract class QuranLocalDataSource {
  Future<List<Surah>> getSurahs();
  Future<Surah> getSurahDetail(int surahNumber);
}

@LazySingleton(as: QuranLocalDataSource)
class QuranLocalDataSourceImpl implements QuranLocalDataSource {
  List<Surah>? _cachedSurahs;

  @override
  Future<List<Surah>> getSurahs() async {
    if (_cachedSurahs != null) return _cachedSurahs!;

    try {
      final jsonString =
          await rootBundle.loadString('assets/data/quran/surahs.json');
      final List<dynamic> jsonList = json.decode(jsonString);

      final surahs = jsonList.map((item) {
        // FIX: Directly cast properties to domain entity
        return Surah(
          number: item['number'] ?? item['id'] ?? 1,
          nameArabic: item['nameArabic'] ?? item['name'] ?? '',
          nameTransliteration:
              item['nameTransliteration'] ?? item['transliteration'] ?? '',
          nameEnglish: item['nameEnglish'] ?? item['englishName'] ?? '',
          nameTurkish: item['nameTurkish'] ?? item['translation'] ?? '',
          ayahCount: item['ayahCount'] ?? item['total_verses'] ?? 0,
          revelationType: (item['revelationType'] ?? item['type'])
                      .toString()
                      .toLowerCase() ==
                  'meccan'
              ? RevelationType.makkah
              : RevelationType.madinah,
        );
      }).toList();

      _cachedSurahs = surahs;
      return surahs;
    } catch (e) {
      throw Exception('Failed to load Surah metadata: $e');
    }
  }

  @override
  Future<Surah> getSurahDetail(int surahNumber) async {
    final surahs = await getSurahs();
    final metadata = surahs.firstWhere((s) => s.number == surahNumber);
    return metadata;
  }
}
