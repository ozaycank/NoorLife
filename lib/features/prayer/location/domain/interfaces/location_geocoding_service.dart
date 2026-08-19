import '../../../../../core/base/result.dart';
import 'location_service.dart';

abstract class LocationGeocodingService {
  Future<Result<(String city, String country), LocationFailure>> reverseGeocode(
    double latitude,
    double longitude,
  );
}
