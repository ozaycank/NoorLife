import 'dart:math' as math;
import '../../../../../core/base/result.dart';
import 'qibla_models.dart';

class QiblaCalculator {
  QiblaCalculator._();

  static Result<QiblaDirection, QiblaFailure> calculate({
    required double latitude,
    required double longitude,
  }) {
    if (latitude < -90.0 || latitude > 90.0) {
      return const ResultFailure(
        QiblaFailure(
          'Invalid latitude. Must be between -90 and 90.',
          code: 'invalid_latitude',
        ),
      );
    }
    if (longitude < -180.0 || longitude > 180.0) {
      return const ResultFailure(
        QiblaFailure(
          'Invalid longitude. Must be between -180 and 180.',
          code: 'invalid_longitude',
        ),
      );
    }

    if ((latitude - KaabaConstants.latitude).abs() < 0.00001 &&
        (longitude - KaabaConstants.longitude).abs() < 0.00001) {
      return const ResultFailure(
        QiblaFailure(
          'Qibla direction is undefined at the Kaaba.',
          code: 'qiblaUndefinedAtKaaba',
        ),
      );
    }

    final phi1 = latitude * (math.pi / 180.0);
    final lambda1 = longitude * (math.pi / 180.0);
    const phi2 = KaabaConstants.latitude * (math.pi / 180.0);
    const lambda2 = KaabaConstants.longitude * (math.pi / 180.0);

    final deltaLambda = lambda2 - lambda1;

    final y = math.sin(deltaLambda) * math.cos(phi2);
    final x = math.cos(phi1) * math.sin(phi2) -
        math.sin(phi1) * math.cos(phi2) * math.cos(deltaLambda);

    final bearingRadians = math.atan2(y, x);
    var bearingDegrees = bearingRadians * (180.0 / math.pi);

    bearingDegrees = (bearingDegrees + 360.0) % 360.0;

    return Success(
      QiblaDirection(
        bearingDegrees: bearingDegrees,
        compassDirection: getCompassDirection(bearingDegrees),
      ),
    );
  }

  static CompassDirection getCompassDirection(double bearing) {
    final normalized = (bearing + 360.0) % 360.0;
    if (normalized >= 337.5 || normalized < 22.5) return CompassDirection.n;
    if (normalized >= 22.5 && normalized < 67.5) return CompassDirection.ne;
    if (normalized >= 67.5 && normalized < 112.5) return CompassDirection.e;
    if (normalized >= 112.5 && normalized < 157.5) return CompassDirection.se;
    if (normalized >= 157.5 && normalized < 202.5) return CompassDirection.s;
    if (normalized >= 202.5 && normalized < 247.5) return CompassDirection.sw;
    if (normalized >= 247.5 && normalized < 292.5) return CompassDirection.w;
    return CompassDirection.nw;
  }
}
