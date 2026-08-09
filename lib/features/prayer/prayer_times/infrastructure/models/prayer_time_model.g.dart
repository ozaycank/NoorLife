// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'prayer_time_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PrayerTimeModel _$PrayerTimeModelFromJson(Map<String, dynamic> json) =>
    PrayerTimeModel(
      name: $enumDecode(_$PrayerNameEnumMap, json['name']),
      formattedTime: json['formattedTime'] as String,
      isNext: json['isNext'] as bool,
    );

Map<String, dynamic> _$PrayerTimeModelToJson(PrayerTimeModel instance) =>
    <String, dynamic>{
      'name': _$PrayerNameEnumMap[instance.name]!,
      'formattedTime': instance.formattedTime,
      'isNext': instance.isNext,
    };

const _$PrayerNameEnumMap = {
  PrayerName.fajr: 'fajr',
  PrayerName.sunrise: 'sunrise',
  PrayerName.dhuhr: 'dhuhr',
  PrayerName.asr: 'asr',
  PrayerName.maghrib: 'maghrib',
  PrayerName.isha: 'isha',
};
