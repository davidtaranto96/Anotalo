import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/utils/format_utils.dart';
import '../../../hoy/domain/models/task.dart';
import '../providers/semana_provider.dart';

class WeekDayColumn extends ConsumerWidget {
  final DateTime date;
  final Function(Task, String) onTaskDropped;

  const WeekDayColumn({
    super.key,
    required this.date,
    required this.onTaskDropped,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dayId = dateToId(date);
    final tasksAsync = ref.watch(dayTasksProvider(dayId));
    final isToday = dayId == todayId();

    return DragTarget<Task>(
      onAcceptWithDetails: (details) => onTaskDropped(details.data, dayId),
      builder: (context, candidateData, rejectedData) {
        final isHovered = candidateData.isNotEmpty;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            color: isHovered
                ? AppTheme.colorPrimary.withAlpha((0.1 * 255).round())
                : isToday
                    ? AppTheme.surfaceElevated
                    : AppTheme.surfaceCard,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isToday
                  ? AppTheme.colorPrimary.withAlpha((0.3 * 255).round())
                  : isHovered
                      ? AppTheme.colorPrimary.withAlpha((0.4 * 255).round())
                      : Colors.white.withAlpha((0.07 * 255).round()),
            ),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  children: [
                    Text(
                      shortDayName(date).toUpperCase().substring(0, 3),
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: isToday ? AppTheme.colorPrimary : AppTheme.colorNeutral,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${date.day}',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: isToday ? AppTheme.colorPrimary : const Color(0xFFF0F0FF),
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1, color: Color(0x10FFFFFF)),
              Expanded(
                child: tasksAsync.when(
                  data: (tasks) {
                    final pending = tasks.where(
                      (t) => t.status != TaskStatus.done && t.status != TaskStatus.deleted
                    ).toList();
                    return ListView.builder(
                      padding: const EdgeInsets.all(4),
                      itemCount: pending.length,
                      itemBuilder: (_, i) => _WeekTaskChip(task: pending[i]),
                    );
                  },
                  loading: () => const SizedBox.shrink(),
                  error: (_, __) => const SizedBox.shrink(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _WeekTaskChip extends StatelessWidget {
  final Task task;
  const _WeekTaskChip({required this.task});

  @override
  Widget build(BuildContext context) {
    return LongPressDraggable<Task>(
      data: task,
      feedback: Material(
        color: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: _priorityColor(task.priority).withAlpha((0.9 * 255).round()),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            task.title,
            style: GoogleFonts.inter(fontSize: 11, color: Colors.white),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
      childWhenDragging: Opacity(
        opacity: 0.3,
        child: _chip(),
      ),
      child: _chip(),
    );
  }

  Widget _chip() {
    return Container(
      margin: const EdgeInsets.only(bottom: 3),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: _priorityColor(task.priority).withAlpha((0.15 * 255).round()),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: _priorityColor(task.priority).withAlpha((0.3 * 255).round()),
        ),
      ),
      child: Text(
        task.title,
        style: GoogleFonts.inter(
          fontSize: 11,
          color: const Color(0xFFF0F0FF),
        ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Color _priorityColor(TaskPriority p) => switch (p) {
    TaskPriority.primordial   => AppTheme.colorDanger,
    TaskPriority.importante   => AppTheme.colorWarning,
    TaskPriority.puedeEsperar => AppTheme.colorPrimary,
    TaskPriority.secundaria   => AppTheme.colorNeutral,
  };
}
