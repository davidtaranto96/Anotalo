import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/feedback/feedback_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../proyectos/domain/models/project.dart';
import '../../../proyectos/presentation/providers/project_provider.dart';
import '../../../proyectos/presentation/widgets/project_detail_sheet.dart';
import '../providers/task_provider.dart';

/// Resumen de proyectos activos en Hoy. Las tareas individuales del
/// proyecto YA aparecen arriba en las priority sections junto con las
/// tareas sueltas — esta sección no las duplica. Sólo muestra una
/// fila por proyecto con el progreso y la próxima tarea pendiente
/// como hint. Tap → abre el sheet de detalle del proyecto.
class ActiveProjectsSection extends ConsumerWidget {
  const ActiveProjectsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projects = ref.watch(activeProjectsProvider);
    final tasksByProject = ref.watch(pendingTasksByProjectProvider);

    // Sólo mostramos los proyectos con al menos una tarea pendiente —
    // los proyectos vacíos serían ruido en Hoy.
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
            _ProjectSummaryRow(
              project: project,
              pendingCount: (tasksByProject[project.id] ?? const []).length,
              nextTitle:
                  (tasksByProject[project.id] ?? const []).isNotEmpty
                      ? tasksByProject[project.id]!.first.title
                      : null,
              onTap: () {
                FeedbackService.instance.tick();
                ProjectDetailSheet.show(context, project);
              },
            ),
        ],
      ),
    );
  }
}

class _ProjectSummaryRow extends StatelessWidget {
  const _ProjectSummaryRow({
    required this.project,
    required this.pendingCount,
    required this.nextTitle,
    required this.onTap,
  });

  final Project project;
  final int pendingCount;
  final String? nextTitle;
  final VoidCallback onTap;

  Color _projectColor() {
    final hex = project.color.replaceAll('#', '').trim();
    final padded = hex.length == 6 ? 'FF$hex' : hex;
    final v = int.tryParse(padded, radix: 16);
    return v == null ? AppTheme.colorPrimary : Color(v);
  }

  @override
  Widget build(BuildContext context) {
    final color = _projectColor();
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: AppTheme.r12,
        child: Container(
          padding: const EdgeInsets.fromLTRB(12, 10, 10, 10),
          decoration: BoxDecoration(
            color: context.surfaceCard,
            borderRadius: AppTheme.r12,
            border: Border.all(color: context.dividerColor),
          ),
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
                      nextTitle != null
                          ? '→ $nextTitle'
                          : 'Sin tareas pendientes',
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: color.withAlpha(30),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '$pendingCount',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: color,
                  ),
                ),
              ),
              Icon(Icons.chevron_right_rounded,
                  color: context.textTertiary, size: 18),
            ],
          ),
        ),
      ),
    );
  }
}
