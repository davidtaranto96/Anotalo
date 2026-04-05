enum TimerMode {
  pomodoro25,
  pomodoro50,
  deepWork90,
  quick5,
  break5,
  break10,
  break15,
}

extension TimerModeX on TimerMode {
  int get durationSeconds => switch (this) {
    TimerMode.pomodoro25  => 25 * 60,
    TimerMode.pomodoro50  => 50 * 60,
    TimerMode.deepWork90  => 90 * 60,
    TimerMode.quick5      => 5 * 60,
    TimerMode.break5      => 5 * 60,
    TimerMode.break10     => 10 * 60,
    TimerMode.break15     => 15 * 60,
  };

  String get label => switch (this) {
    TimerMode.pomodoro25  => 'Pomodoro 25',
    TimerMode.pomodoro50  => 'Pomodoro 50',
    TimerMode.deepWork90  => 'Deep Work 90',
    TimerMode.quick5      => 'Rápido 5',
    TimerMode.break5      => 'Descanso 5',
    TimerMode.break10     => 'Descanso 10',
    TimerMode.break15     => 'Descanso 15',
  };

  String get dbValue => switch (this) {
    TimerMode.pomodoro25  => 'pomodoro_25',
    TimerMode.pomodoro50  => 'pomodoro_50',
    TimerMode.deepWork90  => 'deep_work_90',
    TimerMode.quick5      => 'quick_5',
    TimerMode.break5      => 'break_5',
    TimerMode.break10     => 'break_10',
    TimerMode.break15     => 'break_15',
  };
}

enum TimerStatus { idle, running, paused, completed }

class TimerState {
  final TimerMode mode;
  final TimerStatus status;
  final int remainingSeconds;
  final int totalSeconds;
  final String? linkedTaskId;
  final int sessionsCompleted;

  const TimerState({
    required this.mode,
    required this.status,
    required this.remainingSeconds,
    required this.totalSeconds,
    this.linkedTaskId,
    this.sessionsCompleted = 0,
  });

  factory TimerState.idle() => TimerState(
    mode: TimerMode.pomodoro25,
    status: TimerStatus.idle,
    remainingSeconds: TimerMode.pomodoro25.durationSeconds,
    totalSeconds: TimerMode.pomodoro25.durationSeconds,
  );

  TimerState copyWith({
    TimerMode? mode,
    TimerStatus? status,
    int? remainingSeconds,
    int? totalSeconds,
    String? linkedTaskId,
    int? sessionsCompleted,
  }) => TimerState(
    mode: mode ?? this.mode,
    status: status ?? this.status,
    remainingSeconds: remainingSeconds ?? this.remainingSeconds,
    totalSeconds: totalSeconds ?? this.totalSeconds,
    linkedTaskId: linkedTaskId ?? this.linkedTaskId,
    sessionsCompleted: sessionsCompleted ?? this.sessionsCompleted,
  );

  double get progress => totalSeconds == 0
      ? 0
      : 1 - (remainingSeconds / totalSeconds);
}
