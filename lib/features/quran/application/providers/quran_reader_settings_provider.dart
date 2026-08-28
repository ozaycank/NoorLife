import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/di/injection_container.dart';
import '../../domain/entities/quran_reader_config.dart';
import '../../domain/entities/quran_reader_settings.dart';
import '../../domain/errors/quran_failure.dart';
import '../../domain/repositories/quran_reader_settings_repository.dart';
import '../states/quran_reader_settings_state.dart';

final quranReaderSettingsNotifierProvider =
    NotifierProvider<QuranReaderSettingsNotifier, QuranReaderSettingsState>(
  QuranReaderSettingsNotifier.new,
);

class QuranReaderSettingsNotifier extends Notifier<QuranReaderSettingsState> {
  late final QuranReaderSettingsRepository _repository;
  Timer? _debounceTimer;

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
      state = state.copyWith(
        isLoading: false,
        failure: QuranFailure('Settings load failed: $e', code: 'loadError'),
      );
    }
  }

  Future<void> increaseFontSize() async {
    final newSize =
        state.settings.arabicFontSize + QuranReaderConfig.arabicFontSizeStep;
    if (newSize > QuranReaderConfig.maxArabicFontSize) return;

    final newSettings = state.settings.copyWith(arabicFontSize: newSize);
    state = state.copyWith(settings: newSettings, failure: null);

    _persistSettingsDebounced(newSettings);
  }

  Future<void> decreaseFontSize() async {
    final newSize =
        state.settings.arabicFontSize - QuranReaderConfig.arabicFontSizeStep;
    if (newSize < QuranReaderConfig.minArabicFontSize) return;

    final newSettings = state.settings.copyWith(arabicFontSize: newSize);
    state = state.copyWith(settings: newSettings, failure: null);

    _persistSettingsDebounced(newSettings);
  }

  Future<void> resetSettings() async {
    _debounceTimer?.cancel();
    state = state.copyWith(
      settings: QuranReaderSettings.initial(),
      failure: null,
    );

    try {
      await _repository.resetSettings();
    } catch (e) {
      state = state.copyWith(
        failure: QuranFailure('Settings reset failed: $e', code: 'resetError'),
      );
    }
  }

  void _persistSettingsDebounced(QuranReaderSettings newSettings) {
    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();

    _debounceTimer = Timer(const Duration(milliseconds: 500), () async {
      try {
        await _repository.saveSettings(newSettings);
      } catch (e) {
        state = state.copyWith(
          failure: QuranFailure('Settings save failed: $e', code: 'saveError'),
        );
      }
    });
  }
}
