import 'package:flutter/material.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../shared/design_system/tokens/app_icons.dart';

class AppBottomNavigation extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  const AppBottomNavigation({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return NavigationBarTheme(
      data: NavigationBarThemeData(
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return context.textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.bold,
            );
          }
          return context.textTheme.labelSmall;
        }),
      ),
      child: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: onDestinationSelected,
        destinations: [
          NavigationDestination(
            icon: const Icon(AppIcons.home),
            selectedIcon: const Icon(AppIcons.homeSelected),
            label: l10n.navHome,
          ),
          NavigationDestination(
            icon: const Icon(AppIcons.prayer),
            selectedIcon: const Icon(AppIcons.prayerSelected),
            label: l10n.navPrayer,
          ),
          NavigationDestination(
            icon: const Icon(AppIcons.quran),
            selectedIcon: const Icon(AppIcons.quranSelected),
            label: l10n.navQuran,
          ),
          NavigationDestination(
            icon: const Icon(AppIcons.activity),
            selectedIcon: const Icon(AppIcons.activitySelected),
            label: l10n.navActivity,
          ),
          NavigationDestination(
            icon: const Icon(AppIcons.profile),
            selectedIcon: const Icon(AppIcons.profileSelected),
            label: l10n.navProfile,
          ),
        ],
      ),
    );
  }
}
