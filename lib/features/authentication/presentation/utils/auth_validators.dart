import '../../../../l10n/generated/app_localizations.dart';

class AuthValidators {
  AuthValidators._();

  static String? validateEmail(String? value, AppLocalizations l10n) {
    if (value == null || value.trim().isEmpty) {
      return l10n.validationEmailEmpty;
    }
    final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!emailRegex.hasMatch(value.trim())) {
      return l10n.validationEmailInvalid;
    }
    return null;
  }

  static String? validatePassword(String? value, AppLocalizations l10n) {
    if (value == null || value.isEmpty) {
      return l10n.validationPasswordEmpty;
    }
    if (value.length < 6) {
      return l10n.validationPasswordLength;
    }
    return null;
  }

  static String? validateConfirmPassword(
    String? value,
    String? password,
    AppLocalizations l10n,
  ) {
    if (value == null || value.isEmpty) {
      return l10n.validationConfirmPasswordEmpty;
    }
    if (value != password) {
      return l10n.validationPasswordMismatch;
    }
    return null;
  }
}
