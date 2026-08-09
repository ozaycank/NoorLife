import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'prayer_notifier.dart';
import 'prayer_state.dart';

final prayerNotifierProvider =
    NotifierProvider<PrayerNotifier, PrayerState>(PrayerNotifier.new);

final prayerDayProvider = Provider((ref) {
  return ref.watch(prayerNotifierProvider).prayerDay;
});

final prayerLocationProvider = Provider((ref) {
  return ref.watch(prayerNotifierProvider).location;
});
