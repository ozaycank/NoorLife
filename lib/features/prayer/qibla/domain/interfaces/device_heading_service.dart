import '../../../../../core/base/result.dart';
import '../compass_models.dart';

abstract class DeviceHeadingService {
  Stream<Result<DeviceHeading?, CompassFailure>> get headingStream;
}
