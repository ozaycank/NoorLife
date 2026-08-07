import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_tr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('tr')
  ];

  /// Application title
  ///
  /// In en, this message translates to:
  /// **'NoorLife'**
  String get appTitle;

  /// Splash loading text
  ///
  /// In en, this message translates to:
  /// **'Loading application...'**
  String get splashLoading;

  /// General error message
  ///
  /// In en, this message translates to:
  /// **'An unexpected error occurred. Please try again.'**
  String get generalError;

  /// Login title
  ///
  /// In en, this message translates to:
  /// **'Welcome Back'**
  String get loginTitle;

  /// Login subtitle
  ///
  /// In en, this message translates to:
  /// **'Sign in to continue your daily spiritual journey.'**
  String get loginSubtitle;

  /// Email input label
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get emailLabel;

  /// Password input label
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get passwordLabel;

  /// Confirm password input label
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPasswordLabel;

  /// Remember me checkbox text
  ///
  /// In en, this message translates to:
  /// **'Remember me'**
  String get rememberMe;

  /// Forgot password link text
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPassword;

  /// Sign in button text
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get loginButton;

  /// Guest login button text
  ///
  /// In en, this message translates to:
  /// **'Continue as Guest'**
  String get guestLoginButton;

  /// No account text
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? '**
  String get noAccountText;

  /// Register link text
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get registerLink;

  /// Register title
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get registerTitle;

  /// Register subtitle
  ///
  /// In en, this message translates to:
  /// **'Join NoorLife and organize your Islamic daily life.'**
  String get registerSubtitle;

  /// Register button text
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get registerButton;

  /// Already have account text
  ///
  /// In en, this message translates to:
  /// **'Already have an account? '**
  String get alreadyHaveAccountText;

  /// Login link text
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get loginLink;

  /// Forgot password title
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get forgotPasswordTitle;

  /// Forgot password subtitle
  ///
  /// In en, this message translates to:
  /// **'Enter your registered email address to receive a password reset link.'**
  String get forgotPasswordSubtitle;

  /// Send reset link button text
  ///
  /// In en, this message translates to:
  /// **'Send Reset Link'**
  String get sendResetLinkButton;

  /// Reset link sent success message
  ///
  /// In en, this message translates to:
  /// **'Password reset link has been sent to your email.'**
  String get resetEmailSentSuccess;

  /// Email verification title
  ///
  /// In en, this message translates to:
  /// **'Verify Your Email'**
  String get emailVerificationTitle;

  /// Email verification subtitle
  ///
  /// In en, this message translates to:
  /// **'We have sent a verification email to your address. Please verify your account to continue.'**
  String get emailVerificationSubtitle;

  /// Check verification button text
  ///
  /// In en, this message translates to:
  /// **'I Have Verified'**
  String get checkVerificationButton;

  /// Resend verification button text
  ///
  /// In en, this message translates to:
  /// **'Resend Verification Email'**
  String get resendEmailButton;

  /// Cooldown timer text
  ///
  /// In en, this message translates to:
  /// **'Resend available in {seconds}s'**
  String resendCooldownText(int seconds);

  /// Verification email sent message
  ///
  /// In en, this message translates to:
  /// **'Verification email resent successfully.'**
  String get verificationEmailSent;

  /// Email not verified yet warning
  ///
  /// In en, this message translates to:
  /// **'Your email is not verified yet. Please check your inbox.'**
  String get emailNotVerifiedYet;

  /// Logout button text
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get logoutButton;

  /// Empty email validation
  ///
  /// In en, this message translates to:
  /// **'Please enter an email address.'**
  String get validationEmailEmpty;

  /// Invalid email validation
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address.'**
  String get validationEmailInvalid;

  /// Empty password validation
  ///
  /// In en, this message translates to:
  /// **'Please enter a password.'**
  String get validationPasswordEmpty;

  /// Password length validation
  ///
  /// In en, this message translates to:
  /// **'Password must be between 8 and 64 characters.'**
  String get validationPasswordLength;

  /// Password strength validation
  ///
  /// In en, this message translates to:
  /// **'Password must contain uppercase, lowercase and numbers.'**
  String get validationPasswordStrength;

  /// Empty confirm password validation
  ///
  /// In en, this message translates to:
  /// **'Please confirm your password.'**
  String get validationConfirmPasswordEmpty;

  /// Password mismatch validation
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match.'**
  String get validationPasswordMismatch;

  /// Whitespace check validation
  ///
  /// In en, this message translates to:
  /// **'This field cannot contain spaces.'**
  String get validationNoWhitespace;

  /// Bottom navigation Home label
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// Bottom navigation Prayer label
  ///
  /// In en, this message translates to:
  /// **'Prayer'**
  String get navPrayer;

  /// Bottom navigation Quran label
  ///
  /// In en, this message translates to:
  /// **'Quran'**
  String get navQuran;

  /// Bottom navigation Activity label
  ///
  /// In en, this message translates to:
  /// **'Activity'**
  String get navActivity;

  /// Bottom navigation Profile label
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// Home placeholder page title
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get homeTitle;

  /// Home placeholder page description
  ///
  /// In en, this message translates to:
  /// **'Welcome to NoorLife. Your daily spiritual overview will appear here.'**
  String get homeDesc;

  /// Prayer placeholder page title
  ///
  /// In en, this message translates to:
  /// **'Prayer Times'**
  String get prayerTitle;

  /// Prayer placeholder page description
  ///
  /// In en, this message translates to:
  /// **'Accurate prayer times and qibla direction will be displayed here.'**
  String get prayerDesc;

  /// Quran placeholder page title
  ///
  /// In en, this message translates to:
  /// **'Al-Quran'**
  String get quranTitle;

  /// Quran placeholder page description
  ///
  /// In en, this message translates to:
  /// **'Holy Quran reading, audio recitations, and bookmarks will be available here.'**
  String get quranDesc;

  /// Activity placeholder page title
  ///
  /// In en, this message translates to:
  /// **'Worship Activity'**
  String get activityTitle;

  /// Activity placeholder page description
  ///
  /// In en, this message translates to:
  /// **'Track your daily prayers, dhikr, and fasting progress here.'**
  String get activityDesc;

  /// Profile placeholder page title
  ///
  /// In en, this message translates to:
  /// **'User Profile'**
  String get profileTitle;

  /// Profile placeholder page description
  ///
  /// In en, this message translates to:
  /// **'Manage your NoorLife account, preferences, and personal statistics.'**
  String get profileDesc;

  /// Settings placeholder page title
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// Settings placeholder page description
  ///
  /// In en, this message translates to:
  /// **'Configure notifications, calculation methods, and app themes.'**
  String get settingsDesc;

  /// Open settings button label
  ///
  /// In en, this message translates to:
  /// **'Open Settings'**
  String get openSettingsButton;

  /// Default empty state title
  ///
  /// In en, this message translates to:
  /// **'No Content Available'**
  String get emptyStateDefaultTitle;

  /// Default empty state description
  ///
  /// In en, this message translates to:
  /// **'This module is currently under development for a future phase.'**
  String get emptyStateDefaultDesc;

  /// Default error state title
  ///
  /// In en, this message translates to:
  /// **'Something Went Wrong'**
  String get errorStateDefaultTitle;

  /// Retry button label
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retryButton;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'tr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'tr':
      return AppLocalizationsTr();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
