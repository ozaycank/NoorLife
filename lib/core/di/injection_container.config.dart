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
import '../../features/prayer/prayer_times/domain/repositories/prayer_times_repository.dart'
    as _i621;
import '../../features/prayer/prayer_times/infrastructure/repositories/prayer_times_repository_impl.dart'
    as _i887;
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
    gh.lazySingleton<_i621.PrayerTimesRepository>(
        () => _i887.PrayerTimesRepositoryImpl());
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
