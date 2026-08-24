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

  Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}
