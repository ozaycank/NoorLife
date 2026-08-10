import 'package:equatable/equatable.dart';
import '../value_objects/prayer_name.dart';

class PrayerTime extends Equatable {
  final PrayerName name;
  final DateTime time;
  final String formattedTime;
  final Duration remainingDuration;
  final bool isPassed;
  final bool isCurrent;
  final bool isUpcoming;
  final bool isNext;

  const PrayerTime({
    required this.name,
    required this.time,
    required this.formattedTime,
    required this.remainingDuration,
    required this.isPassed,
    required this.isCurrent,
    required this.isUpcoming,
    required this.isNext,
  });

  @override
  List<Object?> get props => [
        name,
        time,
        formattedTime,
        remainingDuration,
        isPassed,
        isCurrent,
        isUpcoming,
        isNext,
      ];
}
