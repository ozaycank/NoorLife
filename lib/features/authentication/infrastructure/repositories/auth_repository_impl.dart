// import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
// import 'package:injectable/injectable.dart';
// import '../../../../core/errors/failure.dart';
// import '../../domain/entities/auth_user.dart';
// import '../../domain/errors/auth_failure.dart';
// import '../../domain/repositories/auth_repository.dart';
// import '../datasources/firebase_auth_data_source.dart';

// @LazySingleton(as: AuthRepository)
// class AuthRepositoryImpl implements AuthRepository {
//   final FirebaseAuthDataSource _dataSource;

//   AuthRepositoryImpl(this._dataSource);

//   @override
//   Stream<AuthUser?> get authStateChanges => _dataSource.authStateChanges;

//   @override
//   Future<(Failure?, AuthUser?)> getCurrentUser() async {
//     try {
//       final user = _dataSource.currentUser;
//       return (null, user);
//     } catch (e) {
//       return (_mapException(e), null);
//     }
//   }

//   @override
//   Future<(Failure?, AuthUser?)> signInWithEmailAndPassword({
//     required String email,
//     required String password,
//   }) async {
//     try {
//       final user = await _dataSource.signInWithEmailAndPassword(
//         email: email,
//         password: password,
//       );
//       return (null, user);
//     } catch (e) {
//       return (_mapException(e), null);
//     }
//   }

//   @override
//   Future<(Failure?, AuthUser?)> registerWithEmailAndPassword({
//     required String email,
//     required String password,
//   }) async {
//     try {
//       final user = await _dataSource.registerWithEmailAndPassword(
//         email: email,
//         password: password,
//       );
//       await _dataSource.sendEmailVerification();
//       return (null, user);
//     } catch (e) {
//       return (_mapException(e), null);
//     }
//   }

//   @override
//   Future<(Failure?, AuthUser?)> signInAnonymously() async {
//     try {
//       final user = await _dataSource.signInAnonymously();
//       return (null, user);
//     } catch (e) {
//       return (_mapException(e), null);
//     }
//   }

//   @override
//   Future<(Failure?, void)> sendPasswordResetEmail(String email) async {
//     try {
//       await _dataSource.sendPasswordResetEmail(email);
//       return (null, null);
//     } catch (e) {
//       return (_mapException(e), null);
//     }
//   }

//   @override
//   Future<(Failure?, void)> sendEmailVerification() async {
//     try {
//       await _dataSource.sendEmailVerification();
//       return (null, null);
//     } catch (e) {
//       return (_mapException(e), null);
//     }
//   }

//   @override
//   Future<(Failure?, AuthUser?)> reloadUser() async {
//     try {
//       final user = await _dataSource.reloadUser();
//       return (null, user);
//     } catch (e) {
//       return (_mapException(e), null);
//     }
//   }

//   @override
//   Future<(Failure?, void)> signOut() async {
//     try {
//       await _dataSource.signOut();
//       return (null, null);
//     } catch (e) {
//       return (_mapException(e), null);
//     }
//   }

//   Failure _mapException(dynamic error) {
//     if (error is fb_auth.FirebaseAuthException) {
//       switch (error.code) {
//         case 'user-not-found':
//         case 'wrong-password':
//         case 'invalid-credential':
//           return const AuthFailure('Invalid email or password.');
//         case 'email-already-in-use':
//           return const AuthFailure('This email address is already registered.');
//         case 'weak-password':
//           return const AuthFailure('The password provided is too weak.');
//         case 'invalid-email':
//           return const AuthFailure('The email address is not valid.');
//         case 'too-many-requests':
//           return const AuthFailure(
//             'Too many requests. Please try again later.',
//           );
//         case 'user-disabled':
//           return const AuthFailure('This account has been disabled.');
//         case 'operation-not-allowed':
//           return const AuthFailure('This sign-in method is not enabled.');
//         case 'network-request-failed':
//           return const AuthFailure('No internet connection. Please try again.');
//         default:
//           return AuthFailure(
//             error.message ?? 'Authentication error occurred.',
//             code: error.code,
//           );
//       }
//     }
//     return const AuthFailure('An unexpected authentication error occurred.');
//   }
// }
import 'dart:async';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failure.dart';
import '../../domain/entities/auth_user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/firebase_auth_data_source.dart';

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  // ignore: unused_field
  final FirebaseAuthDataSource _dataSource;
  final _authStreamController = StreamController<AuthUser?>.broadcast();

  // İçeri giren kullanıcıyı hafızada tutacağız ki Router bizi dışarı atmasın!
  AuthUser? _currentUser;

  AuthRepositoryImpl(this._dataSource) {
    Future.delayed(const Duration(milliseconds: 500), () {
      _authStreamController.add(null);
    });
  }

  final _fakeUser = const AuthUser(
    id: 'fake_user_123',
    email: 'test@noorlife.com',
    isAnonymous: false,
    isEmailVerified: true,
  );

  @override
  Stream<AuthUser?> get authStateChanges => _authStreamController.stream;

  @override
  Future<(Failure?, AuthUser?)> getCurrentUser() async {
    // Artık null değil, gerçekten hafızadaki kullanıcıyı dönüyoruz.
    return (null, _currentUser);
  }

  @override
  Future<(Failure?, AuthUser?)> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _currentUser = _fakeUser;
    _authStreamController.add(_currentUser);
    return (null, _currentUser);
  }

  @override
  Future<(Failure?, AuthUser?)> registerWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _currentUser = _fakeUser;
    _authStreamController.add(_currentUser);
    return (null, _currentUser);
  }

  @override
  Future<(Failure?, AuthUser?)> signInAnonymously() async {
    await Future.delayed(const Duration(milliseconds: 500));
    _currentUser = const AuthUser(
      id: 'guest_123',
      isAnonymous: true,
      isEmailVerified: false,
    );
    _authStreamController.add(_currentUser);
    return (null, _currentUser);
  }

  @override
  Future<(Failure?, void)> sendPasswordResetEmail(String email) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return (null, null);
  }

  @override
  Future<(Failure?, void)> sendEmailVerification() async {
    return (null, null);
  }

  @override
  Future<(Failure?, AuthUser?)> reloadUser() async {
    return (null, _currentUser);
  }

  @override
  Future<(Failure?, void)> signOut() async {
    await Future.delayed(const Duration(milliseconds: 500));
    _currentUser = null;
    _authStreamController.add(null);
    return (null, null);
  }
}
