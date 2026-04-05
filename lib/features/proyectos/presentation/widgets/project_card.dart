import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../domain/models/project.dart';

class ProjectCard extends StatelessWidget {
  final Project project;
  final int taskCount;
  final int completedCount;
  final VoidCallback onTap;

  const ProjectCard({
    super.key,
    required this.project,
    required this.taskCount,
    required this.completedCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = _parseColor(project.color);
    final progress = taskCount == 0 ? 0.0 : completedCount / taskCount;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.surfaceCard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: color.withAlpha((0.2 * 255).round()),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: color,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    project.title,
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFFF0F0FF),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: _statusColor(project.status).withAlpha((0.15 * 255).round()),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: _statusColor(project.status).withAlpha((0.3 * 255).round()),
                    ),
                  ),
                  child: Text(
                    _statusLabel(project.status),
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: _statusColor(project.status),
                    ),
                  ),
                ),
              ],
            ),
            if (project.description != null) ...[
              const SizedBox(height: 6),
              Text(
                project.description!,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: AppTheme.colorNeutral,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            if (taskCount > 0) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(3),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 4,
                        backgroundColor: AppTheme.surfaceElevated,
                        valueColor: AlwaysStoppedAnimation(color),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    '$completedCount/$taskCount',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: AppTheme.colorNeutral,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Color _parseColor(String hex) {
    try {
      return Color(int.parse(hex.replaceFirst('#', 'FF'), radix: 16));
    } catch (_) {
      return AppTheme.colorPrimary;
    }
  }

  Color _statusColor(ProjectStatus s) => switch (s) {
    ProjectStatus.active    => AppTheme.colorAccent,
    ProjectStatus.completed => AppTheme.colorPrimary,
    ProjectStatus.paused    => AppTheme.colorWarning,
    ProjectStatus.archived  => AppTheme.colorNeutral,
  };

  String _statusLabel(ProjectStatus s) => switch (s) {
    ProjectStatus.active    => 'Activo',
    ProjectStatus.completed => 'Completado',
    ProjectStatus.paused    => 'Pausado',
    ProjectStatus.archived  => 'Archivado',
  };
}
