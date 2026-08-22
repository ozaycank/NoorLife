import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../shared/design_system/tokens/app_spacing.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/error_state_widget.dart';
import '../../../../shared/widgets/section_header.dart';
import '../application/qibla_provider.dart';

class QiblaDirectionFormatter {
  QiblaDirectionFormatter._();

  static String format(BuildContext context, double bearing) {
    final l10n = context.l10n;
    final normalized = (bearing + 360.0) % 360.0;

    if (normalized >= 337.5 || normalized < 22.5) return l10n.dirNorth;
    if (normalized >= 22.5 && normalized < 67.5) return l10n.dirNorthEast;
    if (normalized >= 67.5 && normalized < 112.5) return l10n.dirEast;
    if (normalized >= 112.5 && normalized < 157.5) return l10n.dirSouthEast;
    if (normalized >= 157.5 && normalized < 202.5) return l10n.dirSouth;
    if (normalized >= 202.5 && normalized < 247.5) return l10n.dirSouthWest;
    if (normalized >= 247.5 && normalized < 292.5) return l10n.dirWest;
    return l10n.dirNorthWest;
  }
}

class QiblaScreen extends ConsumerWidget {
  const QiblaScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final state = ref.watch(qiblaProvider);
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
                message: state.failure?.message ?? l10n.qiblaCalculationError,
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
                          QiblaDirectionFormatter.format(
                            context,
                            state.direction!.bearingDegrees,
                          ),
                          style: textTheme.titleLarge?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xl),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
