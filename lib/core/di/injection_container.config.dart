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
import '../../features/prayer/calculation_methods/application/usecases/get_calculation_methods_use_case.dart'
    as _i247;
import '../../features/prayer/calculation_methods/application/usecases/get_madhab_use_case.dart'
    as _i50;
import '../../features/prayer/calculation_methods/application/usecases/update_calculation_method_use_case.dart'
    as _i301;
import '../../features/prayer/calculation_methods/application/usecases/update_madhab_use_case.dart'
    as _i907;
import '../../features/prayer/shared/application/usecases/get_prayer_times_use_case.dart'
    as _i454;
import '../../features/prayer/shared/application/usecases/refresh_prayer_times_use_case.dart'
    as _i124;
import '../../features/prayer/shared/domain/repositories/prayer_repository.dart'
    as _i351;
import '../../features/prayer/shared/infrastructure/datasources/prayer_dummy_data_source.dart'
    as _i343;
import '../../features/prayer/shared/infrastructure/datasources/prayer_local_data_source.dart'
    as _i260;
import '../../features/prayer/shared/infrastructure/datasources/prayer_remote_data_source.dart'
    as _i15;
import '../../features/prayer/shared/infrastructure/repositories/prayer_repository_impl.dart'
    as _i188;
import '../logging/logger_service.dart' as _i731;
import '../network/dio_client.dart' as _i667;
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
    gh.lazySingleton<_i15.PrayerRemoteDataSource>(
        () => _i343.PrayerDummyDataSource());
    gh.lazySingleton<_i351.PrayerRepository>(() => _i188.PrayerRepositoryImpl(
          gh<_i15.PrayerRemoteDataSource>(),
          gh<_i260.PrayerLocalDataSource>(),
        ));
    gh.lazySingleton<_i247.GetCalculationMethodsUseCase>(
        () => _i247.GetCalculationMethodsUseCase(gh<_i351.PrayerRepository>()));
    gh.lazySingleton<_i50.GetMadhabUseCase>(
        () => _i50.GetMadhabUseCase(gh<_i351.PrayerRepository>()));
    gh.lazySingleton<_i301.UpdateCalculationMethodUseCase>(() =>
        _i301.UpdateCalculationMethodUseCase(gh<_i351.PrayerRepository>()));
    gh.lazySingleton<_i907.UpdateMadhabUseCase>(
        () => _i907.UpdateMadhabUseCase(gh<_i351.PrayerRepository>()));
    gh.lazySingleton<_i454.GetPrayerTimesUseCase>(
        () => _i454.GetPrayerTimesUseCase(gh<_i351.PrayerRepository>()));
    gh.lazySingleton<_i124.RefreshPrayerTimesUseCase>(
        () => _i124.RefreshPrayerTimesUseCase(gh<_i351.PrayerRepository>()));
    gh.lazySingleton<_i1048.FirebaseAuthDataSource>(
        () => _i1048.FirebaseAuthDataSource(gh<_i59.FirebaseAuth>()));
    gh.lazySingleton<_i667.DioClient>(
        () => _i667.DioClient(gh<_i731.LoggerService>()));
    gh.lazySingleton<_i742.AuthRepository>(
        () => _i996.AuthRepositoryImpl(gh<_i1048.FirebaseAuthDataSource>()));
    return this;
  }
}

class _$FirebaseModule extends _i616.FirebaseModule {}
