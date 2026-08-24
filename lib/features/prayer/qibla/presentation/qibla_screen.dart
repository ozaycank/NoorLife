import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../../shared/design_system/tokens/app_spacing.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/error_state_widget.dart';
import '../../../../shared/widgets/section_header.dart';
import '../application/qibla_compass_provider.dart';
import '../application/qibla_provider.dart';
import '../domain/qibla_models.dart';

class QiblaScreen extends ConsumerWidget {
  const QiblaScreen({super.key});

  String _getLocalizedDirection(CompassDirection dir, AppLocalizations l10n) {
    switch (dir) {
      case CompassDirection.n:
        return l10n.dirNorth;
      case CompassDirection.ne:
        return l10n.dirNorthEast;
      case CompassDirection.e:
        return l10n.dirEast;
      case CompassDirection.se:
        return l10n.dirSouthEast;
      case CompassDirection.s:
        return l10n.dirSouth;
      case CompassDirection.sw:
        return l10n.dirSouthWest;
      case CompassDirection.w:
        return l10n.dirWest;
      case CompassDirection.nw:
        return l10n.dirNorthWest;
    }
  }

  Widget _buildCompassSection(BuildContext context, QiblaCompassState state) {
    final l10n = context.l10n;
    final colorScheme = context.colorScheme;
    final textTheme = context.textTheme;

    if (state.status == CompassStatus.unsupportedPlatform) {
      return Text(l10n.compassUnsupportedPlatform);
    }
    if (state.status == CompassStatus.sensorUnavailable) {
      return Text(l10n.compassSensorUnavailable);
    }
    if (state.status == CompassStatus.error) {
      return Text(state.failure?.message ?? l10n.compassError);
    }
    if (state.deviceHeading == null || state.relativeQiblaAngle == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final relative = state.relativeQiblaAngle!;
    String directionText;
    IconData dirIcon;

    if (relative.abs() < 2.0) {
      directionText = l10n.qiblaAligned;
      dirIcon = Icons.check_circle;
    } else if (relative > 0) {
      directionText = l10n.turnRight(relative.abs().toStringAsFixed(1));
      dirIcon = Icons.turn_right;
    } else {
      directionText = l10n.turnLeft(relative.abs().toStringAsFixed(1));
      dirIcon = Icons.turn_left;
    }

    return Column(
      children: [
        _InfoRow(
          label: l10n.qiblaHeading,
          value: '${state.deviceHeading!.toStringAsFixed(1)}°',
        ),
        _InfoRow(
          label: l10n.qiblaRelativeAngle,
          value: '${relative > 0 ? '+' : ''}${relative.toStringAsFixed(1)}°',
        ),
        const SizedBox(height: AppSpacing.xl),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(dirIcon, color: colorScheme.primary, size: 28),
            const SizedBox(width: AppSpacing.sm),
            Text(directionText, style: textTheme.titleLarge),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final state = ref.watch(qiblaProvider);
    final compassState = ref.watch(qiblaCompassProvider);
    final colorScheme = context.colorScheme;
    final textTheme = context.textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.qiblaTitle),
      ),
      body: SafeArea(
        child: state.status == QiblaStatus.failure || state.direction == null
            ? ErrorStateWidget(
                title: l10n.qiblaUnavailable,
                message: state.failure?.code == 'qiblaUndefinedAtKaaba'
                    ? l10n.qiblaUndefinedAtKaaba
                    : (state.failure?.message ?? l10n.qiblaCalculationError),
                retryText: l10n.retryButton,
              )
            : ListView(
                padding: const EdgeInsets.all(AppSpacing.lg),
                children: [
                  SectionHeader(title: l10n.qiblaLocation),
                  AppCard(
                    child: Row(
                      children: [
                        Icon(Icons.location_on, color: colorScheme.primary),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: Text(
                            state.locationName ?? '-',
                            style: textTheme.titleMedium,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  SectionHeader(title: l10n.qiblaDirection),
                  AppCard(
                    child: Column(
                      children: [
                        const SizedBox(height: AppSpacing.xl),
                        Icon(
                          Icons.explore,
                          size: 80,
                          color: colorScheme.primary,
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        Text(
                          '${state.direction!.bearingDegrees.toStringAsFixed(1)}°',
                          style: textTheme.headlineLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: colorScheme.primary,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          _getLocalizedDirection(
                            state.direction!.compassDirection,
                            l10n,
                          ),
                          style: textTheme.titleLarge?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xxl),
                        Text(
                          l10n.qiblaDisclaimer,
                          textAlign: TextAlign.center,
                          style: textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  SectionHeader(title: l10n.qiblaCompass),
                  AppCard(
                    child: _buildCompassSection(context, compassState),
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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Row(
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
      ),
    );
  }
}
