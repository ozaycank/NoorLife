import 'package:equatable/equatable.dart';
import '../../../shared/domain/errors/prayer_failure.dart';
import '../../../../../core/base/result.dart';

class CalculationMethodProfile extends Equatable {
  final String id;
  final String name;
  final double fajrAngle;
  final double? ishaAngle;
  final int? ishaIntervalMinutes;

  const CalculationMethodProfile({
    required this.id,
    required this.name,
    required this.fajrAngle,
    this.ishaAngle,
    this.ishaIntervalMinutes,
  });

  static const CalculationMethodProfile mwl = CalculationMethodProfile(
    id: 'mwl',
    name: 'Muslim World League',
    fajrAngle: 18.0,
    ishaAngle: 17.0,
  );

  static const CalculationMethodProfile isna = CalculationMethodProfile(
    id: 'isna',
    name: 'Islamic Society of North America',
    fajrAngle: 15.0,
    ishaAngle: 15.0,
  );

  static const CalculationMethodProfile egypt = CalculationMethodProfile(
    id: 'egypt',
    name: 'Egyptian General Authority',
    fajrAngle: 19.5,
    ishaAngle: 17.5,
  );

  static const CalculationMethodProfile makkah = CalculationMethodProfile(
    id: 'makkah',
    name: 'Umm Al-Qura',
    fajrAngle: 18.5,
    ishaIntervalMinutes: 90,
  );

  /// Note: This is an astronomical approximation profile based on 18/17 degrees.
  /// It is not an official reproduction of Diyanet's proprietary calculation system.
  /// Accuracy must be validated against a trusted reference dataset.
  static const CalculationMethodProfile diyanetApproximation =
      CalculationMethodProfile(
    id: 'diyar_turk',
    name: 'Diyanet Approximation Profile',
    fajrAngle: 18.0,
    ishaAngle: 17.0,
  );

  static Result<CalculationMethodProfile, PrayerCalculationFailure> fromId(
      String id,) {
    switch (id) {
      case 'mwl':
        return const Success(mwl);
      case 'isna':
        return const Success(isna);
      case 'egypt':
        return const Success(egypt);
      case 'makkah':
        return const Success(makkah);
      case 'diyar_turk':
        return const Success(diyanetApproximation);
      default:
        return Error(
            PrayerCalculationFailure('Unsupported calculation method ID: $id'),);
    }
  }

  @override
  List<Object?> get props =>
      [id, name, fajrAngle, ishaAngle, ishaIntervalMinutes];
}
