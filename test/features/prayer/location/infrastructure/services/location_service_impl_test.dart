import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:geolocator/geolocator.dart';
import 'package:noor_life/features/prayer/location/infrastructure/datasources/geolocator_data_source.dart';
import 'package:noor_life/features/prayer/location/domain/interfaces/location_permission_service.dart';
import 'package:noor_life/features/prayer/location/domain/interfaces/location_geocoding_service.dart';
import 'package:noor_life/features/prayer/location/infrastructure/services/location_service_impl.dart';
import 'package:noor_life/features/prayer/location/domain/interfaces/location_service.dart';
import 'package:noor_life/core/base/result.dart';

class MockGeolocatorDataSource extends Mock implements GeolocatorDataSource {}

class MockLocationPermissionService extends Mock
    implements LocationPermissionService {}

class MockLocationGeocodingService extends Mock
    implements LocationGeocodingService {}

void main() {
  late MockGeolocatorDataSource mockGeoSource;
  late MockLocationPermissionService mockPermissionService;
  late MockLocationGeocodingService mockGeocodingService;
  late LocationServiceImpl locationService;

  setUp(() {
    mockGeoSource = MockGeolocatorDataSource();
    mockPermissionService = MockLocationPermissionService();
    mockGeocodingService = MockLocationGeocodingService();
    locationService = LocationServiceImpl(
      mockPermissionService,
      mockGeocodingService,
      mockGeoSource,
    );
  });

  test('returns PrayerLocation with City and Country on successful geocoding',
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
    when(() => mockGeocodingService.reverseGeocode(41.0082, 28.9784))
        .thenAnswer((_) async => const Success(('Istanbul', 'Türkiye')));

    final result = await locationService.getCurrentLocation();

    expect(result, isA<Success>());
    final location = (result as Success).value;
    expect(location.cityName, 'Istanbul');
    expect(location.countryName, 'Türkiye');
    expect(location.timezoneIdentifier, 'Europe/Istanbul');
  });

  test(
      'gracefully falls back when geocoding fails without invalidating GPS or timezone',
      () async {
    when(() => mockGeoSource.isLocationServiceEnabled())
        .thenAnswer((_) async => true);
    when(() => mockPermissionService.checkPermission())
        .thenAnswer((_) async => AppLocationPermission.granted);

    final mockPosition = Position(
      latitude: 51.5074,
      longitude: -0.1278,
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
    when(() => mockGeocodingService.reverseGeocode(51.5074, -0.1278))
        .thenAnswer(
      (_) async => const ResultFailure(LocationFailure('Network error')),
    );

    final result = await locationService.getCurrentLocation();

    expect(result, isA<Success>());
    final location = (result as Success).value;
    expect(location.cityName, 'Current Location');
    expect(location.countryName, 'Unknown');
    expect(location.timezoneIdentifier, 'Europe/London');
  });
}
