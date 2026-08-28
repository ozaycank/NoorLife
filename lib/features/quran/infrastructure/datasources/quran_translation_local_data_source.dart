import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';
import '../../domain/entities/quran_translation.dart';
import '../models/quran_translation_model.dart';

abstract class QuranTranslationLocalDataSource {
  Future<List<QuranTranslation>> getTranslationsForSurah(int surahNumber);
}

@LazySingleton(as: QuranTranslationLocalDataSource)
class QuranTranslationLocalDataSourceImpl
    implements QuranTranslationLocalDataSource {
  // Path assumes developer puts a verified JSON asset here.
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
      final seenAyahs =
          <int>{}; // Prevent duplicates deterministically (first wins)

      for (final item in jsonList) {
        try {
          if (item is Map<String, dynamic>) {
            final t = QuranTranslationModel.fromJson(item).toDomain();

            // Domain validation checks
            if (t.surahNumber == surahNumber && t.ayahNumber > 0) {
              if (!seenAyahs.contains(t.ayahNumber)) {
                validTranslations.add(t);
                seenAyahs.add(t.ayahNumber);
              }
            }
          }
        } catch (_) {
          // Safely skip malformed items without crashing the loop
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
