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
      // Apunto usa `launcher_icon` (no `ic_launcher`) — es el nombre que
      // setea flutter_launcher_icons en pubspec.yaml. Apuntar a un asset
      // que no existe hace fallar el init y silencia TODAS las notifs.
      const initSettings = InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/launcher_icon'),
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

  // ───────────────────── Recordatorios de tareas ─────────────────────
  // Cada tarea programada genera una notificación one-shot al horario
  // exacto (o N minutos antes). Notif id derivada del id de la tarea
  // por hashCode + offset, estable y reproducible.
  static const String _taskChannelId = 'anotalo_task_reminder';
  static const int _taskNotifOffset = 100000;
  static const String prefRemindBeforeMin = 'pref_remind_before_min';

  int _taskNotifId(String taskId) =>
      _taskNotifOffset + (taskId.hashCode & 0x7FFFFFFF) % 900000;

  /// Programa un recordatorio one-shot para `dayId` (yyyy-mm-dd) +
  /// `time` ("HH:mm"). Si el horario ya pasó, no programa nada (la notif
  /// se generaría en el pasado y dispararía inmediatamente). Cancela
  /// cualquier notif previa de esta tarea antes de reagendar.
  Future<void> scheduleTaskReminder({
    required String taskId,
    required String taskTitle,
    required String dayId,
    required String time,
    int advanceMinutes = 0,
  }) async {
    if (!_initialized) return;
    final notifId = _taskNotifId(taskId);
    try {
      await _plugin.cancel(notifId);

      final dParts = dayId.split('-');
      final tParts = time.split(':');
      if (dParts.length != 3 || tParts.length != 2) return;
      final y = int.tryParse(dParts[0]);
      final mo = int.tryParse(dParts[1]);
      final d = int.tryParse(dParts[2]);
      final h = int.tryParse(tParts[0]);
      final mi = int.tryParse(tParts[1]);
      if (y == null || mo == null || d == null || h == null || mi == null) {
        return;
      }

      var scheduled = tz.TZDateTime(tz.local, y, mo, d, h, mi)
          .subtract(Duration(minutes: advanceMinutes));
      final now = tz.TZDateTime.now(tz.local);
      if (scheduled.isBefore(now)) return; // horario ya pasó

      const details = NotificationDetails(
        android: AndroidNotificationDetails(
          _taskChannelId,
          'Recordatorios de tareas',
          channelDescription: 'Aviso al horario de cada tarea programada',
          importance: Importance.high,
          priority: Priority.high,
        ),
      );

      final body = advanceMinutes == 0
          ? 'Es ahora — $time'
          : 'En $advanceMinutes min — $time';

      await _plugin.zonedSchedule(
        notifId,
        taskTitle,
        body,
        scheduled,
        details,
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      );
    } catch (e) {
      debugPrint('scheduleTaskReminder failed: $e');
    }
  }

  /// Cancela el recordatorio de una tarea (al completar / borrar / quitar
  /// el reminder). Idempotente.
  Future<void> cancelTaskReminder(String taskId) async {
    try {
      await _plugin.cancel(_taskNotifId(taskId));
    } catch (_) {}
  }

  /// Lee la preferencia "avisar N minutos antes" (0 = al horario exacto).
  static Future<int> getRemindBeforeMinutes() async {
    try {
      final p = await SharedPreferences.getInstance();
      return p.getInt(prefRemindBeforeMin) ?? 0;
    } catch (_) {
      return 0;
    }
  }

  /// Recordatorio diario por hábito. `notificationId` debe ser estable por
  /// hábito (por ejemplo `habitId.hashCode`). Llamalo nuevamente con la
  /// misma id para reprogramar/reagendar.
  Future<void> scheduleHabitReminder({
    required int notificationId,
    required String habitTitle,
    required int hour,
    required int minute,
  }) async {
    if (!_initialized) return;
    try {
      await _plugin.cancel(notificationId);
      final now = tz.TZDateTime.now(tz.local);
      var scheduled = tz.TZDateTime(
          tz.local, now.year, now.month, now.day, hour, minute);
      if (scheduled.isBefore(now)) {
        scheduled = scheduled.add(const Duration(days: 1));
      }
      const details = NotificationDetails(
        android: AndroidNotificationDetails(
          'anotalo_habit_reminder',
          'Hábitos',
          channelDescription: 'Recordatorio de hábitos diarios',
          importance: Importance.high,
          priority: Priority.high,
        ),
      );
      await _plugin.zonedSchedule(
        notificationId,
        habitTitle,
        'Es el momento — tu racha te espera',
        scheduled,
        details,
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.time,
      );
    } catch (e) {
      debugPrint('scheduleHabitReminder failed: $e');
    }
  }
}
