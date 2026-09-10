// ignore_for_file: avoid_relative_lib_imports
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:noor_life/core/errors/failure.dart';
import 'package:noor_life/features/authentication/application/auth_providers.dart';
import 'package:noor_life/features/authentication/domain/entities/auth_user.dart';
import 'package:noor_life/features/authentication/domain/repositories/auth_repository.dart';
import '../../../../lib/l10n/generated/app_localizations.dart';
import '../../../../lib/features/profile/presentation/screens/profile_screen.dart';

class FakeAuthRepository implements AuthRepository {
  @override
  Stream<AuthUser?> get authStateChanges => const Stream.empty();

  @override
  Future<(Failure?, AuthUser?)> getCurrentUser() async {
    // Simulate a guest user
    return (null, null);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  Widget buildTestableWidget() {
    return ProviderScope(
      overrides: [
        authRepositoryProvider.overrideWithValue(FakeAuthRepository()),
      ],
      child: const MaterialApp(
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

    // Pump a few times to let FutureProvider resolve the guest user
    await tester.pump();
    await tester.pump();

    expect(find.text('Your Progress'), findsOneWidget);
  });
}
