import '../../domain/entities/quran_bookmark.dart';

class QuranBookmarkState {
  final bool isLoading;
  final List<QuranBookmark> bookmarks;
  final String? failure;

  const QuranBookmarkState({
    required this.isLoading,
    this.bookmarks = const [],
    this.failure,
  });

  factory QuranBookmarkState.initial() => const QuranBookmarkState(
        isLoading: true,
      );

  QuranBookmarkState copyWith({
    bool? isLoading,
    List<QuranBookmark>? bookmarks,
    String? failure,
  }) {
    return QuranBookmarkState(
      isLoading: isLoading ?? this.isLoading,
      bookmarks: bookmarks ?? this.bookmarks,
      failure: failure,
    );
  }
}
