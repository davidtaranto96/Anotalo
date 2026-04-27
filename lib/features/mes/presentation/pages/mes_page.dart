import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../../core/feedback/feedback_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/format_utils.dart';
import '../../../hoy/domain/models/task.dart';
import '../../../hoy/presentation/providers/task_provider.dart';
import '../../../hoy/presentation/widgets/add_task_bottom_sheet.dart';
import '../providers/month_provider.dart';
import '../widgets/day_tasks_inline.dart';
import '../widgets/week_strip.dart';
import '../widgets/weekly_goals_sheet.dart';
import 'monthly_review_page.dart';

/// Vista mensual estilo Samsung Calendar:
/// - Calendario completo (mes) que **colapsa a 1 semana** con swipe-up
/// - Cada día muestra **barras horizontales** por prioridad de tareas
///   (rojo=primordial, ámbar=importante, naranja=puede esperar)
/// - Tap en un día → tareas pendientes de ese día en una **sección inline**
///   abajo del calendario (no bottom sheet flotante)
/// - Long-press en una tarea → drag para mover a otro día
class MesPage extends ConsumerStatefulWidget {
  const MesPage({super.key});

  @override
  ConsumerState<MesPage> createState() => _MesPageState();
}

class _MesPageState extends ConsumerState<MesPage> {
  DateTime _focused = DateTime.now();
  DateTime _selected = DateTime.now();
  CalendarFormat _format = CalendarFormat.month;

  @override
  Widget build(BuildContext context) {
    final tasksByDay = ref.watch(tasksByDayProvider);
    final taskService = ref.read(taskServiceProvider);

    return Scaffold(
      backgroundColor: context.surfaceBase,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // ── Header ────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 12, 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          DateFormat("MMMM 'de' yyyy", 'es')
                              .format(_focused)
                              .replaceFirstMapped(
                                  RegExp(r'^[a-zñáéíóú]'),
                                  (m) => m.group(0)!.toUpperCase()),
                          style: GoogleFonts.fraunces(
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                            color: context.textPrimary,
                            letterSpacing: -0.3,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Vista mensual',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: context.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    tooltip: 'Valoración del mes',
                    onPressed: () {
                      FeedbackService.instance.tick();
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) =>
                              MonthlyReviewPage(month: _focused),
                        ),
                      );
                    },
                    icon: Icon(Icons.bar_chart_rounded,
                        color: context.textSecondary),
                  ),
                  IconButton(
                    tooltip: 'Hoy',
                    onPressed: () {
                      FeedbackService.instance.tick();
                      setState(() {
                        _focused = DateTime.now();
                        _selected = DateTime.now();
                      });
                      ref.read(visibleMonthProvider.notifier).state =
                          DateTime(_focused.year, _focused.month, 1);
                    },
                    icon: Icon(Icons.today_rounded,
                        color: context.textSecondary),
                  ),
                ],
              ),
            ),

            // ── Calendar ─────────────────────────────────────────────
            // Modo week: usamos el WeekStrip estilo Semana (cards con
            // counts y dot verde) en lugar del TableCalendar. Modo
            // mes: TableCalendar con barras horizontales por prioridad.
            if (_format == CalendarFormat.week) ...[
              GestureDetector(
                // Swipe-down → expandir a mes
                onVerticalDragEnd: (d) {
                  if ((d.primaryVelocity ?? 0) > 200) {
                    FeedbackService.instance.tick();
                    setState(() => _format = CalendarFormat.month);
                  }
                },
                child: WeekStrip(
                  weekStart: _weekStartFor(_focused),
                  selected: _selected,
                  tasksByDay: tasksByDay.valueOrNull ?? const {},
                  onDayTap: (day) {
                    setState(() {
                      _selected = day;
                      _focused = day;
                    });
                  },
                  onTaskDroppedOnDay: (task, target) {
                    FeedbackService.instance.success();
                    taskService.moveTaskToDay(task.id, dateToId(target));
                  },
                ),
              ),
              // Navegación entre semanas (flechas) + atajo a metas.
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 4),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.chevron_left_rounded),
                      color: context.textSecondary,
                      onPressed: () {
                        FeedbackService.instance.tick();
                        setState(() {
                          _focused =
                              _focused.subtract(const Duration(days: 7));
                        });
                      },
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          _weekRangeLabel(_focused),
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: context.textSecondary,
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.chevron_right_rounded),
                      color: context.textSecondary,
                      onPressed: () {
                        FeedbackService.instance.tick();
                        setState(() {
                          _focused = _focused.add(const Duration(days: 7));
                        });
                      },
                    ),
                  ],
                ),
              ),
              // Botón "Lo primordial de la semana" — atajo visible al
              // bottom sheet de metas.
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                child: SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      FeedbackService.instance.tick();
                      WeeklyGoalsSheet.show(
                          context, _weekStartFor(_focused));
                    },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                          color: AppTheme.colorDanger.withAlpha(80)),
                      foregroundColor: AppTheme.colorDanger,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                    icon: const Icon(Icons.star_rounded, size: 16),
                    label: Text(
                      'Lo primordial de la semana',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ] else
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: TableCalendar<Task>(
                locale: 'es_ES',
                firstDay: DateTime.utc(2020, 1, 1),
                lastDay: DateTime.utc(2035, 12, 31),
                focusedDay: _focused,
                startingDayOfWeek: StartingDayOfWeek.monday,
                calendarFormat: _format,
                rowHeight: 48,
                daysOfWeekHeight: 24,
                availableCalendarFormats: const {
                  CalendarFormat.month: 'Semana',
                  CalendarFormat.week: 'Mes',
                },
                // Gesto vertical: swipe-up colapsa a semana, swipe-down
                // expande a mes. Como Samsung Calendar.
                availableGestures: AvailableGestures.all,
                onFormatChanged: (f) {
                  FeedbackService.instance.tick();
                  setState(() => _format = f);
                },
                selectedDayPredicate: (d) => isSameDay(_selected, d),
                onPageChanged: (focused) {
                  setState(() => _focused = focused);
                  ref.read(visibleMonthProvider.notifier).state =
                      DateTime(focused.year, focused.month, 1);
                },
                eventLoader: (day) =>
                    tasksByDay.valueOrNull?[dateToId(day)] ?? const [],
                onDaySelected: (selected, focused) {
                  FeedbackService.instance.tick();
                  setState(() {
                    _selected = selected;
                    _focused = focused;
                  });
                },
                calendarBuilders: CalendarBuilders<Task>(
                  defaultBuilder: (ctx, day, _) =>
                      _DayCellWithStar(day: day, taskService: taskService),
                  todayBuilder: (ctx, day, _) => _DayCellWithStar(
                      day: day, isToday: true, taskService: taskService),
                  selectedBuilder: (ctx, day, _) => _DayCellWithStar(
                      day: day,
                      isSelected: true,
                      taskService: taskService),
                  outsideBuilder: (ctx, day, _) => _DayCellWithStar(
                      day: day, isOutside: true, taskService: taskService),
                  // Markers como BARRAS horizontales por prioridad
                  // (estilo Samsung) — hasta 3 barras visibles.
                  markerBuilder: (ctx, day, events) {
                    if (events.isEmpty) return const SizedBox.shrink();
                    final hasP = events.any(
                        (e) => e.priority == TaskPriority.primordial);
                    final hasI = events.any(
                        (e) => e.priority == TaskPriority.importante);
                    final hasE = events.any((e) =>
                        e.priority == TaskPriority.puedeEsperar ||
                        e.priority == TaskPriority.secundaria);
                    return Positioned(
                      left: 6,
                      right: 6,
                      bottom: 4,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (hasP) _bar(AppTheme.colorDanger),
                          if (hasI) _bar(AppTheme.colorWarning),
                          if (hasE) _bar(AppTheme.colorPrimary),
                        ],
                      ),
                    );
                  },
                ),
                calendarStyle: CalendarStyle(
                  outsideDaysVisible: true,
                  cellPadding: EdgeInsets.zero,
                  cellMargin: const EdgeInsets.all(2),
                  defaultTextStyle: GoogleFonts.inter(
                      fontSize: 13, color: context.textPrimary),
                  weekendTextStyle: GoogleFonts.inter(
                      fontSize: 13, color: context.textPrimary),
                  outsideTextStyle: GoogleFonts.inter(
                      fontSize: 13, color: context.textTertiary),
                ),
                headerVisible: false,
                daysOfWeekStyle: DaysOfWeekStyle(
                  weekdayStyle: GoogleFonts.inter(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: context.textTertiary,
                    letterSpacing: 0.8,
                  ),
                  weekendStyle: GoogleFonts.inter(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.colorPrimary,
                    letterSpacing: 0.8,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 4),
            Divider(height: 1, color: context.dividerColor),

            // ── Tareas del día seleccionado (inline) ──────────────────
            Expanded(
              child: DayTasksInline(
                day: _selected,
                tasks: tasksByDay.valueOrNull?[dateToId(_selected)] ??
                    const [],
                onComplete: taskService.completeTask,
                onUncomplete: taskService.uncompleteTask,
                onDelete: taskService.deleteTask,
              ),
            ),

            // ── Botón fijo "+ Nueva tarea para este día" ─────────────
            SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
                child: SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: () {
                      FeedbackService.instance.tick();
                      AddTaskBottomSheet.show(
                        context,
                        prefillDayId: dateToId(_selected),
                      );
                    },
                    icon: const Icon(Icons.add_rounded, size: 18),
                    label: Text(
                      'Nueva tarea para este día',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _bar(Color c) => Container(
        height: 3,
        margin: const EdgeInsets.only(top: 1),
        decoration: BoxDecoration(
          color: c,
          borderRadius: BorderRadius.circular(2),
        ),
      );

  /// Lunes (00:00) de la semana que contiene `d`. Lunes = weekday 1.
  DateTime _weekStartFor(DateTime d) {
    final base = DateTime(d.year, d.month, d.day);
    return base.subtract(Duration(days: base.weekday - 1));
  }

  /// Etiqueta "20 abr – 26 abr" para mostrar entre las flechas en
  /// modo week.
  String _weekRangeLabel(DateTime d) {
    final start = _weekStartFor(d);
    final end = start.add(const Duration(days: 6));
    final months = [
      'ene','feb','mar','abr','may','jun','jul','ago','sep','oct','nov','dic'
    ];
    return '${start.day} ${months[start.month - 1]} – ${end.day} ${months[end.month - 1]}';
  }
}

/// Wrapper de `_DayCell` que agrega un mini-icono estrella en la
/// esquina superior izquierda cuando la celda corresponde a un
/// LUNES. Tap en la estrella → abre el bottom sheet de metas
/// primordiales de esa semana, sin cambiar el día seleccionado.
class _DayCellWithStar extends StatelessWidget {
  const _DayCellWithStar({
    required this.day,
    this.isToday = false,
    this.isSelected = false,
    this.isOutside = false,
    required this.taskService,
  });

  final DateTime day;
  final bool isToday;
  final bool isSelected;
  final bool isOutside;
  final dynamic taskService;

  @override
  Widget build(BuildContext context) {
    final isMonday = day.weekday == 1;
    final cell = _DayCell(
      day: day,
      isToday: isToday,
      isSelected: isSelected,
      isOutside: isOutside,
      taskService: taskService,
    );
    if (!isMonday) return cell;
    final monday = DateTime(day.year, day.month, day.day);
    return Stack(
      clipBehavior: Clip.none,
      children: [
        cell,
        Positioned(
          left: 2,
          top: 2,
          child: GestureDetector(
            onTap: () {
              FeedbackService.instance.tick();
              WeeklyGoalsSheet.show(context, monday);
            },
            behavior: HitTestBehavior.opaque,
            child: Container(
              width: 14,
              height: 14,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppTheme.colorDanger.withAlpha(30),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.star_rounded,
                  size: 9, color: AppTheme.colorDanger),
            ),
          ),
        ),
      ],
    );
  }
}

/// Celda del calendario con DragTarget — soltar una tarea de otro día
/// reasigna su `dayId`.
class _DayCell extends StatelessWidget {
  const _DayCell({
    required this.day,
    this.isToday = false,
    this.isSelected = false,
    this.isOutside = false,
    required this.taskService,
  });

  final DateTime day;
  final bool isToday;
  final bool isSelected;
  final bool isOutside;
  final dynamic taskService;

  @override
  Widget build(BuildContext context) {
    return DragTarget<Task>(
      onAcceptWithDetails: (details) {
        FeedbackService.instance.success();
        taskService.moveTaskToDay(details.data.id, dateToId(day));
      },
      builder: (ctx, candidates, _) {
        final hovering = candidates.isNotEmpty;
        Color? bg;
        Color textColor = isOutside
            ? context.textTertiary
            : context.textPrimary;
        BoxBorder? border;
        if (hovering) {
          bg = AppTheme.colorPrimary.withAlpha(50);
          border = Border.all(color: AppTheme.colorPrimary, width: 2);
        } else if (isSelected) {
          bg = AppTheme.colorPrimary.withAlpha(50);
          border = Border.all(color: AppTheme.colorPrimary, width: 1.5);
        }
        if (isToday) {
          textColor = AppTheme.colorPrimary;
        }
        return Container(
          margin: const EdgeInsets.all(1),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(6),
            border: border,
          ),
          alignment: Alignment.topCenter,
          padding: const EdgeInsets.only(top: 6),
          child: Text(
            '${day.day}',
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: isToday || isSelected
                  ? FontWeight.w700
                  : FontWeight.w500,
              color: textColor,
            ),
          ),
        );
      },
    );
  }
}
