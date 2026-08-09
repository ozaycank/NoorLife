import '../../../calculation_methods/domain/entities/madhab.dart';
import '../../../calculation_methods/domain/entities/prayer_calculation_method.dart';
import '../../../location/domain/entities/prayer_location.dart';
import '../../../prayer_times/domain/entities/prayer_day.dart';

abstract class PrayerLocalDataSource {
  Future<PrayerDay?> getCachedPrayerTimes(PrayerLocation location);
  Future<void> cachePrayerTimes(PrayerLocation location, PrayerDay day);
  Future<List<PrayerCalculationMethod>> getCalculationMethods();
  Future<void> saveSelectedCalculationMethod(String methodId);
  Future<List<Madhab>> getMadhabs();
  Future<void> saveSelectedMadhab(String madhabId);
}
