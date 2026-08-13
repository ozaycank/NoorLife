import 'package:injectable/injectable.dart';
import '../../../../../core/base/result.dart';
import '../../../location/domain/entities/prayer_location.dart';
import '../../../shared/domain/errors/prayer_failure.dart';
import '../../domain/entities/prayer_schedule.dart';
import '../../domain/repositories/prayer_times_repository.dart';

@lazySingleton
class PrayerOrchestratorService {
  final PrayerTimesRepository _repository;

  PrayerOrchestratorService(this._repository);

  Future<Result<PrayerSchedule, PrayerFailure>> getSchedule(
    PrayerLocation location,
    DateTime targetDate,
  ) async {
    final yesterdayDate = targetDate.subtract(const Duration(days: 1));
    final tomorrowDate = targetDate.add(const Duration(days: 1));

    final results = await Future.wait([
      _repository.getPrayerTimes(location, yesterdayDate),
      _repository.getPrayerTimes(location, targetDate),
      _repository.getPrayerTimes(location, tomorrowDate),
    ]);

    final yesterdayResult = results[0];
    final todayResult = results[1];
    final tomorrowResult = results[2];

    if (todayResult is ResultFailure) {
      return ResultFailure(
        (todayResult as ResultFailure).failure as PrayerFailure,
      );
    }
    if (yesterdayResult is ResultFailure) {
      return ResultFailure(
        (yesterdayResult as ResultFailure).failure as PrayerFailure,
      );
    }
    if (tomorrowResult is ResultFailure) {
      return ResultFailure(
        (tomorrowResult as ResultFailure).failure as PrayerFailure,
      );
    }

    return Success(
      PrayerSchedule(
        yesterday: (yesterdayResult as Success).value,
        today: (todayResult as Success).value,
        tomorrow: (tomorrowResult as Success).value,
      ),
    );
  }
}
