import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/models/project.dart';
import '../providers/project_provider.dart';
import '../widgets/project_card.dart';

class ProyectosPage extends ConsumerStatefulWidget {
  const ProyectosPage({super.key});

  @override
  ConsumerState<ProyectosPage> createState() => _ProyectosPageState();
}

class _ProyectosPageState extends ConsumerState<ProyectosPage> {
  ProjectStatus? _filterStatus; // null = all

  @override
  Widget build(BuildContext context) {
    final projectsAsync = ref.watch(allProjectsProvider);

    return Scaffold(
      backgroundColor: AppTheme.surfaceBase,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            floating: true,
            backgroundColor: AppTheme.surfaceBase,
            surfaceTintColor: Colors.transparent,
            title: Text('Proyectos',
                style: GoogleFonts.inter(fontSize: 22, fontWeight: FontWeight.w700)),
          ),
          // Filter chips
          SliverToBoxAdapter(
            child: SizedBox(
              height: 44,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  _FilterChip(label: 'Todos', selected: _filterStatus == null,
                      onTap: () => setState(() => _filterStatus = null)),
                  _FilterChip(label: 'Activos', selected: _filterStatus == ProjectStatus.active,
                      onTap: () => setState(() => _filterStatus = ProjectStatus.active)),
                  _FilterChip(label: 'Pausados', selected: _filterStatus == ProjectStatus.paused,
                      onTap: () => setState(() => _filterStatus = ProjectStatus.paused)),
                  _FilterChip(label: 'Completados', selected: _filterStatus == ProjectStatus.completed,
                      onTap: () => setState(() => _filterStatus = ProjectStatus.completed)),
                ],
              ),
            ),
          ),
          // Projects list
          projectsAsync.when(
            data: (projects) {
              final filtered = _filterStatus == null
                  ? projects
                  : projects.where((p) => p.status == _filterStatus).toList();

              if (filtered.isEmpty) {
                return SliverFillRemaining(
                  child: Center(
                    child: Text('No hay proyectos',
                        style: GoogleFonts.inter(color: AppTheme.colorNeutral)),
                  ),
                );
              }

              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (_, i) => ProjectCard(
                    project: filtered[i],
                    taskCount: filtered[i].taskIds.length,
                    completedCount: 0, // TODO: query from DB
                    onTap: () {}, // TODO: navigate to detail
                  ),
                  childCount: filtered.length,
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

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _FilterChip({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: selected
              ? AppTheme.colorPrimary.withAlpha((0.2 * 255).round())
              : AppTheme.surfaceCard,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected
                ? AppTheme.colorPrimary.withAlpha((0.5 * 255).round())
                : Colors.white.withAlpha((0.07 * 255).round()),
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
            color: selected ? AppTheme.colorPrimary : AppTheme.colorNeutral,
          ),
        ),
      ),
    );
  }
}
