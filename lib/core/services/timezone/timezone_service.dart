import '../../base/result.dart';
import '../../errors/failure.dart';

abstract class TimezoneService {
  Result<DateTime, Failure> convertToTimezone(
    DateTime utcTime,
    String timezoneIdentifier,
  );
}
