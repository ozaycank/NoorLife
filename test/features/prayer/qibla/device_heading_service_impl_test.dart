import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:noor_life/core/base/result.dart';
import 'package:noor_life/features/prayer/qibla/domain/compass_models.dart';
import 'package:noor_life/features/prayer/qibla/infrastructure/datasources/flutter_compass_data_source.dart';
import 'package:noor_life/features/prayer/qibla/infrastructure/services/device_heading_service_impl.dart';

class MockFlutterCompassDataSource extends Mock
    implements FlutterCompassDataSource {}

class MockCompassEvent extends Mock implements CompassEvent {}

void main() {
  late MockFlutterCompassDataSource mockDataSource;
  late DeviceHeadingServiceImpl service;

  setUp(() {
    mockDataSource = MockFlutterCompassDataSource();
    service = DeviceHeadingServiceImpl(mockDataSource);
  });

  group('DeviceHeadingServiceImpl Stream Reliability', () {
    test('Stream error transforms to ResultFailure(stream_error) securely',
        () async {
      final controller = StreamController<CompassEvent>();
      when(() => mockDataSource.events).thenAnswer((_) => controller.stream);

      final results = <Result<DeviceHeading?, CompassFailure>>[];
      final subscription = service.headingStream.listen(results.add);

      controller.addError(Exception('Hardware glitch'));
      await Future.delayed(Duration.zero);

      expect(results.length, 1);
      expect(results.first, isA<ResultFailure>());
      final failure = (results.first as ResultFailure).failure;
      expect(failure.code, 'stream_error');

      await subscription.cancel();
      await controller.close();
    });

    test('Null heading yields ResultFailure(sensor_unavailable) definitively',
        () async {
      final controller = StreamController<CompassEvent>();
      when(() => mockDataSource.events).thenAnswer((_) => controller.stream);

      final results = <Result<DeviceHeading?, CompassFailure>>[];
      final subscription = service.headingStream.listen(results.add);

      final mockEvent = MockCompassEvent();
      when(() => mockEvent.heading).thenReturn(null);

      controller.add(mockEvent);
      await Future.delayed(Duration.zero);

      expect(results.length, 1);
      expect(results.first, isA<ResultFailure>());
      final failure = (results.first as ResultFailure).failure;
      expect(failure.code, 'sensor_unavailable');

      await subscription.cancel();
      await controller.close();
    });
  });
}
