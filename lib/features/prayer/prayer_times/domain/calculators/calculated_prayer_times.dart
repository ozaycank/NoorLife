import 'package:equatable/equatable.dart';

class CalculatedPrayerTimes extends Equatable {
  final DateTime fajr;
  final DateTime sunrise;
  final DateTime dhuhr;
  final DateTime asr;
  final DateTime sunset;
  final DateTime maghrib;
  final DateTime isha;

  const CalculatedPrayerTimes({
    required this.fajr,
    required this.sunrise,
    required this.dhuhr,
    required this.asr,
    required this.sunset,
    required this.maghrib,
    required this.isha,
  });

  @override
  List<Object?> get props => [fajr, sunrise, dhuhr, asr, sunset, maghrib, isha];
}
