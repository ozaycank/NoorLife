import '../entities/quran_reader_settings.dart';

abstract class QuranReaderSettingsRepository {
  Future<QuranReaderSettings> getSettings();
  Future<void> saveSettings(QuranReaderSettings settings);
  Future<void> resetSettings();
}