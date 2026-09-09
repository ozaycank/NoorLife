import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';

abstract class ActivityLocalDataSource {
  Future<Map<String, dynamic>> loadAllRecords();
  Future<void> saveAllRecords(Map<String, dynamic> records);
}

@LazySingleton(as: ActivityLocalDataSource)
class ActivityLocalDataSourceImpl implements ActivityLocalDataSource {
  final FlutterSecureStorage _storage;
  static const String _storageKey = 'noorlife_activity_records_v2';

  // Injecting securely from the existing storage pattern if available, 
  // otherwise instantiating directly but isolated within this file.
  ActivityLocalDataSourceImpl({FlutterSecureStorage? storage}) 
    : _storage = storage ?? const FlutterSecureStorage();

  @override
  Future<Map<String, dynamic>> loadAllRecords() async {
    try {
      final data = await _storage.read(key: _storageKey);
      if (data == null || data.isEmpty) return {};
      
      final decoded = json.decode(data);
      if (decoded is Map<String, dynamic>) {
        return decoded;
      }
      return {};
    } catch (_) {
      // Deterministic fallback: Empty map on JSON corruption
      return {};
    }
  }

  @override
  Future<void> saveAllRecords(Map<String, dynamic> records) async {
    final encoded = json.encode(records);
    await _storage.write(key: _storageKey, value: encoded);
  }
}