import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../features/hoy/domain/models/task.dart';
import '../../features/enfoque/domain/models/timer_state.dart';

/// Centralized user preferences, backed by SharedPreferences.
/// Read reactively via [userPrefsProvider].
class UserPrefs {
  static const _kDefaultPriority = 'pref_default_priority';
  static const _kDefaultArea = 'pref_default_area';
  static const _kDefaultTimerMode = 'pref_default_timer_mode';
  static const _kShowQuotes = 'pref_show_quotes';
  static const _kShowHabitsInHoy = 'pref_show_habits_in_hoy';
  static const _kUserName = 'pref_user_name';
  static const _kRemindBeforeMin = 'pref_remind_before_min';

  final TaskPriority defaultPriority;
  final String? defaultArea;
  final TimerMode defaultTimerMode;
  final bool showQuotes;
  final bool showHabitsInHoy;
  /// Nombre del usuario (capturado en onboarding) para el saludo de Hoy.
  /// Vacío = sin saludo personalizado.
  final String userName;
  /// Minutos de antelación para los recordatorios de tareas (0/5/10/15).
  /// 0 = al horario exacto.
  final int remindBeforeMinutes;

  const UserPrefs({
    required this.defaultPriority,
    required this.defaultArea,
    required this.defaultTimerMode,
    required this.showQuotes,
    required this.showHabitsInHoy,
    required this.userName,
    required this.remindBeforeMinutes,
  });

  factory UserPrefs.defaults() => const UserPrefs(
    defaultPriority: TaskPriority.importante,
    defaultArea: null,
    defaultTimerMode: TimerMode.pomodoro25,
    showQuotes: true,
    showHabitsInHoy: true,
    userName: '',
    remindBeforeMinutes: 0,
  );

  UserPrefs copyWith({
    TaskPriority? defaultPriority,
    Object? defaultArea = _sentinel,
    TimerMode? defaultTimerMode,
    bool? showQuotes,
    bool? showHabitsInHoy,
    String? userName,
    int? remindBeforeMinutes,
  }) => UserPrefs(
    defaultPriority: defaultPriority ?? this.defaultPriority,
    defaultArea: defaultArea == _sentinel ? this.defaultArea : defaultArea as String?,
    defaultTimerMode: defaultTimerMode ?? this.defaultTimerMode,
    showQuotes: showQuotes ?? this.showQuotes,
    showHabitsInHoy: showHabitsInHoy ?? this.showHabitsInHoy,
    userName: userName ?? this.userName,
    remindBeforeMinutes: remindBeforeMinutes ?? this.remindBeforeMinutes,
  );
}

const _sentinel = Object();

class UserPrefsNotifier extends StateNotifier<UserPrefs> {
  UserPrefsNotifier() : super(UserPrefs.defaults()) {
    _load();
  }

  Future<void> _load() async {
    final p = await SharedPreferences.getInstance();
    state = UserPrefs(
      defaultPriority: TaskPriorityX.fromString(
        p.getString(UserPrefs._kDefaultPriority) ?? 'importante',
      ),
      defaultArea: p.getString(UserPrefs._kDefaultArea),
      defaultTimerMode: _modeFromDb(p.getString(UserPrefs._kDefaultTimerMode)),
      showQuotes: p.getBool(UserPrefs._kShowQuotes) ?? true,
      showHabitsInHoy: p.getBool(UserPrefs._kShowHabitsInHoy) ?? true,
      userName: p.getString(UserPrefs._kUserName) ?? '',
      remindBeforeMinutes: p.getInt(UserPrefs._kRemindBeforeMin) ?? 0,
    );
  }

  Future<void> setUserName(String value) async {
    final p = await SharedPreferences.getInstance();
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      await p.remove(UserPrefs._kUserName);
    } else {
      await p.setString(UserPrefs._kUserName, trimmed);
    }
    state = state.copyWith(userName: trimmed);
  }

  Future<void> setRemindBeforeMinutes(int minutes) async {
    final p = await SharedPreferences.getInstance();
    await p.setInt(UserPrefs._kRemindBeforeMin, minutes);
    // El TaskService lee la pref desde SharedPreferences en cada
    // schedule, así que no hace falta reagendar nada manualmente —
    // las próximas notifs ya van a usar el nuevo valor.
    state = state.copyWith(remindBeforeMinutes: minutes);
  }

  Future<void> setDefaultPriority(TaskPriority value) async {
    final p = await SharedPreferences.getInstance();
    await p.setString(UserPrefs._kDefaultPriority, value.value);
    state = state.copyWith(defaultPriority: value);
  }

  Future<void> setDefaultArea(String? value) async {
    final p = await SharedPreferences.getInstance();
    if (value == null) {
      await p.remove(UserPrefs._kDefaultArea);
    } else {
      await p.setString(UserPrefs._kDefaultArea, value);
    }
    state = state.copyWith(defaultArea: value);
  }

  Future<void> setDefaultTimerMode(TimerMode mode) async {
    final p = await SharedPreferences.getInstance();
    await p.setString(UserPrefs._kDefaultTimerMode, mode.dbValue);
    state = state.copyWith(defaultTimerMode: mode);
  }

  Future<void> setShowQuotes(bool value) async {
    final p = await SharedPreferences.getInstance();
    await p.setBool(UserPrefs._kShowQuotes, value);
    state = state.copyWith(showQuotes: value);
  }

  Future<void> setShowHabitsInHoy(bool value) async {
    final p = await SharedPreferences.getInstance();
    await p.setBool(UserPrefs._kShowHabitsInHoy, value);
    state = state.copyWith(showHabitsInHoy: value);
  }

  TimerMode _modeFromDb(String? s) => switch (s) {
    'pomodoro_25' => TimerMode.pomodoro25,
    'pomodoro_50' => TimerMode.pomodoro50,
    'deep_work_90' => TimerMode.deepWork90,
    'quick_5' => TimerMode.quick5,
    'break_5' => TimerMode.break5,
    'break_10' => TimerMode.break10,
    'break_15' => TimerMode.break15,
    _ => TimerMode.pomodoro25,
  };
}

final userPrefsProvider = StateNotifierProvider<UserPrefsNotifier, UserPrefs>(
  (ref) => UserPrefsNotifier(),
);
