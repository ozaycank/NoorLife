import 'package:injectable/injectable.dart';
import '../../domain/entities/quran_reading_progress.dart';
import '../../domain/repositories/quran_progress_repository.dart';
import '../datasources/quran_progress_local_data_source.dart';

@LazySingleton(as: QuranProgressRepository)
class QuranProgressRepositoryImpl implements QuranProgressRepository {
  final QuranProgressLocalDataSource _localDataSource;

  const QuranProgressRepositoryImpl(this._localDataSource);

  @override
  Future<QuranReadingProgress?> getLastRead() async {
    try {
      return await _localDataSource.getLastRead();
    } catch (e) {
      throw Exception('Failed to load progress: $e');
    }
  }

  @override
  Future<void> saveLastRead(QuranReadingProgress progress) async {
    if (progress.surahNumber < 1 ||
        progress.surahNumber > 114 ||
        progress.ayahNumber < 1) {
      throw Exception('Invalid progress data');
    }
    try {
      await _localDataSource.saveLastRead(progress);
    } catch (e) {
      throw Exception('Failed to save progress: $e');
    }
  }

  @override
  Future<void> clearProgress() async {
    try {
      await _localDataSource.clearProgress();
    } catch (e) {
      throw Exception('Failed to clear progress: $e');
    }
  }
}
