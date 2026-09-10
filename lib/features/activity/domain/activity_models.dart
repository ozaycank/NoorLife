import 'package:equatable/equatable.dart';
import '../../../core/errors/failure.dart';
import '../../../core/base/result.dart';
import 'activity_prayer_type.dart';
import '../utils/activity_date_utils.dart';

class ActivityFailure extends Failure {
  const ActivityFailure(super.message, {super.code});
}

class DailyActivity extends Equatable {
  final String date;
  final Map<ActivityPrayerType, bool> completedPrayers;
  final bool quranReadingOccurred;

  const DailyActivity({
    required this.date,
    this.completedPrayers = const {},
    this.quranReadingOccurred = false,
  });

  DailyActivity copyWith({
    String? date,
    Map<ActivityPrayerType, bool>? completedPrayers,
    bool? quranReadingOccurred,
  }) {
    return DailyActivity(
      date: date ?? this.date,
      completedPrayers: completedPrayers ?? this.completedPrayers,
      quranReadingOccurred: quranReadingOccurred ?? this.quranReadingOccurred,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'prayers': completedPrayers.map((k, v) => MapEntry(k.name, v)),
      'quran': quranReadingOccurred,
    };
  }

  factory DailyActivity.fromJson(Map<String, dynamic> json) {
    final prayersMap = json['prayers'] as Map<String, dynamic>? ?? {};
    final parsedPrayers = <ActivityPrayerType, bool>{};

    for (final entry in prayersMap.entries) {
      try {
        final prayerType = ActivityPrayerType.values.firstWhere(
          (e) => e.name == entry.key,
        );
        if (entry.value is bool) {
          parsedPrayers[prayerType] = entry.value as bool;
        }
      } catch (_) {} // Ignore unrecognized keys safely
    }

    for (var p in ActivityPrayerType.values) {
      parsedPrayers.putIfAbsent(p, () => false);
    }

    final rawDate = json['date'] as String? ?? '';
    final safeDate = ActivityDateUtils.isValidFormat(rawDate)
        ? rawDate
        : ActivityDateUtils.today();

    return DailyActivity(
      date: safeDate,
      completedPrayers: parsedPrayers,
      quranReadingOccurred: json['quran'] == true,
    );
  }

  @override
  List<Object?> get props => [
        date,
        completedPrayers,
        quranReadingOccurred,
      ];
}

abstract class ActivityRepository {
  Future<Result<DailyActivity, ActivityFailure>> getDailyActivity(String date);
  // Phase 16: Added method to retrieve history for statistics and UI
  Future<Result<List<DailyActivity>, ActivityFailure>> getAllActivities();
  Future<Result<void, ActivityFailure>> saveDailyActivity(
    DailyActivity activity,
  );
}
