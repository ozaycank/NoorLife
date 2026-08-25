import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:noor_life/core/base/result.dart';
import 'package:noor_life/core/di/injection_container.dart';
import 'package:noor_life/features/prayer/location/application/states/location_state.dart';
import 'package:noor_life/features/prayer/location/domain/entities/prayer_location.dart';
import 'package:noor_life/features/prayer/location/application/providers/location_notifier.dart';
import 'package:noor_life/features/prayer/qibla/domain/compass_alignment_rules.dart';
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
  late StreamController<Result<DeviceHeading?, CompassFailure>>
      streamController;

  setUp(() {
    mockHeadingService = MockDeviceHeadingService();
    streamController =
        StreamController<Result<DeviceHeading?, CompassFailure>>.broadcast();
    when(() => mockHeadingService.headingStream)
        .thenAnswer((_) => streamController.stream);

    if (!getIt.isRegistered<DeviceHeadingService>()) {
      getIt.registerSingleton<DeviceHeadingService>(mockHeadingService);
    } else {
      getIt.unregister<DeviceHeadingService>();
      getIt.registerSingleton<DeviceHeadingService>(mockHeadingService);
    }
  });

  tearDown(() {
    getIt.reset();
    streamController.close();
  });

  group('QiblaCompassProvider Advanced Flow Validation', () {
    test('First valid reading initializes smoothly', () async {
      const loc = PrayerLocation(
        latitude: 41.0082,
        longitude: 28.9784, // Istanbul, Qibla roughly 151.3
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

      streamController.add(const Success(DeviceHeading(100.0)));
      await Future.delayed(Duration.zero);

      final state = container.read(qiblaCompassProvider);
      expect(state.status, CompassStatus.ready);
      expect(state.smoothedHeading, 100.0);
      expect(state.relativeQiblaAngle, closeTo(51.3, 0.5));
      expect(state.alignmentStatus, QiblaAlignmentStatus.turnRight);

      subscription.close();
    });

    test('Alignment dynamically tracks threshold logic correctly', () async {
      const loc = PrayerLocation(
        latitude: 41.0082,
        longitude: 28.9784, // Istanbul, Qibla roughly 151.3
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

      streamController.add(const Success(DeviceHeading(151.0)));
      await Future.delayed(Duration.zero);

      var state = container.read(qiblaCompassProvider);
      expect(state.alignmentStatus, QiblaAlignmentStatus.aligned);

      for (int i = 0; i < 20; i++) {
        streamController.add(const Success(DeviceHeading(130.0)));
      }
      await Future.delayed(Duration.zero);

      state = container.read(qiblaCompassProvider);
      expect(state.alignmentStatus, QiblaAlignmentStatus.turnRight);

      for (int i = 0; i < 20; i++) {
        streamController.add(const Success(DeviceHeading(175.0)));
      }
      await Future.delayed(Duration.zero);

      state = container.read(qiblaCompassProvider);
      expect(state.alignmentStatus, QiblaAlignmentStatus.turnLeft);

      subscription.close();
    });

    test(
        'Sensor interruption explicitly wipes mathematical states and recovers cleanly',
        () async {
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

      streamController.add(const Success(DeviceHeading(100.0)));
      await Future.delayed(Duration.zero);
      expect(container.read(qiblaCompassProvider).status, CompassStatus.ready);

      streamController.add(const Success(null));
      await Future.delayed(Duration.zero);

      final deadState = container.read(qiblaCompassProvider);
      expect(deadState.status, CompassStatus.sensorUnavailable);
      expect(deadState.smoothedHeading, isNull);
      expect(deadState.relativeQiblaAngle, isNull);
      expect(deadState.alignmentStatus, isNull);

      streamController.add(const Success(DeviceHeading(200.0)));
      await Future.delayed(Duration.zero);

      final recoveryState = container.read(qiblaCompassProvider);
      expect(recoveryState.status, CompassStatus.ready);
      expect(recoveryState.smoothedHeading, 200.0);
      expect(recoveryState.alignmentStatus, isNotNull);

      subscription.close();
    });
  });
}
