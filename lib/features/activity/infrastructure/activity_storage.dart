import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import '../domain/activity_models.dart';
import '../../../core/base/result.dart';

@LazySingleton(as: ActivityRepository)
class ActivityRepositoryImpl implements ActivityRepository {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  // Namespaced key to prevent polluting secure storage root
  static const String _storageKey = 'noorlife_activity_records';

  Future<Map<String, DailyActivity>> _loadAllRecords() async {
    try {
      final data = await _storage.read(key: _storageKey);
      if (data == null || data.isEmpty) return {};

      final decoded = json.decode(data) as Map<String, dynamic>;
      final map = <String, DailyActivity>{};

      for (final entry in decoded.entries) {
        map[entry.key] =
            DailyActivity.fromJson(entry.value as Map<String, dynamic>);
      }
      return map;
    } catch (_) {
      // Return empty map on JSON corruption to prevent app crashes
      return {};
    }
  }

  @override
  Future<Result<DailyActivity, ActivityFailure>> getDailyActivity(
      String date,) async {
    try {
      final allRecords = await _loadAllRecords();
      if (allRecords.containsKey(date)) {
        return Success(allRecords[date]!);
      }

      // Return a fresh default object if no record exists for this date
      return Success(DailyActivity(date: date));
    } catch (e) {
      return ResultFailure(ActivityFailure('Failed to read activity: $e',
          code: 'activityReadFailed',),);
    }
  }

  @override
  Future<Result<void, ActivityFailure>> saveDailyActivity(
      DailyActivity activity,) async {
    try {
      final allRecords = await _loadAllRecords();

      // Latest write wins
      allRecords[activity.date] = activity;

      final encoded =
          json.encode(allRecords.map((k, v) => MapEntry(k, v.toJson())));
      await _storage.write(key: _storageKey, value: encoded);

      return const Success(null);
    } catch (e) {
      return ResultFailure(ActivityFailure('Failed to save activity: $e',
          code: 'activityWriteFailed',),);
    }
  }
}
