import 'dart:convert';
import 'package:injectable/injectable.dart';
import '../../../../core/storage/secure_storage_service.dart';
import '../../domain/entities/quran_reading_progress.dart';

abstract class QuranProgressLocalDataSource {
  Future<QuranReadingProgress?> getLastRead();
  Future<void> saveLastRead(QuranReadingProgress progress);
  Future<void> clearProgress();
}

@LazySingleton(as: QuranProgressLocalDataSource)
class QuranProgressLocalDataSourceImpl implements QuranProgressLocalDataSource {
  final SecureStorageService _secureStorage;
  static const String _storageKey = 'quran_last_read';

  const QuranProgressLocalDataSourceImpl(this._secureStorage);

  @override
  Future<QuranReadingProgress?> getLastRead() async {
    try {
      final jsonString = await _secureStorage.read(key: _storageKey);
      if (jsonString == null) return null;

      final Map<String, dynamic> jsonMap = json.decode(jsonString);
      return QuranReadingProgress.fromJson(jsonMap);
    } catch (_) {
      return null; // Safe discard
    }
  }

  @override
  Future<void> saveLastRead(QuranReadingProgress progress) async {
    final jsonString = json.encode(progress.toJson());
    await _secureStorage.write(key: _storageKey, value: jsonString);
  }

  @override
  Future<void> clearProgress() async {
    await _secureStorage.delete(key: _storageKey);
  }
}
