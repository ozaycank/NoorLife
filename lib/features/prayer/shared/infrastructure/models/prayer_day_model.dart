import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/prayer_day.dart';
import 'prayer_time_model.dart';

part 'prayer_day_model.g.dart';

@JsonSerializable(explicitToJson: true)
class PrayerDayModel extends PrayerDay {
  const PrayerDayModel({
    required super.dateIso8601,
    required super.hijriDateFormatted,
    required List<PrayerTimeModel> super.prayerTimes,
    super.nextPrayerName,
    super.timeRemainingFormatted,
  });

  factory PrayerDayModel.fromJson(Map<String, dynamic> json) =>
      _$PrayerDayModelFromJson(json);

  Map<String, dynamic> toJson() => _$PrayerDayModelToJson(this);
}
