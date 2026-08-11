import '../../domain/entities/prayer_day.dart';
import 'prayer_time_model.dart';

class PrayerDayModel extends PrayerDay {
  const PrayerDayModel({
    required super.date,
    required super.prayerTimes,
  });

  factory PrayerDayModel.fromJson(Map<String, dynamic> json) {
    final rawList = json['prayerTimes'] as List<dynamic>? ?? [];
    final times = rawList
        .map((e) => PrayerTimeModel.fromJson(e as Map<String, dynamic>))
        .toList();

    return PrayerDayModel(
      date: DateTime.parse(json['date'] as String),
      prayerTimes: times,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'prayerTimes': prayerTimes
          .map((e) => PrayerTimeModel.fromEntity(e).toJson())
          .toList(),
    };
  }
}
