import 'package:flutter/foundation.dart';
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

    return stream.map<Result<DeviceHeading?, CompassFailure>>((event) {
      final rawHeading = event.heading;
      if (rawHeading == null) {
        return const ResultFailure(
          CompassFailure(
            'Compass sensor data is null.',
            code: 'sensor_unavailable',
          ),
        );
      }

      final normalized = (rawHeading % 360.0 + 360.0) % 360.0;
      return Success(DeviceHeading(normalized));
    }).handleError((error) {
      return ResultFailure(
        CompassFailure('Compass stream error: $error', code: 'stream_error'),
      );
    });
  }
}
