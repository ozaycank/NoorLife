import 'package:flutter/material.dart';
import '../logging/logger_service.dart';

class AppNavigationObserver extends NavigatorObserver {
  final LoggerService _logger;

  AppNavigationObserver(this._logger);

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    _logNavigation('PUSH', route, previousRoute);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    _logNavigation('POP', route, previousRoute);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    _logNavigation('REPLACE', newRoute, oldRoute);
  }

  void _logNavigation(
    String action,
    Route<dynamic>? targetRoute,
    Route<dynamic>? previousRoute,
  ) {
    final targetName = targetRoute?.settings.name ??
        targetRoute?.settings.arguments ??
        targetRoute?.toString() ??
        'unnamed_route';
    _logger.debug('[NAVIGATION $action] -> $targetName');
  }
}
