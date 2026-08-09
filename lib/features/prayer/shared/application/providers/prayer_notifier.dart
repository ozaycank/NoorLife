import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/di/injection_container.dart';
import '../../../../../core/logging/logger_service.dart';
import '../../../../../core/providers/base_providers.dart';
import '../../../calculation_methods/application/usecases/get_calculation_methods_use_case.dart';
import '../../../calculation_methods/application/usecases/get_madhab_use_case.dart';
import '../../../calculation_methods/application/usecases/update_calculation_method_use_case.dart';
import '../../../calculation_methods/application/usecases/update_madhab_use_case.dart';
import '../../../location/domain/entities/prayer_location.dart';
import '../usecases/get_prayer_times_use_case.dart';
import '../usecases/refresh_prayer_times_use_case.dart';
import 'prayer_state.dart';

class PrayerNotifier extends Notifier<PrayerState> {
  late final GetPrayerTimesUseCase _getPrayerTimes;
  late final RefreshPrayerTimesUseCase _refreshPrayerTimes;
  late final GetCalculationMethodsUseCase _getCalculationMethods;
  late final UpdateCalculationMethodUseCase _updateCalculationMethod;
  late final GetMadhabUseCase _getMadhab;
  late final UpdateMadhabUseCase _updateMadhab;
  late final LoggerService _logger;

  @override
  PrayerState build() {
    _getPrayerTimes = getIt<GetPrayerTimesUseCase>();
    _refreshPrayerTimes = getIt<RefreshPrayerTimesUseCase>();
    _getCalculationMethods = getIt<GetCalculationMethodsUseCase>();
    _updateCalculationMethod = getIt<UpdateCalculationMethodUseCase>();
    _getMadhab = getIt<GetMadhabUseCase>();
    _updateMadhab = getIt<UpdateMadhabUseCase>();
    _logger = ref.watch(loggerProvider);

    Future.microtask(() => loadPrayerData());

    return const PrayerState.initial();
  }

  Future<void> loadPrayerData() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    const defaultLocation = PrayerLocation(
      latitude: 41.0082,
      longitude: 28.9784,
      cityName: 'Istanbul',
      countryName: 'Türkiye',
    );

    final (methodsFailure, methods) = await _getCalculationMethods.execute();
    final (madhabFailure, madhabs) = await _getMadhab.execute();
    final (timesFailure, prayerDay) =
        await _getPrayerTimes.execute(defaultLocation);

    if (methodsFailure != null ||
        madhabFailure != null ||
        timesFailure != null) {
      final errorMsg = timesFailure?.message ??
          methodsFailure?.message ??
          madhabFailure?.message ??
          'Failed to load prayer foundation data.';
      _logger.error('PrayerNotifier loadPrayerData failed: $errorMsg');
      state = state.copyWith(isLoading: false, errorMessage: errorMsg);
      return;
    }

    state = state.copyWith(
      isLoading: false,
      location: defaultLocation,
      prayerDay: prayerDay,
      calculationMethods: methods ?? [],
      madhabs: madhabs ?? [],
    );
  }

  Future<void> refreshTimes() async {
    final loc = state.location ??
        const PrayerLocation(
          latitude: 41.0082,
          longitude: 28.9784,
          cityName: 'Istanbul',
          countryName: 'Türkiye',
        );

    state = state.copyWith(isLoading: true, errorMessage: null);
    final (failure, prayerDay) = await _refreshPrayerTimes.execute(loc);

    if (failure != null) {
      _logger.warning('PrayerNotifier refreshTimes failed: ${failure.message}');
      state = state.copyWith(isLoading: false, errorMessage: failure.message);
      return;
    }

    state = state.copyWith(
      isLoading: false,
      prayerDay: prayerDay,
    );
  }

  Future<void> selectCalculationMethod(String methodId) async {
    await _updateCalculationMethod.execute(methodId);
    state = state.copyWith(selectedCalculationMethodId: methodId);
    _logger.debug('Calculation method updated to: $methodId');
  }

  Future<void> selectMadhab(String madhabId) async {
    await _updateMadhab.execute(madhabId);
    state = state.copyWith(selectedMadhabId: madhabId);
    _logger.debug('Madhab updated to: $madhabId');
  }
}
