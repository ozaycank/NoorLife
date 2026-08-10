// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'prayer_time_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PrayerTimeModel _$PrayerTimeModelFromJson(Map<String, dynamic> json) =>
    PrayerTimeModel(
      name: $enumDecode(_$PrayerNameEnumMap, json['name']),
      time: DateTime.parse(json['time'] as String),
      formattedTime: json['formattedTime'] as String,
      remainingDuration:
          Duration(microseconds: (json['remainingDuration'] as num).toInt()),
      isPassed: json['isPassed'] as bool,
      isCurrent: json['isCurrent'] as bool,
      isUpcoming: json['isUpcoming'] as bool,
      isNext: json['isNext'] as bool,
    );

Map<String, dynamic> _$PrayerTimeModelToJson(PrayerTimeModel instance) =>
    <String, dynamic>{
      'name': _$PrayerNameEnumMap[instance.name]!,
      'time': instance.time.toIso8601String(),
      'formattedTime': instance.formattedTime,
      'remainingDuration': instance.remainingDuration.inMicroseconds,
      'isPassed': instance.isPassed,
      'isCurrent': instance.isCurrent,
      'isUpcoming': instance.isUpcoming,
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
