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

  /// Fajr prayer name
  ///
  /// In en, this message translates to:
  /// **'Fajr'**
  String get prayerFajr;

  /// Sunrise time
  ///
  /// In en, this message translates to:
  /// **'Sunrise'**
  String get prayerSunrise;

  /// Dhuhr prayer name
  ///
  /// In en, this message translates to:
  /// **'Dhuhr'**
  String get prayerDhuhr;

  /// Asr prayer name
  ///
  /// In en, this message translates to:
  /// **'Asr'**
  String get prayerAsr;

  /// Maghrib prayer name
  ///
  /// In en, this message translates to:
  /// **'Maghrib'**
  String get prayerMaghrib;

  /// Isha prayer name
  ///
  /// In en, this message translates to:
  /// **'Isha'**
  String get prayerIsha;

  /// Next prayer label
  ///
  /// In en, this message translates to:
  /// **'Next Prayer'**
  String get prayerNextPrayer;

  /// Remaining time label
  ///
  /// In en, this message translates to:
  /// **'Remaining Time'**
  String get prayerRemainingTime;

  /// Calculation method setting label
  ///
  /// In en, this message translates to:
  /// **'Calculation Method'**
  String get prayerCalculationMethod;

  /// Madhab setting label
  ///
  /// In en, this message translates to:
  /// **'Madhab / Juristic Method'**
  String get prayerMadhab;

  /// Prayer location header
  ///
  /// In en, this message translates to:
  /// **'Prayer Location'**
  String get prayerLocationHeader;

  /// Refresh times button
  ///
  /// In en, this message translates to:
  /// **'Refresh Times'**
  String get prayerRefreshButton;

  /// Prayer settings screen title
  ///
  /// In en, this message translates to:
  /// **'Prayer Settings'**
  String get prayerSettingsTitle;

  /// Prayer settings screen description
  ///
  /// In en, this message translates to:
  /// **'Adjust your calculation methods and juristic preferences.'**
  String get prayerSettingsDesc;

  /// Location settings section title
  ///
  /// In en, this message translates to:
  /// **'Location Settings'**
  String get locationTitle;

  /// Fallback city name
  ///
  /// In en, this message translates to:
  /// **'Current Location'**
  String get currentLocation;

  /// Refresh location button text
  ///
  /// In en, this message translates to:
  /// **'Refresh Location'**
  String get refreshLocation;

  /// Location missing fallback
  ///
  /// In en, this message translates to:
  /// **'Location Unavailable'**
  String get locationUnavailable;

  /// Location permission denied error
  ///
  /// In en, this message translates to:
  /// **'Location permission is required.'**
  String get locationPermissionDenied;

  /// Location service disabled error
  ///
  /// In en, this message translates to:
  /// **'Location services are disabled.'**
  String get locationServiceDisabled;

  /// Geocoding failure message
  ///
  /// In en, this message translates to:
  /// **'Failed to resolve address.'**
  String get locationGeocodingFailed;

  /// Timezone display label
  ///
  /// In en, this message translates to:
  /// **'Timezone'**
  String get timezoneLabel;

  /// Coordinates display label
  ///
  /// In en, this message translates to:
  /// **'Coordinates'**
  String get coordinatesLabel;

  /// Unknown country fallback
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get unknownCountry;

  /// Prayer calculation title
  ///
  /// In en, this message translates to:
  /// **'Prayer Calculation'**
  String get prayerCalculationTitle;

  /// Calculation method label
  ///
  /// In en, this message translates to:
  /// **'Calculation Method'**
  String get calculationMethodLabel;

  /// Madhab label
  ///
  /// In en, this message translates to:
  /// **'Madhab / Juristic Method'**
  String get madhabLabel;

  /// High latitude strategy label
  ///
  /// In en, this message translates to:
  /// **'High Latitude Strategy'**
  String get highLatitudeStrategyLabel;

  /// Calculation method saved message
  ///
  /// In en, this message translates to:
  /// **'Settings saved successfully.'**
  String get calculationMethodSaved;

  /// Settings save failed message
  ///
  /// In en, this message translates to:
  /// **'Failed to save settings.'**
  String get settingsSaveFailed;

  /// Angle based label
  ///
  /// In en, this message translates to:
  /// **'Angle Based'**
  String get angleBasedLabel;

  /// One seventh label
  ///
  /// In en, this message translates to:
  /// **'One Seventh'**
  String get oneSeventhLabel;

  /// Middle of the night label
  ///
  /// In en, this message translates to:
  /// **'Middle of the Night'**
  String get nightMiddleLabel;

  /// None label
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get noneLabel;

  /// Qibla direction title
  ///
  /// In en, this message translates to:
  /// **'Qibla Direction'**
  String get qiblaTitle;

  /// Qibla direction label
  ///
  /// In en, this message translates to:
  /// **'Direction'**
  String get qiblaDirection;

  /// Qibla bearing label
  ///
  /// In en, this message translates to:
  /// **'Bearing'**
  String get qiblaBearing;

  /// Qibla location label
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get qiblaLocation;

  /// Qibla unavailable message
  ///
  /// In en, this message translates to:
  /// **'Qibla calculation unavailable. Please ensure your location is set.'**
  String get qiblaUnavailable;

  /// Qibla calculation error message
  ///
  /// In en, this message translates to:
  /// **'Failed to calculate Qibla direction.'**
  String get qiblaCalculationError;

  /// North direction
  ///
  /// In en, this message translates to:
  /// **'N'**
  String get dirNorth;

  /// North east direction
  ///
  /// In en, this message translates to:
  /// **'NE'**
  String get dirNorthEast;

  /// East direction
  ///
  /// In en, this message translates to:
  /// **'E'**
  String get dirEast;

  /// South east direction
  ///
  /// In en, this message translates to:
  /// **'SE'**
  String get dirSouthEast;

  /// South direction
  ///
  /// In en, this message translates to:
  /// **'S'**
  String get dirSouth;

  /// South west direction
  ///
  /// In en, this message translates to:
  /// **'SW'**
  String get dirSouthWest;

  /// West direction
  ///
  /// In en, this message translates to:
  /// **'W'**
  String get dirWest;

  /// North west direction
  ///
  /// In en, this message translates to:
  /// **'NW'**
  String get dirNorthWest;

  /// Qibla disclaimer text
  ///
  /// In en, this message translates to:
  /// **'Calculated from your current location. Turn-by-turn compass guidance is not enabled yet.'**
  String get qiblaDisclaimer;

  /// Qibla undefined at Kaaba message
  ///
  /// In en, this message translates to:
  /// **'You are at the Kaaba. Qibla direction is undefined.'**
  String get qiblaUndefinedAtKaaba;

  /// Qibla compass title
  ///
  /// In en, this message translates to:
  /// **'Qibla Compass'**
  String get qiblaCompass;

  /// Qibla heading label
  ///
  /// In en, this message translates to:
  /// **'Device Heading'**
  String get qiblaHeading;

  /// Qibla relative angle label
  ///
  /// In en, this message translates to:
  /// **'Relative Angle'**
  String get qiblaRelativeAngle;

  /// No description provided for @turnLeft.
  ///
  /// In en, this message translates to:
  /// **'Turn left {degrees}°'**
  String turnLeft(String degrees);

  /// No description provided for @turnRight.
  ///
  /// In en, this message translates to:
  /// **'Turn right {degrees}°'**
  String turnRight(String degrees);

  /// Qibla aligned message
  ///
  /// In en, this message translates to:
  /// **'Aligned with Qibla'**
  String get qiblaAligned;

  /// Compass unavailable title
  ///
  /// In en, this message translates to:
  /// **'Compass Unavailable'**
  String get compassUnavailable;

  /// Compass sensor unavailable message
  ///
  /// In en, this message translates to:
  /// **'Your device does not have a compass sensor.'**
  String get compassSensorUnavailable;

  /// Compass unsupported platform message
  ///
  /// In en, this message translates to:
  /// **'Compass is not supported on this platform.'**
  String get compassUnsupportedPlatform;

  /// Compass error message
  ///
  /// In en, this message translates to:
  /// **'Failed to read compass sensor.'**
  String get compassError;

  /// App language label
  ///
  /// In en, this message translates to:
  /// **'App Language'**
  String get languageLabel;

  /// English language option
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// Turkish language option
  ///
  /// In en, this message translates to:
  /// **'Türkçe'**
  String get languageTurkish;

  /// MWL calculation method
  ///
  /// In en, this message translates to:
  /// **'Muslim World League'**
  String get methodMWL;

  /// ISNA calculation method
  ///
  /// In en, this message translates to:
  /// **'Islamic Society of North America'**
  String get methodISNA;

  /// Egypt calculation method
  ///
  /// In en, this message translates to:
  /// **'Egyptian General Authority'**
  String get methodEgypt;

  /// Makkah calculation method
  ///
  /// In en, this message translates to:
  /// **'Umm Al-Qura'**
  String get methodMakkah;

  /// Karachi calculation method
  ///
  /// In en, this message translates to:
  /// **'University of Islamic Sciences, Karachi'**
  String get methodKarachi;

  /// Tehran calculation method
  ///
  /// In en, this message translates to:
  /// **'Institute of Geophysics, University of Tehran'**
  String get methodTehran;

  /// Shia calculation method
  ///
  /// In en, this message translates to:
  /// **'Shia Ithna-Ashari'**
  String get methodShia;

  /// Gulf calculation method
  ///
  /// In en, this message translates to:
  /// **'Gulf Region'**
  String get methodGulf;

  /// Kuwait calculation method
  ///
  /// In en, this message translates to:
  /// **'Kuwait'**
  String get methodKuwait;

  /// Qatar calculation method
  ///
  /// In en, this message translates to:
  /// **'Qatar'**
  String get methodQatar;

  /// Singapore calculation method
  ///
  /// In en, this message translates to:
  /// **'Majlis Ugama Islam Singapura'**
  String get methodSingapore;

  /// France calculation method
  ///
  /// In en, this message translates to:
  /// **'Union des Organisations Islamiques de France'**
  String get methodFrance;

  /// Turkey calculation method
  ///
  /// In en, this message translates to:
  /// **'Diyanet Approximation Profile'**
  String get methodTurkey;

  /// Russia calculation method
  ///
  /// In en, this message translates to:
  /// **'Spiritual Administration of Muslims of Russia'**
  String get methodRussia;

  /// Moonsighting calculation method
  ///
  /// In en, this message translates to:
  /// **'Moonsighting Committee Worldwide'**
  String get methodMoonsighting;

  /// Dubai calculation method
  ///
  /// In en, this message translates to:
  /// **'Dubai'**
  String get methodDubai;

  /// Jakim calculation method
  ///
  /// In en, this message translates to:
  /// **'Jabatan Kemajuan Islam Malaysia'**
  String get methodJakim;

  /// Tunisia calculation method
  ///
  /// In en, this message translates to:
  /// **'Tunisian Ministry of Religious Affairs'**
  String get methodTunisia;

  /// Algeria calculation method
  ///
  /// In en, this message translates to:
  /// **'Algerian Ministry of Religious Affairs'**
  String get methodAlgeria;

  /// Kemenag calculation method
  ///
  /// In en, this message translates to:
  /// **'Indonesian Ministry of Religious Affairs'**
  String get methodKemenag;

  /// Morocco calculation method
  ///
  /// In en, this message translates to:
  /// **'Moroccan Ministry of Habous and Islamic Affairs'**
  String get methodMorocco;

  /// Portugal calculation method
  ///
  /// In en, this message translates to:
  /// **'Great Mosque of Paris'**
  String get methodPortugal;

  /// Jafari calculation method
  ///
  /// In en, this message translates to:
  /// **'Shia Ithna-Ashari'**
  String get methodJafari;

  /// Standard madhab option
  ///
  /// In en, this message translates to:
  /// **'Standard (Shafi / Maliki / Hanbali)'**
  String get madhabStandard;

  /// Hanafi madhab option
  ///
  /// In en, this message translates to:
  /// **'Hanafi'**
  String get madhabHanafi;

  /// Muharram hijri month
  ///
  /// In en, this message translates to:
  /// **'Muharram'**
  String get hijriMuharram;

  /// Safar hijri month
  ///
  /// In en, this message translates to:
  /// **'Safar'**
  String get hijriSafar;

  /// Rabi al-Awwal hijri month
  ///
  /// In en, this message translates to:
  /// **'Rabi\' al-Awwal'**
  String get hijriRabiAlAwwal;

  /// Rabi al-Thani hijri month
  ///
  /// In en, this message translates to:
  /// **'Rabi\' al-Thani'**
  String get hijriRabiAlThani;

  /// Jumada al-Awwal hijri month
  ///
  /// In en, this message translates to:
  /// **'Jumada al-Awwal'**
  String get hijriJumadaAlAwwal;

  /// Jumada al-Thani hijri month
  ///
  /// In en, this message translates to:
  /// **'Jumada al-Thani'**
  String get hijriJumadaAlThani;

  /// Rajab hijri month
  ///
  /// In en, this message translates to:
  /// **'Rajab'**
  String get hijriRajab;

  /// Shaaban hijri month
  ///
  /// In en, this message translates to:
  /// **'Sha\'ban'**
  String get hijriShaaban;

  /// Ramadan hijri month
  ///
  /// In en, this message translates to:
  /// **'Ramadan'**
  String get hijriRamadan;

  /// Shawwal hijri month
  ///
  /// In en, this message translates to:
  /// **'Shawwal'**
  String get hijriShawwal;

  /// Dhu al-Qi'dah hijri month
  ///
  /// In en, this message translates to:
  /// **'Dhu al-Qi\'dah'**
  String get hijriDhuAlQiDah;

  /// Dhu al-Hijjah hijri month
  ///
  /// In en, this message translates to:
  /// **'Dhu al-Hijjah'**
  String get hijriDhuAlHijjah;

  /// Asr calculation convention description
  ///
  /// In en, this message translates to:
  /// **'Asr calculation convention'**
  String get asrConventionDesc;

  /// Home greeting
  ///
  /// In en, this message translates to:
  /// **'Assalamu Alaikum'**
  String get homeGreeting;

  /// Home today's schedule section title
  ///
  /// In en, this message translates to:
  /// **'Today\'s Schedule'**
  String get homeToday;

  /// Home next prayer header
  ///
  /// In en, this message translates to:
  /// **'Next Prayer'**
  String get nextPrayerHeader;

  /// Home view qibla action
  ///
  /// In en, this message translates to:
  /// **'Qibla Direction'**
  String get viewQibla;

  /// Home open settings action
  ///
  /// In en, this message translates to:
  /// **'App Settings'**
  String get openSettings;

  /// Home prayer error state
  ///
  /// In en, this message translates to:
  /// **'Prayer times unavailable.'**
  String get homePrayerError;

  /// Home prayer retry button
  ///
  /// In en, this message translates to:
  /// **'Retry Location'**
  String get homePrayerRetry;

  /// Home coming soon label
  ///
  /// In en, this message translates to:
  /// **'Coming Soon'**
  String get homeComingSoon;

  /// Quran search input hint
  ///
  /// In en, this message translates to:
  /// **'Search Surah'**
  String get quranSearchHint;

  /// Quran empty search result
  ///
  /// In en, this message translates to:
  /// **'No Surah found.'**
  String get quranNoSurahFound;

  /// Quran meccan revelation type
  ///
  /// In en, this message translates to:
  /// **'Meccan'**
  String get quranMeccan;

  /// Quran medinan revelation type
  ///
  /// In en, this message translates to:
  /// **'Medinan'**
  String get quranMedinan;

  /// Quran ayah count formatting
  ///
  /// In en, this message translates to:
  /// **'{count} Ayahs'**
  String quranAyahCount(int count);

  /// Quran detail placeholder text
  ///
  /// In en, this message translates to:
  /// **'Quran text reader will be implemented in a later phase.'**
  String get quranDetailPlaceholderText;

  /// Quran continue reading button
  ///
  /// In en, this message translates to:
  /// **'Continue Reading'**
  String get quranContinueReading;

  /// Quran last read label
  ///
  /// In en, this message translates to:
  /// **'Last Read'**
  String get quranLastRead;

  /// Quran ayah label
  ///
  /// In en, this message translates to:
  /// **'Ayah'**
  String get quranAyah;

  /// Quran continue button
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get quranContinue;

  /// Quran no reading history message
  ///
  /// In en, this message translates to:
  /// **'No reading history yet.'**
  String get quranNoHistory;

  /// Bookmarks screen title
  ///
  /// In en, this message translates to:
  /// **'Bookmarks'**
  String get quranBookmarks;

  /// Add bookmark tooltip
  ///
  /// In en, this message translates to:
  /// **'Add Bookmark'**
  String get quranBookmarkAdd;

  /// Remove bookmark tooltip
  ///
  /// In en, this message translates to:
  /// **'Remove Bookmark'**
  String get quranBookmarkRemove;

  /// Empty state for bookmarks
  ///
  /// In en, this message translates to:
  /// **'No bookmarks yet.'**
  String get quranNoBookmarksYet;
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
