import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/storage/secure_storage_service.dart';
import '../../../../core/services/local_notification_service.dart';
import '../../../prayer/prayer_times/application/providers/prayer_times_notifier.dart';

class NotificationSettingsState {
  final bool masterEnabled;
  final int prayerReminderMinutes;
  final bool dailyVerseEnabled;
  final String dailyVerseTime;
  final bool isLoaded;

  const NotificationSettingsState({
    this.masterEnabled = true,
    this.prayerReminderMinutes = 30,
    this.dailyVerseEnabled = true,
    this.dailyVerseTime = '20:00',
    this.isLoaded = false,
  });

  NotificationSettingsState copyWith({
    bool? masterEnabled,
    int? prayerReminderMinutes,
    bool? dailyVerseEnabled,
    String? dailyVerseTime,
    bool? isLoaded,
  }) {
    return NotificationSettingsState(
      masterEnabled: masterEnabled ?? this.masterEnabled,
      prayerReminderMinutes:
          prayerReminderMinutes ?? this.prayerReminderMinutes,
      dailyVerseEnabled: dailyVerseEnabled ?? this.dailyVerseEnabled,
      dailyVerseTime: dailyVerseTime ?? this.dailyVerseTime,
      isLoaded: isLoaded ?? this.isLoaded,
    );
  }
}

final notificationSettingsProvider =
    NotifierProvider<NotificationSettingsNotifier, NotificationSettingsState>(
  NotificationSettingsNotifier.new,
);

class NotificationSettingsNotifier extends Notifier<NotificationSettingsState> {
  late final SecureStorageService _storage;
  late final LocalNotificationService _notificationService;

  @override
  NotificationSettingsState build() {
    _storage = getIt<SecureStorageService>();
    _notificationService = getIt<LocalNotificationService>();
    Future.microtask(_loadSettings);
    return const NotificationSettingsState();
  }

  Future<void> _loadSettings() async {
    final enabled = await _storage.getNotificationsEnabled();
    final mins = await _storage.getPrayerReminderMinutes();
    final verseEnabled = await _storage.getDailyVerseEnabled();
    final verseTime = await _storage.getDailyVerseTime();

    state = state.copyWith(
      masterEnabled: enabled,
      prayerReminderMinutes: mins,
      dailyVerseEnabled: verseEnabled,
      dailyVerseTime: verseTime,
      isLoaded: true,
    );

    // Yüklendikten hemen sonra reschedule et
    _rescheduleAll();
  }

  Future<void> toggleMaster(bool val) async {
    await _storage.setNotificationsEnabled(val);
    state = state.copyWith(masterEnabled: val);
    if (val) {
      final granted = await _notificationService.requestPermission();
      if (!granted) {
        state = state.copyWith(masterEnabled: false);
        await _storage.setNotificationsEnabled(false);
        return;
      }
    }
    _rescheduleAll();
  }

  Future<void> setReminderMinutes(int mins) async {
    await _storage.setPrayerReminderMinutes(mins);
    state = state.copyWith(prayerReminderMinutes: mins);
    _rescheduleAll();
  }

  Future<void> toggleDailyVerse(bool val) async {
    await _storage.setDailyVerseEnabled(val);
    state = state.copyWith(dailyVerseEnabled: val);
    _rescheduleAll();
  }

  Future<void> setDailyVerseTime(String time) async {
    await _storage.setDailyVerseTime(time);
    state = state.copyWith(dailyVerseTime: time);
    _rescheduleAll();
  }

  Future<void> _rescheduleAll() async {
    await _notificationService.cancelAll();
    if (!state.masterEnabled) return;

    // Daily Verse Planla
    if (state.dailyVerseEnabled) {
      await _notificationService.scheduleDailyVerse(
        state.dailyVerseTime,
        'Verse of the Day', // Localization context is hard inside background services, using standard
        'Tap to read today\'s verse.',
      );
    }

    // Namazları Planla (PrayerTimesNotifier'dan oku)
    final prayerState = ref.read(prayerTimesNotifierProvider);
    if (prayerState.schedule != null && prayerState.location != null) {
      final prayers = prayerState.schedule!.today.prayerTimes;
      final tzId = prayerState.location!.timezoneIdentifier;

      for (final p in prayers) {
        await _notificationService.schedulePrayer(
            p,
            state.prayerReminderMinutes,
            'Prayer Time',
            '${p.name.name.toUpperCase()} is approaching.',
            tzId,);
      }
    }
  }

  // Bu fonksiyon PrayerTimesNotifier güncellendiğinde dışarıdan çağrılır
  void syncPrayerSchedule() {
    if (state.isLoaded) _rescheduleAll();
  }
}
