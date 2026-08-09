import 'package:injectable/injectable.dart';
import '../../../../../core/errors/failure.dart';
import '../../../shared/domain/repositories/prayer_repository.dart';

@lazySingleton
class UpdateMadhabUseCase {
  final PrayerRepository _repository;

  UpdateMadhabUseCase(this._repository);

  Future<(Failure?, void)> execute(String madhabId) {
    return _repository.updateMadhab(madhabId);
  }
}
