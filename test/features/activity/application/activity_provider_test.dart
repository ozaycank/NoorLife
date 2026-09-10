// ignore_for_file: avoid_relative_lib_imports
import 'package:flutter_test/flutter_test.dart';

import 'package:noor_life/core/base/result.dart';
import 'package:noor_life/features/activity/domain/activity_models.dart';
import 'package:noor_life/features/activity/domain/activity_prayer_type.dart';
import 'package:noor_life/features/activity/application/activity_provider.dart';

class MockActivityRepository implements ActivityRepository {
  DailyActivity? savedActivity;

  @override
  Future<Result<DailyActivity, ActivityFailure>> getDailyActivity(
    String date,
  ) async {
    return Success(savedActivity ?? DailyActivity(date: date));
  }

  @override
  Future<Result<List<DailyActivity>, ActivityFailure>>
      getAllActivities() async {
    // FIX: Simplified history return to strictly match what was saved.
    // Prevents async race condition list bugs.
    return Success(savedActivity != null ? [savedActivity!] : []);
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
      // Manually seed the repository state for statistics to fetch
      mockRepo.savedActivity = const DailyActivity(date: '2026-08-30');

      await notifier.loadDate('2026-08-30');
      await notifier.togglePrayer(ActivityPrayerType.fajr);

      expect(
        notifier.state.dailyActivity?.completedPrayers[ActivityPrayerType.fajr],
        true,
      );

      // Now history length will accurately reflect the saved data
      expect(notifier.state.history.length, 1);
      expect(notifier.state.statistics?.currentStreak, 1);
    });

    test('Quran mark read should flag reading state', () async {
      await notifier.loadDate('2026-08-30');
      await notifier.markQuranRead();
      expect(notifier.state.dailyActivity?.quranReadingOccurred, true);
    });
  });
}
