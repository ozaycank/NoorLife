// ignore_for_file: avoid_relative_lib_imports
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import '../../../../lib/l10n/generated/app_localizations.dart';
import '../../../../lib/features/profile/presentation/screens/profile_screen.dart';

void main() {
  Widget buildTestableWidget() {
    return const ProviderScope(
      child: MaterialApp(
        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: [Locale('en')],
        home: ProfileScreen(),
      ),
    );
  }

  testWidgets('Profile screen renders safely with basic user elements',
      (tester) async {
    await tester.pumpWidget(buildTestableWidget());
    await tester.pumpAndSettle();
    expect(find.text('Your Progress'), findsOneWidget);
  });
}
