import 'package:flutter_dotenv/flutter_dotenv.dart';

enum EnvironmentType { development, staging, production }

class EnvironmentConfig {
  EnvironmentConfig._();

  static Future<void> init() async {
    await dotenv.load(fileName: '.env');
  }

  static EnvironmentType get environment {
    final env = dotenv.env['APP_ENV'] ?? 'development';
    return EnvironmentType.values.firstWhere(
      (e) => e.name == env,
      orElse: () => EnvironmentType.development,
    );
  }

  static String get apiBaseUrl =>
      dotenv.env['API_BASE_URL'] ?? 'https://api.noorlife.example.com';

  static int get connectTimeout =>
      int.tryParse(dotenv.env['CONNECT_TIMEOUT'] ?? '30000') ?? 30000;

  static int get receiveTimeout =>
      int.tryParse(dotenv.env['RECEIVE_TIMEOUT'] ?? '30000') ?? 30000;

  static bool get isDevelopment => environment == EnvironmentType.development;
}
