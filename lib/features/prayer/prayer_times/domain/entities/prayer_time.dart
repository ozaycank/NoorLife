import 'package:equatable/equatable.dart';
import '../value_objects/prayer_name.dart';

class PrayerTime extends Equatable {
  final PrayerName name;
  final String formattedTime;
  final bool isNext;

  const PrayerTime({
    required this.name,
    required this.formattedTime,
    required this.isNext,
  });

  @override
  List<Object?> get props => [name, formattedTime, isNext];
}
