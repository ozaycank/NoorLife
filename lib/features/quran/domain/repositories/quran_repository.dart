import '../entities/surah.dart';

abstract class QuranRepository {
  Future<List<Surah>> getSurahs();
  Future<Surah> getSurahDetail(int surahNumber);
}
