import 'package:injectable/injectable.dart';
import '../../domain/entities/surah.dart';
import '../../domain/repositories/quran_repository.dart';
import '../datasources/quran_local_data_source.dart';

@LazySingleton(as: QuranRepository)
class QuranRepositoryImpl implements QuranRepository {
  final QuranLocalDataSource _localDataSource;

  const QuranRepositoryImpl(this._localDataSource);

  @override
  Future<List<Surah>> getSurahs() async {
    final surahs = await _localDataSource.getSurahs();
    if (surahs.isEmpty) {
      throw Exception('Quran catalog is empty.');
    }
    return surahs;
  }

  @override
  Future<Surah> getSurahDetail(int surahNumber) async {
    if (surahNumber < 1 || surahNumber > 114) {
      throw Exception(
          'Invalid Surah number: $surahNumber. Must be between 1 and 114.',);
    }
    return await _localDataSource.getSurahDetail(surahNumber);
  }
}
