import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/base/result.dart';
import '../domain/activity_models.dart';
import '../domain/activity_prayer_type.dart';
import '../../../core/di/injection_container.dart';
import '../../quran/application/providers/quran_progress_provider.dart';
import '../utils/activity_date_utils.dart';

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
    bool clearFailure = false, // Explicit clearing
  }) {
    return ActivityState(
      isLoading: isLoading ?? this.isLoading,
      dailyActivity: dailyActivity ?? this.dailyActivity,
      failure: clearFailure ? null : (failure ?? this.failure),
    );
  }
}

class ActivityNotifier extends StateNotifier<ActivityState> {
  final ActivityRepository _repository;
  String _currentDate;

  // Prevents overlapping rapid saves (Race Condition Protection)
  bool _isSaving = false;

  ActivityNotifier(this._repository)
      : _currentDate = ActivityDateUtils.today(),
        super(const ActivityState()) {
    loadDate(_currentDate);
  }

  Future<void> loadToday() async {
    await loadDate(ActivityDateUtils.today());
  }

  Future<void> loadDate(String date) async {
    state = state.copyWith(isLoading: true, clearFailure: true);
    _currentDate = date;

    final result = await _repository.getDailyActivity(date);

    switch (result) {
      case Success(value: final activity):
        state = state.copyWith(isLoading: false, dailyActivity: activity);
      case ResultFailure(failure: final err):
        state = state.copyWith(
          isLoading: false,
          // FIX: Removed unnecessary type check since err is already ActivityFailure
          failure: err,
        );
    }
  }

  Future<void> togglePrayer(ActivityPrayerType prayer) async {
    if (state.dailyActivity == null || _isSaving) return;
    _isSaving = true;

    final currentActivity = state.dailyActivity!;
    final currentStatus = currentActivity.completedPrayers[prayer] ?? false;

    final newPrayers =
        Map<ActivityPrayerType, bool>.from(currentActivity.completedPrayers);
    newPrayers[prayer] = !currentStatus;

    final newActivity = currentActivity.copyWith(completedPrayers: newPrayers);

    // Optimistic UI update
    state = state.copyWith(dailyActivity: newActivity, clearFailure: true);

    final result = await _repository.saveDailyActivity(newActivity);

    switch (result) {
      case Success():
        break;
      case ResultFailure(failure: final err):
        // Revert UI on failure
        state = state.copyWith(
          dailyActivity: currentActivity,
          // FIX: Removed unnecessary type check
          failure: err,
        );
    }
    _isSaving = false;
  }

  Future<void> markQuranRead() async {
    if (state.dailyActivity == null || _isSaving) return;
    final currentActivity = state.dailyActivity!;

    if (currentActivity.quranReadingOccurred) return;

    _isSaving = true;

    final newActivity = currentActivity.copyWith(quranReadingOccurred: true);
    state = state.copyWith(dailyActivity: newActivity, clearFailure: true);

    final result = await _repository.saveDailyActivity(newActivity);

    switch (result) {
      case Success():
        break;
      case ResultFailure(failure: final err):
        state = state.copyWith(
          dailyActivity: currentActivity,
          // FIX: Removed unnecessary type check
          failure: err,
        );
    }
    _isSaving = false;
  }
}

final activityNotifierProvider =
    StateNotifierProvider<ActivityNotifier, ActivityState>((ref) {
  return ActivityNotifier(getIt<ActivityRepository>());
});

final quranActivityBridgeProvider = Provider<void>((ref) {
  ref.listen(quranProgressNotifierProvider, (previous, next) {
    if (next.lastRead != null) {
      final isInitialLoad = previous?.lastRead == null;
      final ayahAdvanced =
          previous?.lastRead?.ayahNumber != next.lastRead?.ayahNumber;
      final surahAdvanced =
          previous?.lastRead?.surahNumber != next.lastRead?.surahNumber;

      if (!isInitialLoad && (ayahAdvanced || surahAdvanced)) {
        ref.read(activityNotifierProvider.notifier).markQuranRead();
      }
    }
  });
});
