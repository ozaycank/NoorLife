import 'package:flutter/material.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../shared/design_system/tokens/app_border_radius.dart';
import '../../../../shared/design_system/tokens/app_spacing.dart';

class PrayerSettingsTile extends StatelessWidget {
  final String title;
  final String currentValue;
  final VoidCallback onTap;

  const PrayerSettingsTile({
    super.key,
    required this.title,
    required this.currentValue,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    final colorScheme = context.colorScheme;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: AppBorderRadius.medium,
      ),
      child: ListTile(
        onTap: onTap,
        shape: const RoundedRectangleBorder(
          borderRadius: AppBorderRadius.medium,
        ),
        title: Text(
          title,
          style: textTheme.titleMedium,
        ),
        subtitle: Text(
          currentValue,
          style: textTheme.bodyMedium?.copyWith(
            color: colorScheme.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}
