import 'package:equatable/equatable.dart';
import '../value_objects/prayer_name.dart';

class PrayerTime extends Equatable {
  final PrayerName name;
  final DateTime time;

  const PrayerTime({
    required this.name,
    required this.time,
  });

  @override
  List<Object?> get props => [name, time];
}
