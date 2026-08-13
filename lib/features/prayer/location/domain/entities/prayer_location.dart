import 'package:equatable/equatable.dart';

class PrayerLocation extends Equatable {
  final double latitude;
  final double longitude;
  final String cityName;
  final String countryName;
  final String timezoneIdentifier;

  const PrayerLocation({
    required this.latitude,
    required this.longitude,
    required this.cityName,
    required this.countryName,
    required this.timezoneIdentifier,
  });

  @override
  List<Object?> get props =>
      [latitude, longitude, cityName, countryName, timezoneIdentifier];
}
