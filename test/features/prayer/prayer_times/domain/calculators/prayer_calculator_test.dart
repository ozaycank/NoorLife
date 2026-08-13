import 'package:flutter_test/flutter_test.dart';
import 'package:noor_life/features/prayer/calculation_methods/domain/entities/madhab.dart';
import 'package:noor_life/features/prayer/prayer_times/domain/calculators/calculation_method_profile.dart';
import 'package:noor_life/features/prayer/prayer_times/domain/calculators/prayer_calculation_config.dart';
import 'package:noor_life/features/prayer/prayer_times/domain/calculators/prayer_calculator.dart';
import 'package:noor_life/core/base/result.dart';

void main() {
  group('PrayerCalculator Math & Validation', () {
    test('Standard vs Hanafi Asr applies verified shadow ratios', () {
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

      final timesStandard = resStandard.value;
      final timesHanafi = resHanafi.value;

      expect(timesHanafi.asr.isAfter(timesStandard.asr), isTrue);

      final diffMins = timesHanafi.asr.difference(timesStandard.asr).inMinutes;
      expect(diffMins, greaterThan(45));
      expect(diffMins, lessThan(80));
    });

    test('Invalid Madhab ID causes explicit failure', () {
      final configInvalidMadhab = PrayerCalculationConfig(
        latitude: 41.0082,
        longitude: 28.9784,
        dateUtc: DateTime.utc(2026, 8, 9),
        method: CalculationMethodProfile.mwl,
        madhab: const Madhab(id: 'random_id', name: 'Unknown'),
      );

      final result = PrayerCalculator(configInvalidMadhab).calculate();
      expect(result, isA<ResultFailure>());
      if (result is ResultFailure) {
        // Explicitly cast to ResultFailure to access failure property
        final failureResult = result as ResultFailure;
        expect(
            failureResult.failure.message, contains('Unsupported madhab ID'),);
      }
    });

    test(
        'Abnormal Polar Latitude returns Astronomical Failure without High Latitude Strategy',
        () {
      final config = PrayerCalculationConfig(
        latitude: 80.0, // Svalbard (Polar Day/Night)
        longitude: 15.0,
        dateUtc: DateTime.utc(2026, 6, 21), // Summer Solstice (Midnight Sun)
        method: CalculationMethodProfile.mwl,
        madhab: const Madhab(id: 'shafi_hanbali_maliki', name: 'Standard'),
      );

      final result = PrayerCalculator(config).calculate();
      expect(result, isA<ResultFailure>());
      if (result is ResultFailure) {
        // Explicitly cast to ResultFailure to access failure property
        final failureResult = result as ResultFailure;
        expect(failureResult.failure.message, contains('Astronomical failure'));
      }
    });
  });
}
