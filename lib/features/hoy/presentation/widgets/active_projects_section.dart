import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/feedback/feedback_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../proyectos/domain/models/project.dart';
import '../../../proyectos/presentation/providers/project_provider.dart';
import '../../../proyectos/presentation/widgets/project_detail_sheet.dart';
import '../../domain/models/task.dart';
import '../providers/task_provider.dart';

/// Sección "Proyectos activos" que va abajo de Hábitos en Hoy.
///
/// Cada proyecto activo es una fila colapsable. Tap en el header
/// expande inline las tareas pendientes del proyecto, con un checkbox
/// para marcar cada una completa/incompleta sin salir de Hoy.
/// Long-press en el header → abre el ProjectDetailSheet completo.
class ActiveProjectsSection extends ConsumerStatefulWidget {
  const ActiveProjectsSection({super.key});

  @override
  ConsumerState<ActiveProjectsSection> createState() =>
      _ActiveProjectsSectionState();
}

class _ActiveProjectsSectionState
    extends ConsumerState<ActiveProjectsSection> {
  final Set<String> _expanded = {};

  @override
  Widget build(BuildContext context) {
    final projects = ref.watch(activeProjectsProvider);
    final tasksByProject = ref.watch(pendingTasksByProjectProvider);
    final taskService = ref.read(taskServiceProvider);

    final visible = projects
        .where((p) => (tasksByProject[p.id] ?? const []).isNotEmpty)
        .toList();
    if (visible.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppTheme.colorAccent,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'PROYECTOS ACTIVOS',
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.colorAccent,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '${visible.length}',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: context.textTertiary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          for (final project in visible)
            _ProjectRow(
              project: project,
              tasks: tasksByProject[project.id] ?? const [],
              expanded: _expanded.contains(project.id),
              onToggle: () {
                FeedbackService.instance.tick();
                setState(() {
                  if (_expanded.contains(project.id)) {
                    _expanded.remove(project.id);
                  } else {
                    _expanded.add(project.id);
                  }
                });
              },
              onLongPress: () {
                FeedbackService.instance.warn();
                ProjectDetailSheet.show(context, project);
              },
              onTaskComplete: taskService.completeTask,
              onTaskUncomplete: taskService.uncompleteTask,
            ),
        ],
      ),
    );
  }
}

class _ProjectRow extends StatelessWidget {
  const _ProjectRow({
    required this.project,
    required this.tasks,
    required this.expanded,
    required this.onToggle,
    required this.onLongPress,
    required this.onTaskComplete,
    required this.onTaskUncomplete,
  });

  final Project project;
  final List<Task> tasks;
  final bool expanded;
  final VoidCallback onToggle;
  final VoidCallback onLongPress;
  final void Function(String id) onTaskComplete;
  final void Function(String id) onTaskUncomplete;

  Color _projectColor() {
    final hex = project.color.replaceAll('#', '').trim();
    final padded = hex.length == 6 ? 'FF$hex' : hex;
    final v = int.tryParse(padded, radix: 16);
    return v == null ? AppTheme.colorPrimary : Color(v);
  }

  @override
  Widget build(BuildContext context) {
    final color = _projectColor();
    final next = tasks.isNotEmpty ? tasks.first : null;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Container(
        decoration: BoxDecoration(
          color: context.surfaceCard,
          borderRadius: AppTheme.r12,
          border: Border.all(color: context.dividerColor),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header: tap = expand/collapse, long-press = detalle.
            InkWell(
              onTap: onToggle,
              onLongPress: onLongPress,
              borderRadius: AppTheme.r12,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 10, 10, 10),
                child: Row(
                  children: [
                    Container(
                      width: 4,
                      height: 36,
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            project.title,
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: context.textPrimary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            expanded
                                ? '${tasks.length} ${tasks.length == 1 ? "tarea" : "tareas"} pendiente${tasks.length == 1 ? "" : "s"}'
                                : (next != null ? '→ ${next.title}' : ''),
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: context.textSecondary,
                              height: 1.3,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(right: 4),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: color.withAlpha(30),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '${tasks.length}',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: color,
                        ),
                      ),
                    ),
                    AnimatedRotation(
                      turns: expanded ? 0.5 : 0,
                      duration: const Duration(milliseconds: 180),
                      child: Icon(
                        Icons.expand_more_rounded,
                        color: context.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Lista de tareas (expandida).
            if (expanded) ...[
              Divider(height: 1, color: context.dividerColor),
              for (final t in tasks)
                _ProjectTaskRow(
                  task: t,
                  projectColor: color,
                  onComplete: () {
                    FeedbackService.instance.success();
                    onTaskComplete(t.id);
                  },
                  onUncomplete: () {
                    FeedbackService.instance.tick();
                    onTaskUncomplete(t.id);
                  },
                ),
              const SizedBox(height: 6),
            ],
          ],
        ),
      ),
    );
  }
}

/// Fila simple de tarea dentro de un proyecto expandido. Sólo
/// checkbox + título — sin Slidable ni acciones extra para
/// mantener la sección liviana y evitar choques de gestos con
/// las priority sections de arriba.
class _ProjectTaskRow extends StatelessWidget {
  const _ProjectTaskRow({
    required this.task,
    required this.projectColor,
    required this.onComplete,
    required this.onUncomplete,
  });
  final Task task;
  final Color projectColor;
  final VoidCallback onComplete;
  final VoidCallback onUncomplete;

  @override
  Widget build(BuildContext context) {
    final isDone = task.status == TaskStatus.done;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          GestureDetector(
            onTap: isDone ? onUncomplete : onComplete,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isDone ? projectColor : Colors.transparent,
                border: Border.all(color: projectColor, width: 2),
              ),
              child: isDone
                  ? const Icon(Icons.check_rounded,
                      size: 14, color: Colors.white)
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
        ],
      ),
    );
  }
}
