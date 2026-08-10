import 'package:equatable/equatable.dart';
import '../../../shared/domain/errors/prayer_failure.dart';
import '../../domain/entities/prayer_day.dart';

class PrayerTimesState extends Equatable {
  final bool isLoading;
  final PrayerFailure? failure;
  final PrayerDay? prayerDay;

  const PrayerTimesState({
    this.isLoading = false,
    this.failure,
    this.prayerDay,
  });

  const PrayerTimesState.initial() : this();

  PrayerTimesState copyWith({
    bool? isLoading,
    PrayerFailure? failure,
    PrayerDay? prayerDay,
  }) {
    return PrayerTimesState(
      isLoading: isLoading ?? this.isLoading,
      failure: failure,
      prayerDay: prayerDay ?? this.prayerDay,
    );
  }

  @override
  List<Object?> get props => [isLoading, failure, prayerDay];
}
