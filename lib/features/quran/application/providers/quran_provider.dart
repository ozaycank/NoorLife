import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/di/injection_container.dart';
import '../../domain/entities/surah.dart';
import '../../domain/errors/quran_failure.dart';
import '../../domain/repositories/quran_repository.dart';
import '../states/quran_state.dart';

final quranNotifierProvider =
    NotifierProvider<QuranNotifier, QuranState>(QuranNotifier.new);

class QuranNotifier extends Notifier<QuranState> {
  late final QuranRepository _repository;
  List<Surah> _allSurahs = [];

  @override
  QuranState build() {
    _repository = getIt<QuranRepository>();
    _loadSurahs();
    return QuranState.initial();
  }

  Future<void> _loadSurahs() async {
    state = state.copyWith(isLoading: true, failure: null);
    try {
      final surahs = await _repository.getSurahs();
      _allSurahs = surahs;
      state = state.copyWith(
        isLoading: false,
        surahs: _allSurahs,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        failure: QuranFailure(e.toString(), code: 'quranDataParseFailed'),
      );
    }
  }

  void searchSurahs(String query) {
    final queryLower = query.toLowerCase().trim();
    if (queryLower.isEmpty) {
      state = state.copyWith(surahs: _allSurahs, searchQuery: query);
      return;
    }

    final filtered = _allSurahs.where((surah) {
      return surah.number.toString() == queryLower ||
          surah.nameTransliteration.toLowerCase().contains(queryLower) ||
          surah.nameEnglish.toLowerCase().contains(queryLower) ||
          surah.nameTurkish.toLowerCase().contains(queryLower) ||
          surah.nameArabic.contains(queryLower);
    }).toList();

    state = state.copyWith(surahs: filtered, searchQuery: query);
  }
}
