import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';
import '../models/surah_model.dart';

abstract class QuranLocalDataSource {
  Future<List<SurahModel>> getSurahs();
}

@LazySingleton(as: QuranLocalDataSource)
class QuranLocalDataSourceImpl implements QuranLocalDataSource {
  static const String _catalogPath = 'assets/data/quran/surahs.json';

  @override
  Future<List<SurahModel>> getSurahs() async {
    try {
      final jsonString = await rootBundle.loadString(_catalogPath);
      final List<dynamic> jsonMap = json.decode(jsonString);
      return jsonMap.map((e) => SurahModel.fromJson(e)).toList();
    } catch (e) {
      throw Exception('Failed to load local surah catalog: $e');
    }
  }
}
