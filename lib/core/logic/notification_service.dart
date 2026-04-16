import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  static const _channelId = 'anota_daily_reminder';
  static const _notifId = 1;
  static const prefHour = 'reminder_hour';
  static const prefMinute = 'reminder_minute';
  static const prefEnabled = 'reminder_enabled';

  final _plugin = FlutterLocalNotificationsPlugin();
  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;

    // Timezone data — quick and safe.
    try {
      tz_data.initializeTimeZones();
      final localTimezone = await FlutterTimezone.getLocalTimezone()
          .timeout(const Duration(seconds: 3));
      tz.setLocalLocation(tz.getLocation(localTimezone));
    } catch (e) {
      debugPrint('Timezone init fallback to UTC: $e');
      try {
        tz.setLocalLocation(tz.UTC);
      } catch (_) {}
    }

    try {
      const initSettings = InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      );
      await _plugin.initialize(initSettings);

      // Android 13+ runtime permission for POST_NOTIFICATIONS (best-effort).
      final androidImpl = _plugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();
      await androidImpl?.requestNotificationsPermission();

      _initialized = true;
    } catch (e) {
      debugPrint('Notifications plugin init failed: $e');
    }
  }

  Future<void> scheduleFromPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final enabled = prefs.getBool(prefEnabled) ?? true;
      if (!enabled) {
        await cancelReminder();
        return;
      }
      final hour = prefs.getInt(prefHour) ?? 21;
      final minute = prefs.getInt(prefMinute) ?? 0;
      await scheduleDailyReminder(hour: hour, minute: minute);
    } catch (e) {
      debugPrint('scheduleFromPrefs failed: $e');
    }
  }

  Future<void> scheduleDailyReminder({int hour = 21, int minute = 0}) async {
    if (!_initialized) return;
    try {
      await _plugin.cancel(_notifId);

      final now = tz.TZDateTime.now(tz.local);
      var scheduled =
          tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
      if (scheduled.isBefore(now)) {
        scheduled = scheduled.add(const Duration(days: 1));
      }

      const details = NotificationDetails(
        android: AndroidNotificationDetails(
          _channelId,
          'Recordatorio diario',
          channelDescription: 'Recordatorio nocturno de tareas pendientes',
          importance: Importance.high,
          priority: Priority.high,
        ),
      );

      // Use inexact mode — avoids the SCHEDULE_EXACT_ALARM runtime prompt on
      // Android 14 and never throws a PlatformException at startup.
      await _plugin.zonedSchedule(
        _notifId,
        '¿Cómo te fue hoy?',
        'Revisá tus tareas pendientes antes de cerrar el día.',
        scheduled,
        details,
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.time,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );
    } catch (e) {
      debugPrint('scheduleDailyReminder failed: $e');
    }
  }

  Future<void> cancelReminder() async {
    try {
      await _plugin.cancel(_notifId);
    } catch (_) {}
  }
}
