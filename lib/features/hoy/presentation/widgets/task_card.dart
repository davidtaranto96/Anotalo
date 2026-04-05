import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../domain/models/task.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback onComplete;
  final VoidCallback onDefer;
  final VoidCallback onDelete;

  const TaskCard({
    super.key,
    required this.task,
    required this.onComplete,
    required this.onDefer,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Slidable(
        key: ValueKey(task.id),
        endActionPane: ActionPane(
          motion: const DrawerMotion(),
          extentRatio: 0.55,
          children: [
            SlidableAction(
              onPressed: (_) {
                HapticFeedback.lightImpact();
                onDefer();
              },
              backgroundColor: AppTheme.colorWarning,
              foregroundColor: Colors.white,
              icon: Icons.schedule_rounded,
              label: 'Diferir',
              borderRadius: const BorderRadius.horizontal(left: Radius.circular(12)),
            ),
            SlidableAction(
              onPressed: (_) {
                HapticFeedback.heavyImpact();
                onDelete();
              },
              backgroundColor: AppTheme.colorDanger,
              foregroundColor: Colors.white,
              icon: Icons.delete_rounded,
              label: 'Borrar',
              borderRadius: const BorderRadius.horizontal(right: Radius.circular(12)),
            ),
          ],
        ),
        child: Container(
          decoration: BoxDecoration(
            color: AppTheme.surfaceCard,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.white.withAlpha((0.07 * 255).round()),
            ),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            leading: GestureDetector(
              onTap: () {
                HapticFeedback.lightImpact();
                onComplete();
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: _priorityColor(task.priority),
                    width: 2,
                  ),
                  color: task.status == TaskStatus.done
                      ? _priorityColor(task.priority)
                      : Colors.transparent,
                ),
                child: task.status == TaskStatus.done
                    ? const Icon(Icons.check, size: 14, color: Colors.white)
                    : null,
              ),
            ),
            title: Text(
              task.title,
              style: GoogleFonts.inter(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: task.status == TaskStatus.done
                    ? AppTheme.colorNeutral
                    : const Color(0xFFF0F0FF),
                decoration: task.status == TaskStatus.done
                    ? TextDecoration.lineThrough
                    : null,
              ),
            ),
            subtitle: task.estimatedMinutes != null
                ? Text(
                    '${task.estimatedMinutes} min',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: AppTheme.colorNeutral,
                    ),
                  )
                : null,
          ),
        ),
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
