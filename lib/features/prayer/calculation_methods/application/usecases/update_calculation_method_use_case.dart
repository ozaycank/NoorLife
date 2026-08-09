import 'package:injectable/injectable.dart';
import '../../../../../core/errors/failure.dart';
import '../../../shared/domain/repositories/prayer_repository.dart';

@lazySingleton
class UpdateCalculationMethodUseCase {
  final PrayerRepository _repository;

  UpdateCalculationMethodUseCase(this._repository);

  Future<(Failure?, void)> execute(String methodId) {
    return _repository.updateCalculationMethod(methodId);
  }
}
