import 'package:equatable/equatable.dart';
import 'activity_models.dart';
import '../utils/activity_date_utils.dart';

class ActivityStatistics extends Equatable {
  final int currentStreak;
  final double last7DaysCompletion;
  final int last7DaysQuran;

  const ActivityStatistics({
    required this.currentStreak,
    required this.last7DaysCompletion,
    required this.last7DaysQuran,
  });

  @override
  List<Object?> get props =>
      [currentStreak, last7DaysCompletion, last7DaysQuran];
}

class ActivityStatisticsCalculator {
  ActivityStatisticsCalculator._();

  // Pure logic, zero UI dependencies. Calculates deterministic statistics.
  static ActivityStatistics calculate(
    List<DailyActivity> records,
    String todayStr,
  ) {
    if (records.isEmpty) {
      return const ActivityStatistics(
        currentStreak: 0,
        last7DaysCompletion: 0.0,
        last7DaysQuran: 0,
      );
    }

    // Convert list to map for O(1) lookups
    final recordMap = {for (var r in records) r.date: r};

    int streak = 0;
    DateTime dateCursor = DateTime.parse(todayStr);

    // Check if today is active
    if (_isActive(recordMap[todayStr])) {
      streak++;
    }

    // Look backward continuously starting from yesterday
    dateCursor = dateCursor.subtract(const Duration(days: 1));

    while (true) {
      final key = ActivityDateUtils.normalizeDate(dateCursor);
      if (_isActive(recordMap[key])) {
        streak++;
        dateCursor = dateCursor.subtract(const Duration(days: 1));
      } else {
        break; // Streak is broken
      }
    }

    // Calculate 7-day trailing stats
    int totalPrayers = 0;
    int completedPrayers = 0;
    int quranDays = 0;

    DateTime cursor7 = DateTime.parse(todayStr);
    for (int i = 0; i < 7; i++) {
      final key = ActivityDateUtils.normalizeDate(cursor7);
      final dayRecord = recordMap[key];

      totalPrayers += 5; // 5 prayers standard daily

      if (dayRecord != null) {
        completedPrayers +=
            dayRecord.completedPrayers.values.where((v) => v).length;
        if (dayRecord.quranReadingOccurred) quranDays++;
      }

      cursor7 = cursor7.subtract(const Duration(days: 1));
    }

    final double completion =
        totalPrayers > 0 ? (completedPrayers / totalPrayers) : 0.0;

    return ActivityStatistics(
      currentStreak: streak,
      last7DaysCompletion: completion,
      last7DaysQuran: quranDays,
    );
  }

  // A day is active if ANY prayer is done OR Quran is read.
  static bool _isActive(DailyActivity? activity) {
    if (activity == null) return false;
    if (activity.quranReadingOccurred) return true;
    if (activity.completedPrayers.values.contains(true)) return true;
    return false;
  }
}
