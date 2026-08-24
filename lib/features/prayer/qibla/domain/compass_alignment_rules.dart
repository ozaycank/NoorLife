enum QiblaAlignmentStatus { aligned, turnLeft, turnRight }

class CompassAlignmentRules {
  CompassAlignmentRules._();

  static const double alignmentThreshold = 2.0;

  static QiblaAlignmentStatus evaluate(double relativeQiblaAngle) {
    if (relativeQiblaAngle.abs() <= alignmentThreshold) {
      return QiblaAlignmentStatus.aligned;
    } else if (relativeQiblaAngle > 0) {
      return QiblaAlignmentStatus.turnRight;
    } else {
      return QiblaAlignmentStatus.turnLeft;
    }
  }
}
