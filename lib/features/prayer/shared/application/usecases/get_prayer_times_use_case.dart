import 'package:injectable/injectable.dart';
import '../../../../../core/errors/failure.dart';
import '../../../location/domain/entities/prayer_location.dart';
import '../../../prayer_times/domain/entities/prayer_day.dart';
import '../../domain/repositories/prayer_repository.dart';

@lazySingleton
class GetPrayerTimesUseCase {
  final PrayerRepository _repository;

  GetPrayerTimesUseCase(this._repository);

  Future<(Failure?, PrayerDay?)> execute(PrayerLocation location) {
    return _repository.getPrayerTimes(location);
  }
}
