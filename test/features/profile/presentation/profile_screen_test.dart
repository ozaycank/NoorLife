// ignore_for_file: avoid_relative_lib_imports
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get_it/get_it.dart';

import 'package:noor_life/core/errors/failure.dart';
import 'package:noor_life/core/base/result.dart';
import 'package:noor_life/features/authentication/domain/entities/auth_user.dart';
import 'package:noor_life/features/authentication/domain/repositories/auth_repository.dart';
import 'package:noor_life/features/activity/domain/activity_models.dart';
import '../../../../lib/l10n/generated/app_localizations.dart';
import '../../../../lib/features/profile/presentation/screens/profile_screen.dart';

class FakeAuthRepository implements AuthRepository {
  @override
  Stream<AuthUser?> get authStateChanges => const Stream.empty();

  @override
  Future<(Failure?, AuthUser?)> getCurrentUser() async {
    return (null, null); // Simulate Guest
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class FakeActivityRepository implements ActivityRepository {
  @override
  Future<Result<DailyActivity, ActivityFailure>> getDailyActivity(
      String date,) async {
    return Success(DailyActivity(date: date));
  }

  @override
  Future<Result<List<DailyActivity>, ActivityFailure>>
      getAllActivities() async {
    return const Success([]);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  setUp(() {
    final getIt = GetIt.instance;
    getIt.reset();
    getIt.registerSingleton<AuthRepository>(FakeAuthRepository());
    getIt.registerSingleton<ActivityRepository>(FakeActivityRepository());
  });

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
        locale: Locale('en'),
        home: ProfileScreen(),
      ),
    );
  }

  testWidgets('Profile screen renders safely with basic user elements',
      (tester) async {
    // FIX: Removed runAsync to allow Flutter to load Localizations synchronously
    // in the first frame, preventing ContextExtensions.l10n null crashes.
    await tester.pumpWidget(buildTestableWidget());

    // Wait for the FutureProvider and rendering to settle
    await tester.pumpAndSettle();

    expect(find.text('Your Progress'), findsOneWidget);
  });
}
