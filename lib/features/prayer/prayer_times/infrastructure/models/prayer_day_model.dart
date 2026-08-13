import '../../domain/entities/prayer_day.dart';
import 'prayer_time_model.dart';

class PrayerDayModel extends PrayerDay {
  const PrayerDayModel({
    required super.targetDate,
    required super.prayerTimes,
    super.tomorrowFajr,
    super.hijriDateString,
  });

  factory PrayerDayModel.fromJson(Map<String, dynamic> json) {
    final rawList = json['prayerTimes'] as List<dynamic>? ?? [];
    final times = rawList
        .map((e) => PrayerTimeModel.fromJson(e as Map<String, dynamic>))
        .toList();

    PrayerTimeModel? tomorrowFajr;
    if (json['tomorrowFajr'] != null) {
      tomorrowFajr = PrayerTimeModel.fromJson(
          json['tomorrowFajr'] as Map<String, dynamic>,);
    }

    return PrayerDayModel(
      targetDate: DateTime.parse(json['targetDate'] as String),
      prayerTimes: times,
      tomorrowFajr: tomorrowFajr,
      hijriDateString: json['hijriDateString'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'targetDate': targetDate.toIso8601String(),
      'prayerTimes': prayerTimes
          .map((e) => PrayerTimeModel.fromEntity(e).toJson())
          .toList(),
      'tomorrowFajr': tomorrowFajr != null
          ? PrayerTimeModel.fromEntity(tomorrowFajr!).toJson()
          : null,
      'hijriDateString': hijriDateString,
    };
  }
}
