import 'package:injectable/injectable.dart';
import '../../../../../core/base/result.dart';
import '../../../shared/domain/errors/prayer_failure.dart';
import '../../../shared/infrastructure/datasources/prayer_local_data_source.dart';
import '../../domain/entities/madhab.dart';
import '../../domain/entities/prayer_calculation_method.dart';
import '../../domain/repositories/calculation_method_repository.dart';

@LazySingleton(as: CalculationMethodRepository)
class CalculationMethodRepositoryImpl implements CalculationMethodRepository {
  final PrayerLocalDataSource _localDataSource;

  CalculationMethodRepositoryImpl(this._localDataSource);

  @override
  Future<Result<List<PrayerCalculationMethod>, PrayerFailure>>
      getCalculationMethods() async {
    try {
      final methods = await _localDataSource.getSupportedMethods();
      return Success(methods);
    } catch (e) {
      return ResultFailure(
        PrayerCalculationFailure('Failed to load calculation methods: $e'),
      );
    }
  }

  @override
  Future<Result<List<Madhab>, PrayerFailure>> getMadhabs() async {
    try {
      final madhabs = await _localDataSource.getSupportedMadhabs();
      return Success(madhabs);
    } catch (e) {
      return ResultFailure(
        PrayerCalculationFailure('Failed to load madhabs: $e'),
      );
    }
  }

  @override
  Future<Result<void, PrayerFailure>> updateCalculationMethod(
    String methodId,
  ) async {
    try {
      await _localDataSource.saveSelectedCalculationMethod(methodId);
      return const Success(null);
    } catch (e) {
      return ResultFailure(
        PrayerCalculationFailure('Failed to update calculation method: $e'),
      );
    }
  }

  @override
  Future<Result<void, PrayerFailure>> updateMadhab(String madhabId) async {
    try {
      await _localDataSource.saveSelectedMadhab(madhabId);
      return const Success(null);
    } catch (e) {
      return ResultFailure(
        PrayerCalculationFailure('Failed to update madhab: $e'),
      );
    }
  }
}
