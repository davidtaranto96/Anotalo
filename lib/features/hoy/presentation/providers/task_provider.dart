import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/database/database_providers.dart';
import '../../../../core/logic/task_service.dart';
import '../../../../core/utils/format_utils.dart';
import '../../domain/models/task.dart';

final taskServiceProvider = Provider((ref) =>
    TaskService(ref.watch(databaseProvider)));

final todayTasksProvider = StreamProvider<List<Task>>((ref) {
  final dayId = todayId();
  // Uses the rollover-aware stream: tasks for today + pending tasks
  // from previous days that the user never moved/completed.
  return ref.watch(taskServiceProvider).watchTodayTasks(dayId);
});

final primordialTasksProvider = Provider<List<Task>>((ref) {
  return ref.watch(todayTasksProvider).valueOrNull
      ?.where((t) => t.priority == TaskPriority.primordial && t.status != TaskStatus.done)
      .toList() ?? [];
});

final importanteTasksProvider = Provider<List<Task>>((ref) {
  return ref.watch(todayTasksProvider).valueOrNull
      ?.where((t) => t.priority == TaskPriority.importante && t.status != TaskStatus.done)
      .toList() ?? [];
});

final puedeEsperarTasksProvider = Provider<List<Task>>((ref) {
  return ref.watch(todayTasksProvider).valueOrNull
      ?.where((t) => (t.priority == TaskPriority.puedeEsperar || t.priority == TaskPriority.secundaria) && t.status != TaskStatus.done)
      .toList() ?? [];
});

final completedTasksProvider = Provider<List<Task>>((ref) {
  return ref.watch(todayTasksProvider).valueOrNull
      ?.where((t) => t.status == TaskStatus.done)
      .toList() ?? [];
});

final dayProgressProvider = Provider<double>((ref) {
  final all = ref.watch(todayTasksProvider).valueOrNull ?? [];
  if (all.isEmpty) return 0.0;
  final done = all.where((t) => t.status == TaskStatus.done).length;
  return done / all.length;
});

/// Counts consecutive past days (starting from yesterday) that have at least
/// one completed task. Returns 0 if yesterday had no completions.
final streakProvider = FutureProvider<int>((ref) async {
  final service = ref.watch(taskServiceProvider);
  int streak = 0;
  DateTime day = DateTime.now().subtract(const Duration(days: 1));

  for (;;) {
    final dayId = dateToId(day);
    final completed = await service.countCompletedToday(dayId);
    if (completed == 0) break;
    streak++;
    day = day.subtract(const Duration(days: 1));
  }

  // Also count today if there's at least one completion
  final todayCompleted = await service.countCompletedToday(todayId());
  if (todayCompleted > 0) streak++;

  return streak;
});
