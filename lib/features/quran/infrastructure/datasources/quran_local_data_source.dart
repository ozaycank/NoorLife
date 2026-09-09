import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/revelation_type.dart';
import '../../domain/entities/surah.dart';
import '../../domain/entities/ayah.dart';

abstract class QuranLocalDataSource {
  Future<List<Surah>> getSurahs();
  Future<Surah> getSurahDetail(int surahNumber);
}

@LazySingleton(as: QuranLocalDataSource)
class QuranLocalDataSourceImpl implements QuranLocalDataSource {
  List<Surah>? _cachedSurahs;
  Map<String, dynamic>? _cachedQuranData;

  @override
  Future<List<Surah>> getSurahs() async {
    if (_cachedSurahs != null) return _cachedSurahs!;

    try {
      final jsonString =
          await rootBundle.loadString('assets/data/quran/surahs.json');
      final List<dynamic> jsonList = json.decode(jsonString);

      final surahs = jsonList.map((item) {
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
          // Catalog fetching remains lightweight by supplying empty ayahs initially
          ayahs: const [],
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
    // 1. Fetch lightweight metadata
    final surahs = await getSurahs();
    final metadata = surahs.firstWhere(
      (s) => s.number == surahNumber,
      orElse: () => throw Exception('Surah $surahNumber metadata not found'),
    );

    // 2. Load and cache the full quran.json if not already in memory
    if (_cachedQuranData == null) {
      try {
        final jsonString =
            await rootBundle.loadString('assets/data/quran/quran.json');
        final decoded = json.decode(jsonString);

        // Normalize standard AlQuranCloud structures
        if (decoded is Map<String, dynamic>) {
          _cachedQuranData = decoded;
        } else if (decoded is List) {
          _cachedQuranData = {
            'data': {'surahs': decoded},
          };
        }
      } catch (e) {
        throw Exception('Failed to load quran.json data: $e');
      }
    }

    // 3. Extract Ayahs specific to this Surah
    List<Ayah> parsedAyahs = [];
    try {
      List<dynamic> surahList = [];
      if (_cachedQuranData != null) {
        if (_cachedQuranData!.containsKey('data')) {
          final dataObj = _cachedQuranData!['data'];
          if (dataObj is Map && dataObj.containsKey('surahs')) {
            surahList = dataObj['surahs'];
          } else if (dataObj is List) {
            surahList = dataObj;
          }
        } else if (_cachedQuranData!.containsKey('surahs')) {
          surahList = _cachedQuranData!['surahs'];
        }
      }

      // Find actual surah node in quran.json
      final targetSurahJson = surahList.firstWhere(
        (s) => (s['number'] ?? s['id']) == surahNumber,
        orElse: () => null,
      );

      if (targetSurahJson != null && targetSurahJson['ayahs'] != null) {
        final ayahsJson = targetSurahJson['ayahs'] as List<dynamic>;
        parsedAyahs = ayahsJson.map((item) {
          return Ayah(
            number: item['number'] ?? 0,
            text: item['text'] ?? '',
            numberInSurah: item['numberInSurah'] ?? 0,
            juz: item['juz'] ?? 1,
            page: item['page'] ?? 1,
            hizbQuarter: item['hizbQuarter'] ?? 1,
          );
        }).toList();
      }
    } catch (e) {
      throw Exception('Failed to parse ayahs for Surah $surahNumber: $e');
    }

    // 4. Merge metadata with actual parsed Ayahs
    return Surah(
      number: metadata.number,
      nameArabic: metadata.nameArabic,
      nameTransliteration: metadata.nameTransliteration,
      nameEnglish: metadata.nameEnglish,
      nameTurkish: metadata.nameTurkish,
      // Priority to actual parsed ayah count to avoid mismatch crashes
      ayahCount:
          parsedAyahs.isNotEmpty ? parsedAyahs.length : metadata.ayahCount,
      revelationType: metadata.revelationType,
      ayahs: parsedAyahs,
    );
  }
}
