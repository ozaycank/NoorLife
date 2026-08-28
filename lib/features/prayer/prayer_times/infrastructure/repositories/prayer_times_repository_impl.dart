import 'package:hijri/hijri_calendar.dart';
import 'package:injectable/injectable.dart';
import '../../../../../core/base/result.dart';
import '../../../../../core/errors/failure.dart';
import '../../../../../core/services/timezone/timezone_service.dart';
import '../../../location/domain/entities/prayer_location.dart';
import '../../../shared/domain/errors/prayer_failure.dart';
import '../../../shared/infrastructure/datasources/prayer_local_data_source.dart';
import '../../domain/calculators/calculation_method_profile.dart';
import '../../domain/calculators/prayer_calculation_config.dart';
import '../../domain/calculators/prayer_calculator.dart';
import '../../domain/calculators/calculated_prayer_times.dart';
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
      final methodId =
          await _localDataSource.getSelectedCalculationMethodId() ??
              'diyar_turk';
      final madhabId = await _localDataSource.getSelectedMadhabId() ??
          'shafi_hanbali_maliki';
      final highLatStrategy =
          await _localDataSource.getSelectedHighLatitudeStrategy();

      final methodResult = CalculationMethodProfile.fromId(methodId);
      CalculationMethodProfile methodProfile;

      switch (methodResult) {
        case ResultFailure(failure: final f):
          return ResultFailure(f as PrayerFailure);
        case Success(value: final v):
          methodProfile = v;
      }

      final supportedMadhabs = await _localDataSource.getSupportedMadhabs();
      final madhabList =
          supportedMadhabs.where((m) => m.id == madhabId).toList();
      if (madhabList.isEmpty) {
        return ResultFailure(
          PrayerCalculationFailure(
            'Unsupported madhab ID explicitly rejected: $madhabId',
          ),
        );
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
        madhab: madhabList.first,
        highLatitudeStrategy: highLatStrategy,
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

      // Base times converted to local timezone
      final localFajr = convert(utcTimes.fajr);
      DateTime localSunrise = convert(utcTimes.sunrise);
      DateTime localDhuhr = convert(utcTimes.dhuhr);
      DateTime localAsr = convert(utcTimes.asr);
      DateTime localMaghrib = convert(utcTimes.maghrib);
      final localIsha = convert(utcTimes.isha);

      // FIX: Apply deterministic Diyanet Prescautionary Offsets (Temkin Payı)
      // Diyanet historically adds these exact minute corrections on top of pure astronomical times.
      if (methodId == 'diyar_turk') {
        localSunrise = localSunrise.add(const Duration(minutes: -7));
        localDhuhr = localDhuhr.add(const Duration(minutes: 5));
        localAsr = localAsr.add(
          const Duration(
            minutes: 4,
          ),
        ); // Varies strictly by shadow angle mathematically, typical base is +4
        localMaghrib = localMaghrib.add(const Duration(minutes: 7));
        // Fajr and Isha offsets are generally integrated into the 18/17 degree rules directly by Adhan's Diyanet profile.
      }

      final prayerTimes = [
        PrayerTime(name: PrayerName.fajr, time: localFajr),
        PrayerTime(name: PrayerName.sunrise, time: localSunrise),
        PrayerTime(name: PrayerName.dhuhr, time: localDhuhr),
        PrayerTime(name: PrayerName.asr, time: localAsr),
        PrayerTime(name: PrayerName.maghrib, time: localMaghrib),
        PrayerTime(name: PrayerName.isha, time: localIsha),
      ];

      final hijriDate = HijriCalendar.fromDate(
        DateTime(targetDate.year, targetDate.month, targetDate.day),
      );
      final hijriString =
          '${hijriDate.hDay} ${hijriDate.longMonthName} ${hijriDate.hYear}';

      return Success(
        PrayerDay(
          targetDate: targetDate,
          prayerTimes: prayerTimes,
          hijriDateString: hijriString,
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
