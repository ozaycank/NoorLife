import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:noor_life/core/di/injection_container.dart';
import 'package:noor_life/core/logging/logger_service.dart';
import 'package:noor_life/core/providers/base_providers.dart';
import 'package:noor_life/core/storage/secure_storage_service.dart';
import 'package:noor_life/features/authentication/application/auth_providers.dart';
import 'package:noor_life/features/authentication/domain/entities/auth_user.dart';
import 'package:noor_life/features/authentication/domain/repositories/auth_repository.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

class MockLoggerService extends Mock implements LoggerService {}

class MockSecureStorageService extends Mock implements SecureStorageService {}

void main() {
  late MockAuthRepository repository;
  late MockLoggerService logger;
  late MockSecureStorageService secureStorage;

  setUp(() {
    repository = MockAuthRepository();
    logger = MockLoggerService();
    secureStorage = MockSecureStorageService();
    getIt.registerSingleton<SecureStorageService>(secureStorage);
  });

  tearDown(() {
    getIt.reset();
  });

  test('should return true and set isSuccess to true on successful login',
      () async {
    const tUser = AuthUser(
      id: 'usr_1',
      email: 'user@noorlife.app',
      isAnonymous: false,
      isEmailVerified: true,
    );

    when(
      () => repository.signInWithEmailAndPassword(
        email: 'user@noorlife.app',
        password: 'Password123',
      ),
    ).thenAnswer((_) async => (null, tUser));

    when(
      () => secureStorage.saveRememberMe(
        rememberMe: true,
        email: 'user@noorlife.app',
      ),
    ).thenAnswer((_) async {});

    final container = ProviderContainer(
      overrides: [
        authRepositoryProvider.overrideWithValue(repository),
        loggerProvider.overrideWithValue(logger),
      ],
    );

    final controller = container.read(authControllerProvider.notifier);
    final success = await controller.signIn(
      email: 'user@noorlife.app',
      password: 'Password123',
      rememberMe: true,
    );

    expect(success, isTrue);
    expect(container.read(authControllerProvider).isSuccess, isTrue);
  });
}
