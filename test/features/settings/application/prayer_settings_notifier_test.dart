import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';

import 'package:noor_life/core/base/result.dart';
import 'package:noor_life/core/di/injection_container.dart';
import 'package:noor_life/features/prayer/calculation_methods/domain/entities/madhab.dart';
import 'package:noor_life/features/prayer/calculation_methods/domain/entities/prayer_calculation_method.dart';
import 'package:noor_life/features/prayer/calculation_methods/domain/repositories/calculation_method_repository.dart';
import 'package:noor_life/features/prayer/prayer_times/application/providers/prayer_times_notifier.dart';
import 'package:noor_life/features/prayer/prayer_times/domain/calculators/high_latitude_strategy.dart';
import 'package:noor_life/features/prayer/shared/domain/errors/prayer_failure.dart';
import 'package:noor_life/features/prayer/shared/infrastructure/datasources/prayer_local_data_source.dart';
import 'package:noor_life/features/settings/application/providers/prayer_settings_notifier.dart';

class MockCalculationMethodRepository extends Mock
    implements CalculationMethodRepository {}

class MockPrayerLocalDataSource extends Mock implements PrayerLocalDataSource {}

class FakePrayerTimesNotifier extends PrayerTimesNotifier {
  bool wasRefreshCalled = false;

  @override
  Future<void> refreshTimes() async {
    wasRefreshCalled = true;
  }
}

void main() {
  late MockCalculationMethodRepository mockRepository;
  late MockPrayerLocalDataSource mockLocalSource;

  setUp(() {
    mockRepository = MockCalculationMethodRepository();
    mockLocalSource = MockPrayerLocalDataSource();

    getIt.registerSingleton<CalculationMethodRepository>(mockRepository);
    getIt.registerSingleton<PrayerLocalDataSource>(mockLocalSource);
  });

  tearDown(() {
    getIt.reset();
  });

  group('PrayerSettingsNotifier Logic', () {
    test('Successfully loads initial persisted settings and lists', () async {
      when(() => mockRepository.getCalculationMethods()).thenAnswer(
        (_) async => const Success([
          PrayerCalculationMethod(id: 'mwl', name: 'MWL', description: 'Desc'),
        ]),
      );
      when(() => mockRepository.getMadhabs()).thenAnswer(
        (_) async => const Success([
          Madhab(id: 'hanafi', name: 'Hanafi'),
        ]),
      );
      when(() => mockLocalSource.getSelectedCalculationMethodId())
          .thenAnswer((_) async => 'mwl');
      when(() => mockLocalSource.getSelectedMadhabId())
          .thenAnswer((_) async => 'hanafi');
      when(() => mockLocalSource.getSelectedHighLatitudeStrategy())
          .thenAnswer((_) async => HighLatitudeStrategy.oneSeventh);

      final container = ProviderContainer();
      final notifier = container.read(prayerSettingsNotifierProvider.notifier);

      await notifier.loadSettings();
      final state = container.read(prayerSettingsNotifierProvider);

      expect(state.isLoading, isFalse);
      expect(state.failure, isNull);
      expect(state.selectedMethodId, 'mwl');
      expect(state.selectedMadhabId, 'hanafi');
      expect(state.selectedHighLatStrategy, HighLatitudeStrategy.oneSeventh);
      expect(state.availableMethods.length, 1);
    });

    test('Saving successfully triggers downstream prayer schedule refresh',
        () async {
      when(() => mockRepository.updateCalculationMethod('isna'))
          .thenAnswer((_) async => const Success(null));

      final fakePrayerNotifier = FakePrayerTimesNotifier();
      final container = ProviderContainer(
        overrides: [
          prayerTimesNotifierProvider.overrideWith(() => fakePrayerNotifier),
        ],
      );

      final notifier = container.read(prayerSettingsNotifierProvider.notifier);
      await notifier.updateMethod('isna');

      final state = container.read(prayerSettingsNotifierProvider);
      expect(state.isSaving, isFalse);
      expect(state.selectedMethodId, 'isna');
      expect(fakePrayerNotifier.wasRefreshCalled, isTrue);
    });

    test('Failing to save prevents downstream prayer schedule refresh',
        () async {
      when(() => mockRepository.updateMadhab('hanafi')).thenAnswer(
        (_) async => const ResultFailure(
          PrayerCalculationFailure('Disk read failed'),
        ),
      );

      final fakePrayerNotifier = FakePrayerTimesNotifier();
      final container = ProviderContainer(
        overrides: [
          prayerTimesNotifierProvider.overrideWith(() => fakePrayerNotifier),
        ],
      );

      final notifier = container.read(prayerSettingsNotifierProvider.notifier);
      await notifier.updateMadhab('hanafi');

      final state = container.read(prayerSettingsNotifierProvider);
      expect(state.isSaving, isFalse);
      expect(state.failure, isNotNull);
      expect(fakePrayerNotifier.wasRefreshCalled, isFalse);
    });
  });
}
