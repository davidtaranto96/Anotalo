import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/first_time_tip.dart';
import '../../domain/models/project.dart';
import '../providers/project_provider.dart';
import '../widgets/project_card.dart';
import '../widgets/project_detail_sheet.dart';
import '../widgets/add_project_bottom_sheet.dart';

class ProyectosPage extends ConsumerStatefulWidget {
  const ProyectosPage({super.key});

  @override
  ConsumerState<ProyectosPage> createState() => _ProyectosPageState();
}

class _ProyectosPageState extends ConsumerState<ProyectosPage> {
  final _expanded = <ProjectStatus, bool>{
    ProjectStatus.active: true,
    ProjectStatus.paused: false,
    ProjectStatus.completed: false,
    ProjectStatus.archived: false,
  };

  @override
  Widget build(BuildContext context) {
    final projectsAsync = ref.watch(allProjectsIncludingArchivedProvider);

    return FirstTimeTip(
      tipKey: 'coach.proyectos',
      title: 'Tus proyectos en marcha',
      body:
          'Tocá un proyecto para ver tareas y notas. Mantené apretado uno activo para reordenarlo.',
      icon: Icons.folder_rounded,
      child: Scaffold(
      backgroundColor: context.surfaceBase,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            floating: true,
            backgroundColor: Colors.transparent,
            surfaceTintColor: Colors.transparent,
            title: Text('Proyectos',
                style: GoogleFonts.fraunces(
                  fontSize: 24, fontWeight: FontWeight.w600,
                  color: context.textPrimary, letterSpacing: -0.3,
                )),
            actions: [
              TextButton.icon(
                onPressed: () => AddProjectBottomSheet.show(context),
                icon: Icon(Icons.add_rounded,
                    size: 18, color: context.colorPrimary),
                label: Text('Nuevo',
                    style: GoogleFonts.inter(
                        color: context.colorPrimary,
                        fontWeight: FontWeight.w600,
                        fontSize: 13)),
              ),
            ],
          ),
          projectsAsync.when(
            data: (projects) {
              if (projects.isEmpty) {
                return SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.folder_open_rounded, size: 48, color: context.neutral400),
                        const SizedBox(height: 12),
                        Text('No hay proyectos',
                            style: GoogleFonts.inter(color: context.textTertiary, fontSize: 15)),
                        const SizedBox(height: 8),
                        Text('Tocá Nuevo para crear uno',
                            style: GoogleFonts.inter(color: context.textTertiary, fontSize: 13)),
                      ],
                    ),
                  ),
                );
              }

              final sections = [
                (ProjectStatus.active, 'ACTIVOS'),
                (ProjectStatus.paused, 'PAUSADOS'),
                (ProjectStatus.completed, 'COMPLETADOS'),
                (ProjectStatus.archived, 'ARCHIVADOS'),
              ];

              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (_, i) {
                    final (status, label) = sections[i];
                    final filtered = projects.where((p) => p.status == status).toList();
                    if (filtered.isEmpty) return const SizedBox.shrink();

                    return _ProjectSection(
                      label: label,
                      status: status,
                      projects: filtered,
                      expanded: _expanded[status] ?? true,
                      onToggle: () => setState(() =>
                          _expanded[status] = !(_expanded[status] ?? true)),
                      onTap: (p) => ProjectDetailSheet.show(context, p),
                    );
                  },
                  childCount: sections.length,
                ),
              );
            },
            loading: () => const SliverFillRemaining(
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (e, _) => SliverFillRemaining(
              child: Center(child: Text('Error: $e')),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 140)),
        ],
      ),
    ), // Scaffold
    ); // FirstTimeTip
  }
}

class _ProjectSection extends ConsumerWidget {
  final String label;
  final ProjectStatus status;
  final List<Project> projects;
  final bool expanded;
  final VoidCallback onToggle;
  final Function(Project) onTap;

  const _ProjectSection({
    required this.label,
    required this.status,
    required this.projects,
    required this.expanded,
    required this.onToggle,
    required this.onTap,
  });

  /// Color semántico por estado, replicando el patrón "dot 8pt" de
  /// PrioritySection en Hoy.
  Color _statusColor() => switch (status) {
        ProjectStatus.active    => AppTheme.colorSuccess,
        ProjectStatus.paused    => AppTheme.colorWarning,
        ProjectStatus.completed => AppTheme.colorPrimary,
        ProjectStatus.archived  => AppTheme.neutral400,
      };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dotColor = _statusColor();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: onToggle,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
            child: Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: dotColor,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: dotColor,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '${projects.length}',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: context.textTertiary,
                  ),
                ),
                const Spacer(),
                Icon(
                  expanded
                      ? Icons.expand_less_rounded
                      : Icons.expand_more_rounded,
                  color: context.textTertiary,
                  size: 18,
                ),
              ],
            ),
          ),
        ),
        if (expanded)
          // Reorderable solo en la sección "ACTIVOS" (donde tiene sentido
          // priorizar). En las otras secciones queda como lista plana.
          if (label == 'ACTIVOS')
            ReorderableListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              proxyDecorator: (child, index, animation) => Material(
                color: Colors.transparent,
                child: child,
              ),
              onReorder: (oldIndex, newIndex) async {
                final adjustedNew =
                    newIndex > oldIndex ? newIndex - 1 : newIndex;
                final updated = List<Project>.from(projects);
                final moved = updated.removeAt(oldIndex);
                updated.insert(adjustedNew, moved);
                await ref
                    .read(projectServiceProvider)
                    .reorderProjects(updated.map((p) => p.id).toList());
              },
              children: [
                for (final p in projects)
                  ReorderableDelayedDragStartListener(
                    key: ValueKey('project-${p.id}'),
                    index: projects.indexOf(p),
                    child: ProjectCard(
                      project: p,
                      onTap: () => onTap(p),
                    ),
                  ),
              ],
            )
          else
            ...projects.map((p) => ProjectCard(
                  project: p,
                  onTap: () => onTap(p),
                )),
      ],
    );
  }
}
