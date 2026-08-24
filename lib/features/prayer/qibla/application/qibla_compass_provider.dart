import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/base/result.dart';
import '../../../../core/di/injection_container.dart';
import '../domain/circular_smoothing_filter.dart';
import '../domain/compass_alignment_rules.dart';
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
  locationUnavailable,
}

class QiblaCompassState extends Equatable {
  final CompassStatus status;
  final double? qiblaBearing;
  final double? deviceHeading;
  final double? relativeQiblaAngle;
  final QiblaAlignmentStatus? alignmentStatus;
  final CompassFailure? failure;

  const QiblaCompassState({
    this.status = CompassStatus.initial,
    this.qiblaBearing,
    this.deviceHeading,
    this.relativeQiblaAngle,
    this.alignmentStatus,
    this.failure,
  });

  QiblaCompassState copyWith({
    CompassStatus? status,
    double? Function()? qiblaBearing,
    double? Function()? deviceHeading,
    double? Function()? relativeQiblaAngle,
    QiblaAlignmentStatus? Function()? alignmentStatus,
    CompassFailure? Function()? failure,
  }) {
    return QiblaCompassState(
      status: status ?? this.status,
      qiblaBearing: qiblaBearing != null ? qiblaBearing() : this.qiblaBearing,
      deviceHeading:
          deviceHeading != null ? deviceHeading() : this.deviceHeading,
      relativeQiblaAngle: relativeQiblaAngle != null
          ? relativeQiblaAngle()
          : this.relativeQiblaAngle,
      alignmentStatus:
          alignmentStatus != null ? alignmentStatus() : this.alignmentStatus,
      failure: failure != null ? failure() : this.failure,
    );
  }

  @override
  List<Object?> get props => [
        status,
        qiblaBearing,
        deviceHeading,
        relativeQiblaAngle,
        alignmentStatus,
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
  late final CircularSmoothingFilter _smoothingFilter;

  @override
  QiblaCompassState build() {
    _headingService = getIt<DeviceHeadingService>();
    _smoothingFilter = CircularSmoothingFilter(alpha: 0.2);

    ref.listen(qiblaProvider, (previous, next) {
      if (next.status == QiblaStatus.success && next.direction != null) {
        _updateQiblaBearing(next.direction!.bearingDegrees);
      } else {
        state = state.copyWith(
          status: CompassStatus.locationUnavailable,
          qiblaBearing: () => null,
          relativeQiblaAngle: () => null,
          alignmentStatus: () => null,
        );
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
      status: initialBearing != null
          ? CompassStatus.initial
          : CompassStatus.locationUnavailable,
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
            final smoothedHeading =
                _smoothingFilter.smooth(heading.headingDegrees);

            final bearing = state.qiblaBearing;
            double? relative;
            QiblaAlignmentStatus? alignment;
            CompassStatus nextStatus = state.status;

            if (bearing != null) {
              relative = RelativeQiblaCalculator.calculate(
                bearing,
                smoothedHeading,
              );
              alignment = CompassAlignmentRules.evaluate(relative);
              nextStatus = CompassStatus.ready;
            } else {
              nextStatus = CompassStatus.locationUnavailable;
            }

            state = state.copyWith(
              status: nextStatus,
              deviceHeading: () => smoothedHeading,
              relativeQiblaAngle: () => relative,
              alignmentStatus: () => alignment,
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
    QiblaAlignmentStatus? alignment;
    final heading = state.deviceHeading;
    CompassStatus nextStatus = state.status;

    if (heading != null) {
      relative = RelativeQiblaCalculator.calculate(newBearing, heading);
      alignment = CompassAlignmentRules.evaluate(relative);
      if (state.status == CompassStatus.locationUnavailable ||
          state.status == CompassStatus.initial) {
        nextStatus = CompassStatus.ready;
      }
    } else if (state.status == CompassStatus.locationUnavailable) {
      nextStatus = CompassStatus.initial;
    }

    state = state.copyWith(
      status: nextStatus,
      qiblaBearing: () => newBearing,
      relativeQiblaAngle: () => relative,
      alignmentStatus: () => alignment,
    );
  }
}
