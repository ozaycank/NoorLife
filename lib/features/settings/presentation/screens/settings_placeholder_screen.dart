import 'package:flutter/material.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../shared/widgets/empty_state_widget.dart';

class SettingsPlaceholderScreen extends StatelessWidget {
  const SettingsPlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settingsTitle),
      ),
      body: SafeArea(
        child: EmptyStateWidget(
          icon: Icons.settings_applications_outlined,
          title: l10n.settingsTitle,
          description: l10n.settingsDesc,
        ),
      ),
    );
  }
}
