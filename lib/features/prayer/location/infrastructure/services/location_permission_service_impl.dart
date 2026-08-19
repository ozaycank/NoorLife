import 'package:geolocator/geolocator.dart';
import 'package:injectable/injectable.dart';
import '../../domain/interfaces/location_permission_service.dart';
import '../datasources/geolocator_data_source.dart';

@LazySingleton(as: LocationPermissionService)
class LocationPermissionServiceImpl implements LocationPermissionService {
  final GeolocatorDataSource _geoDataSource;

  LocationPermissionServiceImpl(this._geoDataSource);

  @override
  Future<AppLocationPermission> checkPermission() async {
    final permission = await _geoDataSource.checkPermission();
    return _mapPermission(permission);
  }

  @override
  Future<AppLocationPermission> requestPermission() async {
    var permission = await _geoDataSource.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await _geoDataSource.requestPermission();
    }
    return _mapPermission(permission);
  }

  AppLocationPermission _mapPermission(LocationPermission permission) {
    if (permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) {
      return AppLocationPermission.granted;
    }
    if (permission == LocationPermission.deniedForever) {
      return AppLocationPermission.permanentlyDenied;
    }
    return AppLocationPermission.denied;
  }
}
