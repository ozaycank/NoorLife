import 'package:injectable/injectable.dart';
import 'package:timezone/timezone.dart' as tz;
import '../../base/result.dart';
import '../../errors/failure.dart';
import 'timezone_service.dart';

class TimezoneFailure extends Failure {
  const TimezoneFailure(super.message);
}

@LazySingleton(as: TimezoneService)
class TimezoneServiceImpl implements TimezoneService {
  @override
  Result<DateTime, Failure> convertToTimezone(
      DateTime utcTime, String timezoneIdentifier,) {
    try {
      final location = tz.getLocation(timezoneIdentifier);
      final tzTime = tz.TZDateTime.from(utcTime, location);
      return Success(tzTime);
    } catch (e) {
      return ResultFailure(TimezoneFailure(
          'Failed to convert timezone for $timezoneIdentifier: $e',),);
    }
  }
}
