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

  @override
  String get prayerFajr => 'Fajr';

  @override
  String get prayerSunrise => 'Sunrise';

  @override
  String get prayerDhuhr => 'Dhuhr';

  @override
  String get prayerAsr => 'Asr';

  @override
  String get prayerMaghrib => 'Maghrib';

  @override
  String get prayerIsha => 'Isha';

  @override
  String get prayerNextPrayer => 'Next Prayer';

  @override
  String get prayerRemainingTime => 'Remaining Time';

  @override
  String get prayerCalculationMethod => 'Calculation Method';

  @override
  String get prayerMadhab => 'Madhab / Juristic Method';

  @override
  String get prayerLocationHeader => 'Prayer Location';

  @override
  String get prayerRefreshButton => 'Refresh Times';

  @override
  String get prayerSettingsTitle => 'Prayer Settings';

  @override
  String get prayerSettingsDesc =>
      'Adjust your calculation methods and juristic preferences.';

  @override
  String get locationTitle => 'Location Settings';

  @override
  String get currentLocation => 'Current Location';

  @override
  String get refreshLocation => 'Refresh Location';

  @override
  String get locationUnavailable => 'Location Unavailable';

  @override
  String get locationPermissionDenied => 'Location permission is required.';

  @override
  String get locationServiceDisabled => 'Location services are disabled.';

  @override
  String get locationGeocodingFailed => 'Failed to resolve address.';

  @override
  String get timezoneLabel => 'Timezone';

  @override
  String get coordinatesLabel => 'Coordinates';

  @override
  String get unknownCountry => 'Unknown';

  @override
  String get prayerCalculationTitle => 'Prayer Calculation';

  @override
  String get calculationMethodLabel => 'Calculation Method';

  @override
  String get madhabLabel => 'Madhab / Juristic Method';

  @override
  String get highLatitudeStrategyLabel => 'High Latitude Strategy';

  @override
  String get calculationMethodSaved => 'Settings saved successfully.';

  @override
  String get settingsSaveFailed => 'Failed to save settings.';

  @override
  String get angleBasedLabel => 'Angle Based';

  @override
  String get oneSeventhLabel => 'One Seventh';

  @override
  String get nightMiddleLabel => 'Middle of the Night';

  @override
  String get noneLabel => 'None';

  @override
  String get qiblaTitle => 'Qibla Direction';

  @override
  String get qiblaDirection => 'Direction';

  @override
  String get qiblaBearing => 'Bearing';

  @override
  String get qiblaLocation => 'Location';

  @override
  String get qiblaUnavailable =>
      'Qibla calculation unavailable. Please ensure your location is set.';

  @override
  String get qiblaCalculationError => 'Failed to calculate Qibla direction.';

  @override
  String get dirNorth => 'N';

  @override
  String get dirNorthEast => 'NE';

  @override
  String get dirEast => 'E';

  @override
  String get dirSouthEast => 'SE';

  @override
  String get dirSouth => 'S';

  @override
  String get dirSouthWest => 'SW';

  @override
  String get dirWest => 'W';

  @override
  String get dirNorthWest => 'NW';

  @override
  String get qiblaDisclaimer =>
      'Calculated from your current location. Turn-by-turn compass guidance is not enabled yet.';

  @override
  String get qiblaUndefinedAtKaaba =>
      'You are at the Kaaba. Qibla direction is undefined.';

  @override
  String get qiblaCompass => 'Qibla Compass';

  @override
  String get qiblaHeading => 'Device Heading';

  @override
  String get qiblaRelativeAngle => 'Relative Angle';

  @override
  String turnLeft(String degrees) {
    return 'Turn left $degrees°';
  }

  @override
  String turnRight(String degrees) {
    return 'Turn right $degrees°';
  }

  @override
  String get qiblaAligned => 'Aligned with Qibla';

  @override
  String get compassUnavailable => 'Compass Unavailable';

  @override
  String get compassSensorUnavailable =>
      'Your device does not have a compass sensor.';

  @override
  String get compassUnsupportedPlatform =>
      'Compass is not supported on this platform.';

  @override
  String get compassError => 'Failed to read compass sensor.';

  @override
  String get languageLabel => 'App Language';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageTurkish => 'Türkçe';

  @override
  String get methodMWL => 'Muslim World League';

  @override
  String get methodISNA => 'Islamic Society of North America';

  @override
  String get methodEgypt => 'Egyptian General Authority';

  @override
  String get methodMakkah => 'Umm Al-Qura';

  @override
  String get methodKarachi => 'University of Islamic Sciences, Karachi';

  @override
  String get methodTehran => 'Institute of Geophysics, University of Tehran';

  @override
  String get methodShia => 'Shia Ithna-Ashari';

  @override
  String get methodGulf => 'Gulf Region';

  @override
  String get methodKuwait => 'Kuwait';

  @override
  String get methodQatar => 'Qatar';

  @override
  String get methodSingapore => 'Majlis Ugama Islam Singapura';

  @override
  String get methodFrance => 'Union des Organisations Islamiques de France';

  @override
  String get methodTurkey => 'Diyanet Approximation Profile';

  @override
  String get methodRussia => 'Spiritual Administration of Muslims of Russia';

  @override
  String get methodMoonsighting => 'Moonsighting Committee Worldwide';

  @override
  String get methodDubai => 'Dubai';

  @override
  String get methodJakim => 'Jabatan Kemajuan Islam Malaysia';

  @override
  String get methodTunisia => 'Tunisian Ministry of Religious Affairs';

  @override
  String get methodAlgeria => 'Algerian Ministry of Religious Affairs';

  @override
  String get methodKemenag => 'Indonesian Ministry of Religious Affairs';

  @override
  String get methodMorocco => 'Moroccan Ministry of Habous and Islamic Affairs';

  @override
  String get methodPortugal => 'Great Mosque of Paris';

  @override
  String get methodJafari => 'Shia Ithna-Ashari';

  @override
  String get madhabStandard => 'Standard (Shafi / Maliki / Hanbali)';

  @override
  String get madhabHanafi => 'Hanafi';

  @override
  String get hijriMuharram => 'Muharram';

  @override
  String get hijriSafar => 'Safar';

  @override
  String get hijriRabiAlAwwal => 'Rabi\' al-Awwal';

  @override
  String get hijriRabiAlThani => 'Rabi\' al-Thani';

  @override
  String get hijriJumadaAlAwwal => 'Jumada al-Awwal';

  @override
  String get hijriJumadaAlThani => 'Jumada al-Thani';

  @override
  String get hijriRajab => 'Rajab';

  @override
  String get hijriShaaban => 'Sha\'ban';

  @override
  String get hijriRamadan => 'Ramadan';

  @override
  String get hijriShawwal => 'Shawwal';

  @override
  String get hijriDhuAlQiDah => 'Dhu al-Qi\'dah';

  @override
  String get hijriDhuAlHijjah => 'Dhu al-Hijjah';

  @override
  String get asrConventionDesc => 'Asr calculation convention';

  @override
  String get homeGreeting => 'Assalamu Alaikum';

  @override
  String get homeToday => 'Today\'s Schedule';

  @override
  String get nextPrayerHeader => 'Next Prayer';

  @override
  String get viewQibla => 'Qibla Direction';

  @override
  String get openSettings => 'App Settings';

  @override
  String get homePrayerError => 'Prayer times unavailable.';

  @override
  String get homePrayerRetry => 'Retry Location';

  @override
  String get homeComingSoon => 'Coming Soon';

  @override
  String get quranSearchHint => 'Search Surah';

  @override
  String get quranNoSurahFound => 'No Surah found.';

  @override
  String get quranMeccan => 'Meccan';

  @override
  String get quranMedinan => 'Medinan';

  @override
  String quranAyahCount(int count) {
    return '$count Ayahs';
  }

  @override
  String get quranDetailPlaceholderText =>
      'Quran text reader will be implemented in a later phase.';

  @override
  String get quranContinueReading => 'Continue Reading';

  @override
  String get quranLastRead => 'Last Read';

  @override
  String get quranAyah => 'Ayah';

  @override
  String get quranContinue => 'Continue';

  @override
  String get quranNoHistory => 'No reading history yet.';
}
