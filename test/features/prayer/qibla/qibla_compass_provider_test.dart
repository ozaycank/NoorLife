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
  final LocationState _initialState;
  FakeLocationNotifier(this._initialState);
  @override
  LocationState build() => _initialState;
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

  group('QiblaCompassProvider Logic', () {
    test(
        'Unsupported platform emits specific explicit failure without crashing',
        () async {
      when(() => mockHeadingService.headingStream).thenAnswer(
        (_) => Stream.value(
          const ResultFailure(
            CompassFailure('Web Error', code: 'unsupported_platform'),
          ),
        ),
      );

      final container = ProviderContainer(
        overrides: [
          locationNotifierProvider.overrideWith(
            () => FakeLocationNotifier(const LocationState(location: null)),
          ),
        ],
      );

      // Auto-dispose provider'ı hayatta tutmak için aktif bir dinleyici ekliyoruz
      final subscription = container.listen(qiblaCompassProvider, (_, __) {});

      // Asenkron Stream.value'nun işlenmesi için Event Loop'a süre tanıyoruz
      await Future.delayed(Duration.zero);

      final state = container.read(qiblaCompassProvider);
      expect(state.status, CompassStatus.unsupportedPlatform);

      subscription.close();
    });

    test('Valid location and valid heading combine to form ready state',
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

      final container = ProviderContainer(
        overrides: [
          locationNotifierProvider.overrideWith(
            () => FakeLocationNotifier(const LocationState(location: loc)),
          ),
        ],
      );

      // Auto-dispose provider'ı hayatta tutmak için aktif bir dinleyici ekliyoruz
      final subscription = container.listen(qiblaCompassProvider, (_, __) {});

      // Asenkron Stream.value'nun işlenmesi için Event Loop'a süre tanıyoruz
      await Future.delayed(Duration.zero);

      final state = container.read(qiblaCompassProvider);
      expect(state.status, CompassStatus.ready);
      expect(state.qiblaBearing, isNotNull);
      expect(state.deviceHeading, 140.0);
      expect(state.relativeQiblaAngle, isNotNull);

      subscription.close();
    });
  });
}
