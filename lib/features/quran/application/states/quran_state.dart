import '../../domain/entities/surah.dart';
import '../../domain/errors/quran_failure.dart';

class QuranState {
  final bool isLoading;
  final List<Surah> surahs;
  final String searchQuery;
  final QuranFailure? failure;

  const QuranState({
    required this.isLoading,
    required this.surahs,
    required this.searchQuery,
    this.failure,
  });

  factory QuranState.initial() => const QuranState(
        isLoading: true,
        surahs: [],
        searchQuery: '',
      );

  QuranState copyWith({
    bool? isLoading,
    List<Surah>? surahs,
    String? searchQuery,
    QuranFailure? failure,
  }) {
    return QuranState(
      isLoading: isLoading ?? this.isLoading,
      surahs: surahs ?? this.surahs,
      searchQuery: searchQuery ?? this.searchQuery,
      failure: failure,
    );
  }
}
