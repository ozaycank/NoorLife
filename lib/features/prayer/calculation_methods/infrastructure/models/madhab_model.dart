import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/madhab.dart';

part 'madhab_model.g.dart';

@JsonSerializable()
class MadhabModel extends Madhab {
  const MadhabModel({
    required super.id,
    required super.name,
  });

  factory MadhabModel.fromJson(Map<String, dynamic> json) =>
      _$MadhabModelFromJson(json);

  Map<String, dynamic> toJson() => _$MadhabModelToJson(this);
}
