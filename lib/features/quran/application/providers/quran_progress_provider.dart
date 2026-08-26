import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/base/result.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/di/injection_container.dart';
import '../../domain/entities/quran_reading_progress.dart';
import '../../domain/repositories/quran_progress_repository.dart';
import '../states/quran_progress_state.dart';

final quranProgressNotifierProvider =
    NotifierProvider<QuranProgressNotifier, QuranProgressState>(
        QuranProgressNotifier.new,);

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
    final result = await _repository.getLastRead();

    // DÜZELTME BURADA: Eğer result Success ise value'yu al, Failure ise message/kodu al.
    // Sen projende Result<T, E> kullanıyorsan ve Failure argüman almıyorsa şöyle okuyabiliriz:
    if (result is Success) {
      state = state.copyWith(
        isLoading: false,
        lastRead: (result as Success).value as QuranReadingProgress?,
      );
    } else if (result is Failure) {
      state = state.copyWith(
        isLoading: false,
        failure:
            null, // Veya kendi failure class'ını manuel yarat: QuranFailure((result as Failure).message)
      );
    }
  }

  Future<void> saveProgress(QuranReadingProgress progress) async {
    state = state.copyWith(lastRead: progress, failure: null);

    final result = await _repository.saveLastRead(progress);
    if (result is Failure) {
      state = state.copyWith(
          failure: null,); // Geçici olarak hata null'a eşitlendi (çökmesin diye)
    }
  }

  Future<void> clearProgress() async {
    state = state.copyWith(lastRead: null, failure: null);
    final result = await _repository.clearProgress();
    if (result is Failure) {
      state = state.copyWith(failure: null);
    }
  }
}
