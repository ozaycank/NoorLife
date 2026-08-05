import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failure.dart';
import '../../domain/entities/auth_user.dart';
import '../../domain/errors/auth_failure.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/firebase_auth_data_source.dart';

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuthDataSource _dataSource;

  AuthRepositoryImpl(this._dataSource);

  @override
  Stream<AuthUser?> get authStateChanges => _dataSource.authStateChanges;

  @override
  Future<(Failure?, AuthUser?)> getCurrentUser() async {
    try {
      final user = _dataSource.currentUser;
      return (null, user);
    } catch (e) {
      return (_mapException(e), null);
    }
  }

  @override
  Future<(Failure?, AuthUser?)> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final user = await _dataSource.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return (null, user);
    } catch (e) {
      return (_mapException(e), null);
    }
  }

  @override
  Future<(Failure?, AuthUser?)> registerWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final user = await _dataSource.registerWithEmailAndPassword(
        email: email,
        password: password,
      );
      await _dataSource.sendEmailVerification();
      return (null, user);
    } catch (e) {
      return (_mapException(e), null);
    }
  }

  @override
  Future<(Failure?, AuthUser?)> signInAnonymously() async {
    try {
      final user = await _dataSource.signInAnonymously();
      return (null, user);
    } catch (e) {
      return (_mapException(e), null);
    }
  }

  @override
  Future<(Failure?, void)> sendPasswordResetEmail(String email) async {
    try {
      await _dataSource.sendPasswordResetEmail(email);
      return (null, null);
    } catch (e) {
      return (_mapException(e), null);
    }
  }

  @override
  Future<(Failure?, void)> sendEmailVerification() async {
    try {
      await _dataSource.sendEmailVerification();
      return (null, null);
    } catch (e) {
      return (_mapException(e), null);
    }
  }

  @override
  Future<(Failure?, AuthUser?)> reloadUser() async {
    try {
      final user = await _dataSource.reloadUser();
      return (null, user);
    } catch (e) {
      return (_mapException(e), null);
    }
  }

  @override
  Future<(Failure?, void)> signOut() async {
    try {
      await _dataSource.signOut();
      return (null, null);
    } catch (e) {
      return (_mapException(e), null);
    }
  }

  Failure _mapException(dynamic error) {
    if (error is fb_auth.FirebaseAuthException) {
      switch (error.code) {
        case 'user-not-found':
        case 'wrong-password':
        case 'invalid-credential':
          return const AuthFailure('Invalid email or password.');
        case 'email-already-in-use':
          return const AuthFailure('This email address is already registered.');
        case 'weak-password':
          return const AuthFailure('The password provided is too weak.');
        case 'invalid-email':
          return const AuthFailure('The email address is not valid.');
        case 'network-request-failed':
          return const AuthFailure('No internet connection. Please try again.');
        default:
          return AuthFailure(
            error.message ?? 'Authentication error occurred.',
            code: error.code,
          );
      }
    }
    return const AuthFailure('An unexpected authentication error occurred.');
  }
}
