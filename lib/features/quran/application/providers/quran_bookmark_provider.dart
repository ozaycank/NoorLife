import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/di/injection_container.dart';
import '../../domain/entities/quran_bookmark.dart';
import '../../domain/repositories/quran_bookmark_repository.dart';
import '../states/quran_bookmark_state.dart';

final quranBookmarkNotifierProvider =
    NotifierProvider<QuranBookmarkNotifier, QuranBookmarkState>(
  QuranBookmarkNotifier.new,
);

class QuranBookmarkNotifier extends Notifier<QuranBookmarkState> {
  late final QuranBookmarkRepository _repository;

  @override
  QuranBookmarkState build() {
    _repository = getIt<QuranBookmarkRepository>();
    Future.microtask(() => loadBookmarks());
    return QuranBookmarkState.initial();
  }

  Future<void> loadBookmarks() async {
    state = state.copyWith(isLoading: true, failure: null);
    try {
      final items = await _repository.getBookmarks();
      // Sort newest first naturally
      items.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      state = state.copyWith(isLoading: false, bookmarks: items);
    } catch (e) {
      state = state.copyWith(isLoading: false, failure: e.toString());
    }
  }

  Future<void> toggleBookmark({
    required int surahNumber,
    required int ayahNumber,
  }) async {
    final currentList = List<QuranBookmark>.from(state.bookmarks);

    final existingIndex = currentList.indexWhere(
      (b) => b.surahNumber == surahNumber && b.ayahNumber == ayahNumber,
    );

    if (existingIndex != -1) {
      // Remove it
      currentList.removeAt(existingIndex);
    } else {
      // Add it
      currentList.insert(
        0,
        QuranBookmark(
          surahNumber: surahNumber,
          ayahNumber: ayahNumber,
          createdAt: DateTime.now(),
        ),
      );
    }

    // Optimistic UI update
    state = state.copyWith(bookmarks: currentList);

    try {
      await _repository.saveBookmarks(currentList);
    } catch (e) {
      // Revert on failure
      loadBookmarks();
    }
  }
}
