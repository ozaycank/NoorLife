import 'package:injectable/injectable.dart';
import '../../../calculation_methods/domain/entities/madhab.dart';
import '../../../calculation_methods/domain/entities/prayer_calculation_method.dart';
import '../../../calculation_methods/infrastructure/models/madhab_model.dart';
import '../../../calculation_methods/infrastructure/models/prayer_calculation_method_model.dart';
import '../../../location/domain/entities/prayer_location.dart';
import '../../../prayer_times/domain/value_objects/prayer_name.dart';
import '../../../prayer_times/infrastructure/models/prayer_day_model.dart';
import '../../../prayer_times/infrastructure/models/prayer_time_model.dart';
import 'prayer_local_data_source.dart';
import 'prayer_remote_data_source.dart';

@LazySingleton(as: PrayerRemoteDataSource)
@LazySingleton(as: PrayerLocalDataSource)
class PrayerDummyDataSource
    implements PrayerRemoteDataSource, PrayerLocalDataSource {
  @override
  Future<PrayerDayModel> fetchPrayerTimes(PrayerLocation location) async {
    await Future.delayed(const Duration(milliseconds: 600));
    return _buildMockPrayerDay();
  }

  @override
  Future<PrayerDayModel?> getCachedPrayerTimes(PrayerLocation location) async {
    return _buildMockPrayerDay();
  }

  @override
  Future<void> cachePrayerTimes(
    PrayerLocation location,
    dynamic day,
  ) async {}

  @override
  Future<List<PrayerCalculationMethodModel>> fetchCalculationMethods() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _getMockMethods();
  }

  @override
  Future<List<PrayerCalculationMethodModel>> getCalculationMethods() async {
    return _getMockMethods();
  }

  @override
  Future<void> saveSelectedCalculationMethod(String methodId) async {}

  @override
  Future<List<MadhabModel>> fetchMadhabs() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _getMockMadhabs();
  }

  @override
  Future<List<MadhabModel>> getMadhabs() async {
    return _getMockMadhabs();
  }

  @override
  Future<void> saveSelectedMadhab(String madhabId) async {}

  PrayerDayModel _buildMockPrayerDay() {
    return const PrayerDayModel(
      dateIso8601: '2026-08-07',
      hijriDateFormatted: '23 Safar 1448 AH',
      nextPrayerName: 'Asr',
      timeRemainingFormatted: '02h 15m',
      prayerTimes: [
        PrayerTimeModel(
          name: PrayerName.fajr,
          formattedTime: '04:35',
          isNext: false,
        ),
        PrayerTimeModel(
          name: PrayerName.sunrise,
          formattedTime: '06:05',
          isNext: false,
        ),
        PrayerTimeModel(
          name: PrayerName.dhuhr,
          formattedTime: '13:15',
          isNext: false,
        ),
        PrayerTimeModel(
          name: PrayerName.asr,
          formattedTime: '17:05',
          isNext: true,
        ),
        PrayerTimeModel(
          name: PrayerName.maghrib,
          formattedTime: '20:15',
          isNext: false,
        ),
        PrayerTimeModel(
          name: PrayerName.isha,
          formattedTime: '21:40',
          isNext: false,
        ),
      ],
    );
  }

  List<PrayerCalculationMethodModel> _getMockMethods() {
    return const [
      PrayerCalculationMethodModel(
        id: 'diyar_turk',
        name: 'Diyanet İşleri Başkanlığı (Turkey)',
        description: 'Official calculation method used in Türkiye and Balkans.',
      ),
      PrayerCalculationMethodModel(
        id: 'mwl',
        name: 'Muslim World League',
        description: 'Standard method widely used across Europe and Asia.',
      ),
      PrayerCalculationMethodModel(
        id: 'isna',
        name: 'Islamic Society of North America (ISNA)',
        description: 'Standard method for North America.',
      ),
      PrayerCalculationMethodModel(
        id: 'egypt',
        name: 'Egyptian General Authority of Survey',
        description: 'Standard method in Africa and Middle East.',
      ),
      PrayerCalculationMethodModel(
        id: 'makkah',
        name: 'Umm Al-Qura University, Makkah',
        description: 'Standard method in Arabian Peninsula.',
      ),
    ];
  }

  List<MadhabModel> _getMockMadhabs() {
    return const [
      MadhabModel(
        id: 'shafi_hanbali_maliki',
        name: 'Standard (Shafi, Maliki, Hanbali)',
      ),
      MadhabModel(
        id: 'hanafi',
        name: 'Hanafi',
      ),
    ];
  }
}
