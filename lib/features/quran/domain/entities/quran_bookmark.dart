class QuranBookmark {
  final int surahNumber;
  final int ayahNumber;
  final DateTime createdAt;

  const QuranBookmark({
    required this.surahNumber,
    required this.ayahNumber,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'surahNumber': surahNumber,
      'ayahNumber': ayahNumber,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory QuranBookmark.fromJson(Map<String, dynamic> json) {
    return QuranBookmark(
      surahNumber: json['surahNumber'] as int,
      ayahNumber: json['ayahNumber'] as int,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QuranBookmark &&
          runtimeType == other.runtimeType &&
          surahNumber == other.surahNumber &&
          ayahNumber == other.ayahNumber;

  @override
  int get hashCode => surahNumber.hashCode ^ ayahNumber.hashCode;
}
