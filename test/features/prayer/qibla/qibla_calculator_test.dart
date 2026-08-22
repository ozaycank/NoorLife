import 'package:flutter_test/flutter_test.dart';
import 'package:noor_life/core/base/result.dart';
import 'package:noor_life/features/prayer/qibla/domain/qibla_calculator.dart';

void main() {
  group('QiblaCalculator Deterministic Tests', () {
    test('Istanbul to Kaaba calculates correctly', () {
      final result = QiblaCalculator.calculate(
        latitude: 41.0082,
        longitude: 28.9784,
      );

      expect(result, isA<Success>());
      final direction = (result as Success).value;
      // Exact spherical formula result typically around 151.3 degrees
      expect(direction.bearingDegrees, closeTo(151.3, 0.5));
    });

    test('London to Kaaba calculates correctly', () {
      final result = QiblaCalculator.calculate(
        latitude: 51.5074,
        longitude: -0.1278,
      );

      expect(result, isA<Success>());
      final direction = (result as Success).value;
      expect(direction.bearingDegrees, closeTo(118.9, 0.5));
    });

    test('New York to Kaaba calculates correctly', () {
      final result = QiblaCalculator.calculate(
        latitude: 40.7128,
        longitude: -74.0060,
      );

      expect(result, isA<Success>());
      final direction = (result as Success).value;
      expect(direction.bearingDegrees, closeTo(58.5, 0.5));
    });

    test('Tokyo to Kaaba calculates correctly', () {
      final result = QiblaCalculator.calculate(
        latitude: 35.6762,
        longitude: 139.6503,
      );

      expect(result, isA<Success>());
      final direction = (result as Success).value;
      expect(direction.bearingDegrees, closeTo(293.0, 0.5));
    });

    test('Invalid coordinates return QiblaFailure explicitly', () {
      final res1 = QiblaCalculator.calculate(latitude: 95.0, longitude: 0.0);
      expect(res1, isA<ResultFailure>());
      expect((res1 as ResultFailure).failure.code, 'invalid_latitude');

      final res2 = QiblaCalculator.calculate(latitude: 0.0, longitude: 200.0);
      expect(res2, isA<ResultFailure>());
      expect((res2 as ResultFailure).failure.code, 'invalid_longitude');
    });
  });
}
