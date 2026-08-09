import '../../../../../core/errors/failure.dart';
import '../../../calculation_methods/domain/entities/madhab.dart';
import '../../../calculation_methods/domain/entities/prayer_calculation_method.dart';
import '../../../location/domain/entities/prayer_location.dart';
import '../../../prayer_times/domain/entities/prayer_day.dart';

abstract class PrayerRepository {
  Future<(Failure?, PrayerDay?)> getPrayerTimes(PrayerLocation location);
  Future<(Failure?, PrayerDay?)> refreshPrayerTimes(PrayerLocation location);
  Future<(Failure?, List<PrayerCalculationMethod>?)> getCalculationMethods();
  Future<(Failure?, void)> updateCalculationMethod(String methodId);
  Future<(Failure?, List<Madhab>?)> getMadhabs();
  Future<(Failure?, void)> updateMadhab(String madhabId);
  Future<(Failure?, PrayerLocation?)> getCurrentLocation();
}
