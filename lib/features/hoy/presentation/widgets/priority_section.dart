import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../domain/models/task.dart';
import 'task_card.dart';

class PrioritySection extends StatelessWidget {
  final TaskPriority priority;
  final List<Task> tasks;
  final Function(String) onComplete;
  final Function(String)? onUncomplete;
  final Function(String) onDefer;
  final Function(String) onDelete;

  const PrioritySection({
    super.key,
    required this.priority,
    required this.tasks,
    required this.onComplete,
    this.onUncomplete,
    required this.onDefer,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    if (tasks.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
          child: Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _priorityColor(priority),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                _priorityLabel(priority),
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: _priorityColor(priority),
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '${tasks.length}',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: context.textTertiary,
                ),
              ),
            ],
          ),
        ),
        ...tasks.asMap().entries.map((entry) {
          final index = entry.key;
          final task = entry.value;
          return Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (priority == TaskPriority.primordial) ...[
                const SizedBox(width: 16),
                Container(
                  width: 24,
                  height: 24,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFFD97757), // AppTheme.colorAccent (orange)
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '${index + 1}',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
              Expanded(
                child: TaskCard(
                  task: task,
                  onComplete: () => onComplete(task.id),
                  onUncomplete: onUncomplete != null ? () => onUncomplete!(task.id) : null,
                  onDefer: () => onDefer(task.id),
                  onDelete: () => onDelete(task.id),
                ),
              ),
            ],
          );
        }),
      ],
    );
  }

  String _priorityLabel(TaskPriority p) => switch (p) {
    TaskPriority.primordial   => 'PRIMORDIAL',
    TaskPriority.importante   => 'IMPORTANTE',
    TaskPriority.puedeEsperar => 'PUEDE ESPERAR',
    TaskPriority.secundaria   => 'SECUNDARIA',
  };

  Color _priorityColor(TaskPriority p) => switch (p) {
    TaskPriority.primordial   => AppTheme.colorDanger,
    TaskPriority.importante   => AppTheme.colorWarning,
    TaskPriority.puedeEsperar => AppTheme.colorPrimary,
    TaskPriority.secundaria   => AppTheme.neutral400,
  };
}
