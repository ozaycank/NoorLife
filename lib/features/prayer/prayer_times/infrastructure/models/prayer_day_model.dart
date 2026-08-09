import '../../domain/entities/prayer_day.dart';
import 'prayer_time_model.dart';

class PrayerDayModel extends PrayerDay {
  const PrayerDayModel({
    required super.dateIso8601,
    required super.hijriDateFormatted,
    required super.prayerTimes,
    super.nextPrayerName,
    super.timeRemainingFormatted,
  });

  factory PrayerDayModel.fromJson(Map<String, dynamic> json) {
    final rawList = json['prayerTimes'] as List<dynamic>? ?? [];
    final times = rawList
        .map((e) => PrayerTimeModel.fromJson(e as Map<String, dynamic>))
        .toList();

    return PrayerDayModel(
      dateIso8601: json['dateIso8601'] as String,
      hijriDateFormatted: json['hijriDateFormatted'] as String,
      prayerTimes: times,
      nextPrayerName: json['nextPrayerName'] as String?,
      timeRemainingFormatted: json['timeRemainingFormatted'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'dateIso8601': dateIso8601,
      'hijriDateFormatted': hijriDateFormatted,
      'prayerTimes': prayerTimes
          .map((e) => PrayerTimeModel.fromEntity(e).toJson())
          .toList(),
      'nextPrayerName': nextPrayerName,
      'timeRemainingFormatted': timeRemainingFormatted,
    };
  }
}
