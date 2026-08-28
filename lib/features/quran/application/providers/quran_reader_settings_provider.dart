import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/di/injection_container.dart';
import '../../presentation/constants/quran_reader_typography.dart';
import '../../domain/repositories/quran_reader_settings_repository.dart';
import '../states/quran_reader_settings_state.dart';

final quranReaderSettingsNotifierProvider =
    NotifierProvider<QuranReaderSettingsNotifier, QuranReaderSettingsState>(
        QuranReaderSettingsNotifier.new,);

class QuranReaderSettingsNotifier extends Notifier<QuranReaderSettingsState> {
  late final QuranReaderSettingsRepository _repository;

  @override
  QuranReaderSettingsState build() {
    _repository = getIt<QuranReaderSettingsRepository>();
    Future.microtask(() => loadSettings());
    return QuranReaderSettingsState.initial();
  }

  Future<void> loadSettings() async {
    state = state.copyWith(isLoading: true, failure: null);
    try {
      final settings = await _repository.getSettings();
      state = state.copyWith(isLoading: false, settings: settings);
    } catch (e) {
      state = state.copyWith(isLoading: false, failure: e.toString());
    }
  }

  Future<void> increaseFontSize() async {
    final newSize = state.settings.arabicFontSize +
        QuranReaderTypography.arabicFontSizeStep;
    if (newSize > QuranReaderTypography.maxArabicFontSize) return;

    final newSettings = state.settings.copyWith(arabicFontSize: newSize);
    state = state.copyWith(settings: newSettings);

    _persistSettings(newSettings);
  }

  Future<void> decreaseFontSize() async {
    final newSize = state.settings.arabicFontSize -
        QuranReaderTypography.arabicFontSizeStep;
    if (newSize < QuranReaderTypography.minArabicFontSize) return;

    final newSettings = state.settings.copyWith(arabicFontSize: newSize);
    state = state.copyWith(settings: newSettings);

    _persistSettings(newSettings);
  }

  Future<void> resetSettings() async {
    try {
      await _repository.resetSettings();
      state =
          state.copyWith(settings: QuranReaderSettingsState.initial().settings);
    } catch (e) {
      state = state.copyWith(failure: e.toString());
    }
  }

  Future<void> _persistSettings(newSettings) async {
    try {
      await _repository.saveSettings(newSettings);
    } catch (e) {
      state = state.copyWith(failure: e.toString());
    }
  }
}
