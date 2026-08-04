import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../config/environment_config.dart';
import '../constants/app_constants.dart';
import '../logging/logger_service.dart';

@lazySingleton
class DioClient {
  late final Dio _dio;
  final LoggerService _loggerService;

  DioClient(this._loggerService) {
    _dio = Dio(
      BaseOptions(
        baseUrl: EnvironmentConfig.apiBaseUrl,
        connectTimeout:
            Duration(milliseconds: EnvironmentConfig.connectTimeout),
        receiveTimeout:
            Duration(milliseconds: EnvironmentConfig.receiveTimeout),
        headers: {
          'Content-Type': AppConstants.contentTypeJson,
          'Accept': AppConstants.contentTypeJson,
        },
      ),
    );

    if (EnvironmentConfig.isDevelopment) {
      _dio.interceptors.add(
        LogInterceptor(
          requestBody: true,
          responseBody: true,
          logPrint: (object) => _loggerService.debug('[DIO] $object'),
        ),
      );
    }
  }

  Dio get dio => _dio;
}
