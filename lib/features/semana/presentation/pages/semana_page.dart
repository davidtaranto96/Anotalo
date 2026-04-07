import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/format_utils.dart';
import '../../../../core/widgets/voice_input_button.dart';
import '../../../../core/logic/weekly_plan_service.dart';
import '../../../../core/models/task_area.dart';
import '../../../hoy/domain/models/task.dart';
import '../../../hoy/presentation/providers/task_provider.dart';
import '../providers/semana_provider.dart';

const _uuid = Uuid();

class SemanaPage extends ConsumerStatefulWidget {
  const SemanaPage({super.key});

  @override
  ConsumerState<SemanaPage> createState() => _SemanaPageState();
}

class _SemanaPageState extends ConsumerState<SemanaPage> {
  TaskPriority? _filter; // null = Todo
  final _addController = TextEditingController();
  TaskPriority _addPriority = TaskPriority.importante;
  String? _addArea;
  final _goalController = TextEditingController();

  @override
  void dispose() {
    _addController.dispose();
    _goalController.dispose();
    super.dispose();
  }

  // ── helpers ──────────────────────────────────────────────────────────────

  int _isoWeekNumber(DateTime date) {
    final startOfYear = DateTime(date.year, 1, 1);
    final firstMonday = startOfYear.weekday <= 4
        ? startOfYear.subtract(Duration(days: startOfYear.weekday - 1))
        : startOfYear.add(Duration(days: 8 - startOfYear.weekday));
    final diff = date.difference(firstMonday).inDays;
    return (diff / 7).floor() + 1;
  }

  Color _priorityColor(TaskPriority p) => switch (p) {
    TaskPriority.primordial  => AppTheme.colorDanger,
    TaskPriority.importante  => AppTheme.colorWarning,
    TaskPriority.puedeEsperar => AppTheme.colorPrimary,
    TaskPriority.secundaria  => AppTheme.textTertiary,
  };

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year && date.month == now.month && date.day == now.day;
  }

  static const _shortNames = ['LUN', 'MAR', 'MIE', 'JUE', 'VIE', 'SAB', 'DOM'];

  // ── build ───────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final weekDays = ref.watch(weekDaysProvider);
    final offset = ref.watch(weekOffsetProvider);
    final selectedIdx = ref.watch(selectedDayIndexProvider);
    final selectedDate = weekDays[selectedIdx];
    final selectedDayId = dateToId(selectedDate);

    final monday = weekDays.first;
    final sunday = weekDays.last;
    final weekNumber = _isoWeekNumber(monday);
    final dateRange =
        '${monday.day} ${DateFormat('MMM', 'es').format(monday)} – '
        '${sunday.day} ${DateFormat('MMM', 'es').format(sunday)} ${sunday.year}';

    return Scaffold(
      backgroundColor: context.surfaceBase,
      body: SafeArea(
        bottom: false,
        child: GestureDetector(
          onHorizontalDragEnd: (details) {
            if (details.primaryVelocity != null) {
              if (details.primaryVelocity! < -300) {
                // Swipe left = next week
                ref.read(weekOffsetProvider.notifier).state++;
              } else if (details.primaryVelocity! > 300) {
                // Swipe right = previous week
                ref.read(weekOffsetProvider.notifier).state--;
              }
            }
          },
          behavior: HitTestBehavior.translucent,
          child: Column(
            children: [
              // ── Header with week nav (centered) ──────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _NavArrow(
                      icon: Icons.chevron_left_rounded,
                      onTap: () => ref.read(weekOffsetProvider.notifier).state--,
                    ),
                    const SizedBox(width: 12),
                    Column(
                      children: [
                        Text(
                          'Semana $weekNumber',
                          style: GoogleFonts.lora(
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                            color: context.textPrimary,
                            letterSpacing: -0.3,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(dateRange, style: GoogleFonts.inter(
                          fontSize: 13,
                          color: context.textSecondary,
                        )),
                        if (offset == 0) ...[
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppTheme.colorPrimaryLight,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text('Esta semana',
                              style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w500, color: AppTheme.colorPrimary)),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(width: 12),
                    _NavArrow(
                      icon: Icons.chevron_right_rounded,
                      onTap: () => ref.read(weekOffsetProvider.notifier).state++,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 14),

              // ── Day pills row ───────────────────────────────────────
              SizedBox(
                height: 80,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: 7,
                  separatorBuilder: (_, __) => const SizedBox(width: 6),
                  itemBuilder: (context, i) {
                    final date = weekDays[i];
                    final dayId = dateToId(date);
                    final isSelected = i == selectedIdx;
                    final isToday = _isToday(date);

                    return _DayPill(
                      label: _shortNames[i],
                      dayNumber: date.day,
                      isSelected: isSelected,
                      isToday: isToday,
                      dayId: dayId,
                      onTap: () => ref.read(selectedDayIndexProvider.notifier).state = i,
                    );
                  },
                ),
              ),

              const SizedBox(height: 12),

              // ── Filter tabs ─────────────────────────────────────────
              SizedBox(
                height: 36,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    _FilterTab(label: 'Todo', selected: _filter == null,
                        onTap: () => setState(() => _filter = null)),
                    _FilterTab(label: 'Primordial', selected: _filter == TaskPriority.primordial,
                        color: AppTheme.colorDanger,
                        onTap: () => setState(() => _filter = TaskPriority.primordial)),
                    _FilterTab(label: 'Importante', selected: _filter == TaskPriority.importante,
                        color: AppTheme.colorWarning,
                        onTap: () => setState(() => _filter = TaskPriority.importante)),
                    _FilterTab(label: 'Puede esperar', selected: _filter == TaskPriority.puedeEsperar,
                        color: AppTheme.colorPrimary,
                        onTap: () => setState(() => _filter = TaskPriority.puedeEsperar)),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // ── Scrollable content ──────────────────────────────────
              Expanded(
                child: _buildScrollableContent(selectedDayId, selectedDate),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildScrollableContent(String selectedDayId, DateTime selectedDate) {
    final tasksAsync = ref.watch(dayTasksProvider(selectedDayId));
    final taskService = ref.read(taskServiceProvider);
    final weeklyPlanAsync = ref.watch(weeklyPlanProvider);
    final weeklyPlanService = ref.read(weeklyPlanServiceProvider);
    final weekDays = ref.watch(weekDaysProvider);
    final weekStart = dateToId(weekDays.first);
    final weekEnd = dateToId(weekDays.last);
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
      children: [
        // ── Task list ─────────────────────────────────────────────────
        tasksAsync.when(
          loading: () => const Padding(
            padding: EdgeInsets.all(24),
            child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
          ),
          error: (e, _) => Padding(
            padding: const EdgeInsets.all(24),
            child: Text('Error: $e', style: GoogleFonts.inter(color: AppTheme.colorDanger)),
          ),
          data: (allTasks) {
            // Excluir tareas de proyectos — se muestran aparte abajo
            final ownTasks = allTasks
                .where((t) => t.parentProjectId == null)
                .toList();
            final tasks = _filter == null
                ? ownTasks
                : ownTasks.where((t) => t.priority == _filter).toList();

            if (tasks.isEmpty && _filter != null) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 32),
                child: Center(
                  child: Text(
                    'Sin tareas con este filtro',
                    style: GoogleFonts.inter(fontSize: 13, color: context.textTertiary),
                  ),
                ),
              );
            }

            return Column(
              children: [
                for (final task in tasks) _TaskCard(
                  task: task,
                  priorityColor: _priorityColor(task.priority),
                  onComplete: () => taskService.completeTask(task.id),
                  onDelete: () => taskService.deleteTask(task.id),
                ),
                if (tasks.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    child: Text(
                      'No hay tareas para este dia',
                      style: GoogleFonts.inter(fontSize: 13, color: context.textTertiary),
                    ),
                  ),
              ],
            );
          },
        ),

        // ── Inline add task ─────────────────────────────────────────
        const SizedBox(height: 8),
        _buildInlineAddTask(selectedDayId),

        const SizedBox(height: 28),

        // ── Lo primordial de la semana ──────────────────────────────
        weeklyPlanAsync.when(
          loading: () => const SizedBox.shrink(),
          error: (_, __) => const SizedBox.shrink(),
          data: (plan) {
            final goals = weeklyPlanService.decodePrimordialGoals(plan);
            return _PrimordialCard(
              goals: goals,
              goalController: _goalController,
              onRemove: (i) async {
                await weeklyPlanService.getOrCreatePlan(weekStart, weekEnd);
                final updated = List<String>.from(goals)..removeAt(i);
                await weeklyPlanService.updatePrimordialGoals(weekStart, updated);
              },
              onToggle: (i) async {
                await weeklyPlanService.getOrCreatePlan(weekStart, weekEnd);
                await weeklyPlanService.toggleGoalCompletion(weekStart, goals, i);
              },
              onAdd: (text) async {
                if (text.trim().isEmpty) return;
                await weeklyPlanService.getOrCreatePlan(weekStart, weekEnd);
                final updated = List<String>.from(goals)..add(text.trim());
                await weeklyPlanService.updatePrimordialGoals(weekStart, updated);
                _goalController.clear();
              },
            );
          },
        ),

        const SizedBox(height: 24),
      ],
    );
  }

  // ── Inline add task widget ─────────────────────────────────────────────

  Widget _buildInlineAddTask(String dayId) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 8, 8, 8),
      decoration: BoxDecoration(
        color: context.surfaceCard,
        borderRadius: AppTheme.r12,
        border: Border.all(color: context.dividerColor),
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Priority selector
              GestureDetector(
                onTap: _cyclePriority,
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: _priorityColor(_addPriority).withAlpha(30),
                    shape: BoxShape.circle,
                    border: Border.all(color: _priorityColor(_addPriority), width: 1.5),
                  ),
                  child: Center(
                    child: Text(
                      _addPriority.name[0].toUpperCase(),
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: _priorityColor(_addPriority),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              // Text field
              Expanded(
                child: TextField(
                  controller: _addController,
                  style: GoogleFonts.inter(fontSize: 14, color: context.textPrimary),
                  decoration: InputDecoration(
                    hintText: 'Agregar tarea...',
                    hintStyle: GoogleFonts.inter(fontSize: 14, color: context.textTertiary),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                    filled: false,
                  ),
                  onSubmitted: (text) => _submitTask(text, dayId),
                ),
              ),
              // Voice input
              VoiceInputButton(
                onResult: (text) {
                  _addController.text = text;
                  _submitTask(text, dayId);
                },
                size: 36,
              ),
            ],
          ),
          // Area pills row
          const SizedBox(height: 6),
          SizedBox(
            height: 28,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                // "None" pill
                GestureDetector(
                  onTap: () => setState(() => _addArea = null),
                  child: Container(
                    margin: const EdgeInsets.only(right: 6),
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: _addArea == null
                          ? AppTheme.colorPrimary.withAlpha(25)
                          : context.surfaceElevated,
                      borderRadius: AppTheme.rFull,
                      border: Border.all(
                        color: _addArea == null ? AppTheme.colorPrimary : context.dividerColor,
                      ),
                    ),
                    child: Text(
                      'Sin area',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: _addArea == null ? FontWeight.w600 : FontWeight.w400,
                        color: _addArea == null ? AppTheme.colorPrimary : context.textSecondary,
                      ),
                    ),
                  ),
                ),
                for (final area in kTaskAreas)
                  GestureDetector(
                    onTap: () => setState(() => _addArea = area.id),
                    child: Container(
                      margin: const EdgeInsets.only(right: 6),
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: _addArea == area.id
                            ? area.color.withAlpha(25)
                            : context.surfaceElevated,
                        borderRadius: AppTheme.rFull,
                        border: Border.all(
                          color: _addArea == area.id ? area.color : context.dividerColor,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(area.emoji, style: const TextStyle(fontSize: 11)),
                          const SizedBox(width: 4),
                          Text(
                            area.label,
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              fontWeight: _addArea == area.id ? FontWeight.w600 : FontWeight.w400,
                              color: _addArea == area.id ? area.color : context.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _cyclePriority() {
    setState(() {
      _addPriority = switch (_addPriority) {
        TaskPriority.primordial  => TaskPriority.importante,
        TaskPriority.importante  => TaskPriority.puedeEsperar,
        TaskPriority.puedeEsperar => TaskPriority.secundaria,
        TaskPriority.secundaria  => TaskPriority.primordial,
      };
    });
  }

  void _submitTask(String text, String dayId) {
    if (text.trim().isEmpty) return;
    final task = Task(
      id: _uuid.v4(),
      title: text.trim(),
      priority: _addPriority,
      status: TaskStatus.pending,
      area: _addArea,
      dayId: dayId,
      createdAt: DateTime.now(),
    );
    ref.read(taskServiceProvider).addTask(task);
    _addController.clear();
    setState(() => _addArea = null);
  }

  // ── Section header ─────────────────────────────────────────────────────

}

// ═══════════════════════════════════════════════════════════════════════════════
// Private widgets
// ═══════════════════════════════════════════════════════════════════════════════

// ── Nav arrow (dark-mode aware) ─────────────────────────────────────────────

class _NavArrow extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _NavArrow({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: context.surfaceElevated,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          size: 20,
          color: context.textSecondary,
        ),
      ),
    );
  }
}

// ── Day pill ─────────────────────────────────────────────────────────────────

class _DayPill extends ConsumerWidget {
  final String label;
  final int dayNumber;
  final bool isSelected;
  final bool isToday;
  final String dayId;
  final VoidCallback onTap;

  const _DayPill({
    required this.label,
    required this.dayNumber,
    required this.isSelected,
    required this.isToday,
    required this.dayId,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasksAsync = ref.watch(dayTasksProvider(dayId));
    final allTasks = tasksAsync.valueOrNull ?? [];
    final done = allTasks.where((t) => t.status == TaskStatus.done).length;
    final total = allTasks.length;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: 46,
        padding: const EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.colorPrimary.withAlpha(20) : context.surfaceCard,
          borderRadius: AppTheme.r12,
          border: Border.all(
            color: isSelected ? AppTheme.colorPrimary : context.dividerColor,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: isSelected ? AppTheme.colorPrimary : context.textTertiary,
                letterSpacing: 0.3,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              '$dayNumber',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: isSelected ? AppTheme.colorPrimary : context.textPrimary,
              ),
            ),
            const SizedBox(height: 2),
            if (isToday)
              Container(
                width: 5,
                height: 5,
                decoration: const BoxDecoration(
                  color: AppTheme.colorPrimary,
                  shape: BoxShape.circle,
                ),
              )
            else
              const SizedBox(height: 5),
            Text(
              '$done/$total',
              style: GoogleFonts.inter(
                fontSize: 9,
                fontWeight: FontWeight.w500,
                color: context.textTertiary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Task card ────────────────────────────────────────────────────────────────

class _TaskCard extends StatelessWidget {
  final Task task;
  final Color priorityColor;
  final VoidCallback onComplete;
  final VoidCallback onDelete;

  const _TaskCard({
    required this.task,
    required this.priorityColor,
    required this.onComplete,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isDone = task.status == TaskStatus.done;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Container(
        decoration: BoxDecoration(
          color: context.surfaceCard,
          borderRadius: AppTheme.r12,
          border: Border.all(color: context.dividerColor),
        ),
        child: IntrinsicHeight(
          child: Row(
            children: [
              // Left color border
              Container(
                width: 4,
                decoration: BoxDecoration(
                  color: priorityColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    bottomLeft: Radius.circular(12),
                  ),
                ),
              ),
              // Content
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 12, 8, 12),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          task.title,
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: isDone ? context.textTertiary : context.textPrimary,
                            decoration: isDone ? TextDecoration.lineThrough : null,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Priority dot
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: priorityColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Complete button
                      if (!isDone)
                        GestureDetector(
                          onTap: onComplete,
                          child: Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              color: AppTheme.colorSuccess.withAlpha(20),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.check_rounded,
                              size: 16,
                              color: AppTheme.colorSuccess,
                            ),
                          ),
                        )
                      else
                        const Icon(
                          Icons.check_circle_rounded,
                          size: 20,
                          color: AppTheme.colorSuccess,
                        ),
                      const SizedBox(width: 4),
                      // Delete button
                      GestureDetector(
                        onTap: onDelete,
                        child: Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            color: AppTheme.colorDanger.withAlpha(15),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.close_rounded,
                            size: 16,
                            color: AppTheme.colorDanger,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Filter tab ───────────────────────────────────────────────────────────────

class _FilterTab extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final Color? color;

  const _FilterTab({
    required this.label,
    required this.selected,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final activeColor = color ?? AppTheme.colorPrimary;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        margin: const EdgeInsets.only(right: 6),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? activeColor.withAlpha(25) : context.surfaceCard,
          borderRadius: AppTheme.rFull,
          border: Border.all(
            color: selected ? activeColor : context.dividerColor,
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
            color: selected ? activeColor : context.textSecondary,
          ),
        ),
      ),
    );
  }
}

// ── Primordial card (numbered goals) ────────────────────────────────────────

class _PrimordialCard extends StatefulWidget {
  final List<String> goals;
  final TextEditingController goalController;
  final Future<void> Function(int index) onRemove;
  final Future<void> Function(int index) onToggle;
  final Future<void> Function(String text) onAdd;

  const _PrimordialCard({
    required this.goals,
    required this.goalController,
    required this.onRemove,
    required this.onToggle,
    required this.onAdd,
  });

  @override
  State<_PrimordialCard> createState() => _PrimordialCardState();
}

class _PrimordialCardState extends State<_PrimordialCard> {
  bool _adding = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.surfaceCard,
        borderRadius: AppTheme.r16,
        border: Border.all(color: AppTheme.colorDanger.withAlpha(40)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title row
          Row(
            children: [
              const Text('\u{1F3AF}', style: TextStyle(fontSize: 18)),
              const SizedBox(width: 8),
              Text(
                'Lo primordial',
                style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.colorDanger,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Numbered goals
          if (widget.goals.isEmpty && !_adding)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                'Sin metas esta semana',
                style: GoogleFonts.inter(fontSize: 13, color: context.textTertiary),
              ),
            ),
          for (int i = 0; i < widget.goals.length; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Builder(builder: (context) {
                final isDone = WeeklyPlanService.isGoalDone(widget.goals[i]);
                final goalText = WeeklyPlanService.goalText(widget.goals[i]);
                return Row(
                  children: [
                    // Tap to toggle completion
                    GestureDetector(
                      onTap: () => widget.onToggle(i),
                      child: Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isDone ? AppTheme.colorSuccess : AppTheme.colorDanger.withAlpha(20),
                          border: isDone ? null : Border.all(color: AppTheme.colorDanger.withAlpha(60)),
                        ),
                        child: isDone
                            ? const Icon(Icons.check_rounded, size: 14, color: Colors.white)
                            : Center(
                                child: Text(
                                  '${i + 1}',
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: AppTheme.colorDanger,
                                  ),
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        goalText,
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: isDone ? context.textTertiary : context.textPrimary,
                          decoration: isDone ? TextDecoration.lineThrough : null,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => widget.onRemove(i),
                      child: Icon(
                        Icons.close_rounded,
                        size: 14,
                        color: context.textTertiary,
                      ),
                    ),
                  ],
                );
              }),
            ),

          // Add goal inline or button
          if (_adding)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: widget.goalController,
                      autofocus: true,
                      style: GoogleFonts.inter(fontSize: 14, color: context.textPrimary),
                      decoration: InputDecoration(
                        hintText: 'Nueva meta...',
                        hintStyle: GoogleFonts.inter(fontSize: 14, color: context.textTertiary),
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                        filled: false,
                      ),
                      onSubmitted: (text) {
                        widget.onAdd(text);
                        setState(() => _adding = false);
                      },
                      onTapOutside: (_) {
                        setState(() => _adding = false);
                        widget.goalController.clear();
                      },
                    ),
                  ),
                ],
              ),
            )
          else
            GestureDetector(
              onTap: () => setState(() => _adding = true),
              child: Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Row(
                  children: [
                    Icon(
                      Icons.add_circle_outline_rounded,
                      size: 20,
                      color: context.textTertiary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Agregar meta...',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: context.textTertiary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}


