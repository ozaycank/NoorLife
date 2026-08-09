import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/prayer_time.dart';
import '../../domain/value_objects/prayer_name.dart';

part 'prayer_time_model.g.dart';

@JsonSerializable()
class PrayerTimeModel extends PrayerTime {
  const PrayerTimeModel({
    required super.name,
    required super.formattedTime,
    required super.isNext,
  });

  factory PrayerTimeModel.fromJson(Map<String, dynamic> json) =>
      _$PrayerTimeModelFromJson(json);

  Map<String, dynamic> toJson() => _$PrayerTimeModelToJson(this);

  factory PrayerTimeModel.fromEntity(PrayerTime entity) {
    return PrayerTimeModel(
      name: entity.name,
      formattedTime: entity.formattedTime,
      isNext: entity.isNext,
    );
  }
}
