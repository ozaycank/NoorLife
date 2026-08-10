
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/prayer/location/domain/entities/prayer_location.dart';

final defaultLocationProvider = Provider<PrayerLocation>((ref) {
  return const PrayerLocation(
    latitude: 41.0082,
    longitude: 28.9784,
    cityName: 'Istanbul',
    countryName: 'Türkiye',
  );
});
