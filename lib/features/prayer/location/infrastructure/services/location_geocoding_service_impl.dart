import 'dart:convert';
import 'package:http/http.dart' as http;
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
      // 1. Try standard device geocoding first (Works best on iOS/Android)
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

      // 2. If no placemarks (often happens on Web), fallback to Nominatim REST API.
      return _fallbackGeocodeRest(latitude, longitude);
    } catch (e) {
      // Catch exceptions (like PlatformException on Web) and fallback to REST API
      return _fallbackGeocodeRest(latitude, longitude);
    }
  }

  /// Fallback method for Web/Chrome or devices without play services
  Future<Result<(String, String), LocationFailure>> _fallbackGeocodeRest(
    double lat,
    double lon,
  ) async {
    try {
      final url = Uri.parse(
        'https://nominatim.openstreetmap.org/reverse?format=json&lat=$lat&lon=$lon&zoom=10&addressdetails=1',
      );

      final response = await http.get(url, headers: {
        // Nominatim requires a user-agent to prevent blocking
        'User-Agent': 'NoorLife/1.0 (Flutter App)',
        'Accept-Language': 'en-US,en;q=0.9',
      },);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data != null && data['address'] != null) {
          final address = data['address'];

          // Nominatim provides various keys depending on the region
          final city = address['city'] ??
              address['town'] ??
              address['village'] ??
              address['county'] ??
              address['state'] ??
              'Current Location';

          final country = address['country'] ?? 'Unknown';

          return Success((city.toString(), country.toString()));
        }
      }

      return const ResultFailure(
        LocationFailure(
          'Geocoding fallback failed or returned no data.',
          code: 'locationGeocodingFallbackFailed',
        ),
      );
    } catch (e) {
      return ResultFailure(
        LocationFailure(
          'Geocoding network fallback failed: $e',
          code: 'locationGeocodingFallbackFailed',
        ),
      );
    }
  }
}
