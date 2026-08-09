import 'package:injectable/injectable.dart';
import '../../../../../core/errors/failure.dart';
import '../../domain/entities/prayer_calculation_method.dart';
import '../../../shared/domain/repositories/prayer_repository.dart';

@lazySingleton
class GetCalculationMethodsUseCase {
  final PrayerRepository _repository;

  GetCalculationMethodsUseCase(this._repository);

  Future<(Failure?, List<PrayerCalculationMethod>?)> execute() {
    return _repository.getCalculationMethods();
  }
}
