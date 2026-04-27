import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../../core/feedback/feedback_service.dart';
import '../../../../core/models/task_area.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../hoy/domain/models/task.dart';

/// Lista inline (no modal) de tareas del día seleccionado en MesPage.
///
/// Cada tarea es un `LongPressDraggable<Task>` — long-press inicia drag
/// y al soltar sobre otra celda del calendario reasigna su `dayId`.
/// Tap en el checkbox marca completa/incompleta sin salir.
class DayTasksInline extends StatelessWidget {
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
  Widget build(BuildContext context) {
    // Agrupar por área. Las tareas con prioridad alta primero.
    final byArea = <String?, List<Task>>{};
    for (final t in tasks) {
      byArea.putIfAbsent(t.area, () => []).add(t);
    }
    for (final list in byArea.values) {
      list.sort((a, b) => a.priority.index.compareTo(b.priority.index));
    }

    final dateLabel = DateFormat("EEEE d 'de' MMMM", 'es')
        .format(day)
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
                      tasks.isEmpty
                          ? 'Día libre'
                          : '${tasks.length} ${tasks.length == 1 ? "tarea" : "tareas"}',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: context.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              if (tasks.isNotEmpty)
                Text(
                  'Mantené ↕ para arrastrar',
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
          child: tasks.isEmpty
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
              : ListView(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                  children: [
                    for (final entry in byArea.entries) ...[
                      _AreaHeader(areaId: entry.key),
                      for (final t in entry.value)
                        _DraggableTaskRow(
                          task: t,
                          onComplete: onComplete,
                          onUncomplete: onUncomplete,
                          onDelete: onDelete,
                        ),
                      const SizedBox(height: 8),
                    ],
                  ],
                ),
        ),
      ],
    );
  }
}

class _AreaHeader extends StatelessWidget {
  const _AreaHeader({required this.areaId});
  final String? areaId;

  @override
  Widget build(BuildContext context) {
    final area = areaId == null ? null : getTaskArea(areaId);
    final label = area?.label ?? (areaId == null ? 'Sin área' : areaId!);
    final color = area?.color ?? context.textSecondary;
    final emoji = area?.emoji ?? '📌';
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 10, 4, 4),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 14)),
          const SizedBox(width: 6),
          Text(
            label.toUpperCase(),
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: color,
              letterSpacing: 0.8,
            ),
          ),
        ],
      ),
    );
  }
}

class _DraggableTaskRow extends StatelessWidget {
  const _DraggableTaskRow({
    required this.task,
    required this.onComplete,
    required this.onUncomplete,
    required this.onDelete,
  });
  final Task task;
  final void Function(String id) onComplete;
  final void Function(String id) onUncomplete;
  final void Function(String id) onDelete;

  Color _priorityColor() => switch (task.priority) {
        TaskPriority.primordial => AppTheme.colorDanger,
        TaskPriority.importante => AppTheme.colorWarning,
        TaskPriority.puedeEsperar => AppTheme.colorPrimary,
        TaskPriority.secundaria => AppTheme.neutral400,
      };

  @override
  Widget build(BuildContext context) {
    final isDone = task.status == TaskStatus.done;
    final priorityColor = _priorityColor();
    final body = Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: context.surfaceCard,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: priorityColor.withAlpha(70)),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              FeedbackService.instance.success();
              if (isDone) {
                onUncomplete(task.id);
              } else {
                onComplete(task.id);
              }
            },
            child: Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isDone ? priorityColor : Colors.transparent,
                border: Border.all(color: priorityColor, width: 2),
              ),
              child: isDone
                  ? const Icon(Icons.check, size: 14, color: Colors.white)
                  : null,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              task.title,
              style: GoogleFonts.inter(
                fontSize: 13.5,
                fontWeight: FontWeight.w500,
                color: isDone ? context.textTertiary : context.textPrimary,
                decoration: isDone ? TextDecoration.lineThrough : null,
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

    return LongPressDraggable<Task>(
      data: task,
      delay: const Duration(milliseconds: 280),
      onDragStarted: () => FeedbackService.instance.warn(),
      feedback: Material(
        color: Colors.transparent,
        child: Container(
          width: 240,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
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
