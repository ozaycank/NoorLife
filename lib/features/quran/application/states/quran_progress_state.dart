import '../../domain/entities/quran_reading_progress.dart';
import '../../domain/errors/quran_failure.dart';

class QuranProgressState {
  final bool isLoading;
  final QuranReadingProgress? lastRead;
  final QuranFailure? failure;

  const QuranProgressState({
    required this.isLoading,
    this.lastRead,
    this.failure,
  });

  factory QuranProgressState.initial() => const QuranProgressState(
        isLoading: true,
      );

  QuranProgressState copyWith({
    bool? isLoading,
    QuranReadingProgress? lastRead,
    QuranFailure? failure,
  }) {
    return QuranProgressState(
      isLoading: isLoading ?? this.isLoading,
      lastRead: lastRead ?? this.lastRead,
      failure: failure,
    );
  }
}
