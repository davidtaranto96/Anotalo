import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/app_colors.dart';
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

    return Scaffold(
      backgroundColor: context.surfaceBase,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            floating: true,
            backgroundColor: Colors.transparent,
            surfaceTintColor: Colors.transparent,
            title: Text('📁 Proyectos',
                style: GoogleFonts.lora(
                  fontSize: 24, fontWeight: FontWeight.w600,
                  color: context.textPrimary, letterSpacing: -0.3,
                )),
            actions: [
              TextButton.icon(
                onPressed: () => AddProjectBottomSheet.show(context),
                icon: const Icon(Icons.add_rounded, size: 18, color: AppTheme.colorPrimary),
                label: Text('Nuevo',
                    style: GoogleFonts.inter(
                        color: AppTheme.colorPrimary, fontWeight: FontWeight.w600, fontSize: 13)),
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
    );
  }
}

class _ProjectSection extends StatelessWidget {
  final String label;
  final List<Project> projects;
  final bool expanded;
  final VoidCallback onToggle;
  final Function(Project) onTap;

  const _ProjectSection({
    required this.label,
    required this.projects,
    required this.expanded,
    required this.onToggle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: onToggle,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
            child: Row(
              children: [
                Text(
                  '$label · ${projects.length}',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: context.textTertiary,
                    letterSpacing: 0.5,
                  ),
                ),
                const Spacer(),
                Icon(
                  expanded ? Icons.expand_less_rounded : Icons.expand_more_rounded,
                  color: context.textTertiary,
                  size: 18,
                ),
              ],
            ),
          ),
        ),
        if (expanded)
          ...projects.map((p) => ProjectCard(
            project: p,
            onTap: () => onTap(p),
          )),
      ],
    );
  }
}
