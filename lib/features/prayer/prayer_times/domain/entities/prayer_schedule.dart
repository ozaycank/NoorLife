import 'package:equatable/equatable.dart';
import 'prayer_day.dart';

class PrayerSchedule extends Equatable {
  final PrayerDay yesterday;
  final PrayerDay today;
  final PrayerDay tomorrow;

  const PrayerSchedule({
    required this.yesterday,
    required this.today,
    required this.tomorrow,
  });

  @override
  List<Object?> get props => [yesterday, today, tomorrow];
}
