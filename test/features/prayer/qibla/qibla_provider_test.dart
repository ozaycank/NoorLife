import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noor_life/features/prayer/location/application/states/location_state.dart';
import 'package:noor_life/features/prayer/location/domain/entities/prayer_location.dart';
import 'package:noor_life/features/prayer/location/application/providers/location_notifier.dart';
import 'package:noor_life/features/prayer/qibla/application/qibla_provider.dart';

class FakeLocationNotifier extends LocationNotifier {
  final LocationState _initialState;

  FakeLocationNotifier(this._initialState);

  @override
  LocationState build() => _initialState;
}

void main() {
  group('QiblaProvider Flow Tests', () {
    test('Returns failure state when location is null', () {
      final container = ProviderContainer(
        overrides: [
          locationNotifierProvider.overrideWith(
            () => FakeLocationNotifier(const LocationState(location: null)),
          ),
        ],
      );

      final state = container.read(qiblaProvider);
      expect(state.status, QiblaStatus.failure);
      expect(state.failure, isNotNull);
    });

    test('Returns success state and calculates Qibla with valid location', () {
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

      final state = container.read(qiblaProvider);
      expect(state.status, QiblaStatus.success);
      expect(state.direction, isNotNull);
      expect(state.locationName, 'Istanbul, Turkiye');
    });
  });
}
