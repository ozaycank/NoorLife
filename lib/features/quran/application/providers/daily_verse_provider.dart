import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/di/injection_container.dart';
import '../../domain/entities/surah.dart';
import '../../domain/repositories/quran_repository.dart';
import 'quran_provider.dart';
import 'quran_translation_provider.dart';

class DailyVerseData {
  final Surah surah;
  final int ayahNumber;

  DailyVerseData(this.surah, this.ayahNumber);
}

class DailyVerseContent {
  final String arabicText;
  final String translation;

  DailyVerseContent({required this.arabicText, required this.translation});
}

final dailyVerseProvider = Provider<DailyVerseData?>((ref) {
  final quranState = ref.watch(quranNotifierProvider);
  if (quranState.surahs.isEmpty) return null;

  // Deterministik Seed: O gün için uygulama kaç kere açılırsa açılsın AYNI ayeti üretir.
  final now = DateTime.now();
  final seed = now.year * 10000 + now.month * 100 + now.day;
  final random = Random(seed);

  // Kısa ayeti olan sureleri filtrele (Aşırı uzun sureleri/ayetleri engelle)
  final validSurahs = quranState.surahs
      .where((s) => s.ayahCount > 0 && s.ayahCount < 150)
      .toList();
  if (validSurahs.isEmpty) return DailyVerseData(quranState.surahs.first, 1);

  final selectedSurah = validSurahs[random.nextInt(validSurahs.length)];
  final selectedAyah = random.nextInt(selectedSurah.ayahCount) + 1;

  return DailyVerseData(selectedSurah, selectedAyah);
});

final dailyVerseContentProvider =
    FutureProvider.family<DailyVerseContent?, String>(
        (ref, languageCode) async {
  final dailyVerse = ref.watch(dailyVerseProvider);
  if (dailyVerse == null) return null;

  final repository = getIt<QuranRepository>();
  final surahDetail = await repository.getSurahDetail(dailyVerse.surah.number);

  final ayah = surahDetail.ayahs?.firstWhere(
    (a) => a.numberInSurah == dailyVerse.ayahNumber,
    orElse: () => surahDetail.ayahs!.first,
  );

  // Fetch translation dynamically based on Locale
  final translationMap = await ref.watch(
    quranTranslationProvider((
      surahNumber: dailyVerse.surah.number,
      languageCode: languageCode,
    ),).future,
  );

  return DailyVerseContent(
    arabicText: ayah?.text ?? '',
    // FIX: `.toString()` yerine doğrudan JSON'daki karşılığı olan `.text` özelliğini çağırıyoruz.
    translation: translationMap[dailyVerse.ayahNumber]?.text ?? '',
  );
});
