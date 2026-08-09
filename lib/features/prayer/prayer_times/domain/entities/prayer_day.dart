import 'package:equatable/equatable.dart';
import 'prayer_time.dart';

class PrayerDay extends Equatable {
  final String dateIso8601;
  final String hijriDateFormatted;
  final List<PrayerTime> prayerTimes;
  final String? nextPrayerName;
  final String? timeRemainingFormatted;

  const PrayerDay({
    required this.dateIso8601,
    required this.hijriDateFormatted,
    required this.prayerTimes,
    this.nextPrayerName,
    this.timeRemainingFormatted,
  });

  @override
  List<Object?> get props => [
        dateIso8601,
        hijriDateFormatted,
        prayerTimes,
        nextPrayerName,
        timeRemainingFormatted,
      ];
}
