import '../../../../l10n/generated/app_localizations.dart';

class AuthValidators {
  AuthValidators._();

  static String? validateEmail(String? value, AppLocalizations l10n) {
    if (value == null || value.trim().isEmpty) {
      return l10n.validationEmailEmpty;
    }
    if (value.contains(' ')) {
      return l10n.validationNoWhitespace;
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
    if (value.contains(' ')) {
      return l10n.validationNoWhitespace;
    }
    if (value.length < 8 || value.length > 64) {
      return l10n.validationPasswordLength;
    }
    final strengthRegex = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).*$');
    if (!strengthRegex.hasMatch(value)) {
      return l10n.validationPasswordStrength;
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
