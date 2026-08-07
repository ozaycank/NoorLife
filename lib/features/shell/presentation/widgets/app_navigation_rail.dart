import 'package:flutter/material.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../shared/design_system/tokens/app_icons.dart';

class AppNavigationRail extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  const AppNavigationRail({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return NavigationRail(
      selectedIndex: selectedIndex,
      onDestinationSelected: onDestinationSelected,
      labelType: NavigationRailLabelType.all,
      destinations: [
        NavigationRailDestination(
          icon: const Icon(AppIcons.home),
          selectedIcon: const Icon(AppIcons.homeSelected),
          label: Text(l10n.navHome),
        ),
        NavigationRailDestination(
          icon: const Icon(AppIcons.prayer),
          selectedIcon: const Icon(AppIcons.prayerSelected),
          label: Text(l10n.navPrayer),
        ),
        NavigationRailDestination(
          icon: const Icon(AppIcons.quran),
          selectedIcon: const Icon(AppIcons.quranSelected),
          label: Text(l10n.navQuran),
        ),
        NavigationRailDestination(
          icon: const Icon(AppIcons.activity),
          selectedIcon: const Icon(AppIcons.activitySelected),
          label: Text(l10n.navActivity),
        ),
        NavigationRailDestination(
          icon: const Icon(AppIcons.profile),
          selectedIcon: const Icon(AppIcons.profileSelected),
          label: Text(l10n.navProfile),
        ),
      ],
    );
  }
}
