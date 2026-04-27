import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../hoy/domain/models/task.dart';
import '../../../hoy/presentation/providers/task_provider.dart';
import '../../domain/models/project.dart';

class ProjectCard extends ConsumerWidget {
  final Project project;
  final VoidCallback onTap;

  const ProjectCard({
    super.key,
    required this.project,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final taskService = ref.read(taskServiceProvider);
    final color = _parseColor(project.color);

    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 3),
        decoration: BoxDecoration(
          color: context.surfaceCard,
          borderRadius: AppTheme.r12,
          border: Border.all(color: color.withAlpha(60)),
          boxShadow: AppTheme.shadowSm,
        ),
        // Stack + barra-acento 3pt: misma firma visual que TaskCard.
        child: Stack(
          children: [
            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              child: Container(
                width: 3,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    bottomLeft: Radius.circular(12),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(13, 12, 12, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      // Avatar circular con la inicial — el color viene del
                      // proyecto y la forma redonda combina con el círculo
                      // de complete-task de TaskCard.
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: color.withAlpha(30),
                          border:
                              Border.all(color: color.withAlpha(80), width: 1.5),
                        ),
                        child: Center(
                          child: Text(
                            project.title.isNotEmpty
                                ? project.title[0].toUpperCase()
                                : 'P',
                            style: GoogleFonts.fraunces(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: color,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              project.title,
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: context.textPrimary,
                                height: 1.25,
                              ),
                            ),
                            const SizedBox(height: 3),
                            _CategoryTag(category: project.category),
                          ],
                        ),
                      ),
                    ],
                  ),
                  if (project.description != null) ...[
                    const SizedBox(height: 6),
                    Text(
                      project.description!,
                      style: GoogleFonts.inter(
                          fontSize: 12.5, color: context.textSecondary),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  const SizedBox(height: 8),
                  // Task count + fecha
                  FutureBuilder<_ProjectStats>(
                    future: _getStats(taskService, project.id),
                    builder: (context, snapshot) {
                      final stats = snapshot.data ?? _ProjectStats(0, 0);
                      final progress = stats.total == 0
                          ? 0.0
                          : stats.completed / stats.total;
                      return Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                '${stats.completed}/${stats.total} tareas',
                                style: GoogleFonts.inter(
                                  fontSize: 11.5,
                                  color: context.textTertiary,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                '${(progress * 100).round()}%',
                                style: GoogleFonts.inter(
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w700,
                                  color: color,
                                ),
                              ),
                              const Spacer(),
                              ..._buildDeadlineIndicator(context),
                              if (project.targetDate == null)
                                Text(
                                  DateFormat('d MMM yyyy', 'es')
                                      .format(project.createdAt),
                                  style: GoogleFonts.inter(
                                    fontSize: 11,
                                    color: context.textTertiary,
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 5),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(3),
                            child: LinearProgressIndicator(
                              value: progress,
                              minHeight: 3,
                              backgroundColor: context.dividerColor,
                              valueColor: AlwaysStoppedAnimation(color),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildDeadlineIndicator(BuildContext context) {
    if (project.targetDate == null) return [];
    try {
      final target = DateTime.parse(project.targetDate!);
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final diff = target.difference(today).inDays;
      final dateText = DateFormat('d MMM', 'es').format(target);

      if (diff < 0) {
        return [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: AppTheme.colorDanger.withAlpha(28),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              'Vencido',
              style: GoogleFonts.inter(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: AppTheme.colorDanger,
              ),
            ),
          ),
          const SizedBox(width: 4),
          Text(
            dateText,
            style: GoogleFonts.inter(
                fontSize: 11, color: AppTheme.colorDanger),
          ),
        ];
      } else if (diff <= 7) {
        return [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: AppTheme.colorWarning.withAlpha(28),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              'Pronto',
              style: GoogleFonts.inter(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: AppTheme.colorWarning,
              ),
            ),
          ),
          const SizedBox(width: 4),
          Text(
            dateText,
            style: GoogleFonts.inter(
                fontSize: 11, color: AppTheme.colorWarning),
          ),
        ];
      } else {
        return [
          Text(
            dateText,
            style: GoogleFonts.inter(
                fontSize: 11, color: context.textTertiary),
          ),
        ];
      }
    } catch (_) {
      return [];
    }
  }

  Future<_ProjectStats> _getStats(dynamic taskService, String projectId) async {
    final tasks = await taskService.watchTasksByProject(projectId).first;
    final list = tasks as List;
    final total = list.length;
    final completed = list.where((t) => (t as Task).status == TaskStatus.done).length;
    return _ProjectStats(completed, total);
  }

  Color _parseColor(String hex) {
    try {
      return Color(int.parse(hex.replaceFirst('#', 'FF'), radix: 16));
    } catch (_) {
      return AppTheme.colorPrimary;
    }
  }
}

class _ProjectStats {
  final int completed;
  final int total;
  _ProjectStats(this.completed, this.total);
}

class _CategoryTag extends StatelessWidget {
  final ProjectCategory category;
  const _CategoryTag({required this.category});

  @override
  Widget build(BuildContext context) {
    final (label, emoji, tint) = _categoryInfo(category);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: tint.withAlpha(22),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: tint.withAlpha(70)),
      ),
      child: Text(
        '$emoji $label',
        style: GoogleFonts.inter(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: tint,
        ),
      ),
    );
  }

  /// Info por categoría: label, emoji y color "tint" para la pill.
  (String, String, Color) _categoryInfo(ProjectCategory c) => switch (c) {
    ProjectCategory.professional =>
      ('Profesional', '💼', AppTheme.colorPrimary),
    ProjectCategory.personal     =>
      ('Personal', '🏠', AppTheme.colorSuccess),
    ProjectCategory.health       =>
      ('Salud', '🏥', AppTheme.colorDanger),
    ProjectCategory.learning     =>
      ('Estudio', '📚', AppTheme.colorWarning),
    ProjectCategory.travel       =>
      ('Viaje', '✈️', AppTheme.colorInfo),
  };
}
