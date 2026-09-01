import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/base/result.dart';
import '../domain/activity_models.dart';
import '../../../core/di/injection_container.dart';
import '../../prayer/prayer_times/domain/value_objects/prayer_name.dart';
import '../../quran/application/providers/quran_progress_provider.dart';

// Utility for normalized local date strings
String _getNormalizedToday() {
  return DateFormat('yyyy-MM-dd').format(DateTime.now());
}

class ActivityState {
  final bool isLoading;
  final DailyActivity? dailyActivity;
  final ActivityFailure? failure;

  const ActivityState({
    this.isLoading = false,
    this.dailyActivity,
    this.failure,
  });

  ActivityState copyWith({
    bool? isLoading,
    DailyActivity? dailyActivity,
    ActivityFailure? failure,
  }) {
    return ActivityState(
      isLoading: isLoading ?? this.isLoading,
      dailyActivity: dailyActivity ?? this.dailyActivity,
      failure: failure ?? this.failure,
    );
  }
}

class ActivityNotifier extends StateNotifier<ActivityState> {
  final ActivityRepository _repository;
  String _currentDate;

  ActivityNotifier(this._repository)
      : _currentDate = _getNormalizedToday(),
        super(const ActivityState()) {
    loadDate(_currentDate);
  }

  Future<void> loadToday() async {
    await loadDate(_getNormalizedToday());
  }

  Future<void> loadDate(String date) async {
    state = state.copyWith(isLoading: true, failure: null);
    _currentDate = date;

    final result = await _repository.getDailyActivity(date);

    switch (result) {
      case Success(value: final activity):
        state = state.copyWith(isLoading: false, dailyActivity: activity);
      case ResultFailure(failure: final err):
        // FIX: Removed unnecessary type check because 'err' is already typed as ActivityFailure
        state = state.copyWith(
          isLoading: false,
          failure: err,
        );
    }
  }

  Future<void> togglePrayer(PrayerName prayer) async {
    if (state.dailyActivity == null) return;

    final currentActivity = state.dailyActivity!;
    final currentStatus = currentActivity.completedPrayers[prayer] ?? false;

    final newPrayers =
        Map<PrayerName, bool>.from(currentActivity.completedPrayers);
    newPrayers[prayer] = !currentStatus;

    final newActivity = currentActivity.copyWith(completedPrayers: newPrayers);

    // Optimistic UI update
    state = state.copyWith(dailyActivity: newActivity);

    final result = await _repository.saveDailyActivity(newActivity);

    // FIX: Using switch pattern matching to safely extract failure without raw getter errors
    switch (result) {
      case Success():
        // Success case requires no action since UI was optimistically updated
        break;
      case ResultFailure(failure: final err):
        // Revert state and show failure
        state = state.copyWith(
          dailyActivity: currentActivity,
          failure: err,
        );
    }
  }

  Future<void> markQuranRead() async {
    if (state.dailyActivity == null) return;
    final currentActivity = state.dailyActivity!;

    if (currentActivity.quranReadingOccurred) return;

    final newActivity = currentActivity.copyWith(quranReadingOccurred: true);
    state = state.copyWith(dailyActivity: newActivity);

    final result = await _repository.saveDailyActivity(newActivity);

    // FIX: Using switch pattern matching to safely extract failure without raw getter errors
    switch (result) {
      case Success():
        break;
      case ResultFailure(failure: final err):
        // Revert state and show failure
        state = state.copyWith(
          dailyActivity: currentActivity,
          failure: err,
        );
    }
  }
}

final activityNotifierProvider =
    StateNotifierProvider<ActivityNotifier, ActivityState>((ref) {
  return ActivityNotifier(getIt<ActivityRepository>());
});

final quranActivityBridgeProvider = Provider<void>((ref) {
  ref.listen(quranProgressNotifierProvider, (previous, next) {
    if (next.lastRead != null && previous?.lastRead != next.lastRead) {
      ref.read(activityNotifierProvider.notifier).markQuranRead();
    }
  });
});
