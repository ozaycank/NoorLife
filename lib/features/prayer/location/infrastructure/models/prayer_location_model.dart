import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/prayer_location.dart';

part 'prayer_location_model.g.dart';

@JsonSerializable()
class PrayerLocationModel extends PrayerLocation {
  const PrayerLocationModel({
    required super.latitude,
    required super.longitude,
    required super.cityName,
    required super.countryName,
    required super.timezoneIdentifier,
  });

  factory PrayerLocationModel.fromJson(Map<String, dynamic> json) =>
      _$PrayerLocationModelFromJson(json);

  Map<String, dynamic> toJson() => _$PrayerLocationModelToJson(this);
}
