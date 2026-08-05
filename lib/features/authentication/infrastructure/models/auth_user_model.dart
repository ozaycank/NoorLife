import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import '../../domain/entities/auth_user.dart';

class AuthUserModel extends AuthUser {
  const AuthUserModel({
    required super.id,
    super.email,
    required super.isAnonymous,
    required super.isEmailVerified,
  });

  factory AuthUserModel.fromFirebaseUser(fb_auth.User user) {
    return AuthUserModel(
      id: user.uid,
      email: user.email,
      isAnonymous: user.isAnonymous,
      isEmailVerified: user.emailVerified,
    );
  }
}
