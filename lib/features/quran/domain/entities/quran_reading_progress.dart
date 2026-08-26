class QuranReadingProgress {
  final int surahNumber;
  final int ayahNumber;
  final DateTime updatedAt;

  const QuranReadingProgress({
    required this.surahNumber,
    required this.ayahNumber,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'surahNumber': surahNumber,
      'ayahNumber': ayahNumber,
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory QuranReadingProgress.fromJson(Map<String, dynamic> json) {
    return QuranReadingProgress(
      surahNumber: json['surahNumber'] as int,
      ayahNumber: json['ayahNumber'] as int,
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QuranReadingProgress &&
          runtimeType == other.runtimeType &&
          surahNumber == other.surahNumber &&
          ayahNumber == other.ayahNumber;

  @override
  int get hashCode => surahNumber.hashCode ^ ayahNumber.hashCode;
}
