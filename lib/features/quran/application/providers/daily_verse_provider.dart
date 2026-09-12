import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/surah.dart';
import 'quran_provider.dart';

class DailyVerseData {
  final Surah surah;
  final int ayahNumber;

  DailyVerseData(this.surah, this.ayahNumber);
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
