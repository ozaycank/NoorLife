import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/prayer_time.dart';
import '../../domain/value_objects/prayer_name.dart';
import '../../application/providers/prayer_times_notifier.dart';
import '../../application/states/prayer_times_state.dart';

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
  final now = ref.watch(currentTimeProvider).value ?? DateTime.now();

  if (state.prayerDay == null) return PrayerLiveState();

  final times = state.prayerDay!.prayerTimes;
  PrayerTime? current;
  PrayerTime? next;

  for (int i = 0; i < times.length; i++) {
    if (times[i].time.isAfter(now)) {
      next = times[i];
      if (i > 0) current = times[i - 1];
      break;
    }
  }

  // If now is after Isha, next prayer is theoretically tomorrow's Fajr.
  // For Phase 4, we fallback to today's Fajr conceptually to prevent UI crash,
  // pending full cross-day architecture in Phase 5.
  if (next == null && times.isNotEmpty) {
    current = times.last;
    next = PrayerTime(
      name: PrayerName.fajr,
      time: times.first.time.add(const Duration(days: 1)),
    );
  }

  final remaining = next?.time.difference(now) ?? Duration.zero;

  return PrayerLiveState(
    currentPrayer: current,
    nextPrayer: next,
    timeRemaining: remaining.isNegative ? Duration.zero : remaining,
  );
});
