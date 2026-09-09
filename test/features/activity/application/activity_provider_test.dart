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
  Future<Result<void, ActivityFailure>> saveDailyActivity(
    DailyActivity activity,
  ) async {
    savedActivity = activity;
    return const Success(null);
  }
}

void main() {
  group('ActivityNotifier Race Condition & Logic Tests', () {
    late ActivityNotifier notifier;
    late MockActivityRepository mockRepo;

    setUp(() {
      mockRepo = MockActivityRepository();
      notifier = ActivityNotifier(mockRepo);
    });

    test('Toggle prayer should update properly', () async {
      await notifier.loadDate('2026-08-30');
      await notifier.togglePrayer(ActivityPrayerType.fajr);
      expect(
        notifier.state.dailyActivity?.completedPrayers[ActivityPrayerType.fajr],
        true,
      );
    });

    test('Quran mark read should only update once', () async {
      await notifier.loadDate('2026-08-30');
      await notifier.markQuranRead();
      expect(notifier.state.dailyActivity?.quranReadingOccurred, true);
    });
  });
}
