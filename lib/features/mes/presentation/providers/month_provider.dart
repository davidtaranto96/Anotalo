import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/format_utils.dart';
import '../../../hoy/domain/models/task.dart';
import '../../../hoy/presentation/providers/task_provider.dart';

/// Mes/año actualmente visible en la vista de calendario. El usuario
/// avanza/retrocede con las flechas del header de TableCalendar.
final visibleMonthProvider =
    StateProvider<DateTime>((ref) => DateTime(DateTime.now().year, DateTime.now().month, 1));

/// Stream de tareas dentro del mes visible (con padding de 7 días antes
/// y después para cubrir las celdas del calendario que pertenecen a
/// meses adyacentes).
final tasksByDayProvider = StreamProvider<Map<String, List<Task>>>((ref) {
  final visible = ref.watch(visibleMonthProvider);
  final from = DateTime(visible.year, visible.month, 1)
      .subtract(const Duration(days: 7));
  // Último día del mes + padding hacia adelante.
  final lastDay = DateTime(visible.year, visible.month + 1, 0);
  final to = lastDay.add(const Duration(days: 7));
  final fromId = dateToId(from);
  final toId = dateToId(to);
  final service = ref.watch(taskServiceProvider);
  return service.watchTasksInRange(fromId, toId).map((tasks) {
    final map = <String, List<Task>>{};
    for (final t in tasks) {
      map.putIfAbsent(t.dayId, () => []).add(t);
    }
    return map;
  });
});
