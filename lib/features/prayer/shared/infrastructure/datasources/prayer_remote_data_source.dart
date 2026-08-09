import '../../../calculation_methods/domain/entities/madhab.dart';
import '../../../calculation_methods/domain/entities/prayer_calculation_method.dart';
import '../../../location/domain/entities/prayer_location.dart';
import '../../../prayer_times/domain/entities/prayer_day.dart';

abstract class PrayerRemoteDataSource {
  Future<PrayerDay> fetchPrayerTimes(PrayerLocation location);
  Future<List<PrayerCalculationMethod>> fetchCalculationMethods();
  Future<List<Madhab>> fetchMadhabs();
}
