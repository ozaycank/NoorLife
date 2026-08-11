import '../../domain/entities/prayer_time.dart';
import '../../domain/value_objects/prayer_name.dart';

class PrayerTimeModel extends PrayerTime {
  const PrayerTimeModel({
    required super.name,
    required super.time,
  });

  factory PrayerTimeModel.fromJson(Map<String, dynamic> json) {
    return PrayerTimeModel(
      name: PrayerName.values.firstWhere(
        (e) => e.name == json['name'],
        orElse: () => PrayerName.fajr,
      ),
      time: DateTime.parse(json['time'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name.name,
      'time': time.toIso8601String(),
    };
  }

  factory PrayerTimeModel.fromEntity(PrayerTime entity) {
    return PrayerTimeModel(
      name: entity.name,
      time: entity.time,
    );
  }
}
