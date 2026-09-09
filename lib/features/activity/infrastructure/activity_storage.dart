import 'package:injectable/injectable.dart';
import '../domain/activity_models.dart';
import '../../../core/base/result.dart';
import 'datasources/activity_local_data_source.dart';

@LazySingleton(as: ActivityRepository)
class ActivityRepositoryImpl implements ActivityRepository {
  final ActivityLocalDataSource _dataSource;

  ActivityRepositoryImpl(this._dataSource);

  @override
  Future<Result<DailyActivity, ActivityFailure>> getDailyActivity(
    String date,
  ) async {
    try {
      final allRecords = await _dataSource.loadAllRecords();
      if (allRecords.containsKey(date)) {
        final jsonRecord = allRecords[date];
        if (jsonRecord is Map<String, dynamic>) {
          return Success(DailyActivity.fromJson(jsonRecord));
        }
      }
      return Success(DailyActivity(date: date));
    } catch (e) {
      // FIX: Added const to failure objects and fixed trailing commas
      return const ResultFailure(
        ActivityFailure(
          'Failed to read activity',
          code: 'activityReadFailed',
        ),
      );
    }
  }

  @override
  Future<Result<void, ActivityFailure>> saveDailyActivity(
    DailyActivity activity,
  ) async {
    try {
      final allRecords = await _dataSource.loadAllRecords();

      // Latest write wins
      allRecords[activity.date] = activity.toJson();

      await _dataSource.saveAllRecords(allRecords);
      return const Success(null);
    } catch (e) {
      // FIX: Added const to failure objects and fixed trailing commas
      return const ResultFailure(
        ActivityFailure(
          'Failed to save activity',
          code: 'activityWriteFailed',
        ),
      );
    }
  }
}
