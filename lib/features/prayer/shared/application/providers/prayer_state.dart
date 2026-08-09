import 'package:equatable/equatable.dart';
import '../../../calculation_methods/domain/entities/madhab.dart';
import '../../../calculation_methods/domain/entities/prayer_calculation_method.dart';
import '../../../location/domain/entities/prayer_location.dart';
import '../../../prayer_times/domain/entities/prayer_day.dart';

class PrayerState extends Equatable {
  final bool isLoading;
  final String? errorMessage;
  final PrayerDay? prayerDay;
  final PrayerLocation? location;
  final List<PrayerCalculationMethod> calculationMethods;
  final String selectedCalculationMethodId;
  final List<Madhab> madhabs;
  final String selectedMadhabId;

  const PrayerState({
    this.isLoading = false,
    this.errorMessage,
    this.prayerDay,
    this.location,
    this.calculationMethods = const [],
    this.selectedCalculationMethodId = 'diyar_turk',
    this.madhabs = const [],
    this.selectedMadhabId = 'shafi_hanbali_maliki',
  });

  const PrayerState.initial() : this();

  PrayerState copyWith({
    bool? isLoading,
    String? errorMessage,
    PrayerDay? prayerDay,
    PrayerLocation? location,
    List<PrayerCalculationMethod>? calculationMethods,
    String? selectedCalculationMethodId,
    List<Madhab>? madhabs,
    String? selectedMadhabId,
  }) {
    return PrayerState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      prayerDay: prayerDay ?? this.prayerDay,
      location: location ?? this.location,
      calculationMethods: calculationMethods ?? this.calculationMethods,
      selectedCalculationMethodId:
          selectedCalculationMethodId ?? this.selectedCalculationMethodId,
      madhabs: madhabs ?? this.madhabs,
      selectedMadhabId: selectedMadhabId ?? this.selectedMadhabId,
    );
  }

  @override
  List<Object?> get props => [
        isLoading,
        errorMessage,
        prayerDay,
        location,
        calculationMethods,
        selectedCalculationMethodId,
        madhabs,
        selectedMadhabId,
      ];
}
