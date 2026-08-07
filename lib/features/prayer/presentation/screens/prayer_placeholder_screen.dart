import 'package:flutter/material.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../shared/widgets/empty_state_widget.dart';

class PrayerPlaceholderScreen extends StatelessWidget {
  const PrayerPlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.prayerTitle),
      ),
      body: SafeArea(
        child: EmptyStateWidget(
          icon: Icons.access_time_outlined,
          title: l10n.prayerTitle,
          description: l10n.prayerDesc,
        ),
      ),
    );
  }
}
