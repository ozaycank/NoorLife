import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';
import '../../domain/entities/quran_translation.dart';
import '../models/quran_translation_model.dart';

abstract class QuranTranslationLocalDataSource {
  Future<List<QuranTranslation>> getTranslationsForSurah(
    int surahNumber,
    String languageCode,
  );
}

@LazySingleton(as: QuranTranslationLocalDataSource)
class QuranTranslationLocalDataSourceImpl
    implements QuranTranslationLocalDataSource {
  @override
  Future<List<QuranTranslation>> getTranslationsForSurah(
    int surahNumber,
    String languageCode,
  ) async {
    try {
      final translationPath =
          'assets/data/quran/translations/$languageCode/translation.json';
      final jsonString = await rootBundle.loadString(translationPath);
      final dynamic jsonMap = json.decode(jsonString);

      List<dynamic> jsonList;

      // Fawaz Ahmed's JSON has {"quran": [ {...} ] } or something similar
      if (jsonMap is Map<String, dynamic>) {
        if (jsonMap.containsKey('quran')) {
          jsonList = jsonMap['quran'] as List<dynamic>;
        } else if (jsonMap.containsKey('data')) {
          jsonList = jsonMap['data'] as List<dynamic>;
        } else if (jsonMap.containsKey('verses')) {
          jsonList = jsonMap['verses'] as List<dynamic>;
        } else {
          // If it's a map but has no array key, maybe it's just keys?
          throw Exception('Invalid translation JSON Object structure.');
        }
      } else if (jsonMap is List) {
        jsonList = jsonMap;
      } else {
        throw Exception('Invalid translation JSON structure.');
      }

      final validTranslations = <QuranTranslation>[];
      final seenAyahs = <int>{};

      for (final item in jsonList) {
        try {
          if (item is Map<String, dynamic>) {
            final t = QuranTranslationModel.fromJson(item).toDomain();

            if (t.surahNumber == surahNumber && t.ayahNumber > 0) {
              if (!seenAyahs.contains(t.ayahNumber)) {
                validTranslations.add(t);
                seenAyahs.add(t.ayahNumber);
              }
            }
          }
        } catch (_) {
          // Safely skip malformed items
        }
      }

      if (validTranslations.isEmpty) {
        throw Exception('No valid translations found for surah.');
      }

      return validTranslations;
    } catch (e) {
      throw Exception('Failed to load or parse local translation file: $e');
    }
  }
}
