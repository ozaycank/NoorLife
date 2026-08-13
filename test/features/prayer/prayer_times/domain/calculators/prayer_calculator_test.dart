import 'package:flutter_test/flutter_test.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:noor_life/features/prayer/calculation_methods/domain/entities/madhab.dart';
import 'package:noor_life/features/prayer/prayer_times/domain/calculators/calculation_method_profile.dart';
import 'package:noor_life/features/prayer/prayer_times/domain/calculators/high_latitude_strategy.dart';
import 'package:noor_life/features/prayer/prayer_times/domain/calculators/prayer_calculation_config.dart';
import 'package:noor_life/features/prayer/prayer_times/domain/calculators/prayer_calculator.dart';
import 'package:noor_life/core/base/result.dart';

void main() {
  setUpAll(() {
    tz.initializeTimeZones();
  });

  group('PrayerCalculator Math & Cross-Day Validation', () {
    test('Standard vs Hanafi Asr ensures Hanafi is chronologically later', () {
      final configStandard = PrayerCalculationConfig(
        latitude: 41.0082,
        longitude: 28.9784,
        dateUtc: DateTime.utc(2026, 8, 9),
        method: CalculationMethodProfile.mwl,
        madhab: const Madhab(id: 'shafi_hanbali_maliki', name: 'Standard'),
      );

      final configHanafi = PrayerCalculationConfig(
        latitude: 41.0082,
        longitude: 28.9784,
        dateUtc: DateTime.utc(2026, 8, 9),
        method: CalculationMethodProfile.mwl,
        madhab: const Madhab(id: 'hanafi', name: 'Hanafi'),
      );

      final resStandard =
          PrayerCalculator(configStandard).calculate() as Success;
      final resHanafi = PrayerCalculator(configHanafi).calculate() as Success;

      expect(resHanafi.value.asr.isAfter(resStandard.value.asr), isTrue);
    });

    test(
      'Polar Latitude gracefully explicitly rejects without valid High Latitude Strategy',
      () {
        final config = PrayerCalculationConfig(
          latitude: 80.0, // Svalbard Polar Day
          longitude: 15.0,
          dateUtc: DateTime.utc(2026, 6, 21),
          method: CalculationMethodProfile.mwl,
          madhab: const Madhab(id: 'shafi_hanbali_maliki', name: 'Standard'),
          highLatitudeStrategy: HighLatitudeStrategy.none,
        );

        final result = PrayerCalculator(config).calculate();
        expect(result, isA<ResultFailure>());
        if (result is ResultFailure) {
          final resFailure = result as ResultFailure;
          expect(resFailure.failure.message, contains('Astronomical failure'));
        }
      },
    );

    test(
      'High Latitude None strategy explicitly fails when Fajr is unreachable',
      () {
        final config = PrayerCalculationConfig(
          latitude: 55.0,
          longitude: -0.1278,
          dateUtc: DateTime.utc(2026, 6, 21),
          method: CalculationMethodProfile.mwl, // 18 degrees Fajr
          madhab: const Madhab(id: 'shafi_hanbali_maliki', name: 'Standard'),
          highLatitudeStrategy: HighLatitudeStrategy.none,
        );

        final result = PrayerCalculator(config).calculate();
        expect(result, isA<ResultFailure>());
        if (result is ResultFailure) {
          final resFailure = result as ResultFailure;
          expect(
            resFailure.failure.message,
            contains('Fajr angle not reached'),
          );
        }
      },
    );
  });
}
