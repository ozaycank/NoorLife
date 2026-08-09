import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/prayer_calculation_method.dart';

part 'prayer_calculation_method_model.g.dart';

@JsonSerializable()
class PrayerCalculationMethodModel extends PrayerCalculationMethod {
  const PrayerCalculationMethodModel({
    required super.id,
    required super.name,
    required super.description,
  });

  factory PrayerCalculationMethodModel.fromJson(Map<String, dynamic> json) =>
      _$PrayerCalculationMethodModelFromJson(json);

  Map<String, dynamic> toJson() => _$PrayerCalculationMethodModelToJson(this);
}
