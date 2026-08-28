import '../../domain/entities/quran_reader_settings.dart';
import '../../domain/errors/quran_failure.dart';

class QuranReaderSettingsState {
  final bool isLoading;
  final QuranReaderSettings settings;
  final QuranFailure? failure;

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
    QuranFailure? failure,
  }) {
    return QuranReaderSettingsState(
      isLoading: isLoading ?? this.isLoading,
      settings: settings ?? this.settings,
      failure: failure,
    );
  }
}
