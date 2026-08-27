import 'dart:convert';
import 'package:injectable/injectable.dart';
import '../../../../core/storage/secure_storage_service.dart';
import '../../domain/entities/quran_bookmark.dart';

abstract class QuranBookmarkLocalDataSource {
  Future<List<QuranBookmark>> getBookmarks();
  Future<void> saveBookmarks(List<QuranBookmark> bookmarks);
}

@LazySingleton(as: QuranBookmarkLocalDataSource)
class QuranBookmarkLocalDataSourceImpl implements QuranBookmarkLocalDataSource {
  final SecureStorageService _secureStorage;
  static const String _storageKey = 'quran_bookmarks';

  const QuranBookmarkLocalDataSourceImpl(this._secureStorage);

  @override
  Future<List<QuranBookmark>> getBookmarks() async {
    try {
      final jsonString = await _secureStorage.read(key: _storageKey);
      if (jsonString == null) return [];

      final List<dynamic> jsonList = json.decode(jsonString);
      final bookmarks = <QuranBookmark>[];

      for (var item in jsonList) {
        try {
          bookmarks.add(QuranBookmark.fromJson(item));
        } catch (_) {
          // Skip invalid entries safely
        }
      }
      return bookmarks;
    } catch (_) {
      return [];
    }
  }

  @override
  Future<void> saveBookmarks(List<QuranBookmark> bookmarks) async {
    final jsonString = json.encode(bookmarks.map((e) => e.toJson()).toList());
    await _secureStorage.write(key: _storageKey, value: jsonString);
  }
}
