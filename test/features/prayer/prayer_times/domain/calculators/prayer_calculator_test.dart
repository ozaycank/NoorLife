import 'package:flutter_test/flutter_test.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:noor_life/features/prayer/calculation_methods/domain/entities/madhab.dart';
import 'package:noor_life/features/prayer/prayer_times/domain/calculators/calculation_method_profile.dart';
import 'package:noor_life/features/prayer/prayer_times/domain/calculators/prayer_calculation_config.dart';
import 'package:noor_life/features/prayer/prayer_times/domain/calculators/prayer_calculator.dart';
import 'package:noor_life/core/base/result.dart';

void main() {
  setUpAll(() {
    tz.initializeTimeZones();
  });

  group('PrayerCalculator Engine Validation', () {
    test('Standard Asr vs Hanafi Asr applies correct shadow ratio', () {
      final configStandard = PrayerCalculationConfig(
        latitude: 41.0082,
        longitude: 28.9784,
        date: DateTime.utc(2026, 8, 9),
        timezone: 'Europe/Istanbul',
        method: CalculationMethodProfile.mwl,
        madhab: const Madhab(id: 'shafi_hanbali_maliki', name: 'Standard'),
      );

      final configHanafi = PrayerCalculationConfig(
        latitude: 41.0082,
        longitude: 28.9784,
        date: DateTime.utc(2026, 8, 9),
        timezone: 'Europe/Istanbul',
        method: CalculationMethodProfile.mwl,
        madhab: const Madhab(id: 'hanafi', name: 'Hanafi'),
      );

      final resStandard =
          PrayerCalculator(configStandard).calculate() as Success;
      final resHanafi = PrayerCalculator(configHanafi).calculate() as Success;

      final timesStandard = resStandard.value;
      final timesHanafi = resHanafi.value;

      expect(timesHanafi.asr.isAfter(timesStandard.asr), isTrue);
      expect(
        timesHanafi.asr.difference(timesStandard.asr).inMinutes,
        greaterThan(30),
      );
    });

    test('Invalid Configuration causes domain ArgumentError', () {
      expect(
        () => PrayerCalculationConfig(
          latitude: 100.0, // Invalid
          longitude: 28.9784,
          date: DateTime.utc(2026, 8, 9),
          timezone: 'Europe/Istanbul',
          method: CalculationMethodProfile.mwl,
          madhab: const Madhab(id: 'standard', name: 'Standard'),
        ),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('Invalid Timezone creates ResultFailure', () {
      final config = PrayerCalculationConfig(
        latitude: 41.0082,
        longitude: 28.9784,
        date: DateTime.utc(2026, 8, 9),
        timezone: 'Fake/Timezone',
        method: CalculationMethodProfile.mwl,
        madhab: const Madhab(id: 'standard', name: 'Standard'),
      );

      final result = PrayerCalculator(config).calculate();
      expect(result, isA<ResultFailure>());
    });
  });
}
