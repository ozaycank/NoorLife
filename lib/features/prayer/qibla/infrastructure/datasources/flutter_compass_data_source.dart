import 'package:flutter_compass/flutter_compass.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class FlutterCompassDataSource {
  Stream<CompassEvent>? get events => FlutterCompass.events;
}
