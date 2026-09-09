// ignore_for_file: avoid_relative_lib_imports
import 'package:flutter_test/flutter_test.dart';

import '../../../../lib/features/activity/domain/activity_prayer_type.dart';
import '../../../../lib/features/activity/domain/activity_models.dart';

void main() {
  group('DailyActivity Domain Model Tests', () {
    test('Should return default values correctly', () {
      // FIX: Const added to improve performance
      const activity = DailyActivity(date: '2026-08-30');
      expect(activity.date, '2026-08-30');
      expect(activity.quranReadingOccurred, false);
      expect(activity.completedPrayers.isEmpty, true);
    });

    test('Should serialize to JSON correctly', () {
      // FIX: Const added to constructor and internal map literal
      const activity = DailyActivity(
        date: '2026-08-30',
        completedPrayers: {ActivityPrayerType.fajr: true},
        quranReadingOccurred: true,
      );

      final json = activity.toJson();
      expect(json['date'], '2026-08-30');
      expect(json['quran'], true);
      expect((json['prayers'] as Map)['fajr'], true);
    });

    test('Should safely deserialize missing fields from corrupted JSON', () {
      final corruptedJson = {
        'date': 'invalid_date_format',
        'prayers': {'unknown_prayer': true},
      };

      final activity = DailyActivity.fromJson(corruptedJson);
      // Fallbacks to today's date if invalid format provided
      expect(activity.date.isNotEmpty, true);
      expect(activity.completedPrayers[ActivityPrayerType.fajr], false);
    });
  });
}
