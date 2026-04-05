import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../domain/models/task.dart';
import 'task_card.dart';

class PrioritySection extends StatelessWidget {
  final TaskPriority priority;
  final List<Task> tasks;
  final Function(String) onComplete;
  final Function(String) onDefer;
  final Function(String) onDelete;

  const PrioritySection({
    super.key,
    required this.priority,
    required this.tasks,
    required this.onComplete,
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
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
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
                  fontSize: 12,
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
                  color: AppTheme.colorNeutral,
                ),
              ),
            ],
          ),
        ),
        ...tasks.map((task) => TaskCard(
          task: task,
          onComplete: () => onComplete(task.id),
          onDefer: () => onDefer(task.id),
          onDelete: () => onDelete(task.id),
        )),
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
    TaskPriority.secundaria   => AppTheme.colorNeutral,
  };
}
