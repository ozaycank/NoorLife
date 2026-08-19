import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../shared/design_system/tokens/app_spacing.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/primary_button.dart';
import '../../../../shared/widgets/section_header.dart';
import '../../../prayer/location/application/providers/location_notifier.dart';
import '../../../prayer/location/application/states/location_state.dart';
import '../../../prayer/prayer_times/application/providers/prayer_times_notifier.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  Future<void> _refreshLocation(BuildContext context, WidgetRef ref) async {
    final success = await ref
        .read(locationNotifierProvider.notifier)
        .acquireDeviceLocation();

    if (success && context.mounted) {
      await ref.read(prayerTimesNotifierProvider.notifier).refreshTimes();
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final locState = ref.watch(locationNotifierProvider);
    final textTheme = context.textTheme;
    final colorScheme = context.colorScheme;

    final location = locState.location;
    final isLoading = locState.status == LocationStatus.requesting;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settingsTitle),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            SectionHeader(title: l10n.locationTitle),
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        color: colorScheme.primary,
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Text(
                          location != null
                              ? '${location.cityName}, ${location.countryName}'
                              : l10n.locationUnavailable,
                          style: textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: AppSpacing.xl),
                  _InfoRow(
                    label: l10n.timezoneLabel,
                    value: location?.timezoneIdentifier ?? '-',
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  _InfoRow(
                    label: l10n.coordinatesLabel,
                    value: location != null
                        ? '${location.latitude.toStringAsFixed(4)}, ${location.longitude.toStringAsFixed(4)}'
                        : '-',
                  ),
                  if (locState.failure != null) ...[
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      locState.failure!.message,
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.error,
                      ),
                    ),
                  ],
                  const SizedBox(height: AppSpacing.lg),
                  SizedBox(
                    width: double.infinity,
                    child: PrimaryButton(
                      text: l10n.refreshLocation,
                      icon: Icons.my_location,
                      isLoading: isLoading,
                      onPressed: () => _refreshLocation(context, ref),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    final colorScheme = context.colorScheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        Text(
          value,
          style: textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
