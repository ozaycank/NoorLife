import 'package:flutter/material.dart';
import '../../../../../shared/design_system/tokens/app_spacing.dart';
import '../../../../../shared/widgets/app_card.dart';
import '../../domain/entities/prayer_time.dart';
import 'prayer_time_tile.dart';

class PrayerCard extends StatelessWidget {
  final List<PrayerTime> prayerTimes;

  const PrayerCard({
    super.key,
    required this.prayerTimes,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        children: prayerTimes
            .map(
              (time) => PrayerTimeTile(
                name: time.name,
                formattedTime: time.formattedTime,
                isNext: time.isNext,
              ),
            )
            .toList(),
      ),
    );
  }
}
