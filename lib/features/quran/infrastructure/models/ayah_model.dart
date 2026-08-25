import '../../domain/entities/ayah.dart';

class AyahModel extends Ayah {
  const AyahModel({
    required super.number,
    required super.numberInSurah,
    required super.text,
    required super.page,
    required super.hizbQuarter,
    required super.juz,
  });

  factory AyahModel.fromJson(Map<String, dynamic> json) {
    return AyahModel(
      number: json['number'] as int,
      numberInSurah: json['numberInSurah'] as int,
      text: json['text'] as String,
      page: json['page'] as int,
      hizbQuarter: json['hizbQuarter'] as int,
      juz: json['juz'] as int,
    );
  }
}
