class RelativeQiblaCalculator {
  RelativeQiblaCalculator._();

  static double calculate(double qiblaBearing, double deviceHeading) {
    double relative = qiblaBearing - deviceHeading;

    while (relative > 180.0) {
      relative -= 360.0;
    }

    while (relative < -180.0) {
      relative += 360.0;
    }

    return relative;
  }
}
