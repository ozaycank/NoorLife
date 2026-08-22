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
        sourceLatitude: latitude,
        sourceLongitude: longitude,
        kaabaLatitude: KaabaConstants.latitude,
        kaabaLongitude: KaabaConstants.longitude,
      ),
    );
  }
}
