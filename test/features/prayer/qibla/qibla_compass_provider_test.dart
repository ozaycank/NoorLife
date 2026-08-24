import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:noor_life/core/base/result.dart';
import 'package:noor_life/core/di/injection_container.dart';
import 'package:noor_life/features/prayer/location/application/states/location_state.dart';
import 'package:noor_life/features/prayer/location/domain/entities/prayer_location.dart';
import 'package:noor_life/features/prayer/location/application/providers/location_notifier.dart';
import 'package:noor_life/features/prayer/qibla/domain/compass_models.dart';
import 'package:noor_life/features/prayer/qibla/domain/interfaces/device_heading_service.dart';
import 'package:noor_life/features/prayer/qibla/application/qibla_compass_provider.dart';

class MockDeviceHeadingService extends Mock implements DeviceHeadingService {}

class FakeLocationNotifier extends LocationNotifier {
  LocationState _state;
  FakeLocationNotifier(this._state);

  @override
  LocationState build() => _state;

  void updateLocation(PrayerLocation? newLocation) {
    _state = _state.copyWith(
      location: () => newLocation,
      status:
          newLocation != null ? LocationStatus.success : LocationStatus.failure,
    );
    state = _state;
  }
}

void main() {
  late MockDeviceHeadingService mockHeadingService;

  setUp(() {
    mockHeadingService = MockDeviceHeadingService();
    if (!getIt.isRegistered<DeviceHeadingService>()) {
      getIt.registerSingleton<DeviceHeadingService>(mockHeadingService);
    } else {
      getIt.unregister<DeviceHeadingService>();
      getIt.registerSingleton<DeviceHeadingService>(mockHeadingService);
    }
  });

  tearDown(() {
    getIt.reset();
  });

  group('QiblaCompassProvider Logic Validation', () {
    test('Qibla failure deterministically wipes stale bearing and angle',
        () async {
      when(() => mockHeadingService.headingStream).thenAnswer(
        (_) => Stream.value(const Success(DeviceHeading(140.0))),
      );

      const loc = PrayerLocation(
        latitude: 41.0082,
        longitude: 28.9784,
        cityName: 'Istanbul',
        countryName: 'Turkiye',
        timezoneIdentifier: 'Europe/Istanbul',
      );

      final fakeLocationNotifier = FakeLocationNotifier(
        const LocationState(status: LocationStatus.success, location: loc),
      );

      final container = ProviderContainer(
        overrides: [
          locationNotifierProvider.overrideWith(() => fakeLocationNotifier),
        ],
      );

      final subscription = container.listen(qiblaCompassProvider, (_, __) {});

      // Phase 1: Wait for resolution
      await Future.delayed(Duration.zero);

      final readyState = container.read(qiblaCompassProvider);
      expect(readyState.status, CompassStatus.ready);
      expect(readyState.qiblaBearing, isNotNull);

      // Phase 2: Kill location explicitly
      fakeLocationNotifier.updateLocation(null);
      await Future.delayed(Duration.zero);

      final wipedState = container.read(qiblaCompassProvider);
      expect(wipedState.status, CompassStatus.locationUnavailable);
      expect(wipedState.qiblaBearing, isNull);
      expect(wipedState.relativeQiblaAngle, isNull);

      subscription.close();
    });
  });
}
