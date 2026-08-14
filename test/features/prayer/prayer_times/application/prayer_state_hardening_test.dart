import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import 'package:noor_life/features/prayer/prayer_times/application/states/prayer_times_state.dart';
import 'package:noor_life/features/prayer/prayer_times/presentation/providers/prayer_live_state_provider.dart';
import 'package:noor_life/features/prayer/prayer_times/domain/entities/prayer_time.dart';
import 'package:noor_life/features/prayer/prayer_times/domain/entities/prayer_day.dart';
import 'package:noor_life/features/prayer/prayer_times/domain/entities/prayer_schedule.dart';
import 'package:noor_life/features/prayer/prayer_times/domain/value_objects/prayer_name.dart';
import 'package:noor_life/features/prayer/location/domain/entities/prayer_location.dart';
import 'package:noor_life/features/prayer/prayer_times/application/providers/prayer_times_notifier.dart';
import 'package:noor_life/features/prayer/shared/domain/errors/prayer_failure.dart';

class FakePrayerTimesNotifier extends PrayerTimesNotifier {
  final PrayerTimesState fakeState;
  FakePrayerTimesNotifier(this.fakeState);

  @override
  PrayerTimesState build() => fakeState;
}

void main() {
  setUpAll(() {
    tz.initializeTimeZones();
  });

  group('Phase 5.1 Hardening Tests', () {
    test(
      'TEST E - PrayerTimesState.copyWith nullable field explicitly clears',
      () {
        const location = PrayerLocation(
          latitude: 0,
          longitude: 0,
          cityName: 'City',
          countryName: 'Country',
          timezoneIdentifier: 'UTC',
        );
        const failure = PrayerCalculationFailure('test error');

        const state = PrayerTimesState(
          isLoading: true,
          failure: failure,
          schedule: null,
          location: location,
        );

        final newState = state.copyWith(
          isLoading: false,
          failure: () => null,
          location: () => null,
        );

        expect(newState.isLoading, false);
        expect(newState.failure, isNull);
        expect(newState.location, isNull);
      },
    );

    test('TEST A, B, C - Chronological cross-day ordering', () async {
      final yesterday = PrayerDay(
        targetDate: DateTime.utc(2026, 8, 12),
        prayerTimes: [
          PrayerTime(
            name: PrayerName.fajr,
            time: DateTime.utc(2026, 8, 12, 4, 0),
          ),
          PrayerTime(
            name: PrayerName.isha,
            time: DateTime.utc(2026, 8, 12, 20, 0),
          ),
        ],
      );

      // Intentionally scramble 'today' to verify the provider's native .sort() logic
      final today = PrayerDay(
        targetDate: DateTime.utc(2026, 8, 13),
        prayerTimes: [
          PrayerTime(
            name: PrayerName.dhuhr,
            time: DateTime.utc(2026, 8, 13, 12, 0),
          ),
          PrayerTime(
            name: PrayerName.fajr,
            time: DateTime.utc(2026, 8, 13, 4, 0),
          ),
          PrayerTime(
            name: PrayerName.isha,
            time: DateTime.utc(2026, 8, 13, 20, 0),
          ),
        ],
      );

      final tomorrow = PrayerDay(
        targetDate: DateTime.utc(2026, 8, 14),
        prayerTimes: [
          PrayerTime(
            name: PrayerName.fajr,
            time: DateTime.utc(2026, 8, 14, 4, 0),
          ),
        ],
      );

      final schedule = PrayerSchedule(
        yesterday: yesterday,
        today: today,
        tomorrow: tomorrow,
      );

      const loc = PrayerLocation(
        latitude: 0,
        longitude: 0,
        cityName: 'C',
        countryName: 'C',
        timezoneIdentifier: 'UTC',
      );

      final state = PrayerTimesState(
        schedule: schedule,
        location: loc,
      );

      // TEST A: Before today's Fajr
      var container = ProviderContainer(
        overrides: [
          prayerTimesNotifierProvider.overrideWith(
            () => FakePrayerTimesNotifier(state),
          ),
          currentTimeProvider.overrideWith(
            (ref) => Stream.value(DateTime.utc(2026, 8, 13, 2, 0)),
          ),
        ],
      );

      // Wait for Stream to emit first value
      await container.read(currentTimeProvider.future);

      var liveState = container.read(prayerLiveStateProvider);
      expect(liveState.currentPrayer?.name, PrayerName.isha);
      expect(liveState.currentPrayer?.time.day, 12);
      expect(liveState.nextPrayer?.name, PrayerName.fajr);
      expect(liveState.nextPrayer?.time.day, 13);

      // TEST B: Between Dhuhr and Isha today
      container = ProviderContainer(
        overrides: [
          prayerTimesNotifierProvider.overrideWith(
            () => FakePrayerTimesNotifier(state),
          ),
          currentTimeProvider.overrideWith(
            (ref) => Stream.value(DateTime.utc(2026, 8, 13, 14, 0)),
          ),
        ],
      );

      // Wait for Stream to emit first value
      await container.read(currentTimeProvider.future);

      liveState = container.read(prayerLiveStateProvider);
      expect(liveState.currentPrayer?.name, PrayerName.dhuhr);
      expect(liveState.currentPrayer?.time.day, 13);
      expect(liveState.nextPrayer?.name, PrayerName.isha);
      expect(liveState.nextPrayer?.time.day, 13);

      // TEST C: After Isha today
      container = ProviderContainer(
        overrides: [
          prayerTimesNotifierProvider.overrideWith(
            () => FakePrayerTimesNotifier(state),
          ),
          currentTimeProvider.overrideWith(
            (ref) => Stream.value(DateTime.utc(2026, 8, 13, 22, 0)),
          ),
        ],
      );

      // Wait for Stream to emit first value
      await container.read(currentTimeProvider.future);

      liveState = container.read(prayerLiveStateProvider);
      expect(liveState.currentPrayer?.name, PrayerName.isha);
      expect(liveState.currentPrayer?.time.day, 13);
      expect(liveState.nextPrayer?.name, PrayerName.fajr);
      expect(liveState.nextPrayer?.time.day, 14);
    });

    test('TEST D - Target timezone date boundary normalization', () {
      final tzTokyo = tz.getLocation('Asia/Tokyo');
      // Simulated device time: 2026-08-13 18:42 UTC (which is 2026-08-14 03:42 Tokyo local)
      final deviceTimeUtc = DateTime.utc(2026, 8, 13, 18, 42);

      // Mimicking PrayerTimesNotifier internal extraction
      final targetNow = tz.TZDateTime.from(deviceTimeUtc, tzTokyo);

      expect(targetNow.year, 2026);
      expect(targetNow.month, 8);
      expect(targetNow.day, 14); // Verified: Crossed midnight into the 14th

      // Normalization to pure calendar date at midnight UTC
      final targetCalendarDate = DateTime.utc(
        targetNow.year,
        targetNow.month,
        targetNow.day,
      );

      expect(targetCalendarDate, DateTime.utc(2026, 8, 14));
    });
  });
}
