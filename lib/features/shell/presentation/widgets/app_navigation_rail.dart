import 'package:flutter/material.dart';
import '../../../../core/extensions/context_extensions.dart';

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
          icon: const Icon(Icons.home_outlined),
          selectedIcon: const Icon(Icons.home),
          label: Text(l10n.navHome),
        ),
        NavigationRailDestination(
          icon: const Icon(Icons.access_time_outlined),
          selectedIcon: const Icon(Icons.access_time_filled),
          label: Text(l10n.navPrayer),
        ),
        NavigationRailDestination(
          icon: const Icon(Icons.menu_book_outlined),
          selectedIcon: const Icon(Icons.menu_book),
          label: Text(l10n.navQuran),
        ),
        NavigationRailDestination(
          icon: const Icon(Icons.track_changes_outlined),
          selectedIcon: const Icon(Icons.track_changes),
          label: Text(l10n.navActivity),
        ),
        NavigationRailDestination(
          icon: const Icon(Icons.person_outline),
          selectedIcon: const Icon(Icons.person),
          label: Text(l10n.navProfile),
        ),
      ],
    );
  }
}
