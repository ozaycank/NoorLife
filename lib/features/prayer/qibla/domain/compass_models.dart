import 'package:equatable/equatable.dart';
import '../../../../core/errors/failure.dart';

class DeviceHeading extends Equatable {
  final double headingDegrees;

  const DeviceHeading(this.headingDegrees)
      : assert(
          headingDegrees >= 0.0 && headingDegrees < 360.0,
          'Heading must be normalized between 0 and 360 degrees.',
        );

  @override
  List<Object?> get props => [headingDegrees];
}

class CompassFailure extends Failure {
  const CompassFailure(super.message, {super.code});
}
