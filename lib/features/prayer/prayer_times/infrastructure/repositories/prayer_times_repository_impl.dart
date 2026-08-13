import 'package:injectable/injectable.dart';
import '../../../../../core/base/result.dart';
import '../../../../../core/errors/failure.dart';
import '../../../../../core/services/timezone/timezone_service.dart';
import '../../../calculation_methods/domain/entities/madhab.dart';
import '../../../location/domain/entities/prayer_location.dart';
import '../../../shared/domain/errors/prayer_failure.dart';
import '../../../shared/infrastructure/datasources/prayer_local_data_source.dart';
import '../../domain/calculators/calculated_prayer_times.dart';
import '../../domain/calculators/calculation_method_profile.dart';
import '../../domain/calculators/high_latitude_strategy.dart';
import '../../domain/calculators/prayer_calculation_config.dart';
import '../../domain/calculators/prayer_calculator.dart';
import '../../domain/entities/prayer_day.dart';
import '../../domain/entities/prayer_time.dart';
import '../../domain/repositories/prayer_times_repository.dart';
import '../../domain/value_objects/prayer_name.dart';

@LazySingleton(as: PrayerTimesRepository)
class PrayerTimesRepositoryImpl implements PrayerTimesRepository {
  final PrayerLocalDataSource _localDataSource;
  final TimezoneService _timezoneService;

  PrayerTimesRepositoryImpl(this._localDataSource, this._timezoneService);

  @override
  Future<Result<PrayerDay, PrayerFailure>> getPrayerTimes(
    PrayerLocation location,
    DateTime targetDate,
  ) async {
    try {
      final methodId = await _localDataSource.getSelectedCalculationMethodId();
      final madhabId = await _localDataSource.getSelectedMadhabId();

      final methodResult = CalculationMethodProfile.fromId(methodId);
      CalculationMethodProfile methodProfile;

      switch (methodResult) {
        case ResultFailure(failure: final f):
          return ResultFailure(f as PrayerFailure);
        case Success(value: final v):
          methodProfile = v;
      }

      final baseDateUtc = DateTime.utc(
        targetDate.year,
        targetDate.month,
        targetDate.day,
      );

      final config = PrayerCalculationConfig(
        latitude: location.latitude,
        longitude: location.longitude,
        dateUtc: baseDateUtc,
        method: methodProfile,
        madhab: Madhab(id: madhabId, name: madhabId),
        highLatitudeStrategy: HighLatitudeStrategy.angleBased,
      );

      final calculator = PrayerCalculator(config);
      final calcResult = calculator.calculate();

      CalculatedPrayerTimes utcTimes;
      switch (calcResult) {
        case ResultFailure(failure: final f):
          return ResultFailure(f);
        case Success(value: final v):
          utcTimes = v;
      }

      final tomorrowConfig = PrayerCalculationConfig(
        latitude: location.latitude,
        longitude: location.longitude,
        dateUtc: baseDateUtc.add(const Duration(days: 1)),
        method: methodProfile,
        madhab: Madhab(id: madhabId, name: madhabId),
        highLatitudeStrategy: HighLatitudeStrategy.angleBased,
      );
      final tomorrowResult = PrayerCalculator(tomorrowConfig).calculate();

      DateTime? tomorrowFajrLocal;
      switch (tomorrowResult) {
        case ResultFailure():
          // Keep null if tomorrow fails
          break;
        case Success(value: final v):
          final res = _timezoneService.convertToTimezone(
            v.fajr,
            location.timezoneIdentifier,
          );
          if (res is Success<DateTime, Failure>) {
            tomorrowFajrLocal = res.value;
          }
      }

      DateTime convert(DateTime utc) {
        final res = _timezoneService.convertToTimezone(
          utc,
          location.timezoneIdentifier,
        );
        if (res is Success<DateTime, Failure>) return res.value;
        throw Exception(
          'Timezone conversion failed for ${location.timezoneIdentifier}',
        );
      }

      final prayerTimes = [
        PrayerTime(name: PrayerName.fajr, time: convert(utcTimes.fajr)),
        PrayerTime(name: PrayerName.sunrise, time: convert(utcTimes.sunrise)),
        PrayerTime(name: PrayerName.dhuhr, time: convert(utcTimes.dhuhr)),
        PrayerTime(name: PrayerName.asr, time: convert(utcTimes.asr)),
        PrayerTime(name: PrayerName.maghrib, time: convert(utcTimes.maghrib)),
        PrayerTime(name: PrayerName.isha, time: convert(utcTimes.isha)),
      ];

      return Success(
        PrayerDay(
          targetDate: targetDate,
          prayerTimes: prayerTimes,
          tomorrowFajr: tomorrowFajrLocal != null
              ? PrayerTime(name: PrayerName.fajr, time: tomorrowFajrLocal)
              : null,
          hijriDateString: null,
        ),
      );
    } catch (e) {
      return ResultFailure(
        PrayerCalculationFailure('Repository orchestration failed: $e'),
      );
    }
  }

  @override
  Future<Result<PrayerDay, PrayerFailure>> refreshPrayerTimes(
    PrayerLocation location,
    DateTime targetDate,
  ) async {
    return getPrayerTimes(location, targetDate);
  }
}
