import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../hoy/domain/models/task.dart';
import '../../../hoy/presentation/providers/task_provider.dart';

// Tasks for a specific day
final dayTasksProvider = StreamProvider.family<List<Task>, String>((ref, dayId) =>
    ref.watch(taskServiceProvider).watchTasksByDay(dayId));

// Current week days (Mon-Sun)
final currentWeekDaysProvider = Provider<List<DateTime>>((ref) {
  final now = DateTime.now();
  final monday = now.subtract(Duration(days: now.weekday - 1));
  return List.generate(7, (i) => monday.add(Duration(days: i)));
});
