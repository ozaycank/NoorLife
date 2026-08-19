import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/base/result.dart';
import '../../../../../core/di/injection_container.dart';
import '../../../shared/infrastructure/datasources/prayer_local_data_source.dart';
import '../../domain/interfaces/location_service.dart';
import '../states/location_state.dart';

final locationNotifierProvider =
    NotifierProvider<LocationNotifier, LocationState>(LocationNotifier.new);

class LocationNotifier extends Notifier<LocationState> {
  late final LocationService _locationService;
  late final PrayerLocalDataSource _localDataSource;

  @override
  LocationState build() {
    _locationService = getIt<LocationService>();
    _localDataSource = getIt<PrayerLocalDataSource>();
    Future.microtask(() => _initLocation());
    return const LocationState();
  }

  Future<void> _initLocation() async {
    final saved = await _localDataSource.getSelectedLocation();
    if (saved == null) {
      await acquireDeviceLocation();
    } else {
      state = state.copyWith(
        status: LocationStatus.success,
        location: () => saved,
        failure: () => null,
      );
    }
  }

  Future<bool> acquireDeviceLocation() async {
    state = state.copyWith(
      status: LocationStatus.requesting,
      failure: () => null,
    );

    final result = await _locationService.getCurrentLocation();

    switch (result) {
      case Success(value: final loc):
        await _localDataSource.saveSelectedLocation(loc);
        state = state.copyWith(
          status: LocationStatus.success,
          location: () => loc,
          failure: () => null,
        );
        return true;
      case ResultFailure(failure: final f):
        state = state.copyWith(
          status: LocationStatus.failure,
          failure: () => f,
        );
        return false;
    }
  }
}
