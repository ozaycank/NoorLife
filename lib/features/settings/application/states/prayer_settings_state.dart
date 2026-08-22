import 'package:equatable/equatable.dart';
import '../../../prayer/calculation_methods/domain/entities/madhab.dart';
import '../../../prayer/calculation_methods/domain/entities/prayer_calculation_method.dart';
import '../../../prayer/prayer_times/domain/calculators/high_latitude_strategy.dart';
import '../../../prayer/shared/domain/errors/prayer_failure.dart';

class PrayerSettingsState extends Equatable {
  final bool isLoading;
  final bool isSaving;
  final PrayerFailure? failure;
  final List<PrayerCalculationMethod> availableMethods;
  final List<Madhab> availableMadhabs;
  final String? selectedMethodId;
  final String? selectedMadhabId;
  final HighLatitudeStrategy? selectedHighLatStrategy;

  const PrayerSettingsState({
    this.isLoading = false,
    this.isSaving = false,
    this.failure,
    this.availableMethods = const [],
    this.availableMadhabs = const [],
    this.selectedMethodId,
    this.selectedMadhabId,
    this.selectedHighLatStrategy,
  });

  PrayerSettingsState copyWith({
    bool? isLoading,
    bool? isSaving,
    PrayerFailure? Function()? failure,
    List<PrayerCalculationMethod>? availableMethods,
    List<Madhab>? availableMadhabs,
    String? selectedMethodId,
    String? selectedMadhabId,
    HighLatitudeStrategy? selectedHighLatStrategy,
  }) {
    return PrayerSettingsState(
      isLoading: isLoading ?? this.isLoading,
      isSaving: isSaving ?? this.isSaving,
      failure: failure != null ? failure() : this.failure,
      availableMethods: availableMethods ?? this.availableMethods,
      availableMadhabs: availableMadhabs ?? this.availableMadhabs,
      selectedMethodId: selectedMethodId ?? this.selectedMethodId,
      selectedMadhabId: selectedMadhabId ?? this.selectedMadhabId,
      selectedHighLatStrategy:
          selectedHighLatStrategy ?? this.selectedHighLatStrategy,
    );
  }

  @override
  List<Object?> get props => [
        isLoading,
        isSaving,
        failure,
        availableMethods,
        availableMadhabs,
        selectedMethodId,
        selectedMadhabId,
        selectedHighLatStrategy,
      ];
}
