import 'package:geolocator/geolocator.dart';
import 'package:injectable/injectable.dart';
import '../../domain/interfaces/location_permission_service.dart';
import '../datasources/geolocator_data_source.dart';

@LazySingleton(as: LocationPermissionService)
class LocationPermissionServiceImpl implements LocationPermissionService {
  final GeolocatorDataSource _geoDataSource;

  LocationPermissionServiceImpl(this._geoDataSource);

  @override
  Future<bool> checkPermission() async {
    final permission = await _geoDataSource.checkPermission();
    return permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse;
  }

  @override
  Future<bool> requestPermission() async {
    var permission = await _geoDataSource.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await _geoDataSource.requestPermission();
    }
    return permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse;
  }
}
