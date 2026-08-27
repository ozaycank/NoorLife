import 'package:injectable/injectable.dart';
import '../../domain/entities/quran_bookmark.dart';
import '../../domain/repositories/quran_bookmark_repository.dart';
import '../datasources/quran_bookmark_local_data_source.dart';

@LazySingleton(as: QuranBookmarkRepository)
class QuranBookmarkRepositoryImpl implements QuranBookmarkRepository {
  final QuranBookmarkLocalDataSource _localDataSource;

  const QuranBookmarkRepositoryImpl(this._localDataSource);

  @override
  Future<List<QuranBookmark>> getBookmarks() async {
    try {
      return await _localDataSource.getBookmarks();
    } catch (e) {
      throw Exception('Failed to load bookmarks');
    }
  }

  @override
  Future<void> saveBookmarks(List<QuranBookmark> bookmarks) async {
    try {
      await _localDataSource.saveBookmarks(bookmarks);
    } catch (e) {
      throw Exception('Failed to save bookmarks');
    }
  }
}
