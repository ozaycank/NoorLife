enum AppLocationPermission { granted, denied, permanentlyDenied }

abstract class LocationPermissionService {
  Future<AppLocationPermission> checkPermission();
  Future<AppLocationPermission> requestPermission();
}
