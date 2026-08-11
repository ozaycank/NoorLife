import 'package:injectable/injectable.dart';
import '../../../calculation_methods/domain/entities/madhab.dart';
import '../../../calculation_methods/domain/entities/prayer_calculation_method.dart';
import 'prayer_local_data_source.dart';

@LazySingleton(as: PrayerLocalDataSource)
class PrayerInMemoryDataSource implements PrayerLocalDataSource {
  String _selectedMethodId = 'diyar_turk';
  String _selectedMadhabId = 'shafi_hanbali_maliki';

  @override
  Future<List<PrayerCalculationMethod>> getSupportedMethods() async {
    return const [
      PrayerCalculationMethod(
        id: 'diyar_turk',
        name: 'Diyanet Approximation Profile',
        description: 'Approximation using 18°/17° angles.',
      ),
      PrayerCalculationMethod(
        id: 'mwl',
        name: 'Muslim World League',
        description: 'Standard method widely used across Europe and Asia.',
      ),
      PrayerCalculationMethod(
        id: 'isna',
        name: 'Islamic Society of North America',
        description: 'Standard method for North America.',
      ),
      PrayerCalculationMethod(
        id: 'egypt',
        name: 'Egyptian General Authority',
        description: 'Standard method in Africa and Middle East.',
      ),
      PrayerCalculationMethod(
        id: 'makkah',
        name: 'Umm Al-Qura',
        description: 'Standard method in Arabian Peninsula.',
      ),
    ];
  }

  @override
  Future<void> saveSelectedCalculationMethod(String methodId) async {
    _selectedMethodId = methodId;
  }

  @override
  Future<String> getSelectedCalculationMethodId() async {
    return _selectedMethodId;
  }

  @override
  Future<List<Madhab>> getSupportedMadhabs() async {
    return const [
      Madhab(
          id: 'shafi_hanbali_maliki',
          name: 'Standard (Shafi, Maliki, Hanbali)',),
      Madhab(id: 'hanafi', name: 'Hanafi'),
    ];
  }

  @override
  Future<void> saveSelectedMadhab(String madhabId) async {
    _selectedMadhabId = madhabId;
  }

  @override
  Future<String> getSelectedMadhabId() async {
    return _selectedMadhabId;
  }
}
