import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:noor_life/features/home/presentation/screens/home_screen.dart';
import 'package:noor_life/features/prayer/location/application/providers/location_notifier.dart';
import 'package:noor_life/features/prayer/location/application/states/location_state.dart';
import 'package:noor_life/features/prayer/location/domain/entities/prayer_location.dart';
import 'package:noor_life/features/prayer/prayer_times/application/providers/prayer_times_notifier.dart';
import 'package:noor_life/features/prayer/prayer_times/application/states/prayer_times_state.dart';
import 'package:noor_life/features/prayer/shared/domain/errors/prayer_failure.dart';
import 'package:noor_life/l10n/generated/app_localizations.dart';

class FakeLocationNotifier extends LocationNotifier {
  @override
  LocationState build() => const LocationState(
        status: LocationStatus.success,
        location: PrayerLocation(
          latitude: 41.0,
          longitude: 28.0,
          cityName: 'Istanbul',
          countryName: 'Turkey',
          timezoneIdentifier: 'Europe/Istanbul',
        ),
      );
}

class FakePrayerTimesNotifier extends PrayerTimesNotifier {
  @override
  PrayerTimesState build() => const PrayerTimesState(
        isLoading: false,
        // DÜZELTME BURADA: Testin error ekranını görebilmesi için açıkça bir failure gönderiyoruz.
        failure: PrayerCalculationFailure('Network error'),
        location: PrayerLocation(
          latitude: 41.0,
          longitude: 28.0,
          cityName: 'Istanbul',
          countryName: 'Turkey',
          timezoneIdentifier: 'Europe/Istanbul',
        ),
      );
}

void main() {
  Widget buildTestableWidget(Widget widget,
      {required List<Override> overrides,}) {
    return ProviderScope(
      overrides: overrides,
      child: MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('en')],
        home: widget,
      ),
    );
  }

  testWidgets('Home displays Location and Failsafe Prayer States Safely',
      (tester) async {
    await tester.pumpWidget(
      buildTestableWidget(
        const HomeScreen(),
        overrides: [
          locationNotifierProvider.overrideWith(() => FakeLocationNotifier()),
          prayerTimesNotifierProvider
              .overrideWith(() => FakePrayerTimesNotifier()),
        ],
      ),
    );

    // Initial state without valid schedule generates explicit error
    expect(find.text('Prayer times unavailable.'), findsOneWidget);
  });
}
