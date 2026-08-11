import 'package:equatable/equatable.dart';
import '../../../calculation_methods/domain/entities/madhab.dart';
import 'calculation_method_profile.dart';
import 'high_latitude_strategy.dart';

class PrayerCalculationConfig extends Equatable {
  final double latitude;
  final double longitude;
  final DateTime date;
  final String timezone;
  final CalculationMethodProfile method;
  final Madhab madhab;
  final HighLatitudeStrategy highLatitudeStrategy;

  PrayerCalculationConfig({
    required this.latitude,
    required this.longitude,
    required this.date,
    required this.timezone,
    required this.method,
    required this.madhab,
    this.highLatitudeStrategy = HighLatitudeStrategy.angleBased,
  }) {
    if (latitude < -90 || latitude > 90) {
      throw ArgumentError('Latitude must be between -90 and 90');
    }
    if (longitude < -180 || longitude > 180) {
      throw ArgumentError('Longitude must be between -180 and 180');
    }
    if (timezone.trim().isEmpty) {
      throw ArgumentError('Timezone identifier cannot be empty');
    }
  }

  @override
  List<Object?> get props => [
        latitude,
        longitude,
        date,
        timezone,
        method,
        madhab,
        highLatitudeStrategy,
      ];
}
