import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:noor_life/app.dart';
import 'package:noor_life/core/di/injection_container.dart';
import 'package:noor_life/core/logging/logger_service.dart';
import 'package:noor_life/features/authentication/application/auth_providers.dart';
import 'package:noor_life/features/authentication/domain/repositories/auth_repository.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

class MockLoggerService extends Mock implements LoggerService {}

void main() {
  late MockAuthRepository mockAuthRepository;
  late MockLoggerService mockLoggerService;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    mockLoggerService = MockLoggerService();

    when(() => mockAuthRepository.authStateChanges)
        .thenAnswer((_) => const Stream.empty());
    when(() => mockAuthRepository.getCurrentUser())
        .thenAnswer((_) async => (null, null));

    if (!getIt.isRegistered<AuthRepository>()) {
      getIt.registerSingleton<AuthRepository>(mockAuthRepository);
    } else {
      getIt.unregister<AuthRepository>();
      getIt.registerSingleton<AuthRepository>(mockAuthRepository);
    }

    if (!getIt.isRegistered<LoggerService>()) {
      getIt.registerSingleton<LoggerService>(mockLoggerService);
    } else {
      getIt.unregister<LoggerService>();
      getIt.registerSingleton<LoggerService>(mockLoggerService);
    }
  });

  tearDown(() {
    getIt.reset();
  });

  testWidgets('App initialization test', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authRepositoryProvider.overrideWithValue(mockAuthRepository),
        ],
        child: const NoorLifeApp(),
      ),
    );

    expect(find.byType(NoorLifeApp), findsOneWidget);
  });
}
