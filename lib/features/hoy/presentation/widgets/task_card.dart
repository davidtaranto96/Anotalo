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
import 'pencil_strike_title.dart';

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
    final today = todayId();
    final isRolledOver = !isDone && task.dayId.compareTo(today) < 0;
    final rolloverDays = isRolledOver
        ? DateTime.now()
            .difference(idToDate(task.dayId))
            .inDays
        : 0;

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
                      FeedbackService.instance.tick();
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
                      FeedbackService.instance.success();
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
                      FeedbackService.instance.tick();
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
                FeedbackService.instance.danger();
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
          // Long press:
          //   - Pendientes → abrir editor con los datos de la tarea.
          //   - Completadas → deshacer (mantener el shortcut histórico).
          onLongPress: () {
            FeedbackService.instance.warn();
            if (isDone && onUncomplete != null) {
              onUncomplete!();
            } else if (!isDone) {
              AddTaskBottomSheet.show(context, existing: task);
            }
          },
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
              // Main row
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 12, 12, 0),
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
                          ListenableBuilder(
                            listenable: TaskCardPrefs.instance,
                            builder: (ctx, _) => PencilStrikeTitle(
                              title: task.title,
                              done: isDone,
                              strokeColor: priorityColor,
                              onComplete: onComplete,
                              style: GoogleFonts.inter(
                                fontSize:
                                    _scaledFontSize(rolloverDays, context),
                                fontWeight: _scaledFontWeight(rolloverDays),
                                color: isDone
                                    ? context.textTertiary
                                    : context.textPrimary,
                                height: 1.25,
                              ),
                            ),
                          ),
                          // Meta row compacta: "de ayer" + chip de área
                          // en una sola línea para no malgastar vertical.
                          // El chip de área se omite si el usuario está
                          // filtrando justamente por esa área (redundante).
                          Builder(builder: (_) {
                            final area = task.area == null
                                ? null
                                : getTaskArea(task.area);
                            final showAreaChip = area != null &&
                                task.area != currentFilterAreaId;
                            if (!isRolledOver && !showAreaChip) {
                              return const SizedBox.shrink();
                            }
                            return Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Wrap(
                                spacing: 10,
                                runSpacing: 4,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  if (isRolledOver)
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(
                                          Icons.history_rounded,
                                          size: 11,
                                          color: AppTheme.colorWarning,
                                        ),
                                        const SizedBox(width: 3),
                                        Text(
                                          rolloverDays == 1
                                              ? 'de ayer'
                                              : 'hace $rolloverDays días',
                                          style: GoogleFonts.inter(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w500,
                                            color: AppTheme.colorWarning,
                                          ),
                                        ),
                                      ],
                                    ),
                                  if (showAreaChip)
                                    Row(
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
                          FeedbackService.instance.success();
                          onComplete();
                        },
                      ),
                      const SizedBox(width: 6),
                      _ActionButton(
                        label: '→ Diferir',
                        color: context.textSecondary,
                        bgColor: context.neutral100,
                        onTap: () {
                          FeedbackService.instance.tick();
                          onDefer();
                        },
                      ),
                      const SizedBox(width: 6),
                      _ActionButton(
                        label: '✕',
                        color: AppTheme.colorDanger,
                        bgColor: AppTheme.colorDangerLight,
                        onTap: () {
                          FeedbackService.instance.danger();
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
  /// `growOldTasks` está apagado, devolvemos siempre el base 15.
  ///
  /// Curva suave: día 0 = 15, día 1 = 15.6, día 3 = 16.8, día 7 = 19,
  /// día 14 = 21, cap a 22 para que no explote el layout.
  double _scaledFontSize(int rolloverDays, BuildContext context) {
    if (!TaskCardPrefs.growOldTasks || rolloverDays <= 0) return 15;
    final extra = (rolloverDays * 0.6).clamp(0.0, 7.0);
    return 15 + extra;
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
