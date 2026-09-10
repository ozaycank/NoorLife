// ignore_for_file: avoid_relative_lib_imports
import 'package:flutter_test/flutter_test.dart';

import '../../../../lib/core/base/result.dart';
import '../../../../lib/features/activity/domain/activity_models.dart';
import '../../../../lib/features/activity/domain/activity_prayer_type.dart';
import '../../../../lib/features/activity/application/activity_provider.dart';

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
    // Return mock history logic
    if (savedActivity != null) {
      return Success([savedActivity!]);
    }
    return const Success([]);
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

      // Also expect statistics to be updated (mock repo returns 1 entry)
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
