import '../../presentation/constants/quran_reader_typography.dart';

class QuranReaderSettings {
  final double arabicFontSize;

  const QuranReaderSettings({
    required this.arabicFontSize,
  });

  factory QuranReaderSettings.initial() {
    return const QuranReaderSettings(
      arabicFontSize: QuranReaderTypography.defaultArabicFontSize,
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
    double size = json['arabicFontSize'] as double? ?? QuranReaderTypography.defaultArabicFontSize;
    
    // Clamp securely at source
    if (size < QuranReaderTypography.minArabicFontSize) size = QuranReaderTypography.minArabicFontSize;
    if (size > QuranReaderTypography.maxArabicFontSize) size = QuranReaderTypography.maxArabicFontSize;

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