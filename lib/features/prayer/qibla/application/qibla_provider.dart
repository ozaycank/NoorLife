import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/base/result.dart';
import '../../location/application/providers/location_notifier.dart';
import '../domain/qibla_calculator.dart';
import '../domain/qibla_models.dart';

enum QiblaStatus { initial, success, failure }

class QiblaState extends Equatable {
  final QiblaStatus status;
  final QiblaDirection? direction;
  final QiblaFailure? failure;
  final String? locationName;

  const QiblaState({
    this.status = QiblaStatus.initial,
    this.direction,
    this.failure,
    this.locationName,
  });

  @override
  List<Object?> get props => [status, direction, failure, locationName];
}

final qiblaProvider = Provider<QiblaState>((ref) {
  final locState = ref.watch(locationNotifierProvider);
  final location = locState.location;

  if (location == null) {
    return const QiblaState(
      status: QiblaStatus.failure,
      failure: QiblaFailure('Location is unavailable.', code: 'no_location'),
    );
  }

  final result = QiblaCalculator.calculate(
    latitude: location.latitude,
    longitude: location.longitude,
  );

  switch (result) {
    case Success(value: final dir):
      return QiblaState(
        status: QiblaStatus.success,
        direction: dir,
        locationName: '${location.cityName}, ${location.countryName}',
      );
    case ResultFailure(failure: final f):
      return QiblaState(
        status: QiblaStatus.failure,
        failure: f,
      );
  }
});
