import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';
import '../../domain/entities/quran_translation.dart';

abstract class QuranTranslationLocalDataSource {
  Future<List<QuranTranslation>> getTranslationsForSurah(int surahNumber);
}

@LazySingleton(as: QuranTranslationLocalDataSource)
class QuranTranslationLocalDataSourceImpl
    implements QuranTranslationLocalDataSource {
  // Developer must place the verified JSON file here.
  static const String _translationPath =
      'assets/data/quran/translations/tr/translation.json';

  @override
  Future<List<QuranTranslation>> getTranslationsForSurah(
    int surahNumber,
  ) async {
    try {
      final jsonString = await rootBundle.loadString(_translationPath);
      final dynamic jsonMap = json.decode(jsonString);

      List<dynamic> jsonList;
      if (jsonMap is Map<String, dynamic> && jsonMap.containsKey('data')) {
        jsonList = jsonMap['data'] as List<dynamic>;
      } else if (jsonMap is List) {
        jsonList = jsonMap;
      } else {
        throw Exception('Invalid translation JSON structure.');
      }

      final validTranslations = <QuranTranslation>[];
      for (final item in jsonList) {
        try {
          if (item is Map<String, dynamic>) {
            final t = QuranTranslation.fromJson(item);
            if (t.surahNumber == surahNumber &&
                t.ayahNumber > 0 &&
                t.text.isNotEmpty) {
              validTranslations.add(t);
            }
          }
        } catch (_) {
          // Safely skip malformed items
        }
      }
      return validTranslations;
    } catch (e) {
      throw Exception('Failed to load local translation file: $e');
    }
  }
}
