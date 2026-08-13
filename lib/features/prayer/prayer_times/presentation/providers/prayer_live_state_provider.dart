import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timezone/timezone.dart' as tz;
import '../../domain/entities/prayer_time.dart';
import '../../application/providers/prayer_times_notifier.dart';

final currentTimeProvider = StreamProvider<DateTime>((ref) {
  return Stream.periodic(const Duration(seconds: 1), (_) => DateTime.now());
});

class PrayerLiveState {
  final PrayerTime? currentPrayer;
  final PrayerTime? nextPrayer;
  final Duration timeRemaining;

  PrayerLiveState({
    this.currentPrayer,
    this.nextPrayer,
    this.timeRemaining = Duration.zero,
  });
}

final prayerLiveStateProvider = Provider<PrayerLiveState>((ref) {
  final state = ref.watch(prayerTimesNotifierProvider);
  final nowDevice = ref.watch(currentTimeProvider).value ?? DateTime.now();

  if (state.schedule == null || state.location == null) {
    return PrayerLiveState();
  }

  tz.Location targetTz;
  try {
    targetTz = tz.getLocation(state.location!.timezoneIdentifier);
  } catch (_) {
    targetTz = tz.UTC;
  }

  final nowTarget = tz.TZDateTime.from(nowDevice, targetTz);

  final allTimes = [
    ...state.schedule!.yesterday.prayerTimes,
    ...state.schedule!.today.prayerTimes,
    ...state.schedule!.tomorrow.prayerTimes,
  ];

  PrayerTime? current;
  PrayerTime? next;

  for (int i = 0; i < allTimes.length; i++) {
    if (allTimes[i].time.isAfter(nowTarget)) {
      next = allTimes[i];
      if (i > 0) {
        current = allTimes[i - 1];
      }
      break;
    }
  }

  if (next == null && allTimes.isNotEmpty) {
    current = allTimes.last;
  }

  // next.time is guaranteed to be in the future by the loop above, so remaining cannot be negative.
  final remaining = next?.time.difference(nowTarget) ?? Duration.zero;

  return PrayerLiveState(
    currentPrayer: current,
    nextPrayer: next,
    timeRemaining: remaining,
  );
});
