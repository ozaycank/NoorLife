import 'package:equatable/equatable.dart';

class PrayerCalculationMethod extends Equatable {
  final String id;
  final String name;
  final String description;

  const PrayerCalculationMethod({
    required this.id,
    required this.name,
    required this.description,
  });

  @override
  List<Object?> get props => [id, name, description];
}
