abstract class LocationPermissionService {
  Future<bool> checkPermission();
  Future<bool> requestPermission();
}
