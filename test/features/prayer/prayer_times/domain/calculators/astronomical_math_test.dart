import 'package:flutter_test/flutter_test.dart';
import 'package:noor_life/features/prayer/prayer_times/domain/calculators/astronomical_math.dart';

void main() {
  group('AstronomicalMath Exact Precision Validation', () {
    test('Julian Day is exactly 2451545.0 for J2000.0 (Noon UTC)', () {
      final jd = AstronomicalMath.calculateJulianDay(2000, 1, 1, 12.0);
      expect(jd, equals(2451545.0));
    });

    test('Julian Day calculation respects midnight UTC offsets', () {
      final jd = AstronomicalMath.calculateJulianDay(2026, 8, 9, 0.0);
      expect(jd, equals(2461261.5));
    });
  });
}
