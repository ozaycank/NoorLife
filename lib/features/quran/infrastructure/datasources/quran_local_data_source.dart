import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';
import '../models/surah_model.dart';

abstract class QuranLocalDataSource {
  Future<List<SurahModel>> getSurahs();
  Future<SurahModel> getSurahDetail(int surahNumber);
}

@LazySingleton(as: QuranLocalDataSource)
class QuranLocalDataSourceImpl implements QuranLocalDataSource {
  static const String _fullQuranPath = 'assets/data/quran/quran.json';
  List<SurahModel>? _cachedSurahs;

  Future<void> _loadAndCache() async {
    if (_cachedSurahs != null) return;

    try {
      final jsonString = await rootBundle.loadString(_fullQuranPath);
      final dynamic jsonMap = json.decode(jsonString);

      List<dynamic> surahsList;
      if (jsonMap is Map<String, dynamic> && jsonMap.containsKey('data')) {
        surahsList = jsonMap['data']['surahs'] as List<dynamic>;
      } else if (jsonMap is List) {
        surahsList = jsonMap;
      } else {
        throw Exception('Invalid Quran JSON structure.');
      }

      _cachedSurahs = surahsList
          .map((e) => SurahModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to load local Quran file: $e');
    }
  }

  @override
  Future<List<SurahModel>> getSurahs() async {
    await _loadAndCache();
    return _cachedSurahs!;
  }

  @override
  Future<SurahModel> getSurahDetail(int surahNumber) async {
    await _loadAndCache();
    return _cachedSurahs!.firstWhere(
      (s) => s.number == surahNumber,
      orElse: () => throw Exception('Surah $surahNumber not found.'),
    );
  }
}
