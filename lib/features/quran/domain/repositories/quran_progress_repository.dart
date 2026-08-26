import '../entities/quran_reading_progress.dart';

abstract class QuranProgressRepository {
  Future<QuranReadingProgress?> getLastRead();
  Future<void> saveLastRead(QuranReadingProgress progress);
  Future<void> clearProgress();
}
