import 'package:injectable/injectable.dart';
import '../../../../../core/base/result.dart';
import '../../../calculation_methods/domain/entities/madhab.dart';
import '../../../location/domain/entities/prayer_location.dart';
import '../../../shared/domain/errors/prayer_failure.dart';
import '../../../shared/infrastructure/datasources/prayer_local_data_source.dart';
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

  PrayerTimesRepositoryImpl(this._localDataSource);

  @override
  Future<Result<PrayerDay, PrayerFailure>> getPrayerTimes(
    PrayerLocation location,
    DateTime targetDate,
  ) async {
    try {
      final methodId = await _localDataSource.getSelectedCalculationMethodId();
      final madhabId = await _localDataSource.getSelectedMadhabId();

      final methodResult = CalculationMethodProfile.fromId(methodId);
      if (methodResult is ResultFailure) {
        return ResultFailure(
            (methodResult as ResultFailure).failure as PrayerFailure,);
      }
      final methodProfile =
          (methodResult as Success<CalculationMethodProfile, PrayerFailure>)
              .value;

      final config = PrayerCalculationConfig(
        latitude: location.latitude,
        longitude: location.longitude,
        date: targetDate,
        timezone: 'Europe/Istanbul',
        method: methodProfile,
        madhab: Madhab(id: madhabId, name: madhabId),
        highLatitudeStrategy: HighLatitudeStrategy.angleBased,
      );

      final calculator = PrayerCalculator(config);
      final calcResult = calculator.calculate();

      if (calcResult is ResultFailure) {
        return ResultFailure(
            (calcResult as ResultFailure).failure as PrayerFailure,);
      }

      final times = (calcResult as Success).value;

      final prayerTimes = [
        PrayerTime(name: PrayerName.fajr, time: times.fajr),
        PrayerTime(name: PrayerName.sunrise, time: times.sunrise),
        PrayerTime(name: PrayerName.dhuhr, time: times.dhuhr),
        PrayerTime(name: PrayerName.asr, time: times.asr),
        PrayerTime(name: PrayerName.maghrib, time: times.maghrib),
        PrayerTime(name: PrayerName.isha, time: times.isha),
      ];

      return Success(PrayerDay(date: targetDate, prayerTimes: prayerTimes));
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
