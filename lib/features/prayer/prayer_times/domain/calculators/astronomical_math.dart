import 'dart:math' as math;

class AstronomicalMath {
  AstronomicalMath._();

  static double deg2rad(double degree) => degree * (math.pi / 180.0);
  static double rad2deg(double radian) => radian * (180.0 / math.pi);
  static double fixAngle(double angle) =>
      angle - 360.0 * (angle / 360.0).floorToDouble();
  static double fixHour(double hour) =>
      hour - 24.0 * (hour / 24.0).floorToDouble();

  /// Calculates the Julian Day for a given Gregorian date and UTC decimal hour.
  /// Valid for years > 1582. Reference: Meeus Astronomical Algorithms.
  static double calculateJulianDay(
      int year, int month, int day, double utcDecimalHour,) {
    if (month <= 2) {
      year -= 1;
      month += 12;
    }
    final a = (year / 100).floorToDouble();
    final b = 2 - a + (a / 4).floorToDouble();
    return (365.25 * (year + 4716)).floorToDouble() +
        (30.6001 * (month + 1)).floorToDouble() +
        day +
        b -
        1524.5 +
        (utcDecimalHour / 24.0);
  }

  /// Calculates Solar Declination and Equation of Time for a given Julian Day.
  /// Returns [Declination in degrees, Equation of Time in decimal hours]
  static List<double> calculateSunPosition(double jd) {
    final d = jd - 2451545.0;
    final g = fixAngle(357.529 + 0.98560028 * d);
    final q = fixAngle(280.459 + 0.98564736 * d);
    final l = fixAngle(
        q + 1.915 * math.sin(deg2rad(g)) + 0.020 * math.sin(deg2rad(2 * g)),);
    final e = 23.439 - 0.00000036 * d;

    double ra = rad2deg(math.atan2(
        math.cos(deg2rad(e)) * math.sin(deg2rad(l)), math.cos(deg2rad(l))));
    ra = fixAngle(ra);

    final eqt = (q / 15.0) - (ra / 15.0);
    final decl =
        rad2deg(math.asin(math.sin(deg2rad(e)) * math.sin(deg2rad(l))));

    return [decl, eqt];
  }

  /// Calculates the Hour Angle (in decimal hours) for a given solar angle.
  /// Returns double.nan if the sun never reaches the specified angle.
  static double calculateHourAngle(double angle, double decl, double lat) {
    final cosH = (math.sin(deg2rad(angle)) -
            math.sin(deg2rad(decl)) * math.sin(deg2rad(lat))) /
        (math.cos(deg2rad(decl)) * math.cos(deg2rad(lat)));

    if (cosH > 1.0 || cosH < -1.0) return double.nan;
    return rad2deg(math.acos(cosH)) / 15.0;
  }
}
