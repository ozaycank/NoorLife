import 'package:flutter/material.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../shared/widgets/empty_state_widget.dart';

class ActivityPlaceholderScreen extends StatelessWidget {
  const ActivityPlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.activityTitle),
      ),
      body: SafeArea(
        child: EmptyStateWidget(
          icon: Icons.track_changes_outlined,
          title: l10n.activityTitle,
          description: l10n.activityDesc,
        ),
      ),
    );
  }
}
