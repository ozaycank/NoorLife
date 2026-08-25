class Ayah {
  final int number; // Kur'an'daki genel sırası (1'den 6236'ya)
  final int numberInSurah; // Sure içindeki sırası (1'den n'e)
  final String text; // Gerçek Arapça metin
  final int page;
  final int hizbQuarter;
  final int juz;

  const Ayah({
    required this.number,
    required this.numberInSurah,
    required this.text,
    required this.page,
    required this.hizbQuarter,
    required this.juz,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Ayah &&
          runtimeType == other.runtimeType &&
          number == other.number;

  @override
  int get hashCode => number.hashCode;
}
