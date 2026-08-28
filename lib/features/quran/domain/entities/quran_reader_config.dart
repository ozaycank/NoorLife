/// Pure domain configuration for Quran reading parameters.
/// This prevents the Domain layer from importing Presentation typography files.
class QuranReaderConfig {
  QuranReaderConfig._();

  static const double defaultArabicFontSize = 26.0;
  static const double minArabicFontSize = 20.0;
  static const double maxArabicFontSize = 36.0;
  static const double arabicFontSizeStep = 2.0;
}
