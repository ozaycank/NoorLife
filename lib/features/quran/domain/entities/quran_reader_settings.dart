import 'quran_reader_config.dart';

class QuranReaderSettings {
  final double arabicFontSize;

  const QuranReaderSettings({
    required this.arabicFontSize,
  });

  factory QuranReaderSettings.initial() {
    return const QuranReaderSettings(
      arabicFontSize: QuranReaderConfig.defaultArabicFontSize,
    );
  }

  QuranReaderSettings copyWith({
    double? arabicFontSize,
  }) {
    return QuranReaderSettings(
      arabicFontSize: arabicFontSize ?? this.arabicFontSize,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'arabicFontSize': arabicFontSize,
    };
  }

  factory QuranReaderSettings.fromJson(Map<String, dynamic> json) {
    // Robust parsing using num to accept both int (26) and double (26.0) safely.
    final value = json['arabicFontSize'];
    double size = QuranReaderConfig.defaultArabicFontSize;

    if (value is num) {
      size = value.toDouble();
      if (size.isNaN || size.isInfinite) {
        size = QuranReaderConfig.defaultArabicFontSize;
      }
    }

    // Clamp securely at the domain source
    if (size < QuranReaderConfig.minArabicFontSize) {
      size = QuranReaderConfig.minArabicFontSize;
    }
    if (size > QuranReaderConfig.maxArabicFontSize) {
      size = QuranReaderConfig.maxArabicFontSize;
    }

    return QuranReaderSettings(
      arabicFontSize: size,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QuranReaderSettings &&
          runtimeType == other.runtimeType &&
          arabicFontSize == other.arabicFontSize;

  @override
  int get hashCode => arabicFontSize.hashCode;
}
