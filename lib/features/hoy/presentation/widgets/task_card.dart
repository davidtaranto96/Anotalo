import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/models/task_area.dart';
import '../../domain/models/task.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback onComplete;
  final VoidCallback? onUncomplete;
  final VoidCallback onDefer;
  final VoidCallback onDelete;

  const TaskCard({
    super.key,
    required this.task,
    required this.onComplete,
    this.onUncomplete,
    required this.onDefer,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isDone = task.status == TaskStatus.done;
    final priorityColor = _priorityColor(task.priority);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Slidable(
        key: ValueKey(task.id),
        // Completadas: solo deshacer (izquierda). Pendientes: completar (derecha)
        startActionPane: isDone
            ? ActionPane(
                motion: const DrawerMotion(),
                extentRatio: 0.3,
                children: [
                  SlidableAction(
                    onPressed: (_) {
                      HapticFeedback.mediumImpact();
                      onUncomplete?.call();
                    },
                    backgroundColor: AppTheme.colorPrimary,
                    foregroundColor: Colors.white,
                    icon: Icons.undo_rounded,
                    label: 'Deshacer',
                    borderRadius:
                        const BorderRadius.horizontal(left: Radius.circular(12)),
                  ),
                ],
              )
            : ActionPane(
                motion: const DrawerMotion(),
                extentRatio: 0.3,
                children: [
                  SlidableAction(
                    onPressed: (_) {
                      HapticFeedback.mediumImpact();
                      onComplete();
                    },
                    backgroundColor: AppTheme.colorSuccess,
                    foregroundColor: Colors.white,
                    icon: Icons.check_rounded,
                    label: 'Completar',
                    borderRadius:
                        const BorderRadius.horizontal(left: Radius.circular(12)),
                  ),
                ],
              ),
        endActionPane: ActionPane(
          motion: const DrawerMotion(),
          extentRatio: 0.5,
          children: [
            SlidableAction(
              onPressed: isDone
                  ? null
                  : (_) {
                      HapticFeedback.lightImpact();
                      onDefer();
                    },
              backgroundColor: isDone
                  ? AppTheme.colorWarning.withAlpha(120)
                  : AppTheme.colorWarning,
              foregroundColor: Colors.white,
              icon: Icons.schedule_rounded,
              label: 'Diferir',
              borderRadius:
                  const BorderRadius.horizontal(left: Radius.circular(12)),
            ),
            SlidableAction(
              onPressed: (_) {
                HapticFeedback.heavyImpact();
                onDelete();
              },
              backgroundColor: AppTheme.colorDanger,
              foregroundColor: Colors.white,
              icon: Icons.delete_rounded,
              label: 'Borrar',
              borderRadius:
                  const BorderRadius.horizontal(right: Radius.circular(12)),
            ),
          ],
        ),
        child: GestureDetector(
          // Long press en completadas → deshacer
          onLongPress: isDone && onUncomplete != null
              ? () {
                  HapticFeedback.mediumImpact();
                  onUncomplete!();
                }
              : null,
          child: Container(
          decoration: BoxDecoration(
            color: isDone ? context.neutral50 : context.surfaceCard,
            borderRadius: AppTheme.r12,
            border: Border.all(color: isDone ? context.dividerColor : priorityColor.withAlpha(60)),
            boxShadow: isDone ? null : AppTheme.shadowSm,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Main row
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Completion circle
                    GestureDetector(
                      onTap: () {
                        HapticFeedback.lightImpact();
                        if (isDone && onUncomplete != null) {
                          onUncomplete!();
                        } else {
                          onComplete();
                        }
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 24,
                        height: 24,
                        margin: const EdgeInsets.only(top: 1),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: priorityColor, width: 2),
                          color: isDone ? priorityColor : Colors.transparent,
                        ),
                        child: isDone
                            ? const Icon(Icons.check, size: 13, color: Colors.white)
                            : null,
                      ),
                    ),
                    const SizedBox(width: 10),
                    // Title
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            task.title,
                            style: GoogleFonts.inter(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: isDone ? context.textTertiary : context.textPrimary,
                              decoration: isDone ? TextDecoration.lineThrough : null,
                            ),
                          ),
                          if (task.area != null) ...[
                            () {
                              final area = getTaskArea(task.area);
                              if (area == null) return const SizedBox.shrink();
                              return Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(area.emoji, style: const TextStyle(fontSize: 10)),
                                    const SizedBox(width: 3),
                                    Text(
                                      area.label,
                                      style: GoogleFonts.inter(fontSize: 10, color: area.color),
                                    ),
                                  ],
                                ),
                              );
                            }(),
                          ],
                          if (task.estimatedMinutes != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 2),
                              child: Text(
                                '${task.estimatedMinutes} min',
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  color: context.textTertiary,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Action buttons (only when not done)
              if (!isDone)
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 8, 12, 10),
                  child: Row(
                    children: [
                      _ActionButton(
                        label: '✓ Completar',
                        color: AppTheme.colorSuccess,
                        bgColor: AppTheme.colorSuccessLight,
                        onTap: () {
                          HapticFeedback.lightImpact();
                          onComplete();
                        },
                      ),
                      const SizedBox(width: 6),
                      _ActionButton(
                        label: '→ Diferir',
                        color: context.textSecondary,
                        bgColor: context.neutral100,
                        onTap: () {
                          HapticFeedback.lightImpact();
                          onDefer();
                        },
                      ),
                      const SizedBox(width: 6),
                      _ActionButton(
                        label: '✕',
                        color: AppTheme.colorDanger,
                        bgColor: AppTheme.colorDangerLight,
                        onTap: () {
                          HapticFeedback.heavyImpact();
                          onDelete();
                        },
                      ),
                    ],
                  ),
                ),

              if (isDone) const SizedBox(height: 12),
            ],
          ),
        ),
        ), // GestureDetector
      ),
    );
  }

  Color _priorityColor(TaskPriority p) => switch (p) {
    TaskPriority.primordial   => AppTheme.colorDanger,
    TaskPriority.importante   => AppTheme.colorWarning,
    TaskPriority.puedeEsperar => AppTheme.colorPrimary,
    TaskPriority.secundaria   => AppTheme.neutral400,
  };
}

class _ActionButton extends StatelessWidget {
  final String label;
  final Color color;
  final Color bgColor;
  final VoidCallback onTap;

  const _ActionButton({
    required this.label,
    required this.color,
    required this.bgColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: color,
          ),
        ),
      ),
    );
  }
}
