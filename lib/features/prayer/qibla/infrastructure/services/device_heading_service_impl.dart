import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:injectable/injectable.dart';
import '../../../../../core/base/result.dart';
import '../../domain/compass_models.dart';
import '../../domain/interfaces/device_heading_service.dart';
import '../datasources/flutter_compass_data_source.dart';

@LazySingleton(as: DeviceHeadingService)
class DeviceHeadingServiceImpl implements DeviceHeadingService {
  final FlutterCompassDataSource _dataSource;

  DeviceHeadingServiceImpl(this._dataSource);

  @override
  Stream<Result<DeviceHeading?, CompassFailure>> get headingStream {
    if (kIsWeb) {
      return Stream.value(
        const ResultFailure(
          CompassFailure(
            'Compass unavailable on this platform.',
            code: 'unsupported_platform',
          ),
        ),
      );
    }

    final stream = _dataSource.events;
    if (stream == null) {
      return Stream.value(
        const ResultFailure(
          CompassFailure(
            'Compass sensor not found on this device.',
            code: 'sensor_unavailable',
          ),
        ),
      );
    }

    return stream.transform(
      StreamTransformer<CompassEvent,
          Result<DeviceHeading?, CompassFailure>>.fromHandlers(
        handleData: (event, sink) {
          final rawHeading = event.heading;
          if (rawHeading == null) {
            sink.add(
              const ResultFailure(
                CompassFailure(
                  'Compass sensor data is null.',
                  code: 'sensor_unavailable',
                ),
              ),
            );
          } else {
            final normalized = (rawHeading % 360.0 + 360.0) % 360.0;
            sink.add(Success(DeviceHeading(normalized)));
          }
        },
        handleError: (error, stackTrace, sink) {
          sink.add(
            ResultFailure(
              CompassFailure(
                'Compass stream error: $error',
                code: 'stream_error',
              ),
            ),
          );
        },
      ),
    );
  }
}
