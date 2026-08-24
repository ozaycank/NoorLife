import 'package:flutter_test/flutter_test.dart';
import 'package:noor_life/features/prayer/qibla/domain/relative_qibla_calculator.dart';

void main() {
  group('RelativeQiblaCalculator Deterministic Math', () {
    test('Equal heading and bearing equals 0', () {
      expect(RelativeQiblaCalculator.calculate(151.3, 151.3), 0.0);
    });

    test('Clockwise small angle', () {
      expect(RelativeQiblaCalculator.calculate(10.0, 350.0), 20.0);
    });

    test('Counter-clockwise small angle', () {
      expect(RelativeQiblaCalculator.calculate(350.0, 10.0), -20.0);
    });

    test('Boundary limits exact opposite', () {
      expect(RelativeQiblaCalculator.calculate(180.0, 0.0), 180.0);
      // Depending on math sign implementation, exact 180 could be +180 or -180.
      expect(RelativeQiblaCalculator.calculate(0.0, 180.0).abs(), 180.0);
    });

    test('Complex negative wraparounds', () {
      expect(RelativeQiblaCalculator.calculate(45.0, 315.0), 90.0);
      expect(RelativeQiblaCalculator.calculate(315.0, 45.0), -90.0);
    });
  });
}
