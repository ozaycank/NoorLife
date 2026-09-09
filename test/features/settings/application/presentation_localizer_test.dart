// ignore_for_file: avoid_relative_lib_imports
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import '../../../../lib/l10n/generated/app_localizations.dart';
import '../../../../lib/features/prayer/shared/presentation/utils/presentation_localizer.dart';

void main() {
  Widget buildTestContext(
    Locale locale,
    Widget Function(BuildContext) builder,
  ) {
    return MaterialApp(
      locale: locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en'), Locale('tr')],
      home: Scaffold(
        body: Builder(builder: builder),
      ),
    );
  }

  testWidgets('PresentationLocalizer cleanly maps English Madhabs',
      (tester) async {
    late String localized;
    await tester.pumpWidget(
      buildTestContext(const Locale('en'), (context) {
        localized = PresentationLocalizer.localizeMadhab(
          context,
          'shafi_hanbali_maliki',
        );
        return const SizedBox();
      }),
    );
    await tester.pumpAndSettle();

    // FIX: Reverted to the actual string currently present in your app_en.arb
    expect(localized, 'Standard (Shafi / Maliki / Hanbali)');
  });

  testWidgets('PresentationLocalizer cleanly maps Turkish Madhabs',
      (tester) async {
    late String localized;
    await tester.pumpWidget(
      buildTestContext(const Locale('tr'), (context) {
        localized = PresentationLocalizer.localizeMadhab(
          context,
          'shafi_hanbali_maliki',
        );
        return const SizedBox();
      }),
    );
    await tester.pumpAndSettle();

    // Kept the new Turkish translation as it successfully matched in previous runs
    expect(localized, '1 Katı Gölge Boyu (Cumhur)');
  });

  testWidgets('Location Identity de-duplicates effectively', (tester) async {
    late String location;
    await tester.pumpWidget(
      buildTestContext(const Locale('en'), (context) {
        location = PresentationLocalizer.formatLocation(
          context: context,
          cityName: 'Salihli',
          subAdminArea: 'Manisa',
          countryName: 'Türkiye',
        );
        return const SizedBox();
      }),
    );
    expect(location, 'Salihli, Manisa, Türkiye');
  });
}
