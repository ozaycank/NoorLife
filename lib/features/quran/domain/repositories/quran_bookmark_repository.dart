import '../entities/quran_bookmark.dart';

abstract class QuranBookmarkRepository {
  Future<List<QuranBookmark>> getBookmarks();
  Future<void> saveBookmarks(List<QuranBookmark> bookmarks);
}
