import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:table_calendar/table_calendar.dart' show isSameDay;

import '../../../../core/feedback/feedback_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/format_utils.dart';
import '../../../hoy/domain/models/task.dart';

/// Vista de "una semana" estilo Semana: 7 cards con el día/fecha
/// (LUN/20) + counts "1/5" (done/total) + dot verde si todos
/// los pendientes están completos. La card del día seleccionado
/// tiene borde primary + texto naranja.
///
/// Se usa cuando el calendario en MesPage está en modo `week`.
/// Reemplaza al TableCalendar.week para que la UX en formato
/// semana siga sintiéndose familiar.
class WeekStrip extends StatelessWidget {
  const WeekStrip({
    super.key,
    required this.weekStart,
    required this.selected,
    required this.tasksByDay,
    required this.onDayTap,
    required this.onTaskDroppedOnDay,
  });

  /// Lunes de la semana visible (00:00).
  final DateTime weekStart;
  final DateTime selected;
  final Map<String, List<Task>> tasksByDay;
  final ValueChanged<DateTime> onDayTap;
  final void Function(Task task, DateTime targetDay) onTaskDroppedOnDay;

  static const _dayLabels = ['LUN', 'MAR', 'MIÉ', 'JUE', 'VIE', 'SÁB', 'DOM'];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: Row(
        children: [
          for (var i = 0; i < 7; i++) ...[
            Expanded(
              child: _DayCard(
                day: weekStart.add(Duration(days: i)),
                label: _dayLabels[i],
                isSelected: isSameDay(weekStart.add(Duration(days: i)), selected),
                tasks: tasksByDay[
                        dateToId(weekStart.add(Duration(days: i)))] ??
                    const [],
                onTap: () => onDayTap(weekStart.add(Duration(days: i))),
                onTaskDropped: (task) => onTaskDroppedOnDay(
                    task, weekStart.add(Duration(days: i))),
              ),
            ),
            if (i != 6) const SizedBox(width: 4),
          ],
        ],
      ),
    );
  }
}

class _DayCard extends StatelessWidget {
  const _DayCard({
    required this.day,
    required this.label,
    required this.isSelected,
    required this.tasks,
    required this.onTap,
    required this.onTaskDropped,
  });

  final DateTime day;
  final String label;
  final bool isSelected;
  final List<Task> tasks;
  final VoidCallback onTap;
  final ValueChanged<Task> onTaskDropped;

  @override
  Widget build(BuildContext context) {
    final total = tasks.length;
    final done = tasks.where((t) => t.status == TaskStatus.done).length;
    final allDone = total > 0 && done == total;
    final isToday = isSameDay(day, DateTime.now());

    final borderColor = isSelected
        ? AppTheme.colorPrimary
        : (isToday
            ? AppTheme.colorPrimary.withAlpha(80)
            : context.dividerColor);
    final dayNumColor = isSelected
        ? AppTheme.colorPrimary
        : (isToday ? AppTheme.colorPrimary : context.textPrimary);

    return DragTarget<Task>(
      onAcceptWithDetails: (d) => onTaskDropped(d.data),
      builder: (ctx, candidates, _) {
        final hovering = candidates.isNotEmpty;
        return GestureDetector(
          onTap: () {
            FeedbackService.instance.tick();
            onTap();
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
            decoration: BoxDecoration(
              color: hovering
                  ? AppTheme.colorPrimary.withAlpha(50)
                  : (isSelected
                      ? AppTheme.colorPrimary.withAlpha(20)
                      : context.surfaceCard),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: hovering ? AppTheme.colorPrimary : borderColor,
                width: hovering || isSelected ? 1.5 : 1,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: isSelected
                        ? AppTheme.colorPrimary
                        : context.textTertiary,
                    letterSpacing: 0.6,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${day.day}',
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: dayNumColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$done/$total',
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: total == 0
                        ? context.textTertiary
                        : (allDone
                            ? AppTheme.colorSuccess
                            : context.textSecondary),
                  ),
                ),
                const SizedBox(height: 3),
                // Dot — verde si todo done, ámbar si hay pending,
                // gris si no hay tareas.
                Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: total == 0
                        ? Colors.transparent
                        : (allDone
                            ? AppTheme.colorSuccess
                            : AppTheme.colorWarning),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
