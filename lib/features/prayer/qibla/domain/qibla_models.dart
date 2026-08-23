import 'package:equatable/equatable.dart';
import '../../../../core/errors/failure.dart';

class KaabaConstants {
  KaabaConstants._();

  static const double latitude = 21.4225;
  static const double longitude = 39.82611;
}

enum CompassDirection { n, ne, e, se, s, sw, w, nw }

class QiblaDirection extends Equatable {
  final double bearingDegrees;
  final CompassDirection compassDirection;

  const QiblaDirection({
    required this.bearingDegrees,
    required this.compassDirection,
  });

  @override
  List<Object?> get props => [bearingDegrees, compassDirection];
}

class QiblaFailure extends Failure {
  const QiblaFailure(super.message, {super.code});
}
