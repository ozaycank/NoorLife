import '../../../../../core/base/result.dart';
import '../../../../../core/errors/failure.dart';
import '../entities/prayer_location.dart';

class LocationFailure extends Failure {
  const LocationFailure(super.message, {super.code});
}

abstract class LocationService {
  Future<Result<PrayerLocation, LocationFailure>> getCurrentLocation();
}
