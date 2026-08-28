import 'quran_reader_config.dart';

class QuranReaderSettings {
  final double arabicFontSize;
  final bool showTranslation;

  const QuranReaderSettings({
    required this.arabicFontSize,
    required this.showTranslation,
  });

  factory QuranReaderSettings.initial() {
    return const QuranReaderSettings(
      arabicFontSize: QuranReaderConfig.defaultArabicFontSize,
      showTranslation: QuranReaderConfig.defaultShowTranslation,
    );
  }

  QuranReaderSettings copyWith({
    double? arabicFontSize,
    bool? showTranslation,
  }) {
    return QuranReaderSettings(
      arabicFontSize: arabicFontSize ?? this.arabicFontSize,
      showTranslation: showTranslation ?? this.showTranslation,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'arabicFontSize': arabicFontSize,
      'showTranslation': showTranslation,
    };
  }

  factory QuranReaderSettings.fromJson(Map<String, dynamic> json) {
    final value = json['arabicFontSize'];
    double size = QuranReaderConfig.defaultArabicFontSize;

    if (value is num) {
      size = value.toDouble();
      if (size.isNaN || size.isInfinite) {
        size = QuranReaderConfig.defaultArabicFontSize;
      }
    }

    if (size < QuranReaderConfig.minArabicFontSize) {
      size = QuranReaderConfig.minArabicFontSize;
    }
    if (size > QuranReaderConfig.maxArabicFontSize) {
      size = QuranReaderConfig.maxArabicFontSize;
    }

    return QuranReaderSettings(
      arabicFontSize: size,
      showTranslation: json['showTranslation'] as bool? ??
          QuranReaderConfig.defaultShowTranslation,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QuranReaderSettings &&
          runtimeType == other.runtimeType &&
          arabicFontSize == other.arabicFontSize &&
          showTranslation == other.showTranslation;

  @override
  int get hashCode => arabicFontSize.hashCode ^ showTranslation.hashCode;
}
