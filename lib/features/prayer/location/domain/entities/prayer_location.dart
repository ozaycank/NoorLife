import 'package:equatable/equatable.dart';

class PrayerLocation extends Equatable {
  final double latitude;
  final double longitude;
  final String cityName;
  final String countryName;

  const PrayerLocation({
    required this.latitude,
    required this.longitude,
    required this.cityName,
    required this.countryName,
  });

  @override
  List<Object?> get props => [latitude, longitude, cityName, countryName];
}
