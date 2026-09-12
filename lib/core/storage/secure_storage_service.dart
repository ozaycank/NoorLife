import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class SecureStorageService {
  final FlutterSecureStorage _storage;

  SecureStorageService()
      : _storage = const FlutterSecureStorage(
          aOptions: AndroidOptions(
            encryptedSharedPreferences: true,
          ),
          iOptions: IOSOptions(
            accessibility: KeychainAccessibility.first_unlock,
          ),
        );

  static const String keyRememberedEmail = 'sec_key_remembered_email';
  static const String keyRememberMeStatus = 'sec_key_remember_me_status';

  // Notification Keys
  static const String keyNotificationsEnabled = 'sec_key_notif_enabled';
  static const String keyPrayerReminderMinutes = 'sec_key_notif_prayer_mins';
  static const String keyDailyVerseEnabled = 'sec_key_notif_verse_enabled';
  static const String keyDailyVerseTime = 'sec_key_notif_verse_time';

  Future<void> write({required String key, required String value}) async {
    await _storage.write(key: key, value: value);
  }

  Future<String?> read({required String key}) async {
    return await _storage.read(key: key);
  }

  Future<void> delete({required String key}) async {
    await _storage.delete(key: key);
  }

  Future<void> saveRememberMe({
    required bool rememberMe,
    required String email,
  }) async {
    await _storage.write(
      key: keyRememberMeStatus,
      value: rememberMe.toString(),
    );
    if (rememberMe) {
      await _storage.write(key: keyRememberedEmail, value: email);
    } else {
      await _storage.delete(key: keyRememberedEmail);
    }
  }

  Future<bool> getRememberMeStatus() async {
    final status = await _storage.read(key: keyRememberMeStatus);
    return status == 'true';
  }

  Future<String?> getRememberedEmail() async {
    return _storage.read(key: keyRememberedEmail);
  }

  // Notification Getters & Setters
  Future<bool> getNotificationsEnabled() async {
    final val = await read(key: keyNotificationsEnabled);
    return val != 'false'; // Default true
  }

  Future<void> setNotificationsEnabled(bool val) async {
    await write(key: keyNotificationsEnabled, value: val.toString());
  }

  Future<int> getPrayerReminderMinutes() async {
    final val = await read(key: keyPrayerReminderMinutes);
    return val != null ? int.tryParse(val) ?? 30 : 30; // Default 30 min
  }

  Future<void> setPrayerReminderMinutes(int val) async {
    await write(key: keyPrayerReminderMinutes, value: val.toString());
  }

  Future<bool> getDailyVerseEnabled() async {
    final val = await read(key: keyDailyVerseEnabled);
    return val != 'false'; // Default true
  }

  Future<void> setDailyVerseEnabled(bool val) async {
    await write(key: keyDailyVerseEnabled, value: val.toString());
  }

  Future<String> getDailyVerseTime() async {
    final val = await read(key: keyDailyVerseTime);
    return val ?? '20:00'; // Default 20:00
  }

  Future<void> setDailyVerseTime(String val) async {
    await write(key: keyDailyVerseTime, value: val);
  }

  Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}
