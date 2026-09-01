// ignore_for_file: avoid_relative_lib_imports

import 'package:flutter_test/flutter_test.dart';

import '../../../../lib/core/base/result.dart';
import '../../../../lib/features/activity/domain/activity_models.dart';
import '../../../../lib/features/prayer/prayer_times/domain/value_objects/prayer_name.dart';
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
  group('ActivityNotifier Application Logic', () {
    late ActivityNotifier notifier;
    late MockActivityRepository mockRepo;

    setUp(() {
      mockRepo = MockActivityRepository();
      notifier = ActivityNotifier(mockRepo);
    });

    test('Initial load should fetch default activity', () async {
      await notifier.loadDate('2026-08-30');
      expect(notifier.state.isLoading, false);
      expect(notifier.state.dailyActivity?.date, '2026-08-30');
    });

    test('Toggle prayer should optimistically update UI and Repository',
        () async {
      await notifier.loadDate('2026-08-30');

      await notifier.togglePrayer(PrayerName.fajr);

      expect(
        notifier.state.dailyActivity?.completedPrayers[PrayerName.fajr],
        true,
      );
      expect(mockRepo.savedActivity?.completedPrayers[PrayerName.fajr], true);
    });

    test('markQuranRead should permanently flag reading state', () async {
      await notifier.loadDate('2026-08-30');

      await notifier.markQuranRead();

      expect(notifier.state.dailyActivity?.quranReadingOccurred, true);
      expect(mockRepo.savedActivity?.quranReadingOccurred, true);
    });
  });
}
