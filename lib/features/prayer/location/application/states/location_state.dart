import 'package:equatable/equatable.dart';
import '../../domain/entities/prayer_location.dart';
import '../../domain/interfaces/location_service.dart';

enum LocationStatus { initial, requesting, success, failure }

class LocationState extends Equatable {
  final LocationStatus status;
  final PrayerLocation? location;
  final LocationFailure? failure;

  const LocationState({
    this.status = LocationStatus.initial,
    this.location,
    this.failure,
  });

  LocationState copyWith({
    LocationStatus? status,
    PrayerLocation? Function()? location,
    LocationFailure? Function()? failure,
  }) {
    return LocationState(
      status: status ?? this.status,
      location: location != null ? location() : this.location,
      failure: failure != null ? failure() : this.failure,
    );
  }

  @override
  List<Object?> get props => [status, location, failure];
}
