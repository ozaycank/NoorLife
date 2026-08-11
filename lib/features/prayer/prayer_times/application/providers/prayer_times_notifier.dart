import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/base/result.dart';
import '../../../../../core/di/injection_container.dart';
import '../../../../../core/logging/logger_extensions.dart';
import '../../../../../core/logging/logger_service.dart';
import '../../../../../core/providers/base_providers.dart';
import '../../../../../core/providers/default_location_provider.dart';
import '../../domain/repositories/prayer_times_repository.dart';
import 'prayer_times_state.dart';

final prayerTimesNotifierProvider =
    NotifierProvider<PrayerTimesNotifier, PrayerTimesState>(
  PrayerTimesNotifier.new,
);

class PrayerTimesNotifier extends Notifier<PrayerTimesState> {
  late final PrayerTimesRepository _repository;
  late final LoggerService _logger;

  @override
  PrayerTimesState build() {
    _repository = getIt<PrayerTimesRepository>();
    _logger = ref.watch(loggerProvider);
    Future.microtask(() => loadTimes());
    return const PrayerTimesState.initial();
  }

  Future<void> loadTimes() async {
    state = state.copyWith(isLoading: true, failure: null);
    final location = ref.read(defaultLocationProvider);

    final result = await _repository.getPrayerTimes(location, DateTime.now());

    switch (result) {
      case Success(value: final data):
        _logger.logPrayer('Prayer times loaded successfully.');
        state = state.copyWith(isLoading: false, prayerDay: data);
      case ResultFailure(failure: final f):
        _logger.logPrayer('Failed to load prayer times: ${f.message}');
        state = state.copyWith(isLoading: false, failure: f);
    }
  }

  Future<void> refreshTimes() async {
    state = state.copyWith(isLoading: true, failure: null);
    final location = ref.read(defaultLocationProvider);

    final result =
        await _repository.refreshPrayerTimes(location, DateTime.now());

    switch (result) {
      case Success(value: final data):
        _logger.logPrayer('Prayer times refreshed successfully.');
        state = state.copyWith(isLoading: false, prayerDay: data);
      case ResultFailure(failure: final f):
        _logger.logPrayer('Failed to refresh prayer times: ${f.message}');
        state = state.copyWith(isLoading: false, failure: f);
    }
  }
}
