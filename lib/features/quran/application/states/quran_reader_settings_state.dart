import '../../domain/entities/quran_reader_settings.dart';

class QuranReaderSettingsState {
  final bool isLoading;
  final QuranReaderSettings settings;
  final String? failure;

  const QuranReaderSettingsState({
    required this.isLoading,
    required this.settings,
    this.failure,
  });

  factory QuranReaderSettingsState.initial() => QuranReaderSettingsState(
        isLoading: true,
        settings: QuranReaderSettings.initial(),
      );

  QuranReaderSettingsState copyWith({
    bool? isLoading,
    QuranReaderSettings? settings,
    String? failure,
  }) {
    return QuranReaderSettingsState(
      isLoading: isLoading ?? this.isLoading,
      settings: settings ?? this.settings,
      failure: failure,
    );
  }
}
