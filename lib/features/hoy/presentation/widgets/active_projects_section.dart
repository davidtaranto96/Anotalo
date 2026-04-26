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
import 'task_card.dart';

/// Sección "Proyectos activos" que va debajo de las priority sections
/// en Hoy. Cada proyecto activo es una fila colapsable que por default
/// muestra solo la próxima tarea pendiente; al tocar se expande con
/// el resto. Long-press sobre el header → abre el detalle del proyecto.
class ActiveProjectsSection extends ConsumerStatefulWidget {
  const ActiveProjectsSection({super.key});

  @override
  ConsumerState<ActiveProjectsSection> createState() =>
      _ActiveProjectsSectionState();
}

class _ActiveProjectsSectionState extends ConsumerState<ActiveProjectsSection> {
  final Set<String> _expanded = {};

  @override
  Widget build(BuildContext context) {
    final projects = ref.watch(activeProjectsProvider);
    final tasksByProject = ref.watch(pendingTasksByProjectProvider);
    final taskService = ref.read(taskServiceProvider);

    // Solo mostramos los proyectos que tengan al menos una tarea pendiente.
    // Los demás son ruido en Hoy.
    final visible = projects
        .where((p) => (tasksByProject[p.id] ?? const []).isNotEmpty)
        .toList();

    if (visible.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Overline de sección
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
          // Una fila por proyecto
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
              onLongPress: () => ProjectDetailSheet.show(context, project),
              onComplete: taskService.completeTask,
              onUncomplete: taskService.uncompleteTask,
              onDelete: taskService.deleteTask,
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
    required this.onComplete,
    required this.onUncomplete,
    required this.onDelete,
  });

  final Project project;
  final List<Task> tasks;
  final bool expanded;
  final VoidCallback onToggle;
  final VoidCallback onLongPress;
  final void Function(String id) onComplete;
  final void Function(String id) onUncomplete;
  final void Function(String id) onDelete;

  Color _projectColor() {
    final hex = project.color.replaceAll('#', '').trim();
    final padded = hex.length == 6 ? 'FF$hex' : hex;
    final v = int.tryParse(padded, radix: 16);
    return v == null ? AppTheme.colorPrimary : Color(v);
  }

  @override
  Widget build(BuildContext context) {
    final color = _projectColor();
    final next = tasks.first;
    final remaining = tasks.length - 1;

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
            // Header del proyecto: tap toggle, long-press abre detalle.
            InkWell(
              onTap: onToggle,
              onLongPress: onLongPress,
              borderRadius: AppTheme.r12,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(14, 12, 12, 12),
                child: Row(
                  children: [
                    // Banderín de color del proyecto
                    Container(
                      width: 4,
                      height: 32,
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
                          const SizedBox(height: 3),
                          // En estado colapsado mostramos la próxima
                          // tarea como hint inline. Al expandir, este
                          // texto se reemplaza por el contador
                          // "N tareas pendientes" que es más útil.
                          if (!expanded)
                            Text(
                              '→ ${next.title}',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: context.textSecondary,
                                height: 1.3,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            )
                          else
                            Text(
                              tasks.length == 1
                                  ? '1 tarea pendiente'
                                  : '${tasks.length} tareas pendientes',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: context.textSecondary,
                              ),
                            ),
                        ],
                      ),
                    ),
                    if (!expanded && remaining > 0)
                      Container(
                        margin: const EdgeInsets.only(right: 6),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 7, vertical: 2),
                        decoration: BoxDecoration(
                          color: color.withAlpha(30),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '+$remaining',
                          style: GoogleFonts.inter(
                            fontSize: 11,
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
            // Lista de tareas expandida
            if (expanded) ...[
              Divider(height: 1, color: context.dividerColor),
              const SizedBox(height: 6),
              for (final t in tasks)
                TaskCard(
                  task: t,
                  onComplete: () => onComplete(t.id),
                  onUncomplete: () => onUncomplete(t.id),
                  onDefer: () {},
                  onDelete: () => onDelete(t.id),
                ),
              const SizedBox(height: 6),
            ],
          ],
        ),
      ),
    );
  }
}
