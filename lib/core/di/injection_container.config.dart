// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:firebase_auth/firebase_auth.dart' as _i59;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import '../../features/authentication/domain/repositories/auth_repository.dart'
    as _i742;
import '../../features/authentication/infrastructure/datasources/firebase_auth_data_source.dart'
    as _i1048;
import '../../features/authentication/infrastructure/repositories/auth_repository_impl.dart'
    as _i996;
import '../../features/prayer/calculation_methods/domain/repositories/calculation_method_repository.dart'
    as _i612;
import '../../features/prayer/calculation_methods/infrastructure/repositories/calculation_method_repository_impl.dart'
    as _i699;
import '../../features/prayer/location/domain/interfaces/location_geocoding_service.dart'
    as _i711;
import '../../features/prayer/location/domain/interfaces/location_permission_service.dart'
    as _i643;
import '../../features/prayer/location/domain/interfaces/location_service.dart'
    as _i1067;
import '../../features/prayer/location/infrastructure/datasources/geocoding_data_source.dart'
    as _i557;
import '../../features/prayer/location/infrastructure/datasources/geolocator_data_source.dart'
    as _i599;
import '../../features/prayer/location/infrastructure/services/location_geocoding_service_impl.dart'
    as _i768;
import '../../features/prayer/location/infrastructure/services/location_permission_service_impl.dart'
    as _i493;
import '../../features/prayer/location/infrastructure/services/location_service_impl.dart'
    as _i933;
import '../../features/prayer/prayer_times/application/services/prayer_orchestrator_service.dart'
    as _i877;
import '../../features/prayer/prayer_times/domain/repositories/prayer_times_repository.dart'
    as _i621;
import '../../features/prayer/prayer_times/infrastructure/repositories/prayer_times_repository_impl.dart'
    as _i887;
import '../../features/prayer/qibla/domain/interfaces/device_heading_service.dart'
    as _i570;
import '../../features/prayer/qibla/infrastructure/datasources/flutter_compass_data_source.dart'
    as _i321;
import '../../features/prayer/qibla/infrastructure/services/device_heading_service_impl.dart'
    as _i388;
import '../../features/prayer/shared/infrastructure/datasources/prayer_local_data_source.dart'
    as _i260;
import '../../features/prayer/shared/infrastructure/datasources/prayer_secure_storage_data_source.dart'
    as _i949;
import '../../features/quran/domain/repositories/quran_bookmark_repository.dart'
    as _i886;
import '../../features/quran/domain/repositories/quran_progress_repository.dart'
    as _i787;
import '../../features/quran/domain/repositories/quran_reader_settings_repository.dart'
    as _i703;
import '../../features/quran/domain/repositories/quran_repository.dart'
    as _i498;
import '../../features/quran/domain/repositories/quran_translation_repository.dart'
    as _i682;
import '../../features/quran/infrastructure/datasources/quran_bookmark_local_data_source.dart'
    as _i501;
import '../../features/quran/infrastructure/datasources/quran_local_data_source.dart'
    as _i986;
import '../../features/quran/infrastructure/datasources/quran_progress_local_data_source.dart'
    as _i290;
import '../../features/quran/infrastructure/datasources/quran_reader_settings_local_data_source.dart'
    as _i169;
import '../../features/quran/infrastructure/datasources/quran_translation_local_data_source.dart'
    as _i61;
import '../../features/quran/infrastructure/repositories/quran_bookmark_repository_impl.dart'
    as _i535;
import '../../features/quran/infrastructure/repositories/quran_progress_repository_impl.dart'
    as _i896;
import '../../features/quran/infrastructure/repositories/quran_reader_settings_repository_impl.dart'
    as _i478;
import '../../features/quran/infrastructure/repositories/quran_repository_impl.dart'
    as _i771;
import '../../features/quran/infrastructure/repositories/quran_translation_repository_impl.dart'
    as _i821;
import '../logging/logger_service.dart' as _i731;
import '../network/dio_client.dart' as _i667;
import '../services/timezone/timezone_service.dart' as _i280;
import '../services/timezone/timezone_service_impl.dart' as _i338;
import '../storage/secure_storage_service.dart' as _i666;
import 'firebase_module.dart' as _i616;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final firebaseModule = _$FirebaseModule();
    gh.lazySingleton<_i59.FirebaseAuth>(() => firebaseModule.firebaseAuth);
    gh.lazySingleton<_i731.LoggerService>(() => _i731.LoggerService());
    gh.lazySingleton<_i666.SecureStorageService>(
        () => _i666.SecureStorageService());
    gh.lazySingleton<_i557.GeocodingDataSource>(
        () => _i557.GeocodingDataSource());
    gh.lazySingleton<_i599.GeolocatorDataSource>(
        () => _i599.GeolocatorDataSource());
    gh.lazySingleton<_i321.FlutterCompassDataSource>(
        () => _i321.FlutterCompassDataSource());
    gh.lazySingleton<_i260.PrayerLocalDataSource>(
        () => _i949.PrayerSecureStorageDataSource());
    gh.lazySingleton<_i61.QuranTranslationLocalDataSource>(
        () => _i61.QuranTranslationLocalDataSourceImpl());
    gh.lazySingleton<_i612.CalculationMethodRepository>(() =>
        _i699.CalculationMethodRepositoryImpl(
            gh<_i260.PrayerLocalDataSource>()));
    gh.lazySingleton<_i986.QuranLocalDataSource>(
        () => _i986.QuranLocalDataSourceImpl());
    gh.lazySingleton<_i498.QuranRepository>(
        () => _i771.QuranRepositoryImpl(gh<_i986.QuranLocalDataSource>()));
    gh.lazySingleton<_i280.TimezoneService>(() => _i338.TimezoneServiceImpl());
    gh.lazySingleton<_i711.LocationGeocodingService>(() =>
        _i768.LocationGeocodingServiceImpl(gh<_i557.GeocodingDataSource>()));
    gh.lazySingleton<_i643.LocationPermissionService>(() =>
        _i493.LocationPermissionServiceImpl(gh<_i599.GeolocatorDataSource>()));
    gh.lazySingleton<_i570.DeviceHeadingService>(() =>
        _i388.DeviceHeadingServiceImpl(gh<_i321.FlutterCompassDataSource>()));
    gh.lazySingleton<_i169.QuranReaderSettingsLocalDataSource>(() =>
        _i169.QuranReaderSettingsLocalDataSourceImpl(
            gh<_i666.SecureStorageService>()));
    gh.lazySingleton<_i290.QuranProgressLocalDataSource>(() =>
        _i290.QuranProgressLocalDataSourceImpl(
            gh<_i666.SecureStorageService>()));
    gh.lazySingleton<_i1048.FirebaseAuthDataSource>(
        () => _i1048.FirebaseAuthDataSource(gh<_i59.FirebaseAuth>()));
    gh.lazySingleton<_i501.QuranBookmarkLocalDataSource>(() =>
        _i501.QuranBookmarkLocalDataSourceImpl(
            gh<_i666.SecureStorageService>()));
    gh.lazySingleton<_i886.QuranBookmarkRepository>(() =>
        _i535.QuranBookmarkRepositoryImpl(
            gh<_i501.QuranBookmarkLocalDataSource>()));
    gh.lazySingleton<_i667.DioClient>(
        () => _i667.DioClient(gh<_i731.LoggerService>()));
    gh.lazySingleton<_i682.QuranTranslationRepository>(() =>
        _i821.QuranTranslationRepositoryImpl(
            gh<_i61.QuranTranslationLocalDataSource>()));
    gh.lazySingleton<_i1067.LocationService>(() => _i933.LocationServiceImpl(
          gh<_i643.LocationPermissionService>(),
          gh<_i711.LocationGeocodingService>(),
          gh<_i599.GeolocatorDataSource>(),
        ));
    gh.lazySingleton<_i621.PrayerTimesRepository>(
        () => _i887.PrayerTimesRepositoryImpl(
              gh<_i260.PrayerLocalDataSource>(),
              gh<_i280.TimezoneService>(),
            ));
    gh.lazySingleton<_i787.QuranProgressRepository>(() =>
        _i896.QuranProgressRepositoryImpl(
            gh<_i290.QuranProgressLocalDataSource>()));
    gh.lazySingleton<_i742.AuthRepository>(
        () => _i996.AuthRepositoryImpl(gh<_i1048.FirebaseAuthDataSource>()));
    gh.lazySingleton<_i703.QuranReaderSettingsRepository>(() =>
        _i478.QuranReaderSettingsRepositoryImpl(
            gh<_i169.QuranReaderSettingsLocalDataSource>()));
    gh.lazySingleton<_i877.PrayerOrchestratorService>(() =>
        _i877.PrayerOrchestratorService(gh<_i621.PrayerTimesRepository>()));
    return this;
  }
}

class _$FirebaseModule extends _i616.FirebaseModule {}
