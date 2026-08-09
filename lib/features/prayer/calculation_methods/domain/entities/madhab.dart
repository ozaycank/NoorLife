import 'package:equatable/equatable.dart';

class Madhab extends Equatable {
  final String id;
  final String name;

  const Madhab({
    required this.id,
    required this.name,
  });

  @override
  List<Object?> get props => [id, name];
}
