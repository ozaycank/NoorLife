import 'package:equatable/equatable.dart';
import '../../../location/domain/entities/prayer_location.dart';
import '../../../shared/domain/errors/prayer_failure.dart';
import '../../domain/entities/prayer_schedule.dart';

class PrayerTimesState extends Equatable {
  final bool isLoading;
  final PrayerFailure? failure;
  final PrayerSchedule? schedule;
  final PrayerLocation? location;

  const PrayerTimesState({
    this.isLoading = false,
    this.failure,
    this.schedule,
    this.location,
  });

  const PrayerTimesState.initial() : this();

  PrayerTimesState copyWith({
    bool? isLoading,
    PrayerFailure? failure,
    PrayerSchedule? schedule,
    PrayerLocation? location,
  }) {
    return PrayerTimesState(
      isLoading: isLoading ?? this.isLoading,
      failure: failure,
      schedule: schedule ?? this.schedule,
      location: location ?? this.location,
    );
  }

  @override
  List<Object?> get props => [isLoading, failure, schedule, location];
}
