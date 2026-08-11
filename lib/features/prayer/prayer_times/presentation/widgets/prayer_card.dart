import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../../shared/design_system/tokens/app_spacing.dart';
import '../../../../../shared/widgets/app_card.dart';
import '../../domain/entities/prayer_time.dart';
import '../providers/prayer_live_state_provider.dart';
import 'prayer_time_tile.dart';

class PrayerCard extends StatelessWidget {
  final List<PrayerTime> prayerTimes;
  final PrayerLiveState liveState;

  const PrayerCard({
    super.key,
    required this.prayerTimes,
    required this.liveState,
  });

  @override
  Widget build(BuildContext context) {
    final formatter = DateFormat('HH:mm');

    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        children: prayerTimes.map((time) {
          final isNext = liveState.nextPrayer?.name == time.name;
          return PrayerTimeTile(
            name: time.name,
            formattedTime: formatter.format(time.time),
            isNext: isNext,
          );
        }).toList(),
      ),
    );
  }
}
