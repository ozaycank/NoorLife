import 'package:flutter/material.dart';
import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../shared/widgets/empty_state_widget.dart';

class PrayerEmptyWidget extends StatelessWidget {
  const PrayerEmptyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return EmptyStateWidget(
      icon: Icons.access_time_outlined,
      title: l10n.emptyStateDefaultTitle,
      description: l10n.emptyStateDefaultDesc,
    );
  }
}
