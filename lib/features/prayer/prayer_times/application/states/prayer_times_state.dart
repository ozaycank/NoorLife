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
    PrayerFailure? Function()? failure,
    PrayerSchedule? Function()? schedule,
    PrayerLocation? Function()? location,
  }) {
    return PrayerTimesState(
      isLoading: isLoading ?? this.isLoading,
      failure: failure != null ? failure() : this.failure,
      schedule: schedule != null ? schedule() : this.schedule,
      location: location != null ? location() : this.location,
    );
  }

  @override
  List<Object?> get props => [isLoading, failure, schedule, location];
}
