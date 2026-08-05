import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:noor_life/features/authentication/domain/entities/auth_user.dart';
import 'package:noor_life/features/authentication/domain/errors/auth_failure.dart';
import 'package:noor_life/features/authentication/domain/repositories/auth_repository.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository repository;

  setUp(() {
    repository = MockAuthRepository();
  });

  group('AuthRepository Unit Tests', () {
    const tUser = AuthUser(
      id: 'usr_123',
      email: 'test@noorlife.app',
      isAnonymous: false,
      isEmailVerified: true,
    );

    test('should return AuthUser when signIn succeeds', () async {
      when(
        () => repository.signInWithEmailAndPassword(
          email: 'test@noorlife.app',
          password: 'Password123!',
        ),
      ).thenAnswer((_) async => (null, tUser));

      final (failure, user) = await repository.signInWithEmailAndPassword(
        email: 'test@noorlife.app',
        password: 'Password123!',
      );

      expect(failure, isNull);
      expect(user, equals(tUser));
    });

    test('should return AuthFailure when credentials are wrong', () async {
      const tFailure = AuthFailure('Invalid email or password.');
      when(
        () => repository.signInWithEmailAndPassword(
          email: 'test@noorlife.app',
          password: 'WrongPassword!',
        ),
      ).thenAnswer((_) async => (tFailure, null));

      final (failure, user) = await repository.signInWithEmailAndPassword(
        email: 'test@noorlife.app',
        password: 'WrongPassword!',
      );

      expect(user, isNull);
      expect(failure, equals(tFailure));
    });
  });
}
