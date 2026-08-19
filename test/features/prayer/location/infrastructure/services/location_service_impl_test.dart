import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:geolocator/geolocator.dart';
import 'package:noor_life/features/prayer/location/infrastructure/datasources/geolocator_data_source.dart';
import 'package:noor_life/features/prayer/location/domain/interfaces/location_permission_service.dart';
import 'package:noor_life/features/prayer/location/infrastructure/services/location_service_impl.dart';
import 'package:noor_life/core/base/result.dart';

class MockGeolocatorDataSource extends Mock implements GeolocatorDataSource {}

class MockLocationPermissionService extends Mock
    implements LocationPermissionService {}

void main() {
  late MockGeolocatorDataSource mockGeoSource;
  late MockLocationPermissionService mockPermissionService;
  late LocationServiceImpl locationService;

  setUp(() {
    mockGeoSource = MockGeolocatorDataSource();
    mockPermissionService = MockLocationPermissionService();
    locationService = LocationServiceImpl(mockPermissionService, mockGeoSource);
  });

  test(
      'returns LocationFailure with code locationServiceDisabled when services are disabled',
      () async {
    when(() => mockGeoSource.isLocationServiceEnabled())
        .thenAnswer((_) async => false);

    final result = await locationService.getCurrentLocation();

    expect(result, isA<ResultFailure>());
    expect((result as ResultFailure).failure.code, 'locationServiceDisabled');
  });

  test(
      'returns LocationFailure with code permissionDeniedForever when permanently denied',
      () async {
    when(() => mockGeoSource.isLocationServiceEnabled())
        .thenAnswer((_) async => true);
    when(() => mockPermissionService.checkPermission())
        .thenAnswer((_) async => AppLocationPermission.permanentlyDenied);

    final result = await locationService.getCurrentLocation();

    expect(result, isA<ResultFailure>());
    expect((result as ResultFailure).failure.code, 'permissionDeniedForever');
  });

  test('returns LocationFailure with code permissionDenied when denied',
      () async {
    when(() => mockGeoSource.isLocationServiceEnabled())
        .thenAnswer((_) async => true);
    when(() => mockPermissionService.checkPermission())
        .thenAnswer((_) async => AppLocationPermission.denied);
    when(() => mockPermissionService.requestPermission())
        .thenAnswer((_) async => AppLocationPermission.denied);

    final result = await locationService.getCurrentLocation();

    expect(result, isA<ResultFailure>());
    expect((result as ResultFailure).failure.code, 'permissionDenied');
  });

  test('returns PrayerLocation with IANA timezone for valid coordinates',
      () async {
    when(() => mockGeoSource.isLocationServiceEnabled())
        .thenAnswer((_) async => true);
    when(() => mockPermissionService.checkPermission())
        .thenAnswer((_) async => AppLocationPermission.granted);

    final mockPosition = Position(
      latitude: 41.0082,
      longitude: 28.9784,
      timestamp: DateTime.now(),
      accuracy: 1.0,
      altitude: 1.0,
      heading: 1.0,
      speed: 1.0,
      speedAccuracy: 1.0,
      altitudeAccuracy: 1.0,
      headingAccuracy: 1.0,
      isMocked: false,
    );

    when(() => mockGeoSource.getCurrentPosition())
        .thenAnswer((_) async => mockPosition);

    final result = await locationService.getCurrentLocation();

    expect(result, isA<Success>());
    final location = (result as Success).value;
    expect(location.latitude, 41.0082);
    expect(location.longitude, 28.9784);
    expect(location.timezoneIdentifier, 'Europe/Istanbul');
    expect(location.cityName, 'Current Location');
  });
}
