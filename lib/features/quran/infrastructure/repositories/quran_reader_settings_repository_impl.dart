import 'package:injectable/injectable.dart';
import '../../domain/entities/quran_reader_settings.dart';
import '../../domain/repositories/quran_reader_settings_repository.dart';
import '../datasources/quran_reader_settings_local_data_source.dart';

@LazySingleton(as: QuranReaderSettingsRepository)
class QuranReaderSettingsRepositoryImpl
    implements QuranReaderSettingsRepository {
  final QuranReaderSettingsLocalDataSource _localDataSource;

  const QuranReaderSettingsRepositoryImpl(this._localDataSource);

  @override
  Future<QuranReaderSettings> getSettings() async {
    try {
      return await _localDataSource.getSettings();
    } catch (e) {
      throw Exception('Failed to load reader settings: $e');
    }
  }

  @override
  Future<void> saveSettings(QuranReaderSettings settings) async {
    try {
      await _localDataSource.saveSettings(settings);
    } catch (e) {
      throw Exception('Failed to save reader settings: $e');
    }
  }

  @override
  Future<void> resetSettings() async {
    try {
      await _localDataSource.resetSettings();
    } catch (e) {
      throw Exception('Failed to reset reader settings: $e');
    }
  }
}
