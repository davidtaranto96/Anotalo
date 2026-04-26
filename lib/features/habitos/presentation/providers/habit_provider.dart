import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/database/database_providers.dart';
import '../../../../core/logic/habit_service.dart';
import '../../../../core/utils/format_utils.dart';
import '../../domain/models/habit.dart';

final habitServiceProvider = Provider((ref) =>
    HabitService(ref.watch(databaseProvider)));

final activeHabitsProvider = StreamProvider<List<Habit>>((ref) =>
    ref.watch(habitServiceProvider).watchActiveHabits());

final todayCompletionsProvider = StreamProvider<List<HabitCompletion>>((ref) =>
    ref.watch(habitServiceProvider).watchCompletionsForDay(todayId()));

final habitStreakProvider = FutureProvider.family<int, String>((ref, habitId) =>
    ref.watch(habitServiceProvider).getStreak(habitId));

/// Provides completion data for the current week (Mon-Sun).
/// Returns Map<dayId, Set<habitId>> for 7 days.
final weekCompletionsProvider = StreamProvider<Map<String, Set<String>>>((ref) {
  final service = ref.watch(habitServiceProvider);
  final now = DateTime.now();
  final monday = now.subtract(Duration(days: now.weekday - 1));
  final days = List.generate(7, (i) => dateToId(monday.add(Duration(days: i))));
  return service.watchWeekCompletions(days);
});

/// All-time completions (across habits) — powers the aggregate stats section.
final allCompletionsProvider = StreamProvider<List<HabitCompletion>>((ref) =>
    ref.watch(habitServiceProvider).watchAllCompletions());

/// Conteo de completions por hábito en la semana actual (lunes → domingo).
/// Map<habitId, count>. Lo usa el HabitCard para mostrar "X / N esta semana"
/// en hábitos con `frequency == weekly`.
final thisWeekCompletionCountProvider =
    Provider<Map<String, int>>((ref) {
  final all = ref.watch(allCompletionsProvider).valueOrNull ?? const [];
  final now = DateTime.now();
  // Lunes de la semana actual: weekday 1 = lunes.
  final monday = DateTime(now.year, now.month, now.day)
      .subtract(Duration(days: now.weekday - 1));
  final weekIds = List<String>.generate(7, (i) {
    final d = monday.add(Duration(days: i));
    return dateToId(d);
  });
  final weekSet = weekIds.toSet();
  final out = <String, int>{};
  for (final c in all) {
    if (!weekSet.contains(c.dayId)) continue;
    out[c.habitId] = (out[c.habitId] ?? 0) + 1;
  }
  return out;
});
