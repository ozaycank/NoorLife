import 'package:injectable/injectable.dart';
import '../../../../../core/base/result.dart';
import '../../../location/domain/entities/prayer_location.dart';
import '../../../shared/domain/errors/prayer_failure.dart';
import '../../domain/entities/prayer_day.dart';
import '../../domain/repositories/prayer_times_repository.dart';
import '../../domain/value_objects/prayer_name.dart';
import '../models/prayer_day_model.dart';
import '../models/prayer_time_model.dart';

@LazySingleton(as: PrayerTimesRepository)
class PrayerTimesRepositoryImpl implements PrayerTimesRepository {
  @override
  Future<Result<PrayerDay, PrayerFailure>> getPrayerTimes(
    PrayerLocation location,
  ) async {
    await Future.delayed(const Duration(milliseconds: 600));
    return Success(_buildDummyDay());
  }

  @override
  Future<Result<PrayerDay, PrayerFailure>> refreshPrayerTimes(
    PrayerLocation location,
  ) async {
    await Future.delayed(const Duration(milliseconds: 600));
    return Success(_buildDummyDay());
  }

  PrayerDayModel _buildDummyDay() {
    return PrayerDayModel(
      dateIso8601: '2026-08-07',
      hijriDateFormatted: '23 Safar 1448 AH',
      nextPrayerName: 'Asr',
      timeRemainingFormatted: '02h 15m',
      prayerTimes: [
        PrayerTimeModel(
          name: PrayerName.fajr,
          time: DateTime.now().subtract(const Duration(hours: 4)),
          formattedTime: '04:35',
          remainingDuration: Duration.zero,
          isPassed: true,
          isCurrent: false,
          isUpcoming: false,
          isNext: false,
        ),
        PrayerTimeModel(
          name: PrayerName.sunrise,
          time: DateTime.now().subtract(const Duration(hours: 2)),
          formattedTime: '06:05',
          remainingDuration: Duration.zero,
          isPassed: true,
          isCurrent: false,
          isUpcoming: false,
          isNext: false,
        ),
        PrayerTimeModel(
          name: PrayerName.dhuhr,
          time: DateTime.now().subtract(const Duration(minutes: 30)),
          formattedTime: '13:15',
          remainingDuration: Duration.zero,
          isPassed: true,
          isCurrent: true,
          isUpcoming: false,
          isNext: false,
        ),
        PrayerTimeModel(
          name: PrayerName.asr,
          time: DateTime.now().add(const Duration(hours: 2)),
          formattedTime: '17:05',
          remainingDuration: const Duration(hours: 2),
          isPassed: false,
          isCurrent: false,
          isUpcoming: true,
          isNext: true,
        ),
        PrayerTimeModel(
          name: PrayerName.maghrib,
          time: DateTime.now().add(const Duration(hours: 5)),
          formattedTime: '20:15',
          remainingDuration: const Duration(hours: 5),
          isPassed: false,
          isCurrent: false,
          isUpcoming: true,
          isNext: false,
        ),
        PrayerTimeModel(
          name: PrayerName.isha,
          time: DateTime.now().add(const Duration(hours: 6, minutes: 30)),
          formattedTime: '21:40',
          remainingDuration: const Duration(hours: 6, minutes: 30),
          isPassed: false,
          isCurrent: false,
          isUpcoming: true,
          isNext: false,
        ),
      ],
    );
  }
}
