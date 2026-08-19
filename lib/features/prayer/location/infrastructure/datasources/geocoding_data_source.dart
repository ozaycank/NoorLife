import 'package:geocoding/geocoding.dart' as geo;
import 'package:injectable/injectable.dart';

@lazySingleton
class GeocodingDataSource {
  Future<List<geo.Placemark>> getPlacemarks(double lat, double lng) {
    return geo.placemarkFromCoordinates(lat, lng);
  }
}
