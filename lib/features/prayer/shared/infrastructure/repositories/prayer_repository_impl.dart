import 'package:injectable/injectable.dart';
import '../../../../../core/errors/failure.dart';
import '../../../calculation_methods/domain/entities/madhab.dart';
import '../../../calculation_methods/domain/entities/prayer_calculation_method.dart';
import '../../../location/domain/entities/prayer_location.dart';
import '../../../prayer_times/domain/entities/prayer_day.dart';
import '../../domain/errors/prayer_failure.dart';
import '../../domain/repositories/prayer_repository.dart';
import '../datasources/prayer_local_data_source.dart';
import '../datasources/prayer_remote_data_source.dart';

@LazySingleton(as: PrayerRepository)
class PrayerRepositoryImpl implements PrayerRepository {
  final PrayerRemoteDataSource _remoteDataSource;
  final PrayerLocalDataSource _localDataSource;

  PrayerRepositoryImpl(
    this._remoteDataSource,
    this._localDataSource,
  );

  @override
  Future<(Failure?, PrayerDay?)> getPrayerTimes(
    PrayerLocation location,
  ) async {
    try {
      final cached = await _localDataSource.getCachedPrayerTimes(location);
      if (cached != null) {
        return (null, cached);
      }
      final remote = await _remoteDataSource.fetchPrayerTimes(location);
      await _localDataSource.cachePrayerTimes(location, remote);
      return (null, remote);
    } catch (e) {
      return (
        PrayerCalculationFailure('Failed to retrieve prayer foundation: $e'),
        null
      );
    }
  }

  @override
  Future<(Failure?, PrayerDay?)> refreshPrayerTimes(
    PrayerLocation location,
  ) async {
    try {
      final remote = await _remoteDataSource.fetchPrayerTimes(location);
      await _localDataSource.cachePrayerTimes(location, remote);
      return (null, remote);
    } catch (e) {
      return (
        PrayerCalculationFailure('Failed to refresh prayer times: $e'),
        null
      );
    }
  }

  @override
  Future<(Failure?, List<PrayerCalculationMethod>?)>
      getCalculationMethods() async {
    try {
      final methods = await _localDataSource.getCalculationMethods();
      return (null, methods);
    } catch (e) {
      return (
        PrayerCalculationFailure('Failed to load calculation methods: $e'),
        null
      );
    }
  }

  @override
  Future<(Failure?, void)> updateCalculationMethod(String methodId) async {
    try {
      await _localDataSource.saveSelectedCalculationMethod(methodId);
      return (null, null);
    } catch (e) {
      return (
        PrayerCalculationFailure('Failed to update calculation method: $e'),
        null
      );
    }
  }

  @override
  Future<(Failure?, List<Madhab>?)> getMadhabs() async {
    try {
      final madhabs = await _localDataSource.getMadhabs();
      return (null, madhabs);
    } catch (e) {
      return (
        PrayerCalculationFailure('Failed to load juristic madhabs: $e'),
        null
      );
    }
  }

  @override
  Future<(Failure?, void)> updateMadhab(String madhabId) async {
    try {
      await _localDataSource.saveSelectedMadhab(madhabId);
      return (null, null);
    } catch (e) {
      return (
        PrayerCalculationFailure('Failed to update madhab preference: $e'),
        null
      );
    }
  }

  @override
  Future<(Failure?, PrayerLocation?)> getCurrentLocation() async {
    return (
      null,
      const PrayerLocation(
        latitude: 41.0082,
        longitude: 28.9784,
        cityName: 'Istanbul',
        countryName: 'Türkiye',
      )
    );
  }
}
