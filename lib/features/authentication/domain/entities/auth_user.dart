import 'package:equatable/equatable.dart';

class AuthUser extends Equatable {
  final String id;
  final String? email;
  final bool isAnonymous;
  final bool isEmailVerified;

  const AuthUser({
    required this.id,
    this.email,
    required this.isAnonymous,
    required this.isEmailVerified,
  });

  @override
  List<Object?> get props => [id, email, isAnonymous, isEmailVerified];
}
