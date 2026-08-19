import 'package:injectable/injectable.dart';
import 'package:lat_lng_to_timezone/lat_lng_to_timezone.dart' as tzmap;
import '../../../../../core/base/result.dart';
import '../../domain/entities/prayer_location.dart';
import '../../domain/interfaces/location_permission_service.dart';
import '../../domain/interfaces/location_service.dart';
import '../datasources/geolocator_data_source.dart';

@LazySingleton(as: LocationService)
class LocationServiceImpl implements LocationService {
  final LocationPermissionService _permissionService;
  final GeolocatorDataSource _geoDataSource;

  LocationServiceImpl(this._permissionService, this._geoDataSource);

  @override
  Future<Result<PrayerLocation, LocationFailure>> getCurrentLocation() async {
    try {
      final serviceEnabled = await _geoDataSource.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return const ResultFailure(
          LocationFailure('Location services are disabled.',
              code: 'locationServiceDisabled',),
        );
      }

      var permStatus = await _permissionService.checkPermission();
      if (permStatus == AppLocationPermission.denied) {
        permStatus = await _permissionService.requestPermission();
      }

      if (permStatus == AppLocationPermission.permanentlyDenied) {
        return const ResultFailure(
          LocationFailure('Location permission permanently denied.',
              code: 'permissionDeniedForever',),
        );
      } else if (permStatus == AppLocationPermission.denied) {
        return const ResultFailure(
          LocationFailure('Location permission denied.',
              code: 'permissionDenied',),
        );
      }

      final position = await _geoDataSource.getCurrentPosition();

      if (position.latitude < -90 ||
          position.latitude > 90 ||
          position.longitude < -180 ||
          position.longitude > 180) {
        return const ResultFailure(
          LocationFailure('Received invalid coordinates from device.',
              code: 'invalidCoordinates',),
        );
      }

      String timezoneId;
      try {
        timezoneId = tzmap.latLngToTimezoneString(
          position.latitude,
          position.longitude,
        );
      } catch (e) {
        return const ResultFailure(
          LocationFailure('Failed to resolve timezone from coordinates.',
              code: 'timezoneResolutionFailed',),
        );
      }

      final location = PrayerLocation(
        latitude: position.latitude,
        longitude: position.longitude,
        cityName: 'Current Location',
        countryName:
            'Device Coordinates', // Semantic placeholder until reverse-geocoding is implemented
        timezoneIdentifier: timezoneId,
      );

      return Success(location);
    } catch (e) {
      return ResultFailure(
        LocationFailure('Failed to acquire location: $e',
            code: 'coordinateAcquisitionFailed',),
      );
    }
  }
}
