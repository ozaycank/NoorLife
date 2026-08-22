import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/base/result.dart';
import '../../../../core/di/injection_container.dart';
import '../../../prayer/calculation_methods/domain/repositories/calculation_method_repository.dart';
import '../../../prayer/prayer_times/application/providers/prayer_times_notifier.dart';
import '../../../prayer/prayer_times/domain/calculators/high_latitude_strategy.dart';
import '../../../prayer/shared/domain/errors/prayer_failure.dart';
import '../../../prayer/shared/infrastructure/datasources/prayer_local_data_source.dart';
import '../states/prayer_settings_state.dart';

final prayerSettingsNotifierProvider =
    NotifierProvider<PrayerSettingsNotifier, PrayerSettingsState>(
  PrayerSettingsNotifier.new,
);

class PrayerSettingsNotifier extends Notifier<PrayerSettingsState> {
  late final CalculationMethodRepository _repository;
  late final PrayerLocalDataSource _localDataSource;

  @override
  PrayerSettingsState build() {
    _repository = getIt<CalculationMethodRepository>();
    _localDataSource = getIt<PrayerLocalDataSource>();
    Future.microtask(() => loadSettings());
    return const PrayerSettingsState();
  }

  Future<void> loadSettings() async {
    state = state.copyWith(isLoading: true, failure: () => null);

    final methodsResult = await _repository.getCalculationMethods();
    final madhabsResult = await _repository.getMadhabs();
    final selectedMethodId =
        await _localDataSource.getSelectedCalculationMethodId() ?? 'diyar_turk';
    final selectedMadhabId =
        await _localDataSource.getSelectedMadhabId() ?? 'shafi_hanbali_maliki';
    final selectedHighLat =
        await _localDataSource.getSelectedHighLatitudeStrategy();

    if (methodsResult is Success && madhabsResult is Success) {
      state = state.copyWith(
        isLoading: false,
        availableMethods: (methodsResult as Success).value,
        availableMadhabs: (madhabsResult as Success).value,
        selectedMethodId: selectedMethodId,
        selectedMadhabId: selectedMadhabId,
        selectedHighLatStrategy: selectedHighLat,
      );
    } else {
      state = state.copyWith(
        isLoading: false,
        failure: () =>
            const PrayerCalculationFailure('Failed to load settings'),
      );
    }
  }

  Future<void> updateMethod(String id) async {
    state = state.copyWith(isSaving: true, failure: () => null);
    final result = await _repository.updateCalculationMethod(id);
    if (result is Success) {
      state = state.copyWith(isSaving: false, selectedMethodId: id);
      ref.read(prayerTimesNotifierProvider.notifier).refreshTimes();
    } else {
      state = state.copyWith(
        isSaving: false,
        failure: () => (result as ResultFailure).failure as PrayerFailure,
      );
    }
  }

  Future<void> updateMadhab(String id) async {
    state = state.copyWith(isSaving: true, failure: () => null);
    final result = await _repository.updateMadhab(id);
    if (result is Success) {
      state = state.copyWith(isSaving: false, selectedMadhabId: id);
      ref.read(prayerTimesNotifierProvider.notifier).refreshTimes();
    } else {
      state = state.copyWith(
        isSaving: false,
        failure: () => (result as ResultFailure).failure as PrayerFailure,
      );
    }
  }

  Future<void> updateHighLatitudeStrategy(HighLatitudeStrategy strategy) async {
    state = state.copyWith(isSaving: true, failure: () => null);
    try {
      await _localDataSource.saveSelectedHighLatitudeStrategy(strategy);
      state = state.copyWith(
        isSaving: false,
        selectedHighLatStrategy: strategy,
      );
      ref.read(prayerTimesNotifierProvider.notifier).refreshTimes();
    } catch (e) {
      state = state.copyWith(
        isSaving: false,
        failure: () => PrayerCalculationFailure('Failed to save strategy: $e'),
      );
    }
  }
}
