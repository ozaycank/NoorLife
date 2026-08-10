import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/prayer_time.dart';
import '../../domain/value_objects/prayer_name.dart';

part 'prayer_time_model.g.dart';

@JsonSerializable()
class PrayerTimeModel extends PrayerTime {
  const PrayerTimeModel({
    required super.name,
    required super.time,
    required super.formattedTime,
    required super.remainingDuration,
    required super.isPassed,
    required super.isCurrent,
    required super.isUpcoming,
    required super.isNext,
  });

  factory PrayerTimeModel.fromJson(Map<String, dynamic> json) =>
      _$PrayerTimeModelFromJson(json);

  Map<String, dynamic> toJson() => _$PrayerTimeModelToJson(this);

  factory PrayerTimeModel.fromEntity(PrayerTime entity) {
    return PrayerTimeModel(
      name: entity.name,
      time: entity.time,
      formattedTime: entity.formattedTime,
      remainingDuration: entity.remainingDuration,
      isPassed: entity.isPassed,
      isCurrent: entity.isCurrent,
      isUpcoming: entity.isUpcoming,
      isNext: entity.isNext,
    );
  }
}
