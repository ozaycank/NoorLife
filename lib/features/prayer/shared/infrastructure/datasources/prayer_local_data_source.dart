import '../../../calculation_methods/domain/entities/madhab.dart';
import '../../../calculation_methods/domain/entities/prayer_calculation_method.dart';

abstract class PrayerLocalDataSource {
  Future<List<PrayerCalculationMethod>> getSupportedMethods();
  Future<void> saveSelectedCalculationMethod(String methodId);
  Future<String> getSelectedCalculationMethodId();

  Future<List<Madhab>> getSupportedMadhabs();
  Future<void> saveSelectedMadhab(String madhabId);
  Future<String> getSelectedMadhabId();
}
