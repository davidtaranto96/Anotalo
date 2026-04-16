import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/database/database_providers.dart';
import '../../../../core/logic/timer_service.dart';
import '../../domain/models/timer_state.dart';

final timerServiceProvider = Provider((ref) =>
    TimerService(ref.watch(databaseProvider)));

class TimerNotifier extends StateNotifier<TimerState> {
  final TimerService _service;
  Timer? _timer;

  TimerNotifier(this._service) : super(TimerState.idle());

  void setMode(TimerMode mode) {
    if (state.status == TimerStatus.running) stop();
    state = TimerState(
      mode: mode,
      status: TimerStatus.idle,
      remainingSeconds: mode.durationSeconds,
      totalSeconds: mode.durationSeconds,
      sessionsCompleted: state.sessionsCompleted,
    );
  }

  void setLinkedTask(String? taskId) {
    state = state.copyWith(linkedTaskId: taskId);
  }

  void start() {
    if (state.status == TimerStatus.running) return;
    HapticFeedback.lightImpact();
    state = state.copyWith(status: TimerStatus.running);
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
  }

  void pause() {
    _timer?.cancel();
    HapticFeedback.lightImpact();
    state = state.copyWith(status: TimerStatus.paused);
  }

  void resume() {
    start();
  }

  void stop() {
    _timer?.cancel();
    _saveSession(completed: false);
    state = TimerState(
      mode: state.mode,
      status: TimerStatus.idle,
      remainingSeconds: state.mode.durationSeconds,
      totalSeconds: state.mode.durationSeconds,
      sessionsCompleted: state.sessionsCompleted,
    );
  }

  void toggle() {
    if (state.status == TimerStatus.running) {
      pause();
    } else if (state.status == TimerStatus.paused) {
      resume();
    } else {
      start();
    }
  }

  void _tick() {
    if (state.remainingSeconds <= 1) {
      _complete();
    } else {
      state = state.copyWith(remainingSeconds: state.remainingSeconds - 1);
    }
  }

  void _complete() {
    _timer?.cancel();
    // Triple pulse haptic + system alert sound so the user feels and hears
    // the session end even with the app in the background.
    HapticFeedback.heavyImpact();
    Future.delayed(const Duration(milliseconds: 180), () {
      HapticFeedback.heavyImpact();
    });
    Future.delayed(const Duration(milliseconds: 360), () {
      HapticFeedback.heavyImpact();
    });
    SystemSound.play(SystemSoundType.alert);
    _saveSession(completed: true);
    state = state.copyWith(
      status: TimerStatus.completed,
      remainingSeconds: 0,
      sessionsCompleted: state.sessionsCompleted + 1,
    );
  }

  /// Extend an already-completed (or running/paused) session by [extraSeconds].
  /// Used by the completion dialog when the user wants more time to finish a task.
  void extendBy(int extraSeconds) {
    if (extraSeconds <= 0) return;
    HapticFeedback.lightImpact();
    _timer?.cancel();
    state = state.copyWith(
      status: TimerStatus.running,
      remainingSeconds: extraSeconds,
      totalSeconds: state.totalSeconds + extraSeconds,
    );
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
  }

  /// Reset to idle without saving (used after handling the completion dialog).
  void resetToIdle() {
    _timer?.cancel();
    state = TimerState(
      mode: state.mode,
      status: TimerStatus.idle,
      remainingSeconds: state.mode.durationSeconds,
      totalSeconds: state.mode.durationSeconds,
      sessionsCompleted: state.sessionsCompleted,
      linkedTaskId: state.linkedTaskId,
    );
  }

  void _saveSession({required bool completed}) {
    final elapsed = state.totalSeconds - state.remainingSeconds;
    if (elapsed > 5) {
      _service.saveSession(
        mode: state.mode,
        durationSecs: elapsed,
        wasCompleted: completed,
        taskId: state.linkedTaskId,
      );
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

final timerNotifierProvider =
    StateNotifierProvider<TimerNotifier, TimerState>((ref) =>
        TimerNotifier(ref.watch(timerServiceProvider)));
