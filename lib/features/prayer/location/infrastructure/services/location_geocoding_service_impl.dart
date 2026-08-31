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
      final placemarks = await _dataSource.getPlacemarks(
        latitude,
        longitude,
      );
      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        final city = place.locality ??
            place.subAdministrativeArea ??
            place.administrativeArea ??
            '';
        final country = place.country ?? place.isoCountryCode ?? '';
        return Success((city, country));
      }

      return _fallbackGeocodeRest(latitude, longitude);
    } catch (e) {
      return _fallbackGeocodeRest(latitude, longitude);
    }
  }

  Future<Result<(String, String), LocationFailure>> _fallbackGeocodeRest(
    double lat,
    double lon,
  ) async {
    try {
      final url = Uri.parse(
        'https://nominatim.openstreetmap.org/reverse?format=json&lat=$lat&lon=$lon&zoom=10&addressdetails=1',
      );

      final response = await http.get(url, headers: {
        'User-Agent': 'NoorLife/1.0 (Flutter App)',
        'Accept-Language': 'en-US,en;q=0.9',
      },);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data != null && data['address'] != null) {
          final address = data['address'];

          final city = address['city'] ??
              address['town'] ??
              address['village'] ??
              address['county'] ??
              address['state'] ??
              '';

          final country = address['country'] ?? '';

          return Success((city.toString(), country.toString()));
        }
      }

      return const ResultFailure(
        LocationFailure(
          'Geocoding fallback returned no data.',
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
