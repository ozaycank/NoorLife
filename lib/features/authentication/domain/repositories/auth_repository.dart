import '../../../../core/errors/failure.dart';
import '../entities/auth_user.dart';

abstract class AuthRepository {
  Stream<AuthUser?> get authStateChanges;
  Future<(Failure?, AuthUser?)> getCurrentUser();
  Future<(Failure?, AuthUser?)> signInWithEmailAndPassword({
    required String email,
    required String password,
  });
  Future<(Failure?, AuthUser?)> registerWithEmailAndPassword({
    required String email,
    required String password,
  });
  Future<(Failure?, AuthUser?)> signInAnonymously();
  Future<(Failure?, void)> sendPasswordResetEmail(String email);
  Future<(Failure?, void)> sendEmailVerification();
  Future<(Failure?, AuthUser?)> reloadUser();
  Future<(Failure?, void)> signOut();
}
