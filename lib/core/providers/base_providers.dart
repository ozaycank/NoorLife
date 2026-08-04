import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../logging/logger_service.dart';
import '../network/dio_client.dart';
import '../di/injection_container.dart';

final loggerProvider = Provider<LoggerService>((ref) {
  return getIt<LoggerService>();
});

final dioClientProvider = Provider<DioClient>((ref) {
  return getIt<DioClient>();
});
