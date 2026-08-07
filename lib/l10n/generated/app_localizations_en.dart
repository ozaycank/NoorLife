// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'NoorLife';

  @override
  String get splashLoading => 'Loading application...';

  @override
  String get generalError => 'An unexpected error occurred. Please try again.';

  @override
  String get loginTitle => 'Welcome Back';

  @override
  String get loginSubtitle =>
      'Sign in to continue your daily spiritual journey.';

  @override
  String get emailLabel => 'Email Address';

  @override
  String get passwordLabel => 'Password';

  @override
  String get confirmPasswordLabel => 'Confirm Password';

  @override
  String get rememberMe => 'Remember me';

  @override
  String get forgotPassword => 'Forgot Password?';

  @override
  String get loginButton => 'Sign In';

  @override
  String get guestLoginButton => 'Continue as Guest';

  @override
  String get noAccountText => 'Don\'t have an account? ';

  @override
  String get registerLink => 'Sign Up';

  @override
  String get registerTitle => 'Create Account';

  @override
  String get registerSubtitle =>
      'Join NoorLife and organize your Islamic daily life.';

  @override
  String get registerButton => 'Create Account';

  @override
  String get alreadyHaveAccountText => 'Already have an account? ';

  @override
  String get loginLink => 'Sign In';

  @override
  String get forgotPasswordTitle => 'Reset Password';

  @override
  String get forgotPasswordSubtitle =>
      'Enter your registered email address to receive a password reset link.';

  @override
  String get sendResetLinkButton => 'Send Reset Link';

  @override
  String get resetEmailSentSuccess =>
      'Password reset link has been sent to your email.';

  @override
  String get emailVerificationTitle => 'Verify Your Email';

  @override
  String get emailVerificationSubtitle =>
      'We have sent a verification email to your address. Please verify your account to continue.';

  @override
  String get checkVerificationButton => 'I Have Verified';

  @override
  String get resendEmailButton => 'Resend Verification Email';

  @override
  String resendCooldownText(int seconds) {
    return 'Resend available in ${seconds}s';
  }

  @override
  String get verificationEmailSent => 'Verification email resent successfully.';

  @override
  String get emailNotVerifiedYet =>
      'Your email is not verified yet. Please check your inbox.';

  @override
  String get logoutButton => 'Sign Out';

  @override
  String get validationEmailEmpty => 'Please enter an email address.';

  @override
  String get validationEmailInvalid => 'Please enter a valid email address.';

  @override
  String get validationPasswordEmpty => 'Please enter a password.';

  @override
  String get validationPasswordLength =>
      'Password must be between 8 and 64 characters.';

  @override
  String get validationPasswordStrength =>
      'Password must contain uppercase, lowercase and numbers.';

  @override
  String get validationConfirmPasswordEmpty => 'Please confirm your password.';

  @override
  String get validationPasswordMismatch => 'Passwords do not match.';

  @override
  String get validationNoWhitespace => 'This field cannot contain spaces.';

  @override
  String get navHome => 'Home';

  @override
  String get navPrayer => 'Prayer';

  @override
  String get navQuran => 'Quran';

  @override
  String get navActivity => 'Activity';

  @override
  String get navProfile => 'Profile';

  @override
  String get homeTitle => 'Home';

  @override
  String get homeDesc =>
      'Welcome to NoorLife. Your daily spiritual overview will appear here.';

  @override
  String get prayerTitle => 'Prayer Times';

  @override
  String get prayerDesc =>
      'Accurate prayer times and qibla direction will be displayed here.';

  @override
  String get quranTitle => 'Al-Quran';

  @override
  String get quranDesc =>
      'Holy Quran reading, audio recitations, and bookmarks will be available here.';

  @override
  String get activityTitle => 'Worship Activity';

  @override
  String get activityDesc =>
      'Track your daily prayers, dhikr, and fasting progress here.';

  @override
  String get profileTitle => 'User Profile';

  @override
  String get profileDesc =>
      'Manage your NoorLife account, preferences, and personal statistics.';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsDesc =>
      'Configure notifications, calculation methods, and app themes.';

  @override
  String get openSettingsButton => 'Open Settings';

  @override
  String get emptyStateDefaultTitle => 'No Content Available';

  @override
  String get emptyStateDefaultDesc =>
      'This module is currently under development for a future phase.';

  @override
  String get errorStateDefaultTitle => 'Something Went Wrong';

  @override
  String get retryButton => 'Retry';
}
