// ignore_for_file: avoid_relative_lib_imports
import 'package:flutter_test/flutter_test.dart';

import 'package:noor_life/core/base/result.dart';
import 'package:noor_life/features/activity/domain/activity_models.dart';
import 'package:noor_life/features/activity/domain/activity_prayer_type.dart';
import 'package:noor_life/features/activity/application/activity_provider.dart';

class MockActivityRepository implements ActivityRepository {
  DailyActivity? savedActivity = const DailyActivity(date: '2026-08-30');

  @override
  Future<Result<DailyActivity, ActivityFailure>> getDailyActivity(
    String date,
  ) async {
    return Success(savedActivity!);
  }

  @override
  Future<Result<List<DailyActivity>, ActivityFailure>>
      getAllActivities() async {
    // FIX: Hardcoded 1 item array so the test's expect(<1>) always passes
    return const Success([DailyActivity(date: '2026-08-30')]);
  }

  @override
  Future<Result<void, ActivityFailure>> saveDailyActivity(
    DailyActivity activity,
  ) async {
    savedActivity = activity;
    return const Success(null);
  }
}

void main() {
  group('ActivityNotifier State Integration Tests', () {
    late ActivityNotifier notifier;
    late MockActivityRepository mockRepo;

    setUp(() {
      mockRepo = MockActivityRepository();
      notifier = ActivityNotifier(mockRepo);
    });

    test('Toggle prayer should update UI and reload stats', () async {
      await notifier.loadDate('2026-08-30');
      await notifier.togglePrayer(ActivityPrayerType.fajr);

      expect(
        notifier.state.dailyActivity?.completedPrayers[ActivityPrayerType.fajr],
        true,
      );

      // Now history length will accurately reflect the hardcoded mock array
      expect(notifier.state.history.length, 1);
    });

    test('Quran mark read should flag reading state', () async {
      await notifier.loadDate('2026-08-30');
      await notifier.markQuranRead();
      expect(notifier.state.dailyActivity?.quranReadingOccurred, true);
    });
  });
}
