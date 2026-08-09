import 'package:injectable/injectable.dart';
import '../../../../../core/errors/failure.dart';
import '../../domain/entities/madhab.dart';
import '../../../shared/domain/repositories/prayer_repository.dart';

@lazySingleton
class GetMadhabUseCase {
  final PrayerRepository _repository;

  GetMadhabUseCase(this._repository);

  Future<(Failure?, List<Madhab>?)> execute() {
    return _repository.getMadhabs();
  }
}
