import '../../../../../core/base/result.dart';
import '../../../shared/domain/errors/prayer_failure.dart';
import '../entities/madhab.dart';
import '../entities/prayer_calculation_method.dart';

abstract class CalculationMethodRepository {
  Future<Result<List<PrayerCalculationMethod>, PrayerFailure>>
      getCalculationMethods();
  Future<Result<void, PrayerFailure>> updateCalculationMethod(String methodId);
  Future<Result<List<Madhab>, PrayerFailure>> getMadhabs();
  Future<Result<void, PrayerFailure>> updateMadhab(String madhabId);
}
