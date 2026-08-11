import '../../../../../core/base/result.dart';
import '../../../location/domain/entities/prayer_location.dart';
import '../../../shared/domain/errors/prayer_failure.dart';
import '../entities/prayer_day.dart';

abstract class PrayerTimesRepository {
  Future<Result<PrayerDay, PrayerFailure>> getPrayerTimes(
    PrayerLocation location,
    DateTime targetDate,
  );
  Future<Result<PrayerDay, PrayerFailure>> refreshPrayerTimes(
    PrayerLocation location,
    DateTime targetDate,
  );
}
