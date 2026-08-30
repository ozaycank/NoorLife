import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import '../../../calculation_methods/domain/entities/madhab.dart';
import '../../../calculation_methods/domain/entities/prayer_calculation_method.dart';
import '../../../location/domain/entities/prayer_location.dart';
import '../../../location/infrastructure/models/prayer_location_model.dart';
import '../../../prayer_times/domain/calculators/high_latitude_strategy.dart';
import 'prayer_local_data_source.dart';

@LazySingleton(as: PrayerLocalDataSource)
class PrayerSecureStorageDataSource implements PrayerLocalDataSource {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  @override
  Future<List<PrayerCalculationMethod>> getSupportedMethods() async {
    // FIX: Removed hardcoded English strings. UI will map these ID's to localized Arb values.
    return const [
      PrayerCalculationMethod(
        id: 'diyar_turk',
        name: 'diyar_turk',
        description: 'desc_diyar_turk',
      ),
      PrayerCalculationMethod(
        id: 'mwl',
        name: 'mwl',
        description: 'desc_mwl',
      ),
      PrayerCalculationMethod(
        id: 'isna',
        name: 'isna',
        description: 'desc_isna',
      ),
      PrayerCalculationMethod(
        id: 'egypt',
        name: 'egypt',
        description: 'desc_egypt',
      ),
      PrayerCalculationMethod(
        id: 'makkah',
        name: 'makkah',
        description: 'desc_makkah',
      ),
    ];
  }

  @override
  Future<void> saveSelectedCalculationMethod(String methodId) async {
    await _storage.write(key: 'prayer_calc_method', value: methodId);
  }

  @override
  Future<String?> getSelectedCalculationMethodId() async {
    return await _storage.read(key: 'prayer_calc_method');
  }

  @override
  Future<List<Madhab>> getSupportedMadhabs() async {
    // FIX: Using standardized ID's for localization mapping.
    return const [
      Madhab(
        id: 'shafi_hanbali_maliki',
        name: 'shafi_hanbali_maliki',
      ),
      Madhab(id: 'hanafi', name: 'hanafi'),
    ];
  }

  @override
  Future<void> saveSelectedMadhab(String madhabId) async {
    await _storage.write(key: 'prayer_madhab', value: madhabId);
  }

  @override
  Future<String?> getSelectedMadhabId() async {
    return await _storage.read(key: 'prayer_madhab');
  }

  @override
  Future<void> saveSelectedHighLatitudeStrategy(
    HighLatitudeStrategy strategy,
  ) async {
    await _storage.write(key: 'high_lat_strategy', value: strategy.name);
  }

  @override
  Future<HighLatitudeStrategy> getSelectedHighLatitudeStrategy() async {
    final str = await _storage.read(key: 'high_lat_strategy');
    switch (str) {
      case 'oneSeventh':
        return HighLatitudeStrategy.oneSeventh;
      case 'nightMiddle':
        return HighLatitudeStrategy.nightMiddle;
      case 'none':
        return HighLatitudeStrategy.none;
      default:
        return HighLatitudeStrategy.angleBased;
    }
  }

  @override
  Future<void> saveSelectedLocation(PrayerLocation location) async {
    final model = PrayerLocationModel(
      latitude: location.latitude,
      longitude: location.longitude,
      cityName: location.cityName,
      countryName: location.countryName,
      timezoneIdentifier: location.timezoneIdentifier,
    );
    await _storage.write(
      key: 'prayer_location',
      value: jsonEncode(model.toJson()),
    );
  }

  @override
  Future<PrayerLocation?> getSelectedLocation() async {
    final str = await _storage.read(key: 'prayer_location');
    if (str == null) return null;
    try {
      final json = jsonDecode(str) as Map<String, dynamic>;
      return PrayerLocationModel.fromJson(json);
    } catch (_) {
      return null;
    }
  }
}
