import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/database/database_providers.dart';
import '../../../../core/logic/weekly_plan_service.dart';
import '../../../../core/utils/format_utils.dart';
import '../../../hoy/domain/models/task.dart';
import '../../../hoy/presentation/providers/task_provider.dart';

// ── Week navigation ──────────────────────────────────────────────────────────

/// 0 = current week, -1 = last week, +1 = next week, etc.
final weekOffsetProvider = StateProvider<int>((ref) => 0);

/// Index 0-6 (Mon-Sun) of the selected day pill.
final selectedDayIndexProvider = StateProvider<int>((ref) {
  return DateTime.now().weekday - 1; // Monday=0 .. Sunday=6
});

/// The 7 dates (Mon-Sun) for the currently viewed week.
final weekDaysProvider = Provider<List<DateTime>>((ref) {
  final offset = ref.watch(weekOffsetProvider);
  final now = DateTime.now();
  final monday = DateTime(now.year, now.month, now.day)
      .subtract(Duration(days: now.weekday - 1))
      .add(Duration(days: offset * 7));
  return List.generate(7, (i) => monday.add(Duration(days: i)));
});

/// Backward-compatible alias used by WeekDayColumn.
final currentWeekDaysProvider = weekDaysProvider;

// ── Tasks for a specific day ─────────────────────────────────────────────────

final dayTasksProvider = StreamProvider.family<List<Task>, String>((ref, dayId) =>
    ref.watch(taskServiceProvider).watchTasksByDay(dayId));

// ── Weekly plan ──────────────────────────────────────────────────────────────

final weeklyPlanServiceProvider = Provider((ref) =>
    WeeklyPlanService(ref.watch(databaseProvider)));

final weeklyPlanProvider = StreamProvider((ref) {
  final days = ref.watch(weekDaysProvider);
  final weekStart = dateToId(days.first);
  return ref.watch(weeklyPlanServiceProvider).watchWeeklyPlan(weekStart);
});
