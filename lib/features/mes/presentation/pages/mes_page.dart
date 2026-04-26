import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../../core/feedback/feedback_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/format_utils.dart';
import '../../../../core/logic/task_service.dart';
import '../../../hoy/domain/models/task.dart';
import '../../../hoy/presentation/providers/task_provider.dart';
import '../providers/month_provider.dart';
import '../widgets/day_tasks_sheet.dart';
import 'monthly_review_page.dart';

/// Vista mensual. Calendario completo donde cada día muestra dots por
/// prioridad de las tareas asignadas. Tap en un día → bottom sheet con
/// las tareas de ese día agrupadas por área. Drag-and-drop de una tarea
/// (long-press en el sheet) sobre otra celda → reasigna `dayId`.
class MesPage extends ConsumerStatefulWidget {
  const MesPage({super.key});

  @override
  ConsumerState<MesPage> createState() => _MesPageState();
}

class _MesPageState extends ConsumerState<MesPage> {
  DateTime _focused = DateTime.now();
  DateTime? _selected;

  @override
  Widget build(BuildContext context) {
    final tasksByDay = ref.watch(tasksByDayProvider);
    final taskService = ref.read(taskServiceProvider);

    return Scaffold(
      backgroundColor: context.surfaceBase,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
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
                    // Valoración del mes: pantalla de métricas.
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
                    // Botón de "Hoy" — vuelve al día actual
                    IconButton(
                      tooltip: 'Hoy',
                      onPressed: () {
                        FeedbackService.instance.tick();
                        setState(() {
                          _focused = DateTime.now();
                          _selected = null;
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
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: TableCalendar<Task>(
                  locale: 'es_ES',
                  firstDay: DateTime.utc(2020, 1, 1),
                  lastDay: DateTime.utc(2035, 12, 31),
                  focusedDay: _focused,
                  startingDayOfWeek: StartingDayOfWeek.monday,
                  // Mostramos 6 filas siempre para que el grid no salte.
                  rowHeight: 56,
                  daysOfWeekHeight: 28,
                  selectedDayPredicate: (d) =>
                      _selected != null && isSameDay(_selected, d),
                  onPageChanged: (focused) {
                    setState(() => _focused = focused);
                    ref.read(visibleMonthProvider.notifier).state =
                        DateTime(focused.year, focused.month, 1);
                  },
                  eventLoader: (day) {
                    return tasksByDay.valueOrNull?[dateToId(day)] ??
                        const [];
                  },
                  onDaySelected: (selected, focused) {
                    FeedbackService.instance.tick();
                    setState(() {
                      _selected = selected;
                      _focused = focused;
                    });
                    final tasks =
                        tasksByDay.valueOrNull?[dateToId(selected)] ??
                            const <Task>[];
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (_) => DayTasksSheet(
                        day: selected,
                        tasks: tasks,
                        onComplete: taskService.completeTask,
                        onUncomplete: taskService.uncompleteTask,
                        onDelete: taskService.deleteTask,
                      ),
                    );
                  },
                  // Drop target para drag-and-drop entre celdas.
                  calendarBuilders: CalendarBuilders<Task>(
                    defaultBuilder: (ctx, day, focusedDay) =>
                        _DayCell(day: day, isToday: false, taskService: taskService),
                    todayBuilder: (ctx, day, focusedDay) =>
                        _DayCell(day: day, isToday: true, taskService: taskService),
                    selectedBuilder: (ctx, day, focusedDay) =>
                        _DayCell(day: day, isToday: false, isSelected: true, taskService: taskService),
                    outsideBuilder: (ctx, day, focusedDay) =>
                        _DayCell(day: day, isToday: false, isOutside: true, taskService: taskService),
                    markerBuilder: (ctx, day, events) {
                      if (events.isEmpty) return const SizedBox.shrink();
                      // Hasta 4 dots: rojo (primordial), amarillo
                      // (importante), naranja (puede esperar), gris (sec).
                      final hasP = events.any(
                          (e) => e.priority == TaskPriority.primordial);
                      final hasI = events.any(
                          (e) => e.priority == TaskPriority.importante);
                      final hasE = events.any((e) =>
                          e.priority == TaskPriority.puedeEsperar ||
                          e.priority == TaskPriority.secundaria);
                      return Positioned(
                        bottom: 4,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (hasP) _dot(AppTheme.colorDanger),
                            if (hasI) _dot(AppTheme.colorWarning),
                            if (hasE) _dot(AppTheme.colorPrimary),
                          ],
                        ),
                      );
                    },
                  ),
                  calendarStyle: CalendarStyle(
                    outsideDaysVisible: true,
                    cellPadding: EdgeInsets.zero,
                    cellMargin: const EdgeInsets.all(2),
                    weekendTextStyle:
                        TextStyle(color: context.textPrimary),
                    defaultTextStyle: TextStyle(color: context.textPrimary),
                    outsideTextStyle:
                        TextStyle(color: context.textTertiary),
                  ),
                  headerVisible: false,
                  daysOfWeekStyle: DaysOfWeekStyle(
                    weekdayStyle: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: context.textTertiary,
                      letterSpacing: 0.6,
                    ),
                    weekendStyle: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.colorPrimary,
                      letterSpacing: 0.6,
                    ),
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                child: _MonthSummary(tasksByDay: tasksByDay.valueOrNull ?? {}),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 140)),
          ],
        ),
      ),
    );
  }

  static Widget _dot(Color c) => Container(
        width: 5,
        height: 5,
        margin: const EdgeInsets.symmetric(horizontal: 1),
        decoration: BoxDecoration(color: c, shape: BoxShape.circle),
      );
}

/// Celda de día con DragTarget — al soltar una tarea sobre la celda
/// reasigna su `dayId`.
class _DayCell extends StatelessWidget {
  const _DayCell({
    required this.day,
    required this.isToday,
    this.isSelected = false,
    this.isOutside = false,
    required this.taskService,
  });

  final DateTime day;
  final bool isToday;
  final bool isSelected;
  final bool isOutside;
  final TaskService taskService;

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
          bg = AppTheme.colorPrimary.withAlpha(40);
          border = Border.all(color: AppTheme.colorPrimary, width: 2);
        } else if (isSelected) {
          bg = AppTheme.colorPrimary.withAlpha(60);
          border = Border.all(color: AppTheme.colorPrimary, width: 1.5);
        } else if (isToday) {
          bg = AppTheme.colorPrimary.withAlpha(28);
          border = Border.all(color: AppTheme.colorPrimary.withAlpha(120));
        }
        if (isToday) textColor = AppTheme.colorPrimary;
        return Container(
          margin: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(10),
            border: border,
          ),
          alignment: Alignment.center,
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

class _MonthSummary extends StatelessWidget {
  const _MonthSummary({required this.tasksByDay});
  final Map<String, List<Task>> tasksByDay;

  @override
  Widget build(BuildContext context) {
    var total = 0, done = 0, primordial = 0;
    for (final list in tasksByDay.values) {
      for (final t in list) {
        total++;
        if (t.status == TaskStatus.done) done++;
        if (t.priority == TaskPriority.primordial) primordial++;
      }
    }
    final pct = total == 0 ? 0 : ((done / total) * 100).round();
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: context.surfaceCard,
        borderRadius: AppTheme.r16,
        border: Border.all(color: context.dividerColor),
      ),
      child: Row(
        children: [
          Expanded(
            child: _StatCol(
              label: 'COMPLETADAS',
              value: '$done/$total',
              sub: '$pct%',
              color: AppTheme.colorSuccess,
            ),
          ),
          Container(width: 1, height: 36, color: context.dividerColor),
          Expanded(
            child: _StatCol(
              label: 'PRIMORDIAL',
              value: '$primordial',
              sub: 'tareas',
              color: AppTheme.colorDanger,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCol extends StatelessWidget {
  const _StatCol({
    required this.label,
    required this.value,
    required this.sub,
    required this.color,
  });
  final String label;
  final String value;
  final String sub;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: color,
            letterSpacing: 0.8,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: GoogleFonts.fraunces(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: context.textPrimary,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          sub,
          style: GoogleFonts.inter(
            fontSize: 11,
            color: context.textTertiary,
          ),
        ),
      ],
    );
  }
}
