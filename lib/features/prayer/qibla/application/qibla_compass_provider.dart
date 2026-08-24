import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/base/result.dart';
import '../../../../core/di/injection_container.dart';
import '../domain/compass_models.dart';
import '../domain/interfaces/device_heading_service.dart';
import '../domain/relative_qibla_calculator.dart';
import 'qibla_provider.dart';

enum CompassStatus {
  initial,
  ready,
  sensorUnavailable,
  error,
  unsupportedPlatform,
}

class QiblaCompassState extends Equatable {
  final CompassStatus status;
  final double? qiblaBearing;
  final double? deviceHeading;
  final double? relativeQiblaAngle;
  final CompassFailure? failure;

  const QiblaCompassState({
    this.status = CompassStatus.initial,
    this.qiblaBearing,
    this.deviceHeading,
    this.relativeQiblaAngle,
    this.failure,
  });

  QiblaCompassState copyWith({
    CompassStatus? status,
    double? qiblaBearing,
    double? deviceHeading,
    double? relativeQiblaAngle,
    CompassFailure? Function()? failure,
  }) {
    return QiblaCompassState(
      status: status ?? this.status,
      qiblaBearing: qiblaBearing ?? this.qiblaBearing,
      deviceHeading: deviceHeading ?? this.deviceHeading,
      relativeQiblaAngle: relativeQiblaAngle ?? this.relativeQiblaAngle,
      failure: failure != null ? failure() : this.failure,
    );
  }

  @override
  List<Object?> get props => [
        status,
        qiblaBearing,
        deviceHeading,
        relativeQiblaAngle,
        failure,
      ];
}

final qiblaCompassProvider =
    NotifierProvider.autoDispose<QiblaCompassNotifier, QiblaCompassState>(
  QiblaCompassNotifier.new,
);

class QiblaCompassNotifier extends AutoDisposeNotifier<QiblaCompassState> {
  StreamSubscription<Result<DeviceHeading?, CompassFailure>>? _subscription;
  late final DeviceHeadingService _headingService;

  @override
  QiblaCompassState build() {
    _headingService = getIt<DeviceHeadingService>();

    ref.listen(qiblaProvider, (previous, next) {
      if (next.status == QiblaStatus.success && next.direction != null) {
        _updateQiblaBearing(next.direction!.bearingDegrees);
      }
    });

    final initialQibla = ref.read(qiblaProvider);
    final initialBearing = initialQibla.status == QiblaStatus.success
        ? initialQibla.direction?.bearingDegrees
        : null;

    ref.onDispose(() {
      _subscription?.cancel();
    });

    _initStream();

    return QiblaCompassState(
      qiblaBearing: initialBearing,
    );
  }

  void _initStream() {
    _subscription = _headingService.headingStream.listen((result) {
      switch (result) {
        case Success(value: final heading):
          if (heading == null) {
            state = state.copyWith(
              status: CompassStatus.sensorUnavailable,
              failure: () => const CompassFailure(
                'Sensor unavailable',
                code: 'sensor_unavailable',
              ),
            );
          } else {
            final bearing = state.qiblaBearing;
            double? relative;
            if (bearing != null) {
              relative = RelativeQiblaCalculator.calculate(
                bearing,
                heading.headingDegrees,
              );
            }
            state = state.copyWith(
              status: CompassStatus.ready,
              deviceHeading: heading.headingDegrees,
              relativeQiblaAngle: relative,
              failure: () => null,
            );
          }
        case ResultFailure(failure: final f):
          state = state.copyWith(
            status: f.code == 'unsupported_platform'
                ? CompassStatus.unsupportedPlatform
                : (f.code == 'sensor_unavailable'
                    ? CompassStatus.sensorUnavailable
                    : CompassStatus.error),
            failure: () => f,
          );
      }
    });
  }

  void _updateQiblaBearing(double newBearing) {
    double? relative;
    final heading = state.deviceHeading;
    if (heading != null) {
      relative = RelativeQiblaCalculator.calculate(newBearing, heading);
    }
    state = state.copyWith(
      qiblaBearing: newBearing,
      relativeQiblaAngle: relative,
    );
  }
}
