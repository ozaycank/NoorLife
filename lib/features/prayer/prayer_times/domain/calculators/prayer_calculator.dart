import 'dart:math' as math;
import 'package:timezone/timezone.dart' as tz;
import '../../../../../core/base/result.dart';
import '../../../shared/domain/errors/prayer_failure.dart';
import 'astronomical_math.dart';
import 'calculated_prayer_times.dart';
import 'high_latitude_strategy.dart';
import 'prayer_calculation_config.dart';

class PrayerCalculator {
  final PrayerCalculationConfig config;

  const PrayerCalculator(this.config);

  Result<CalculatedPrayerTimes, PrayerCalculationFailure> calculate() {
    try {
      tz.Location targetLocation;
      try {
        targetLocation = tz.getLocation(config.timezone);
      } catch (_) {
        return ResultFailure(
          PrayerCalculationFailure('Invalid timezone: ${config.timezone}'),
        );
      }

      final jdNoonUtc = AstronomicalMath.calculateJulianDay(
        config.date.year,
        config.date.month,
        config.date.day,
        12.0,
      );

      final sunPos = AstronomicalMath.calculateSunPosition(jdNoonUtc);
      final decl = sunPos[0];
      final eqt = sunPos[1];
      final noonUTC = 12.0 - (config.longitude / 15.0) - eqt;

      const angleSunriseSunset = -0.833;
      final hourAngleSunrise = AstronomicalMath.calculateHourAngle(
        angleSunriseSunset,
        decl,
        config.latitude,
      );

      if (hourAngleSunrise.isNaN &&
          config.highLatitudeStrategy == HighLatitudeStrategy.none) {
        return const ResultFailure(
          PrayerCalculationFailure(
            'Astronomical failure: Sun does not rise/set at this latitude.',
          ),
        );
      }

      final sunriseUTC = noonUTC - hourAngleSunrise;
      final sunsetUTC = noonUTC + hourAngleSunrise;

      final jdTomorrowNoon = AstronomicalMath.calculateJulianDay(
        config.date.year,
        config.date.month,
        config.date.day + 1,
        12.0,
      );
      final sunPosTomorrow =
          AstronomicalMath.calculateSunPosition(jdTomorrowNoon);
      final noonTomorrowUTC =
          12.0 - (config.longitude / 15.0) - sunPosTomorrow[1];
      final hourAngleTomorrow = AstronomicalMath.calculateHourAngle(
        angleSunriseSunset,
        sunPosTomorrow[0],
        config.latitude,
      );
      final tomorrowSunriseUTC = noonTomorrowUTC - hourAngleTomorrow + 24.0;

      final nightDuration = tomorrowSunriseUTC - sunsetUTC;

      final fajrAngle = -config.method.fajrAngle;
      double fajrUTC = noonUTC -
          AstronomicalMath.calculateHourAngle(
            fajrAngle,
            decl,
            config.latitude,
          );

      double ishaUTC = double.nan;
      if (config.method.ishaIntervalMinutes != null) {
        ishaUTC = sunsetUTC + (config.method.ishaIntervalMinutes! / 60.0);
      } else if (config.method.ishaAngle != null) {
        final ishaAngle = -config.method.ishaAngle!;
        ishaUTC = noonUTC +
            AstronomicalMath.calculateHourAngle(
              ishaAngle,
              decl,
              config.latitude,
            );
      }

      final asrShadowFactor = config.madhab.id == 'hanafi' ? 2.0 : 1.0;
      final latDeclDiff = (config.latitude - decl).abs();
      final asrAngle = AstronomicalMath.rad2deg(
        math.atan(
          1.0 /
              (asrShadowFactor +
                  math.tan(AstronomicalMath.deg2rad(latDeclDiff))),
        ),
      );

      final asrUTC = noonUTC +
          AstronomicalMath.calculateHourAngle(
            asrAngle,
            decl,
            config.latitude,
          );

      if (fajrUTC.isNaN) {
        if (config.highLatitudeStrategy == HighLatitudeStrategy.angleBased) {
          fajrUTC =
              sunriseUTC - (nightDuration * (config.method.fajrAngle / 60.0));
        } else if (config.highLatitudeStrategy ==
            HighLatitudeStrategy.oneSeventh) {
          fajrUTC = sunriseUTC - (nightDuration / 7.0);
        } else if (config.highLatitudeStrategy ==
            HighLatitudeStrategy.nightMiddle) {
          fajrUTC = sunriseUTC - (nightDuration / 2.0);
        } else {
          return const ResultFailure(
            PrayerCalculationFailure('Fajr angle not reached (High Latitude).'),
          );
        }
      }

      if (ishaUTC.isNaN) {
        if (config.highLatitudeStrategy == HighLatitudeStrategy.angleBased &&
            config.method.ishaAngle != null) {
          ishaUTC =
              sunsetUTC + (nightDuration * (config.method.ishaAngle! / 60.0));
        } else if (config.highLatitudeStrategy ==
            HighLatitudeStrategy.oneSeventh) {
          ishaUTC = sunsetUTC + (nightDuration / 7.0);
        } else if (config.highLatitudeStrategy ==
            HighLatitudeStrategy.nightMiddle) {
          ishaUTC = sunsetUTC + (nightDuration / 2.0);
        } else {
          return const ResultFailure(
            PrayerCalculationFailure('Isha angle not reached (High Latitude).'),
          );
        }
      }

      return Success(
        CalculatedPrayerTimes(
          fajr: _utcDecimalToTZ(config.date, fajrUTC, targetLocation),
          sunrise: _utcDecimalToTZ(config.date, sunriseUTC, targetLocation),
          dhuhr: _utcDecimalToTZ(config.date, noonUTC, targetLocation),
          asr: _utcDecimalToTZ(config.date, asrUTC, targetLocation),
          sunset: _utcDecimalToTZ(config.date, sunsetUTC, targetLocation),
          maghrib: _utcDecimalToTZ(config.date, sunsetUTC, targetLocation),
          isha: _utcDecimalToTZ(config.date, ishaUTC, targetLocation),
        ),
      );
    } catch (e) {
      return ResultFailure(
        PrayerCalculationFailure('Critical engine failure: $e'),
      );
    }
  }

  DateTime _utcDecimalToTZ(
    DateTime baseDate,
    double utcDecimalHours,
    tz.Location targetLocation,
  ) {
    final fixedHours = AstronomicalMath.fixHour(utcDecimalHours);
    final dayOffset =
        utcDecimalHours < 0 ? -1 : (utcDecimalHours >= 24 ? 1 : 0);

    final hours = fixedHours.floor();
    final minutes = ((fixedHours - hours) * 60).floor();
    final seconds = ((((fixedHours - hours) * 60) - minutes) * 60).floor();

    final utcTime = DateTime.utc(
      baseDate.year,
      baseDate.month,
      baseDate.day + dayOffset,
      hours,
      minutes,
      seconds,
    );

    return tz.TZDateTime.from(utcTime, targetLocation);
  }
}
