import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:noor_life/app.dart';
import 'package:noor_life/core/di/injection_container.dart';
import 'package:noor_life/features/authentication/application/auth_providers.dart';
import 'package:noor_life/features/authentication/domain/repositories/auth_repository.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();

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
