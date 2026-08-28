import 'package:injectable/injectable.dart';
import '../../domain/entities/quran_translation.dart';
import '../../domain/repositories/quran_translation_repository.dart';
import '../datasources/quran_translation_local_data_source.dart';

@LazySingleton(as: QuranTranslationRepository)
class QuranTranslationRepositoryImpl implements QuranTranslationRepository {
  final QuranTranslationLocalDataSource _localDataSource;

  const QuranTranslationRepositoryImpl(this._localDataSource);

  @override
  Future<List<QuranTranslation>> getTranslationsForSurah(
    int surahNumber,
  ) async {
    try {
      return await _localDataSource.getTranslationsForSurah(surahNumber);
    } catch (e) {
      throw Exception('Failed to load translations: $e');
    }
  }
}
