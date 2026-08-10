import 'logger_service.dart';

extension AppLoggerExtension on LoggerService {
  void logPrayer(String message) => info('[Prayer] $message');
  void logAuth(String message) => info('[Auth] $message');
  void logLocation(String message) => info('[Location] $message');
  void logSettings(String message) => info('[Settings] $message');
}
