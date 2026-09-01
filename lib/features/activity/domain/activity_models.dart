import 'package:equatable/equatable.dart';
import '../../../core/errors/failure.dart';
import '../../prayer/prayer_times/domain/value_objects/prayer_name.dart';
import '../../../core/base/result.dart';

// Represents localized failures specific to Activity Tracking
class ActivityFailure extends Failure {
  const ActivityFailure(super.message, {super.code});
}

// Immutable domain entity representing a single day's worship record
class DailyActivity extends Equatable {
  final String date; // Format: YYYY-MM-DD
  final Map<PrayerName, bool> completedPrayers;
  final bool quranReadingOccurred;
  final bool fastingCompleted; // Foundation for future phases
  final int dhikrCount; // Foundation for future phases

  const DailyActivity({
    required this.date,
    this.completedPrayers = const {},
    this.quranReadingOccurred = false,
    this.fastingCompleted = false,
    this.dhikrCount = 0,
  });

  DailyActivity copyWith({
    String? date,
    Map<PrayerName, bool>? completedPrayers,
    bool? quranReadingOccurred,
    bool? fastingCompleted,
    int? dhikrCount,
  }) {
    return DailyActivity(
      date: date ?? this.date,
      completedPrayers: completedPrayers ?? this.completedPrayers,
      quranReadingOccurred: quranReadingOccurred ?? this.quranReadingOccurred,
      fastingCompleted: fastingCompleted ?? this.fastingCompleted,
      dhikrCount: dhikrCount ?? this.dhikrCount,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'prayers': completedPrayers.map((k, v) => MapEntry(k.name, v)),
      'quran': quranReadingOccurred,
      'fasting': fastingCompleted,
      'dhikr': dhikrCount,
    };
  }

  factory DailyActivity.fromJson(Map<String, dynamic> json) {
    final prayersMap = json['prayers'] as Map<String, dynamic>? ?? {};
    final parsedPrayers = <PrayerName, bool>{};

    for (final entry in prayersMap.entries) {
      // Safely map string keys back to PrayerName enum
      try {
        final prayerName = PrayerName.values.firstWhere(
          (e) => e.name == entry.key,
        );
        parsedPrayers[prayerName] = entry.value as bool;
      } catch (_) {
        // Ignore unrecognized keys (e.g. from future versions or corruption)
      }
    }

    // Ensure all 5 standard prayers exist in the map, default to false
    for (var p in PrayerName.values) {
      if (p != PrayerName.sunrise) {
        parsedPrayers.putIfAbsent(p, () => false);
      }
    }

    return DailyActivity(
      date: json['date'] as String? ?? '',
      completedPrayers: parsedPrayers,
      quranReadingOccurred: json['quran'] as bool? ?? false,
      fastingCompleted: json['fasting'] as bool? ?? false,
      dhikrCount: json['dhikr'] as int? ?? 0,
    );
  }

  @override
  List<Object?> get props => [
        date,
        completedPrayers,
        quranReadingOccurred,
        fastingCompleted,
        dhikrCount,
      ];
}

// Repository abstraction ensuring clean boundaries
abstract class ActivityRepository {
  Future<Result<DailyActivity, ActivityFailure>> getDailyActivity(String date);
  Future<Result<void, ActivityFailure>> saveDailyActivity(
      DailyActivity activity,);
}
