import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:geolocator/geolocator.dart';
import 'package:noor_life/features/prayer/location/infrastructure/datasources/geolocator_data_source.dart';
import 'package:noor_life/features/prayer/location/infrastructure/services/location_permission_service_impl.dart';
import 'package:noor_life/features/prayer/location/infrastructure/services/location_service_impl.dart';
import 'package:noor_life/core/base/result.dart';

class MockGeolocatorDataSource extends Mock implements GeolocatorDataSource {}

class MockLocationPermissionService extends Mock
    implements LocationPermissionServiceImpl {}

void main() {
  late MockGeolocatorDataSource mockGeoSource;
  late MockLocationPermissionService mockPermissionService;
  late LocationServiceImpl locationService;

  setUp(() {
    mockGeoSource = MockGeolocatorDataSource();
    mockPermissionService = MockLocationPermissionService();
    locationService = LocationServiceImpl(mockPermissionService, mockGeoSource);
  });

  test('returns LocationFailure when location services are disabled', () async {
    when(() => mockGeoSource.isLocationServiceEnabled())
        .thenAnswer((_) async => false);

    final result = await locationService.getCurrentLocation();

    expect(result, isA<ResultFailure>());
    expect((result as ResultFailure).failure.message, contains('disabled'));
  });

  test('returns LocationFailure when permission is denied', () async {
    when(() => mockGeoSource.isLocationServiceEnabled())
        .thenAnswer((_) async => true);
    when(() => mockPermissionService.checkPermission())
        .thenAnswer((_) async => false);
    when(() => mockPermissionService.requestPermission())
        .thenAnswer((_) async => false);

    final result = await locationService.getCurrentLocation();

    expect(result, isA<ResultFailure>());
    expect((result as ResultFailure).failure.message, contains('denied'));
  });

  test('returns PrayerLocation with IANA timezone for valid coordinates',
      () async {
    when(() => mockGeoSource.isLocationServiceEnabled())
        .thenAnswer((_) async => true);
    when(() => mockPermissionService.checkPermission())
        .thenAnswer((_) async => true);

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
      // For older versions of geolocator, these might be required or optional,
      // but providing them ensures full compatibility.
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
