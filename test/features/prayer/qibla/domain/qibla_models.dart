import 'package:equatable/equatable.dart';
import '../../../../core/errors/failure.dart';

class KaabaConstants {
  KaabaConstants._();

  static const double latitude = 21.4225;
  static const double longitude = 39.82611;
}

class QiblaDirection extends Equatable {
  final double bearingDegrees;
  final double sourceLatitude;
  final double sourceLongitude;
  final double kaabaLatitude;
  final double kaabaLongitude;

  const QiblaDirection({
    required this.bearingDegrees,
    required this.sourceLatitude,
    required this.sourceLongitude,
    required this.kaabaLatitude,
    required this.kaabaLongitude,
  });

  @override
  List<Object?> get props => [
        bearingDegrees,
        sourceLatitude,
        sourceLongitude,
        kaabaLatitude,
        kaabaLongitude,
      ];
}

class QiblaFailure extends Failure {
  const QiblaFailure(super.message, {super.code});
}
