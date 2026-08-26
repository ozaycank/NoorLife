import '../../../../core/base/result.dart';
import '../entities/quran_reading_progress.dart';
import '../errors/quran_failure.dart';

abstract class QuranProgressRepository {
  Future<Result<QuranReadingProgress?, QuranFailure>> getLastRead();
  Future<Result<void, QuranFailure>> saveLastRead(
      QuranReadingProgress progress,);
  Future<Result<void, QuranFailure>> clearProgress();
}
