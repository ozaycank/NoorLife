import 'package:flutter_test/flutter_test.dart';
import 'package:noor_life/core/base/result.dart';
import 'package:noor_life/features/prayer/qibla/domain/qibla_calculator.dart';
import 'package:noor_life/features/prayer/qibla/domain/qibla_models.dart';

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

    test('Kaaba to Kaaba yields explicit undefined failure', () {
      final result = QiblaCalculator.calculate(
        latitude: KaabaConstants.latitude,
        longitude: KaabaConstants.longitude,
      );

      expect(result, isA<ResultFailure>());
      expect((result as ResultFailure).failure.code, 'qiblaUndefinedAtKaaba');
    });

    test('Antimeridian (-180 / 180) evaluates smoothly without exceptions', () {
      final res1 = QiblaCalculator.calculate(latitude: 0, longitude: 180.0);
      final res2 = QiblaCalculator.calculate(latitude: 0, longitude: -180.0);
      expect(res1, isA<Success>());
      expect(res2, isA<Success>());
    });

    test('Poles (90 / -90) evaluate smoothly without exceptions', () {
      final resN = QiblaCalculator.calculate(latitude: 90.0, longitude: 0.0);
      expect(resN, isA<Success>());
      final resS = QiblaCalculator.calculate(latitude: -90.0, longitude: 0.0);
      expect(resS, isA<Success>());
    });
  });

  group('Compass Direction Boundary Tests', () {
    test('Boundary 0 and 360 maps to North', () {
      expect(QiblaCalculator.getCompassDirection(0.0), CompassDirection.n);
      expect(QiblaCalculator.getCompassDirection(359.9), CompassDirection.n);
      expect(QiblaCalculator.getCompassDirection(360.0), CompassDirection.n);
    });

    test('Boundary 22.5 maps to NorthEast', () {
      expect(QiblaCalculator.getCompassDirection(22.49), CompassDirection.n);
      expect(QiblaCalculator.getCompassDirection(22.5), CompassDirection.ne);
    });

    test('Exact Cardinal Points Map Correctly', () {
      expect(QiblaCalculator.getCompassDirection(90.0), CompassDirection.e);
      expect(QiblaCalculator.getCompassDirection(180.0), CompassDirection.s);
      expect(QiblaCalculator.getCompassDirection(270.0), CompassDirection.w);
    });
  });
}
