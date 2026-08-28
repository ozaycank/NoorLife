import 'dart:convert';
import 'package:injectable/injectable.dart';
import '../../../../core/storage/secure_storage_service.dart';
import '../../domain/entities/quran_reader_settings.dart';

abstract class QuranReaderSettingsLocalDataSource {
  Future<QuranReaderSettings> getSettings();
  Future<void> saveSettings(QuranReaderSettings settings);
  Future<void> resetSettings();
}

@LazySingleton(as: QuranReaderSettingsLocalDataSource)
class QuranReaderSettingsLocalDataSourceImpl
    implements QuranReaderSettingsLocalDataSource {
  final SecureStorageService _secureStorage;
  static const String _storageKey = 'quran_reader_settings';

  const QuranReaderSettingsLocalDataSourceImpl(this._secureStorage);

  @override
  Future<QuranReaderSettings> getSettings() async {
    try {
      final jsonString = await _secureStorage.read(key: _storageKey);
      if (jsonString == null) return QuranReaderSettings.initial();

      final Map<String, dynamic> jsonMap = json.decode(jsonString);
      return QuranReaderSettings.fromJson(jsonMap);
    } catch (_) {
      return QuranReaderSettings.initial();
    }
  }

  @override
  Future<void> saveSettings(QuranReaderSettings settings) async {
    final jsonString = json.encode(settings.toJson());
    await _secureStorage.write(key: _storageKey, value: jsonString);
  }

  @override
  Future<void> resetSettings() async {
    await _secureStorage.delete(key: _storageKey);
  }
}
