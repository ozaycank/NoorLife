import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';

import 'package:noor_life/core/base/result.dart';
import 'package:noor_life/core/di/injection_container.dart';
import 'package:noor_life/features/prayer/calculation_methods/domain/entities/madhab.dart';
import 'package:noor_life/features/prayer/calculation_methods/domain/entities/prayer_calculation_method.dart';
import 'package:noor_life/features/prayer/calculation_methods/domain/repositories/calculation_method_repository.dart';
import 'package:noor_life/features/prayer/prayer_times/domain/calculators/high_latitude_strategy.dart';
import 'package:noor_life/features/prayer/shared/domain/errors/prayer_failure.dart';
import 'package:noor_life/features/prayer/shared/infrastructure/datasources/prayer_local_data_source.dart';
import 'package:noor_life/features/settings/application/providers/prayer_settings_notifier.dart';

class MockCalculationMethodRepository extends Mock
    implements CalculationMethodRepository {}

class MockPrayerLocalDataSource extends Mock implements PrayerLocalDataSource {}

void main() {
  late MockCalculationMethodRepository mockRepository;
  late MockPrayerLocalDataSource mockLocalSource;

  setUp(() {
    mockRepository = MockCalculationMethodRepository();
    mockLocalSource = MockPrayerLocalDataSource();

    if (!getIt.isRegistered<CalculationMethodRepository>()) {
      getIt.registerSingleton<CalculationMethodRepository>(mockRepository);
    } else {
      getIt.unregister<CalculationMethodRepository>();
      getIt.registerSingleton<CalculationMethodRepository>(mockRepository);
    }

    if (!getIt.isRegistered<PrayerLocalDataSource>()) {
      getIt.registerSingleton<PrayerLocalDataSource>(mockLocalSource);
    } else {
      getIt.unregister<PrayerLocalDataSource>();
      getIt.registerSingleton<PrayerLocalDataSource>(mockLocalSource);
    }

    // Tüm testlerde otomatik çalışan `loadSettings` için varsayılan sahte veriler
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
  });

  tearDown(() {
    getIt.reset();
  });

  group('PrayerSettingsNotifier Logic', () {
    test('Successfully loads initial persisted settings and lists', () async {
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

    test('updateMethod returns true on success', () async {
      when(() => mockRepository.updateCalculationMethod('isna'))
          .thenAnswer((_) async => const Success(null));

      final container = ProviderContainer();
      final notifier = container.read(prayerSettingsNotifierProvider.notifier);

      await notifier.loadSettings();

      final result = await notifier.updateMethod('isna');

      final state = container.read(prayerSettingsNotifierProvider);
      expect(state.isSaving, isFalse);
      expect(state.selectedMethodId, 'isna');
      expect(result, isTrue);
    });

    test('updateMadhab returns false on failure and updates state', () async {
      when(() => mockRepository.updateMadhab('hanafi')).thenAnswer(
        (_) async => const ResultFailure(
          PrayerCalculationFailure('Disk read failed'),
        ),
      );

      final container = ProviderContainer();
      final notifier = container.read(prayerSettingsNotifierProvider.notifier);

      await notifier.loadSettings();

      final result = await notifier.updateMadhab('hanafi');

      final state = container.read(prayerSettingsNotifierProvider);
      expect(state.isSaving, isFalse);
      expect(state.failure, isNotNull);
      expect(result, isFalse);
    });
  });
}
