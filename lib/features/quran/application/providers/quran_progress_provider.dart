import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/di/injection_container.dart';
import '../../domain/entities/quran_reading_progress.dart';
import '../../domain/errors/quran_failure.dart';
import '../../domain/repositories/quran_progress_repository.dart';
import '../states/quran_progress_state.dart';

final quranProgressNotifierProvider =
    NotifierProvider<QuranProgressNotifier, QuranProgressState>(
  QuranProgressNotifier.new,
);

class QuranProgressNotifier extends Notifier<QuranProgressState> {
  late final QuranProgressRepository _repository;

  @override
  QuranProgressState build() {
    _repository = getIt<QuranProgressRepository>();
    Future.microtask(() => loadProgress());
    return QuranProgressState.initial();
  }

  Future<void> loadProgress() async {
    state = state.copyWith(isLoading: true, failure: null);
    try {
      final progress = await _repository.getLastRead();
      state = state.copyWith(
        isLoading: false,
        lastRead: progress,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        failure:
            QuranFailure('Failed to load progress: $e', code: 'readFailed'),
      );
    }
  }

  Future<void> saveProgress(QuranReadingProgress progress) async {
    state = state.copyWith(lastRead: progress, failure: null);
    try {
      await _repository.saveLastRead(progress);
    } catch (e) {
      state = state.copyWith(
        failure:
            QuranFailure('Failed to save progress: $e', code: 'writeFailed'),
      );
    }
  }

  Future<void> clearProgress() async {
    state = state.copyWith(lastRead: null, failure: null);
    try {
      await _repository.clearProgress();
    } catch (e) {
      state = state.copyWith(
        failure:
            QuranFailure('Failed to clear progress: $e', code: 'clearFailed'),
      );
    }
  }
}
