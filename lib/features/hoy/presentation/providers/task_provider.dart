import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/database/database_providers.dart';
import '../../../../core/logic/task_service.dart';
import '../../../../core/utils/format_utils.dart';
import '../../domain/models/task.dart';

final taskServiceProvider = Provider((ref) =>
    TaskService(ref.watch(databaseProvider)));

final todayTasksProvider = StreamProvider<List<Task>>((ref) {
  final dayId = todayId();
  return ref.watch(taskServiceProvider).watchTasksByDay(dayId);
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
      ?.where((t) => t.priority == TaskPriority.puedeEsperar && t.status != TaskStatus.done)
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
