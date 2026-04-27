import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../../core/feedback/feedback_service.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/models/task_area.dart';
import '../../../../../core/utils/format_utils.dart';
import '../../domain/models/task.dart';
import 'add_task_bottom_sheet.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback onComplete;
  final VoidCallback? onUncomplete;
  final VoidCallback onDefer;
  final VoidCallback onDelete;
  /// Área actualmente filtrada en Hoy. Si matchea `task.area`, omitimos
  /// el chip de área en la card porque sería redundante con el filtro.
  final String? currentFilterAreaId;

  const TaskCard({
    super.key,
    required this.task,
    required this.onComplete,
    this.onUncomplete,
    required this.onDefer,
    required this.onDelete,
    this.currentFilterAreaId,
  });

  @override
  Widget build(BuildContext context) {
    final isDone = task.status == TaskStatus.done;
    final priorityColor = _priorityColor(task.priority);
    final area = task.area == null ? null : getTaskArea(task.area);
    // Color para la barra-acento vertical del lado izquierdo. Si la tarea
    // no tiene área, caemos al color de prioridad para no romper el diseño.
    final accentBarColor = (area?.color ?? priorityColor)
        .withValues(alpha: isDone ? 0.30 : 0.85);
    // Rollover: task whose dayId is older than today and still pending.
    // Las tareas con dayId == null (de proyectos sin programar) no
    // hacen rollover porque nunca tuvieron un día.
    final today = todayId();
    final taskDayId = task.dayId;
    final isRolledOver = !isDone &&
        taskDayId != null &&
        taskDayId.compareTo(today) < 0;
    final rolloverDays = isRolledOver
        ? DateTime.now().difference(idToDate(taskDayId)).inDays
        : 0;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 3),
      child: Slidable(
        key: ValueKey(task.id),
        // Completadas: solo deshacer (izquierda). Pendientes: completar.
        // Slide más del 50% del ancho → dispara la acción
        // automáticamente (DismissiblePane).
        startActionPane: ActionPane(
          motion: const DrawerMotion(),
          extentRatio: 0.22,
          dismissible: DismissiblePane(
            dismissThreshold: 0.5,
            closeOnCancel: true,
            onDismissed: () {
              FeedbackService.instance.success();
              if (isDone && onUncomplete != null) {
                onUncomplete!();
              } else if (!isDone) {
                onComplete();
              }
            },
          ),
          children: [
            CustomSlidableAction(
              onPressed: (_) {
                FeedbackService.instance.success();
                if (isDone && onUncomplete != null) {
                  onUncomplete!();
                } else if (!isDone) {
                  onComplete();
                }
              },
              backgroundColor:
                  isDone ? AppTheme.colorPrimary : AppTheme.colorSuccess,
              foregroundColor: Colors.white,
              padding: EdgeInsets.zero,
              child: Icon(
                isDone ? Icons.undo_rounded : Icons.check_rounded,
                size: 28,
              ),
            ),
          ],
        ),
        endActionPane: ActionPane(
          motion: const DrawerMotion(),
          extentRatio: 0.54,
          children: [
            CustomSlidableAction(
              onPressed: isDone
                  ? null
                  : (_) {
                      FeedbackService.instance.tick();
                      AddTaskBottomSheet.show(context, existing: task);
                    },
              backgroundColor: isDone
                  ? AppTheme.colorPrimary.withAlpha(120)
                  : AppTheme.colorPrimary,
              foregroundColor: Colors.white,
              padding: EdgeInsets.zero,
              child: const Icon(Icons.edit_rounded, size: 26),
            ),
            CustomSlidableAction(
              onPressed: isDone
                  ? null
                  : (_) {
                      FeedbackService.instance.tick();
                      onDefer();
                    },
              backgroundColor: isDone
                  ? AppTheme.colorWarning.withAlpha(120)
                  : AppTheme.colorWarning,
              foregroundColor: Colors.white,
              padding: EdgeInsets.zero,
              child: const Icon(Icons.schedule_rounded, size: 26),
            ),
            CustomSlidableAction(
              onPressed: (_) {
                FeedbackService.instance.danger();
                onDelete();
              },
              backgroundColor: AppTheme.colorDanger,
              foregroundColor: Colors.white,
              padding: EdgeInsets.zero,
              child: const Icon(Icons.delete_rounded, size: 26),
            ),
          ],
        ),
        // El long-press del card NO abre el editor — eso interfería con
        // el long-press del ReorderableListView (drag-to-reorder). El
        // editor ahora se accede con swipe-left → "Editar". Se mantiene
        // el shortcut "long-press = deshacer completación" sólo cuando
        // la tarea ya está done (porque ahí no hay reorder de
        // completadas).
        child: GestureDetector(
          onLongPress: isDone && onUncomplete != null
              ? () {
                  FeedbackService.instance.warn();
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
          // Stack en lugar de IntrinsicHeight+Row: el LayoutBuilder
          // interno del PencilStrikeTitle no soporta intrinsic dims y
          // crashea al medir. Con Stack, la barra-acento se estira con
          // Positioned y el contenido ocupa altura natural.
          child: Stack(
            children: [
              Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                child: Container(
                  width: 3,
                  decoration: BoxDecoration(
                    color: accentBarColor,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      bottomLeft: Radius.circular(12),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 3),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
              // Main row — padding reducido (era 10/12/12/0 → ahora 10/10/10/0)
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Completion circle
                    GestureDetector(
                      onTap: () {
                        if (isDone && onUncomplete != null) {
                          FeedbackService.instance.tick();
                          onUncomplete!();
                        } else {
                          FeedbackService.instance.success();
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
                    // Title — el tamaño escala con la antigüedad (rollover)
                    // para que tareas viejas pidan atención visualmente.
                    // Usamos ListenableBuilder para que el toggle en Settings
                    // re-pinte todas las cards sin refrescar la pantalla.
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Texto simple: el PencilStrikeTitle con su
                          // LayoutBuilder interno disparaba crashes de
                          // layout (intrinsic dimensions / relayout
                          // boundary). Vuelvo a Text estático y dejo
                          // que el usuario complete via swipe o el
                          // botón "✓ Completar" del action bar.
                          // Título + indicador de rollover en línea
                          // (a la derecha) para que la card no crezca
                          // verticalmente en tareas viejas.
                          ListenableBuilder(
                            listenable: TaskCardPrefs.instance,
                            builder: (ctx, _) => Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Text(
                                    task.title,
                                    style: GoogleFonts.inter(
                                      fontSize: _scaledFontSize(
                                          rolloverDays, context),
                                      fontWeight:
                                          _scaledFontWeight(rolloverDays),
                                      color: isDone
                                          ? context.textTertiary
                                          : context.textPrimary,
                                      decoration: isDone
                                          ? TextDecoration.lineThrough
                                          : null,
                                      height: 1.25,
                                    ),
                                  ),
                                ),
                                if (isRolledOver) ...[
                                  const SizedBox(width: 8),
                                  Tooltip(
                                    message: rolloverDays == 1
                                        ? 'De ayer'
                                        : 'Hace $rolloverDays días',
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: AppTheme.colorWarning
                                            .withAlpha(32),
                                        borderRadius:
                                            BorderRadius.circular(999),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Icon(
                                            Icons.history_rounded,
                                            size: 14,
                                            color: AppTheme.colorWarning,
                                          ),
                                          if (rolloverDays > 1) ...[
                                            const SizedBox(width: 3),
                                            Text(
                                              '$rolloverDays',
                                              style: GoogleFonts.inter(
                                                fontSize: 11,
                                                fontWeight: FontWeight.w700,
                                                color:
                                                    AppTheme.colorWarning,
                                              ),
                                            ),
                                          ],
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                          // Chip de área (solo si la tarea tiene área y
                          // no estamos filtrando por ella).
                          Builder(builder: (_) {
                            final area = task.area == null
                                ? null
                                : getTaskArea(task.area);
                            final showAreaChip = area != null &&
                                task.area != currentFilterAreaId;
                            if (!showAreaChip) {
                              return const SizedBox.shrink();
                            }
                            return Padding(
                              padding: const EdgeInsets.only(top: 3),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(area.emoji,
                                      style: const TextStyle(fontSize: 10)),
                                  const SizedBox(width: 3),
                                  Text(
                                    area.label,
                                    style: GoogleFonts.inter(
                                        fontSize: 10, color: area.color),
                                  ),
                                ],
                              ),
                            );
                          }),
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

              // Sin action buttons inline: todo se hace por swipe.
              // Margen inferior para no pegar el contenido al borde.
              const SizedBox(height: 10),
                  ],
                ),
              ),
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

  /// Crecimiento del título por antigüedad (rollover). Si la prefs
  /// `growOldTasks` está apagado, devolvemos siempre el base 14.
  ///
  /// Curva más suave para que no explote el layout:
  /// día 0 = 14, día 1 = 14.4, día 3 = 15.2, día 7 = 16.8, cap a 18.
  double _scaledFontSize(int rolloverDays, BuildContext context) {
    if (!TaskCardPrefs.growOldTasks || rolloverDays <= 0) return 14;
    final extra = (rolloverDays * 0.4).clamp(0.0, 4.0);
    return 14 + extra;
  }

  FontWeight _scaledFontWeight(int rolloverDays) {
    if (!TaskCardPrefs.growOldTasks || rolloverDays <= 0) return FontWeight.w500;
    if (rolloverDays >= 7) return FontWeight.w700;
    if (rolloverDays >= 3) return FontWeight.w600;
    return FontWeight.w500;
  }
}

/// Flags de comportamiento del TaskCard. Cache sincrónico para usar en
/// hot-path de render; se hidrata al arranque en main.dart.
class TaskCardPrefs extends ChangeNotifier {
  TaskCardPrefs._();
  static final TaskCardPrefs instance = TaskCardPrefs._();

  static const String _kGrowOldTasks = 'taskcard.growOldTasks';
  static bool growOldTasks = true;

  Future<void> load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      growOldTasks = prefs.getBool(_kGrowOldTasks) ?? true;
      notifyListeners();
    } catch (_) {}
  }

  Future<void> setGrowOldTasks(bool v) async {
    growOldTasks = v;
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_kGrowOldTasks, v);
    } catch (_) {}
  }
}

