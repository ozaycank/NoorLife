import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:injectable/injectable.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter/foundation.dart';
import '../../features/prayer/prayer_times/domain/entities/prayer_time.dart';
import '../../features/prayer/prayer_times/domain/value_objects/prayer_name.dart';

@lazySingleton
class LocalNotificationService {
  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();
  bool _isInitialized = false;

  Future<void> init() async {
    if (_isInitialized) return;
    if (kIsWeb) return; // Graceful fallback for Web

    tz.initializeTimeZones();

    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosInit = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    const initSettings =
        InitializationSettings(android: androidInit, iOS: iosInit);
    await _plugin.initialize(initSettings);
    _isInitialized = true;
  }

  Future<bool> requestPermission() async {
    if (kIsWeb) return false;

    final androidPlugin = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    if (androidPlugin != null) {
      final granted = await androidPlugin.requestNotificationsPermission();
      await androidPlugin.requestExactAlarmsPermission();
      return granted ?? false;
    }

    final iosPlugin = _plugin.resolvePlatformSpecificImplementation<
      IOSFlutterLocalNotificationsPlugin>();
    if (iosPlugin != null) {
      final granted = await iosPlugin.requestPermissions(
          alert: true, badge: true, sound: true,);
      return granted ?? false;
    }
    return true;
  }

  Future<void> cancelAll() async {
    if (kIsWeb) return;
    await _plugin.cancelAll();
  }

  Future<void> schedulePrayer(PrayerTime prayer, int reminderMinutes,
      String title, String body, String timezoneId,) async {
    if (kIsWeb) return;
    if (prayer.name == PrayerName.sunrise) return; // Skip sunrise

    // CRITICAL: Fajr is exact time. Others are offset by reminderMinutes.
    final offset = prayer.name == PrayerName.fajr ? 0 : reminderMinutes;

    tz.Location location;
    try {
      location = tz.getLocation(timezoneId);
    } catch (_) {
      location = tz.local;
    }

    final scheduledDate = tz.TZDateTime.from(prayer.time, location)
        .subtract(Duration(minutes: offset));

    // Skip past notifications
    if (scheduledDate.isBefore(tz.TZDateTime.now(location))) return;

    final id = _getPrayerId(prayer.name, prayer.time);

    await _plugin.zonedSchedule(
      id,
      title,
      body,
      scheduledDate,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'prayer_channel',
          'Prayer Reminders',
          importance: Importance.max,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  Future<void> scheduleDailyVerse(
      String timeStr, String title, String body,) async {
    if (kIsWeb) return;

    final parts = timeStr.split(':');
    if (parts.length != 2) return;
    final hour = int.tryParse(parts[0]) ?? 20;
    final minute = int.tryParse(parts[1]) ?? 0;

    final now = tz.TZDateTime.now(tz.local);
    var scheduledDate =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    await _plugin.zonedSchedule(
      9999, // Static ID for daily verse
      title,
      body,
      scheduledDate,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'verse_channel',
          'Daily Verse',
          importance: Importance.defaultImportance,
          priority: Priority.defaultPriority,
          styleInformation: BigTextStyleInformation(''), // Support long text
        ),
        iOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time, // Repeat daily
    );
  }

  int _getPrayerId(PrayerName name, DateTime time) {
    // Deterministic ID: dayOfYear + prayerIndex * 1000
    final base = time.year * 10000 + time.month * 100 + time.day;
    return base + name.index;
  }
}
