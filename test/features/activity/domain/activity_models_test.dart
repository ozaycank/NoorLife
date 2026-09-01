// ignore_for_file: avoid_relative_lib_imports

import 'package:flutter_test/flutter_test.dart';

import '../../../../lib/features/prayer/prayer_times/domain/value_objects/prayer_name.dart';
import '../../../../lib/features/activity/domain/activity_models.dart';

void main() {
  group('DailyActivity Domain Model Tests', () {
    test('Should return default values correctly', () {
      // FIX: Added 'const' to improve performance as suggested by linter
      const activity = DailyActivity(date: '2026-08-30');
      expect(activity.date, '2026-08-30');
      expect(activity.quranReadingOccurred, false);
      expect(activity.completedPrayers.isEmpty, true);
      expect(activity.fastingCompleted, false);
      expect(activity.dhikrCount, 0);
    });

    test('Should serialize to JSON correctly', () {
      // FIX: Added 'const' to constructor and the inner map literal
      const activity = DailyActivity(
        date: '2026-08-30',
        completedPrayers:  {PrayerName.fajr: true},
        quranReadingOccurred: true,
      );

      final json = activity.toJson();
      expect(json['date'], '2026-08-30');
      expect(json['quran'], true);
      expect((json['prayers'] as Map)['fajr'], true);
    });

    test('Should safely deserialize missing fields from corrupted JSON', () {
      final corruptedJson = {
        'date': '2026-08-31',
        'prayers': {'unknown_prayer': true},
      };

      final activity = DailyActivity.fromJson(corruptedJson);
      expect(activity.date, '2026-08-31');
      expect(activity.completedPrayers[PrayerName.fajr], false);
      expect(activity.quranReadingOccurred, false);
    });
  });
}
