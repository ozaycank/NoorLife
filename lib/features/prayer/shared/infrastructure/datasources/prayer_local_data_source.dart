import '../../../calculation_methods/domain/entities/madhab.dart';
import '../../../calculation_methods/domain/entities/prayer_calculation_method.dart';
import '../../../location/domain/entities/prayer_location.dart';
import '../../../prayer_times/domain/calculators/high_latitude_strategy.dart';

abstract class PrayerLocalDataSource {
  Future<List<PrayerCalculationMethod>> getSupportedMethods();
  Future<void> saveSelectedCalculationMethod(String methodId);
  Future<String?> getSelectedCalculationMethodId();

  Future<List<Madhab>> getSupportedMadhabs();
  Future<void> saveSelectedMadhab(String madhabId);
  Future<String?> getSelectedMadhabId();

  Future<void> saveSelectedHighLatitudeStrategy(HighLatitudeStrategy strategy);
  Future<HighLatitudeStrategy> getSelectedHighLatitudeStrategy();

  Future<void> saveSelectedLocation(PrayerLocation location);
  Future<PrayerLocation?> getSelectedLocation();
}
