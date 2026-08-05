import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:injectable/injectable.dart';
import '../models/auth_user_model.dart';

@lazySingleton
class FirebaseAuthDataSource {
  final fb_auth.FirebaseAuth _firebaseAuth;

  FirebaseAuthDataSource(this._firebaseAuth);

  Stream<AuthUserModel?> get authStateChanges {
    return _firebaseAuth.authStateChanges().map(
          (user) => user != null ? AuthUserModel.fromFirebaseUser(user) : null,
        );
  }

  AuthUserModel? get currentUser {
    final user = _firebaseAuth.currentUser;
    return user != null ? AuthUserModel.fromFirebaseUser(user) : null;
  }

  Future<AuthUserModel> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    final credential = await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    final user = credential.user;
    if (user == null) {
      throw fb_auth.FirebaseAuthException(
        code: 'null-user',
        message: 'Sign in failed. No user returned.',
      );
    }
    return AuthUserModel.fromFirebaseUser(user);
  }

  Future<AuthUserModel> registerWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    final credential = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    final user = credential.user;
    if (user == null) {
      throw fb_auth.FirebaseAuthException(
        code: 'null-user',
        message: 'Registration failed. No user returned.',
      );
    }
    return AuthUserModel.fromFirebaseUser(user);
  }

  Future<AuthUserModel> signInAnonymously() async {
    final credential = await _firebaseAuth.signInAnonymously();
    final user = credential.user;
    if (user == null) {
      throw fb_auth.FirebaseAuthException(
        code: 'null-user',
        message: 'Guest login failed. No user returned.',
      );
    }
    return AuthUserModel.fromFirebaseUser(user);
  }

  Future<void> sendPasswordResetEmail(String email) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  Future<void> sendEmailVerification() async {
    final user = _firebaseAuth.currentUser;
    if (user != null && !user.emailVerified) {
      await user.sendEmailVerification();
    }
  }

  Future<AuthUserModel?> reloadUser() async {
    final user = _firebaseAuth.currentUser;
    if (user != null) {
      await user.reload();
      final updatedUser = _firebaseAuth.currentUser;
      return updatedUser != null
          ? AuthUserModel.fromFirebaseUser(updatedUser)
          : null;
    }
    return null;
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
