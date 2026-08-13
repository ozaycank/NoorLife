import 'package:equatable/equatable.dart';
import 'prayer_time.dart';

class PrayerDay extends Equatable {
  final DateTime targetDate;
  final List<PrayerTime> prayerTimes;
  final String? hijriDateString;

  const PrayerDay({
    required this.targetDate,
    required this.prayerTimes,
    this.hijriDateString,
  });

  @override
  List<Object?> get props => [targetDate, prayerTimes, hijriDateString];
}
