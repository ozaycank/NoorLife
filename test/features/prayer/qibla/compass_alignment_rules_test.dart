import 'package:flutter_test/flutter_test.dart';
import 'package:noor_life/features/prayer/qibla/domain/compass_alignment_rules.dart';

void main() {
  group('CompassAlignmentRules Domain Logic', () {
    test('Relative exactly at 0 is Aligned', () {
      expect(
        CompassAlignmentRules.evaluate(0.0),
        QiblaAlignmentStatus.aligned,
      );
    });

    test('Relative inside positive threshold is Aligned', () {
      expect(
        CompassAlignmentRules.evaluate(1.9),
        QiblaAlignmentStatus.aligned,
      );
    });

    test('Relative inside negative threshold is Aligned', () {
      expect(
        CompassAlignmentRules.evaluate(-1.9),
        QiblaAlignmentStatus.aligned,
      );
    });

    test('Relative outside positive threshold resolves Turn Right', () {
      expect(
        CompassAlignmentRules.evaluate(2.1),
        QiblaAlignmentStatus.turnRight,
      );
      expect(
        CompassAlignmentRules.evaluate(180.0),
        QiblaAlignmentStatus.turnRight,
      );
    });

    test('Relative outside negative threshold resolves Turn Left', () {
      expect(
        CompassAlignmentRules.evaluate(-2.1),
        QiblaAlignmentStatus.turnLeft,
      );
      expect(
        CompassAlignmentRules.evaluate(-180.0),
        QiblaAlignmentStatus.turnLeft,
      );
    });
  });
}
