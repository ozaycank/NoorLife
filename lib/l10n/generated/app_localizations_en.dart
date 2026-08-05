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
      'Password must be at least 6 characters.';

  @override
  String get validationConfirmPasswordEmpty => 'Please confirm your password.';

  @override
  String get validationPasswordMismatch => 'Passwords do not match.';
}
