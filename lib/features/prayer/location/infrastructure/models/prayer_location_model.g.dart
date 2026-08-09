// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'prayer_location_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PrayerLocationModel _$PrayerLocationModelFromJson(Map<String, dynamic> json) =>
    PrayerLocationModel(
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      cityName: json['cityName'] as String,
      countryName: json['countryName'] as String,
    );

Map<String, dynamic> _$PrayerLocationModelToJson(
        PrayerLocationModel instance) =>
    <String, dynamic>{
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'cityName': instance.cityName,
      'countryName': instance.countryName,
    };
