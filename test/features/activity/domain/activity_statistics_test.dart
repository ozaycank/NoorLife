// ignore_for_file: avoid_relative_lib_imports
import 'package:flutter_test/flutter_test.dart';
import '../../../../lib/features/activity/domain/activity_models.dart';
import '../../../../lib/features/activity/domain/activity_prayer_type.dart';
import '../../../../lib/features/activity/domain/activity_statistics.dart';

void main() {
  group('ActivityStatisticsCalculator Tests', () {
    test('Empty records return zeroed statistics', () {
      final stats = ActivityStatisticsCalculator.calculate([], '2026-08-30');

      expect(stats.currentStreak, 0);
      expect(stats.last7DaysCompletion, 0.0);
      expect(stats.last7DaysQuran, 0);
    });

    test('Streak calculates correctly for continuous days including today', () {
      final records = [
        const DailyActivity(date: '2026-08-30', quranReadingOccurred: true),
        const DailyActivity(
          date: '2026-08-29',
          completedPrayers: {ActivityPrayerType.fajr: true},
        ),
        const DailyActivity(date: '2026-08-28', quranReadingOccurred: true),
      ];

      final stats =
          ActivityStatisticsCalculator.calculate(records, '2026-08-30');

      expect(stats.currentStreak, 3);
    });

    test(
        'Streak calculates correctly if today is inactive but yesterday was active',
        () {
      final records = [
        const DailyActivity(
          date: '2026-08-29',
          completedPrayers: {ActivityPrayerType.fajr: true},
        ),
        const DailyActivity(
          date: '2026-08-28',
          completedPrayers: {ActivityPrayerType.dhuhr: true},
        ),
      ];

      final stats =
          ActivityStatisticsCalculator.calculate(records, '2026-08-30');

      expect(stats.currentStreak, 2);
    });

    test('Streak breaks correctly on missed day', () {
      final records = [
        const DailyActivity(date: '2026-08-30', quranReadingOccurred: true),
        const DailyActivity(date: '2026-08-29', quranReadingOccurred: true),
        const DailyActivity(date: '2026-08-27', quranReadingOccurred: true),
      ];

      final stats =
          ActivityStatisticsCalculator.calculate(records, '2026-08-30');

      expect(stats.currentStreak, 2);
    });

    test('7-Day completion handles mixed prayer counts properly', () {
      final records = [
        const DailyActivity(
          date: '2026-08-30',
          completedPrayers: {
            ActivityPrayerType.fajr: true,
            ActivityPrayerType.dhuhr: true,
          },
        ),
        const DailyActivity(
          date: '2026-08-29',
          completedPrayers: {
            ActivityPrayerType.asr: true,
            ActivityPrayerType.maghrib: true,
            ActivityPrayerType.isha: true,
          },
        ),
      ];

      final stats =
          ActivityStatisticsCalculator.calculate(records, '2026-08-30');

      expect(stats.last7DaysCompletion, 5 / 35);
    });
  });
}
