import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/design_system/tokens/app_breakpoints.dart';
import '../widgets/app_bottom_navigation.dart';
import '../widgets/app_navigation_rail.dart';

class AppShellScreen extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const AppShellScreen({
    super.key,
    required this.navigationShell,
  });

  void _onDestinationSelected(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isTabletOrLandscape = AppBreakpoints.isTabletOrLandscape(context);

    return Scaffold(
      body: isTabletOrLandscape
          ? Row(
              children: [
                AppNavigationRail(
                  selectedIndex: navigationShell.currentIndex,
                  onDestinationSelected: _onDestinationSelected,
                ),
                const VerticalDivider(thickness: 1, width: 1),
                Expanded(child: navigationShell),
              ],
            )
          : navigationShell,
      bottomNavigationBar: isTabletOrLandscape
          ? null
          : AppBottomNavigation(
              selectedIndex: navigationShell.currentIndex,
              onDestinationSelected: _onDestinationSelected,
            ),
    );
  }
}
