import 'package:flutter_test/flutter_test.dart';
import 'package:noor_life/features/prayer/qibla/domain/circular_smoothing_filter.dart';

void main() {
  group('CircularSmoothingFilter Deterministic Math', () {
    test('First valid reading initializes without animation', () {
      final filter = CircularSmoothingFilter(alpha: 0.2);
      expect(filter.smooth(150.0), 150.0);
    });

    test('Normal smoothing operation gradually approaches target', () {
      final filter = CircularSmoothingFilter(alpha: 0.5);
      filter.smooth(90.0);
      final smoothed = filter.smooth(100.0);
      // Halfway between 90 and 100
      expect(smoothed, closeTo(95.0, 0.1));
    });

    test(
        'Circular Wraparound: 359 -> 1 smoothly avoids going backwards via 180',
        () {
      final filter = CircularSmoothingFilter(alpha: 0.5);
      filter.smooth(359.0);
      final smoothed = filter.smooth(1.0);
      // Mathematically halfway crossing the 0 mark is 0.0 degrees
      expect(smoothed, closeTo(0.0, 0.1));
    });

    test(
        'Circular Reverse Wraparound: 1 -> 359 smoothly avoids going backwards',
        () {
      final filter = CircularSmoothingFilter(alpha: 0.5);
      filter.smooth(1.0);
      final smoothed = filter.smooth(359.0);
      expect(smoothed, closeTo(0.0, 0.1));
    });

    test('Smoothing factor = 1.0 skips smoothing and matches target exactly',
        () {
      final filter = CircularSmoothingFilter(alpha: 1.0);
      filter.smooth(0.0);
      expect(filter.smooth(180.0), 180.0);
    });

    test('Invalid smoothing factors are explicitly rejected at instantiation',
        () {
      expect(() => CircularSmoothingFilter(alpha: 0.0), throwsArgumentError);
      expect(() => CircularSmoothingFilter(alpha: -1.0), throwsArgumentError);
      expect(() => CircularSmoothingFilter(alpha: 1.5), throwsArgumentError);
    });

    test('Normalized output rigidly stays within 0 <= heading < 360', () {
      final filter = CircularSmoothingFilter(alpha: 0.5);
      filter.smooth(350.0);
      final smoothed = filter.smooth(20.0);
      expect(smoothed >= 0.0, isTrue);
      expect(smoothed < 360.0, isTrue);
    });
  });
}
