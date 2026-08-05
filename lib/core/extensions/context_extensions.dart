import 'package:flutter/material.dart';
import '../../l10n/generated/app_localizations.dart';

extension ContextExtensions on BuildContext {
  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => Theme.of(this).textTheme;
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
  Size get screenSize => MediaQuery.sizeOf(this);
  AppLocalizations get l10n => AppLocalizations.of(this)!;
}
