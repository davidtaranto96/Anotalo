import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../domain/models/task.dart';
import '../providers/task_provider.dart';
import 'task_card.dart';

/// Sección de tareas filtrada por prioridad. Soporta drag-to-reorder
/// vía long-press: el orden se persiste en `tasks.sort_order`.
class PrioritySection extends ConsumerWidget {
  final TaskPriority priority;
  final List<Task> tasks;
  final Function(String) onComplete;
  final Function(String)? onUncomplete;
  final Function(String) onDefer;
  final Function(String) onDelete;

  /// Área actualmente filtrada en Hoy. Se propaga al TaskCard para que
  /// omita mostrar el chip de área cuando es el mismo que el filtro.
  final String? currentFilterAreaId;

  const PrioritySection({
    super.key,
    required this.priority,
    required this.tasks,
    required this.onComplete,
    this.onUncomplete,
    required this.onDefer,
    required this.onDelete,
    this.currentFilterAreaId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
        // ReorderableListView con long-press = drag. El swipe horizontal
        // del Slidable adentro de TaskCard sigue funcionando — no chocan
        // porque uno es vertical (drag) y el otro horizontal (swipe).
        ReorderableListView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          buildDefaultDragHandles: false,
          proxyDecorator: (child, index, animation) => Material(
            color: Colors.transparent,
            child: child,
          ),
          onReorder: (oldIndex, newIndex) async {
            final adjustedNew =
                newIndex > oldIndex ? newIndex - 1 : newIndex;
            final updated = List<Task>.from(tasks);
            final moved = updated.removeAt(oldIndex);
            updated.insert(adjustedNew, moved);
            await ref
                .read(taskServiceProvider)
                .reorderTasks(updated.map((t) => t.id).toList());
          },
          children: [
            for (var i = 0; i < tasks.length; i++)
              ReorderableDelayedDragStartListener(
                key: ValueKey('task-${tasks[i].id}'),
                index: i,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (priority == TaskPriority.primordial) ...[
                      const SizedBox(width: 16),
                      Container(
                        width: 24,
                        height: 24,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFFD97757),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          '${i + 1}',
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
                        task: tasks[i],
                        currentFilterAreaId: currentFilterAreaId,
                        onComplete: () => onComplete(tasks[i].id),
                        onUncomplete: onUncomplete != null
                            ? () => onUncomplete!(tasks[i].id)
                            : null,
                        onDefer: () => onDefer(tasks[i].id),
                        onDelete: () => onDelete(tasks[i].id),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ],
    );
  }

  String _priorityLabel(TaskPriority p) => switch (p) {
        TaskPriority.primordial => 'PRIMORDIAL',
        TaskPriority.importante => 'IMPORTANTE',
        TaskPriority.puedeEsperar => 'PUEDE ESPERAR',
        TaskPriority.secundaria => 'SECUNDARIA',
      };

  Color _priorityColor(TaskPriority p) => switch (p) {
        TaskPriority.primordial => AppTheme.colorDanger,
        TaskPriority.importante => AppTheme.colorWarning,
        TaskPriority.puedeEsperar => AppTheme.colorPrimary,
        TaskPriority.secundaria => AppTheme.neutral400,
      };
}
