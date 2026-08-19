import 'package:injectable/injectable.dart';
import '../../../../../core/base/result.dart';
import '../../domain/interfaces/location_geocoding_service.dart';
import '../../domain/interfaces/location_service.dart';
import '../datasources/geocoding_data_source.dart';

@LazySingleton(as: LocationGeocodingService)
class LocationGeocodingServiceImpl implements LocationGeocodingService {
  final GeocodingDataSource _dataSource;

  LocationGeocodingServiceImpl(this._dataSource);

  @override
  Future<Result<(String, String), LocationFailure>> reverseGeocode(
    double latitude,
    double longitude,
  ) async {
    try {
      final placemarks = await _dataSource.getPlacemarks(
        latitude,
        longitude,
      );
      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        final city =
            place.locality ?? place.subAdministrativeArea ?? 'Current Location';
        final country = place.country ?? 'Unknown';
        return Success((city, country));
      }
      return const ResultFailure(
        LocationFailure(
          'No placemarks found.',
          code: 'locationGeocodingFailed',
        ),
      );
    } catch (e) {
      return ResultFailure(
        LocationFailure(
          'Geocoding failed: $e',
          code: 'locationGeocodingFailed',
        ),
      );
    }
  }
}
