import 'package:equatable/equatable.dart';
import 'prayer_time.dart';

class PrayerDay extends Equatable {
  final DateTime date;
  final List<PrayerTime> prayerTimes;

  const PrayerDay({
    required this.date,
    required this.prayerTimes,
  });

  @override
  List<Object?> get props => [date, prayerTimes];
}
