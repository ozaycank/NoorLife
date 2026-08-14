import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timezone/timezone.dart' as tz;
import '../../../../../core/base/result.dart';
import '../../../../../core/di/injection_container.dart';
import '../../../../../core/logging/logger_extensions.dart';
import '../../../../../core/logging/logger_service.dart';
import '../../../../../core/providers/default_location_provider.dart';
import '../../../location/domain/entities/prayer_location.dart';
import '../../../shared/infrastructure/datasources/prayer_local_data_source.dart';
import '../services/prayer_orchestrator_service.dart';
import '../states/prayer_times_state.dart';

final prayerTimesNotifierProvider =
    NotifierProvider<PrayerTimesNotifier, PrayerTimesState>(
  PrayerTimesNotifier.new,
);

class PrayerTimesNotifier extends Notifier<PrayerTimesState> {
  late final PrayerOrchestratorService _orchestrator;
  late final PrayerLocalDataSource _localDataSource;
  late final LoggerService _logger;

  @override
  PrayerTimesState build() {
    _orchestrator = getIt<PrayerOrchestratorService>();
    _localDataSource = getIt<PrayerLocalDataSource>();
    _logger = getIt<LoggerService>();
    Future.microtask(() => loadTimes());
    return const PrayerTimesState.initial();
  }

  Future<void> loadTimes() async {
    state = state.copyWith(
      isLoading: true,
      failure: () => null,
    );

    final PrayerLocation loc = await _localDataSource.getSelectedLocation() ??
        ref.read(defaultLocationProvider);

    tz.Location targetTz;
    try {
      targetTz = tz.getLocation(loc.timezoneIdentifier);
    } catch (_) {
      targetTz = tz.UTC;
    }

    final nowLocal = DateTime.now();
    final targetNow = tz.TZDateTime.from(nowLocal, targetTz);

    // Normalize target date to midnight to represent pure target calendar date.
    final targetCalendarDate = DateTime.utc(
      targetNow.year,
      targetNow.month,
      targetNow.day,
    );

    final result = await _orchestrator.getSchedule(loc, targetCalendarDate);

    switch (result) {
      case Success(value: final data):
        _logger.logPrayer('Prayer schedule loaded successfully.');
        state = state.copyWith(
          isLoading: false,
          failure: () => null,
          schedule: () => data,
          location: () => loc,
        );
      case ResultFailure(failure: final f):
        _logger.logPrayer('Failed to load prayer schedule: ${f.message}');
        state = state.copyWith(
          isLoading: false,
          failure: () => f,
        );
    }
  }

  Future<void> refreshTimes() async {
    await loadTimes();
  }
}
