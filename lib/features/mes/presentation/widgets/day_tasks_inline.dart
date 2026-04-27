import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../../core/feedback/feedback_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../hoy/domain/models/task.dart';
import '../../../hoy/presentation/providers/task_provider.dart';

/// Lista inline de tareas del día seleccionado.
/// - Pending arriba (lista plana, drag handle ≡ para reordenar)
/// - Completadas en sección colapsable abajo
/// - Cada tarea es un `LongPressDraggable<Task>` para mover de día
class DayTasksInline extends ConsumerStatefulWidget {
  const DayTasksInline({
    super.key,
    required this.day,
    required this.tasks,
    required this.onComplete,
    required this.onUncomplete,
    required this.onDelete,
  });

  final DateTime day;
  final List<Task> tasks;
  final void Function(String id) onComplete;
  final void Function(String id) onUncomplete;
  final void Function(String id) onDelete;

  @override
  ConsumerState<DayTasksInline> createState() => _DayTasksInlineState();
}

class _DayTasksInlineState extends ConsumerState<DayTasksInline> {
  bool _completedExpanded = false;

  @override
  Widget build(BuildContext context) {
    // Ya vienen ordenadas por sortOrder asc desde watchTasksInRange.
    final pending = widget.tasks
        .where((t) => t.status != TaskStatus.done)
        .toList();
    final completed = widget.tasks
        .where((t) => t.status == TaskStatus.done)
        .toList();

    final dateLabel = DateFormat("EEEE d 'de' MMMM", 'es')
        .format(widget.day)
        .replaceFirstMapped(
            RegExp(r'^[a-zñáéíóú]'), (m) => m.group(0)!.toUpperCase());

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 6),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      dateLabel,
                      style: GoogleFonts.fraunces(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: context.textPrimary,
                        letterSpacing: -0.2,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      widget.tasks.isEmpty
                          ? 'Día libre'
                          : '${pending.length} pendiente${pending.length == 1 ? "" : "s"}'
                              '${completed.isNotEmpty ? " · ${completed.length} ✓" : ""}',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: context.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              if (pending.length > 1)
                Text(
                  'Tocá ≡ para reordenar',
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    color: context.textTertiary,
                    fontStyle: FontStyle.italic,
                  ),
                ),
            ],
          ),
        ),
        Expanded(
          child: widget.tasks.isEmpty
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.event_available_rounded,
                          size: 36, color: context.textTertiary),
                      const SizedBox(height: 8),
                      Text(
                        'Sin tareas para este día',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          color: context.textTertiary,
                        ),
                      ),
                    ],
                  ),
                )
              : CustomScrollView(
                  slivers: [
                    // ── Pending (reordenable) ──────────────────────
                    if (pending.isNotEmpty)
                      SliverReorderableList(
                        itemCount: pending.length,
                        itemBuilder: (ctx, i) {
                          return _PendingTaskRow(
                            key: ValueKey('day-task-${pending[i].id}'),
                            task: pending[i],
                            index: i,
                            onComplete: widget.onComplete,
                            onDelete: widget.onDelete,
                          );
                        },
                        onReorder: (oldIndex, newIndex) async {
                          FeedbackService.instance.tick();
                          final adjustedNew =
                              newIndex > oldIndex ? newIndex - 1 : newIndex;
                          final updated = List<Task>.from(pending);
                          final moved = updated.removeAt(oldIndex);
                          updated.insert(adjustedNew, moved);
                          await ref
                              .read(taskServiceProvider)
                              .reorderTasks(updated.map((t) => t.id).toList());
                        },
                      ),

                    // ── Completed (colapsable) ──────────────────────
                    if (completed.isNotEmpty)
                      SliverToBoxAdapter(
                        child: _CompletedSection(
                          tasks: completed,
                          expanded: _completedExpanded,
                          onToggle: () {
                            FeedbackService.instance.tick();
                            setState(() =>
                                _completedExpanded = !_completedExpanded);
                          },
                          onUncomplete: widget.onUncomplete,
                          onDelete: widget.onDelete,
                        ),
                      ),
                    const SliverToBoxAdapter(child: SizedBox(height: 8)),
                  ],
                ),
        ),
      ],
    );
  }
}

/// Fila de tarea pendiente: drag handle ≡ a la izquierda para reorder
/// vertical (mismo día) + cuerpo `LongPressDraggable<Task>` para mover
/// a otra celda del calendario.
class _PendingTaskRow extends StatelessWidget {
  const _PendingTaskRow({
    super.key,
    required this.task,
    required this.index,
    required this.onComplete,
    required this.onDelete,
  });
  final Task task;
  final int index;
  final void Function(String id) onComplete;
  final void Function(String id) onDelete;

  Color _priorityColor() => switch (task.priority) {
        TaskPriority.primordial => AppTheme.colorDanger,
        TaskPriority.importante => AppTheme.colorWarning,
        TaskPriority.puedeEsperar => AppTheme.colorPrimary,
        TaskPriority.secundaria => AppTheme.neutral400,
      };

  @override
  Widget build(BuildContext context) {
    final priorityColor = _priorityColor();
    final body = Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 6),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: context.surfaceCard,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: priorityColor.withAlpha(70)),
      ),
      child: Row(
        children: [
          // Drag handle visible — sólo este inicia el reorder
          ReorderableDragStartListener(
            index: index,
            child: MouseRegion(
              cursor: SystemMouseCursors.grab,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 4, vertical: 4),
                child: Icon(Icons.drag_indicator_rounded,
                    size: 18, color: context.textTertiary),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              FeedbackService.instance.success();
              onComplete(task.id);
            },
            child: Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: priorityColor, width: 2),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              task.title,
              style: GoogleFonts.inter(
                fontSize: 13.5,
                fontWeight: FontWeight.w500,
                color: context.textPrimary,
              ),
            ),
          ),
          IconButton(
            tooltip: 'Borrar',
            icon: const Icon(Icons.delete_outline_rounded, size: 18),
            color: AppTheme.colorDanger,
            onPressed: () {
              FeedbackService.instance.danger();
              onDelete(task.id);
            },
          ),
        ],
      ),
    );

    // El cuerpo es Draggable para mover-de-día. El drag handle (arriba)
    // captura el long-press del reorder antes de que llegue acá.
    return LongPressDraggable<Task>(
      key: ValueKey('drag-${task.id}'),
      data: task,
      delay: const Duration(milliseconds: 320),
      onDragStarted: () => FeedbackService.instance.warn(),
      feedback: Material(
        color: Colors.transparent,
        child: Container(
          width: 240,
          padding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: priorityColor,
            borderRadius: BorderRadius.circular(10),
            boxShadow: const [
              BoxShadow(
                color: Colors.black54,
                blurRadius: 12,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              const Icon(Icons.drag_indicator_rounded,
                  color: Colors.white, size: 18),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  task.title,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
      childWhenDragging: Opacity(opacity: 0.4, child: body),
      child: body,
    );
  }
}

/// Sección colapsable de tareas completadas. Header con count y chevron;
/// tap = toggle.
class _CompletedSection extends StatelessWidget {
  const _CompletedSection({
    required this.tasks,
    required this.expanded,
    required this.onToggle,
    required this.onUncomplete,
    required this.onDelete,
  });
  final List<Task> tasks;
  final bool expanded;
  final VoidCallback onToggle;
  final void Function(String id) onUncomplete;
  final void Function(String id) onDelete;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          InkWell(
            onTap: onToggle,
            borderRadius: BorderRadius.circular(10),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 8, vertical: 8),
              child: Row(
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppTheme.colorSuccess,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'COMPLETADAS',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.colorSuccess,
                      letterSpacing: 0.8,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 7, vertical: 1),
                    decoration: BoxDecoration(
                      color: AppTheme.colorSuccess.withAlpha(30),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '${tasks.length}',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.colorSuccess,
                      ),
                    ),
                  ),
                  const Spacer(),
                  AnimatedRotation(
                    turns: expanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 180),
                    child: Icon(Icons.expand_more_rounded,
                        color: context.textSecondary, size: 20),
                  ),
                ],
              ),
            ),
          ),
          if (expanded)
            for (final t in tasks)
              _DoneTaskRow(
                task: t,
                onUncomplete: onUncomplete,
                onDelete: onDelete,
              ),
        ],
      ),
    );
  }
}

class _DoneTaskRow extends StatelessWidget {
  const _DoneTaskRow({
    required this.task,
    required this.onUncomplete,
    required this.onDelete,
  });
  final Task task;
  final void Function(String id) onUncomplete;
  final void Function(String id) onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 0, 0, 6),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: context.neutral50,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: context.dividerColor),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              FeedbackService.instance.tick();
              onUncomplete(task.id);
            },
            child: Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppTheme.colorSuccess,
              ),
              child: const Icon(Icons.check, size: 14, color: Colors.white),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              task.title,
              style: GoogleFonts.inter(
                fontSize: 13.5,
                fontWeight: FontWeight.w500,
                color: context.textTertiary,
                decoration: TextDecoration.lineThrough,
              ),
            ),
          ),
          IconButton(
            tooltip: 'Borrar',
            icon: const Icon(Icons.delete_outline_rounded, size: 16),
            color: AppTheme.colorDanger.withAlpha(180),
            onPressed: () {
              FeedbackService.instance.danger();
              onDelete(task.id);
            },
          ),
        ],
      ),
    );
  }
}

