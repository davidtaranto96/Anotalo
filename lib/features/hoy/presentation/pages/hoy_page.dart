import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/format_utils.dart';
import '../../domain/models/task.dart';
import '../providers/task_provider.dart';
import '../../../habitos/domain/models/habit.dart';
import '../../../habitos/presentation/providers/habit_provider.dart';
import '../widgets/active_projects_section.dart';
import '../widgets/priority_section.dart';
import '../widgets/task_card.dart';
import '../widgets/task_skeleton.dart';
import '../../../../core/models/task_area.dart';
import '../../../../core/providers/task_area_provider.dart';
import '../../../../core/widgets/voice_input_button.dart';
import '../../../../core/widgets/defer_picker.dart';
import '../../../../core/logic/task_parser.dart';
import '../../../../core/logic/user_prefs.dart';
import '../../../../core/providers/shell_providers.dart';
import '../../data/curated_quotes.dart';
import 'dart:math' as math;

class HoyPage extends ConsumerStatefulWidget {
  const HoyPage({super.key});

  @override
  ConsumerState<HoyPage> createState() => _HoyPageState();
}

class _HoyPageState extends ConsumerState<HoyPage> {
  String? _selectedArea; // null = show all
  bool _showOtras = false;
  bool _showCompleted = false;
  late String _quote;
  late String _quoteAuthor;

  /// Built from the current (possibly DB-edited) list of areas, not the
  /// hardcoded defaults. Resolved lazily in [build] via [_resolveAreaColor].
  Color? _resolveAreaColor(List<TaskArea> areas) => _selectedArea == null
      ? null
      : getTaskAreaFrom(areas, _selectedArea)?.color;

  int? _lastQuoteIdx;

  void _rotateQuote() {
    int idx = math.Random().nextInt(curatedQuotes.length);
    // Avoid repeating the same quote back-to-back.
    if (curatedQuotes.length > 1 && idx == _lastQuoteIdx) {
      idx = (idx + 1) % curatedQuotes.length;
    }
    _lastQuoteIdx = idx;
    _quote = curatedQuotes[idx]['q']!;
    _quoteAuthor = curatedQuotes[idx]['a']!;
  }

  @override
  void initState() {
    super.initState();
    _rotateQuote();
  }

  @override
  Widget build(BuildContext context) {
    // Rotate the motivational quote every time the user navigates back to
    // Hoy from another tab. Tab index 0 = Hoy.
    ref.listen<int>(currentTabIndexProvider, (prev, curr) {
      if (curr == 0 && prev != 0) {
        setState(_rotateQuote);
      }
    });

    final todayTasksAsync = ref.watch(todayTasksProvider);
    final primordial = ref.watch(primordialTasksProvider);
    final importante = ref.watch(importanteTasksProvider);
    final puedeEsperar = ref.watch(puedeEsperarTasksProvider);
    final completed = ref.watch(completedTasksProvider);
    final progress = ref.watch(dayProgressProvider);

    final habitsAsync = ref.watch(activeHabitsProvider);
    final completionsAsync = ref.watch(todayCompletionsProvider);

    final streakAsync = ref.watch(streakProvider);
    final taskService = ref.read(taskServiceProvider);

    // Live-edited list of areas (colors, order, labels all reflect user edits).
    final areas = ref.watch(taskAreasSyncProvider);
    final areaColor = _resolveAreaColor(areas);

    final now = DateTime.now();
    final dateStr = DateFormat("EEEE d 'de' MMMM", 'es').format(now);

    // Filter by area if selected
    final filteredPrimordial = _selectedArea == null
        ? primordial
        : primordial.where((t) => t.area == _selectedArea).toList();
    final filteredImportante = _selectedArea == null
        ? importante
        : importante.where((t) => t.area == _selectedArea).toList();
    final filteredPuedeEsperar = _selectedArea == null
        ? puedeEsperar
        : puedeEsperar.where((t) => t.area == _selectedArea).toList();
    final filteredCompleted = _selectedArea == null
        ? completed
        : completed.where((t) => t.area == _selectedArea).toList();

    final totalTasks = todayTasksAsync.valueOrNull?.length ?? 0;
    final completedCount = completed.length;
    final primordialTotal = (todayTasksAsync.valueOrNull ?? [])
        .where((t) => t.priority == TaskPriority.primordial).length;
    final primordialDone = (todayTasksAsync.valueOrNull ?? [])
        .where((t) => t.priority == TaskPriority.primordial && t.status == TaskStatus.done).length;

    // Stronger tint so the whole page clearly takes on the area color when
    // a category is selected (user-requested "titulo para abajo se tiñe").
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final tintedBg = areaColor != null
        ? Color.lerp(context.surfaceBase, areaColor, isDark ? 0.12 : 0.14)!
        : context.surfaceBase;

    final userPrefs = ref.watch(userPrefsProvider);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
      color: tintedBg,
      child: Scaffold(
      backgroundColor: Colors.transparent,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // ── Header ──────────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Título + iconos centrados en la misma fila para
                    // que queden alineados ópticamente.
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Text(
                            '¿Qué vas a lograr hoy?',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.fraunces(
                              fontSize: 22,
                              fontWeight: FontWeight.w600,
                              color: context.textPrimary,
                              letterSpacing: -0.3,
                              height: 1.15,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            GestureDetector(
                              onLongPress: () {
                                HapticFeedback.mediumImpact();
                                context.push('/review-history');
                              },
                              child: _HeaderIcon(
                                icon: Icons.rate_review_rounded,
                                onTap: () => context.push('/review'),
                              ),
                            ),
                            _HeaderIcon(
                              icon: Icons.settings_rounded,
                              onTap: () => context.push('/settings'),
                            ),
                            _HeaderIcon(
                              icon: Icons.inbox_rounded,
                              onTap: () => context.go('/inbox'),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      dateStr,
                      style: GoogleFonts.inter(fontSize: 13, color: context.textSecondary),
                    ),
                    if (userPrefs.showQuotes) ...[
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.format_quote_rounded, size: 14, color: AppTheme.colorAccent),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text.rich(
                              TextSpan(children: [
                                TextSpan(
                                  text: '"$_quote"',
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    color: context.textTertiary,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                                TextSpan(
                                  text: ' \u2014 $_quoteAuthor',
                                  style: GoogleFonts.inter(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: context.textTertiary,
                                  ),
                                ),
                              ]),
                            ),
                          ),
                        ],
                      ),
                    ],
                    const SizedBox(height: 12),
                    // Stats
                    Row(
                      children: [
                        _StatChip(
                          label: 'Tareas',
                          value: '$completedCount/$totalTasks',
                          color: AppTheme.colorPrimary,
                        ),
                        const SizedBox(width: 8),
                        _StatChip(
                          label: 'Primordiales',
                          value: '$primordialDone/$primordialTotal',
                          color: AppTheme.colorDanger,
                        ),
                        if (streakAsync.valueOrNull != null && streakAsync.valueOrNull! > 0) ...[
                          const SizedBox(width: 8),
                          _StatChip(
                            label: '\u{1F525} ${streakAsync.valueOrNull} d\u{00ED}as',
                            value: 'racha',
                            color: AppTheme.colorWarning,
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ── Area tabs (Excel/Windows style) ─────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    _AreaTab(
                      label: 'Todo',
                      emoji: '\u{1F4CB}',
                      selected: _selectedArea == null,
                      onTap: () {
                        setState(() => _selectedArea = null);
                        ref.read(selectedAreaProvider.notifier).state = null;
                      },
                    ),
                    ...areas.map((area) => _AreaTab(
                          label: area.label,
                          emoji: area.emoji,
                          color: area.color,
                          selected: _selectedArea == area.id,
                          onTap: () {
                            setState(() => _selectedArea = area.id);
                            ref.read(selectedAreaProvider.notifier).state = area.id;
                          },
                          onLongPress: () {
                            HapticFeedback.mediumImpact();
                            context.push('/manage-areas');
                          },
                        )),
                    // "+" → abrir ManageAreasPage para agregar/editar/reordenar.
                    _AddAreaTab(
                      onTap: () => context.push('/manage-areas'),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ── Sticky linear progress bar ────────────────────────────────
          SliverPersistentHeader(
            pinned: true,
            delegate: _StickyProgressDelegate(
              progress: progress,
              completed: completedCount,
              total: totalTasks,
              brightness: Theme.of(context).brightness,
              areaColor: areaColor,
              bgColor: tintedBg,
            ),
          ),

          // ── Skeleton en la primera carga ────────────────────────────────
          // Cada rama usa un if independiente (evita las colisiones del
          // `if-else if-else` con spread collection que antes hacía que
          // _TreeByAreaView no se renderizara en "Todo").
          if (todayTasksAsync.valueOrNull == null && todayTasksAsync.isLoading)
            const SliverToBoxAdapter(child: TaskSkeletonList(count: 5)),

          // ── Priority sections ─────────────────────────────────────────
          // Simplificación: en Todo y en cualquier filtro usamos la misma
          // vista de tres secciones (Primordial / Importante / Puede
          // esperar) ya filtradas por área. El tree-by-area queda
          // disponible como widget pero fuera del flujo principal porque
          // era frágil con IDs no-matcheantes y tareas huérfanas.
          if (todayTasksAsync.valueOrNull != null ||
              !todayTasksAsync.isLoading) ...[
            SliverToBoxAdapter(
              child: PrioritySection(
                priority: TaskPriority.primordial,
                tasks: filteredPrimordial,
                currentFilterAreaId: _selectedArea,
                onComplete: taskService.completeTask,
                onUncomplete: taskService.uncompleteTask,
                onDefer: (id) => _onDeferTask(taskService, id),
                onDelete: taskService.deleteTask,
              ),
            ),
            SliverToBoxAdapter(
              child: PrioritySection(
                priority: TaskPriority.importante,
                tasks: filteredImportante,
                currentFilterAreaId: _selectedArea,
                onComplete: taskService.completeTask,
                onUncomplete: taskService.uncompleteTask,
                onDefer: (id) => _onDeferTask(taskService, id),
                onDelete: taskService.deleteTask,
              ),
            ),
            SliverToBoxAdapter(
              child: PrioritySection(
                priority: TaskPriority.puedeEsperar,
                tasks: filteredPuedeEsperar,
                currentFilterAreaId: _selectedArea,
                onComplete: taskService.completeTask,
                onUncomplete: taskService.uncompleteTask,
                onDefer: (id) => _onDeferTask(taskService, id),
                onDelete: taskService.deleteTask,
              ),
            ),

          ],

          // ── Hábitos ────────────────────────────────────────────────────
          if (!userPrefs.showHabitsInHoy)
            const SliverToBoxAdapter(child: SizedBox.shrink())
          else
          habitsAsync.when(
            data: (habits) {
              if (habits.isEmpty) {
                return const SliverToBoxAdapter(child: SizedBox.shrink());
              }
              final completionIds = completionsAsync.valueOrNull
                      ?.map((c) => c.habitId)
                      .toSet() ??
                  {};
              final weekCount =
                  ref.watch(thisWeekCompletionCountProvider);

              // Un hábito está "cerrado" hoy si:
              //   daily  → ya se marcó hoy
              //   weekly → ya se cumplió el target de la semana
              bool isClosed(Habit h) {
                if (h.frequency == HabitFrequency.daily) {
                  return completionIds.contains(h.id);
                }
                final c = weekCount[h.id] ?? 0;
                return c >= h.targetPerWeek;
              }

              final doneCount = habits.where(isClosed).length;
              return SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'HÁBITOS',
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.colorAccent,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '$doneCount/${habits.length}',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: context.textTertiary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: habits.map((h) => _HabitPill(
                          habit: h,
                          isCompleted: isClosed(h),
                          weeklyDone: weekCount[h.id] ?? 0,
                          onToggle: () {
                            HapticFeedback.lightImpact();
                            ref
                                .read(habitServiceProvider)
                                .toggleCompletion(h.id, todayId());
                          },
                        )).toList(),
                      ),
                    ],
                  ),
                ),
              );
            },
            loading: () => const SliverToBoxAdapter(child: SizedBox.shrink()),
            error: (_, __) => const SliverToBoxAdapter(child: SizedBox.shrink()),
          ),

          // ── Proyectos activos (resumen) ───────────────────────────────
          // Las tareas-de-proyecto ya aparecen arriba en las priority
          // sections junto con las sueltas (no se duplican). Esta
          // sección queda como resumen visual con el progreso del
          // proyecto y un tap → abre el detalle.
          const SliverToBoxAdapter(child: ActiveProjectsSection()),

          // ── Otras tareas (colapsable) ──────────────────────────────────
          // Solo mostramos esta sección cuando hay un área filtrada; en
          // modo "Todo" ya aparece dentro del árbol.
          if (_selectedArea != null && filteredPuedeEsperar.isNotEmpty)
            SliverToBoxAdapter(
              child: _OtrasSection(
                tasks: filteredPuedeEsperar,
                expanded: _showOtras,
                onToggle: () => setState(() => _showOtras = !_showOtras),
                onComplete: taskService.completeTask,
                onDefer: (id) => _onDeferTask(taskService, id),
                onDelete: taskService.deleteTask,
              ),
            ),

          // ── Completadas (colapsable) ────────────────────────────────────
          if (filteredCompleted.isNotEmpty) ...[
            SliverToBoxAdapter(
              child: GestureDetector(
                onTap: () => setState(() => _showCompleted = !_showCompleted),
                behavior: HitTestBehavior.opaque,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
                  child: Row(
                    children: [
                      Text(
                        'COMPLETADAS (${filteredCompleted.length})',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: context.textTertiary,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(width: 6),
                      AnimatedRotation(
                        turns: _showCompleted ? 0.25 : 0,
                        duration: const Duration(milliseconds: 200),
                        child: Icon(
                          Icons.chevron_right_rounded,
                          size: 16,
                          color: context.textTertiary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (_showCompleted)
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final task = filteredCompleted[index];
                    return TaskCard(
                      task: task,
                      onComplete: () => taskService.completeTask(task.id),
                      onUncomplete: () => taskService.uncompleteTask(task.id),
                      onDefer: () => _onDeferTask(taskService, task.id),
                      onDelete: () => taskService.deleteTask(task.id),
                    );
                  },
                  childCount: filteredCompleted.length,
                ),
              ),
          ],

          const SliverToBoxAdapter(child: SizedBox(height: 140)),
        ],
      ),
    ), // Scaffold
    ); // AnimatedContainer
  }

  Future<void> _onDeferTask(dynamic taskService, String taskId) async {
    final newDay = await showDeferPicker(context);
    if (newDay != null) {
      await taskService.deferTask(taskId, newDay);
    }
  }
}

// ── Stat chip ──────────────────────────────────────────────────────────────
class _StatChip extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatChip({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withAlpha(20),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withAlpha(60)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: GoogleFonts.inter(fontSize: 12, color: context.textSecondary),
          ),
          const SizedBox(width: 4),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Add task bottom sheet ──────────────────────────────────────────────────
class _AddTaskSheet extends StatefulWidget {
  final Future<void> Function(String title, TaskPriority priority, String? area, String? reminder) onAdd;

  const _AddTaskSheet({required this.onAdd});

  @override
  State<_AddTaskSheet> createState() => _AddTaskSheetState();
}

class _AddTaskSheetState extends State<_AddTaskSheet> {
  final _controller = TextEditingController();
  TaskPriority _priority = TaskPriority.primordial;
  String? _area;
  TimeOfDay? _reminderTime;
  ParsedTask? _parsed;

  void _updateParsedFromText(String text) {
    if (text.trim().isEmpty) {
      if (_parsed != null) setState(() => _parsed = null);
      return;
    }
    final parsed = TaskParser.parse(text);
    setState(() => _parsed = parsed);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final raw = _controller.text.trim();
    if (raw.isEmpty) return;
    final parsed = _parsed ?? TaskParser.parse(raw);
    final title = parsed.cleanTitle.isNotEmpty ? parsed.cleanTitle : raw;
    final priority = parsed.priority ?? _priority;
    final area = parsed.areaId ?? _area;
    String? reminderStr;
    if (parsed.scheduledTime != null) {
      reminderStr = parsed.scheduledTime;
    } else if (_reminderTime != null) {
      reminderStr = '${_reminderTime!.hour.toString().padLeft(2, '0')}:${_reminderTime!.minute.toString().padLeft(2, '0')}';
    }
    await widget.onAdd(title, priority, area, reminderStr);
    if (mounted) Navigator.of(context).pop();
  }

  Future<void> _pickReminderTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _reminderTime ?? TimeOfDay.now(),
    );
    if (picked != null) setState(() => _reminderTime = picked);
  }

  String _parseVoiceInput(String text) {
    final parsed = TaskParser.parse(text);
    setState(() {
      _parsed = parsed;
      if (parsed.priority != null) _priority = parsed.priority!;
      if (parsed.areaId != null) _area = parsed.areaId;
      if (parsed.scheduledTime != null) {
        final parts = parsed.scheduledTime!.split(':');
        if (parts.length == 2) {
          final h = int.tryParse(parts[0]);
          final m = int.tryParse(parts[1]);
          if (h != null && m != null) {
            _reminderTime = TimeOfDay(hour: h, minute: m);
          }
        }
      }
    });
    return parsed.cleanTitle;
  }

  Color _priorityColor(TaskPriority p) => switch (p) {
    TaskPriority.primordial   => AppTheme.colorDanger,
    TaskPriority.importante   => AppTheme.colorWarning,
    TaskPriority.puedeEsperar => AppTheme.colorPrimary,
    TaskPriority.secundaria   => AppTheme.neutral400,
  };

  String _priorityLabel(TaskPriority p) => switch (p) {
    TaskPriority.primordial   => 'Primordial',
    TaskPriority.importante   => 'Importante',
    TaskPriority.puedeEsperar => 'Puede esperar',
    TaskPriority.secundaria   => 'Side quest',
  };

  Widget _buildAreaPill(String? areaId, String label, String emoji) {
    final selected = _area == areaId;
    final color = areaId != null
        ? getTaskArea(areaId)?.color ?? context.textSecondary
        : context.textSecondary;
    return GestureDetector(
      onTap: () => setState(() => _area = areaId),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        margin: const EdgeInsets.only(right: 6),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? color.withAlpha(30) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: selected ? color : context.dividerColor),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 12)),
            const SizedBox(width: 4),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                color: selected ? color : context.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    return Container(
      padding: EdgeInsets.fromLTRB(20, 16, 20, 16 + bottom),
      decoration: BoxDecoration(
        color: context.surfaceSheet,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle bar
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: context.neutral300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Nueva tarea',
            style: GoogleFonts.fraunces(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: context.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          // Text field + mic
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  autofocus: true,
                  style: GoogleFonts.inter(fontSize: 15, color: context.textPrimary),
                  decoration: InputDecoration(
                    hintText: '\u{00BF}Qu\u{00E9} ten\u{00E9}s que hacer?',
                    hintStyle: GoogleFonts.inter(color: context.textTertiary),
                    filled: true,
                    fillColor: context.surfaceInput,
                    border: OutlineInputBorder(
                      borderRadius: AppTheme.r12,
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onChanged: _updateParsedFromText,
                  onSubmitted: (_) => _submit(),
                ),
              ),
              const SizedBox(width: 8),
              VoiceInputButton(
                onResult: (text) {
                  _controller.text = _parseVoiceInput(text);
                },
                onPartialResult: (text) {
                  _controller.value = TextEditingValue(
                    text: text,
                    selection: TextSelection.collapsed(offset: text.length),
                  );
                  _updateParsedFromText(text);
                },
                size: 44,
              ),
            ],
          ),
          // Parser detection chips
          if (_parsed?.hasDetections == true) ...[
            const SizedBox(height: 10),
            _HoyDetectionChips(parsed: _parsed!),
          ],
          const SizedBox(height: 16),
          // Priority
          Text(
            'Prioridad',
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: context.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: TaskPriority.values.map((p) {
                final selected = _priority == p;
                return GestureDetector(
                  onTap: () => setState(() => _priority = p),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    margin: const EdgeInsets.only(right: 6),
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: selected ? _priorityColor(p).withAlpha(30) : Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: selected ? _priorityColor(p) : context.dividerColor,
                      ),
                    ),
                    child: Text(
                      _priorityLabel(p),
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                        color: selected ? _priorityColor(p) : context.textSecondary,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 16),
          // Area
          Text(
            '\u{00C1}rea',
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: context.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildAreaPill(null, 'Sin \u{00E1}rea', '\u{1F4CB}'),
              ...kTaskAreas.map((a) => _buildAreaPill(a.id, a.label, a.emoji)),
            ],
          ),
          const SizedBox(height: 16),
          // Reminder
          Text(
            'Recordatorio',
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: context.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: _pickReminderTime,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: _reminderTime != null
                    ? AppTheme.colorPrimary.withAlpha(20)
                    : context.surfaceInput,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: _reminderTime != null
                      ? AppTheme.colorPrimary
                      : context.dividerColor,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.alarm_rounded,
                    size: 18,
                    color: _reminderTime != null
                        ? AppTheme.colorPrimary
                        : context.textTertiary,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _reminderTime != null
                          ? _reminderTime!.format(context)
                          : 'Sin recordatorio',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: _reminderTime != null
                            ? AppTheme.colorPrimary
                            : context.textTertiary,
                        fontWeight: _reminderTime != null
                            ? FontWeight.w600
                            : FontWeight.w400,
                      ),
                    ),
                  ),
                  if (_reminderTime != null)
                    GestureDetector(
                      onTap: () => setState(() => _reminderTime = null),
                      child: Icon(
                        Icons.close_rounded,
                        size: 16,
                        color: context.textTertiary,
                      ),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          // Submit button
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: _submit,
              style: FilledButton.styleFrom(
                backgroundColor: AppTheme.colorPrimary,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                'Agregar tarea',
                style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Area tab (Excel/Windows style) ────────────────────────────────────────
class _AreaTab extends StatelessWidget {
  final String label;
  final String emoji;
  final Color? color;
  final bool selected;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;

  const _AreaTab({
    required this.label,
    required this.emoji,
    this.color,
    required this.selected,
    required this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final pillColor = color ?? AppTheme.colorPrimary;
    // EVERY tab is always visible as a colored pill. The selected one is
    // bolder, brighter, slightly bigger and lifts forward with a shadow.
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        margin: EdgeInsets.only(
          right: 6,
          top: selected ? 0 : 4,
          bottom: selected ? 0 : 2,
        ),
        padding: EdgeInsets.symmetric(
          horizontal: selected ? 16 : 12,
          vertical: selected ? 10 : 8,
        ),
        decoration: BoxDecoration(
          // Selected: brighter fill, unselected: faint tint of its own color.
          color: selected
              ? Color.lerp(context.surfaceCard, pillColor, 0.22)
              : pillColor.withAlpha(18),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? pillColor : pillColor.withAlpha(70),
            width: selected ? 2 : 1,
          ),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: pillColor.withAlpha(55),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(emoji, style: TextStyle(fontSize: selected ? 16 : 14)),
            const SizedBox(width: 6),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 220),
              style: GoogleFonts.inter(
                fontSize: selected ? 13.5 : 12.5,
                // Bold when selected, medium weight when not — text always
                // stays fully legible thanks to the colored pill background.
                fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
                color: selected
                    ? context.textPrimary
                    : pillColor,
                letterSpacing: selected ? 0.2 : 0,
              ),
              child: Text(label),
            ),
          ],
        ),
      ),
    );
  }
}


// ── Habit pill ─────────────────────────────────────────────────────────────
class _HabitPill extends ConsumerWidget {
  final Habit habit;
  /// True si el hábito está "cerrado" para hoy/esta semana (daily ya
  /// marcado o weekly al target).
  final bool isCompleted;
  /// Cuántas veces se completó esta semana — sólo se muestra para
  /// hábitos `weekly` con `targetPerWeek > 1`.
  final int weeklyDone;
  final VoidCallback onToggle;

  const _HabitPill({
    required this.habit,
    required this.isCompleted,
    required this.onToggle,
    this.weeklyDone = 0,
  });

  Color _parseHabitColor(Color fallback) {
    if (habit.color == null || habit.color!.isEmpty) return fallback;
    try {
      return Color(int.parse(habit.color!.replaceFirst('#', '0xFF')));
    } catch (_) {
      return fallback;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final streak = ref.watch(habitStreakProvider(habit.id)).valueOrNull ?? 0;
    final habitColor = _parseHabitColor(AppTheme.colorAccent);

    return GestureDetector(
      onTap: onToggle,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isCompleted ? habitColor.withAlpha(22) : context.surfaceCard,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isCompleted ? habitColor.withAlpha(100) : context.dividerColor,
            width: isCompleted ? 1.5 : 1,
          ),
          boxShadow: isCompleted ? null : AppTheme.shadowSm,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (habit.icon != null && habit.icon!.isNotEmpty)
              Text(habit.icon!, style: const TextStyle(fontSize: 18)),
            if (habit.icon != null && habit.icon!.isNotEmpty)
              const SizedBox(width: 6),
            Text(
              habit.title,
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: isCompleted ? habitColor : context.textPrimary,
                decoration: isCompleted ? TextDecoration.lineThrough : null,
              ),
            ),
            if (isCompleted) ...[
              const SizedBox(width: 5),
              Icon(Icons.check_circle_rounded, size: 14, color: habitColor),
            ] else if (habit.frequency == HabitFrequency.weekly) ...[
              // Hábito weekly aún no cumplido: mostrar progreso "X/N".
              const SizedBox(width: 5),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                decoration: BoxDecoration(
                  color: habitColor.withAlpha(20),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '$weeklyDone/${habit.targetPerWeek}',
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: habitColor,
                  ),
                ),
              ),
            ] else if (streak > 1) ...[
              const SizedBox(width: 5),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                decoration: BoxDecoration(
                  color: habitColor.withAlpha(20),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '🔥$streak',
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: habitColor,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ── Otras tareas colapsable ────────────────────────────────────────────────
class _OtrasSection extends StatelessWidget {
  final List<Task> tasks;
  final bool expanded;
  final VoidCallback onToggle;
  final Function(String) onComplete;
  final Function(String) onDefer;
  final Function(String) onDelete;

  const _OtrasSection({
    required this.tasks,
    required this.expanded,
    required this.onToggle,
    required this.onComplete,
    required this.onDefer,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: onToggle,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
            child: Row(
              children: [
                Container(
                  width: 8, height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: context.neutral400,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'OTRAS TAREAS',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: context.neutral400,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  '${tasks.length}',
                  style: GoogleFonts.inter(fontSize: 12, color: context.textTertiary),
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
          ...tasks.map((task) {
            final color = task.priority == TaskPriority.importante
                ? AppTheme.colorWarning
                : context.neutral400;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 3),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: context.surfaceCard,
                  borderRadius: AppTheme.r12,
                  border: Border.all(color: context.dividerColor),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 8, height: 8,
                      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        task.title,
                        style: GoogleFonts.inter(fontSize: 14, color: context.textPrimary),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.check_rounded, size: 16),
                      color: AppTheme.colorSuccess,
                      onPressed: () => onComplete(task.id),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.close_rounded, size: 16),
                      color: context.textTertiary,
                      onPressed: () => onDelete(task.id),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              ),
            );
          }),
      ],
    );
  }
}

// ── Sticky progress delegate ──────────────────────────────────────────────
class _StickyProgressDelegate extends SliverPersistentHeaderDelegate {
  final double progress;
  final int completed;
  final int total;
  final Brightness brightness;
  final Color? areaColor;
  final Color bgColor;

  _StickyProgressDelegate({
    required this.progress,
    required this.completed,
    required this.total,
    required this.brightness,
    required this.bgColor,
    this.areaColor,
  });

  @override
  double get minExtent => 56;
  @override
  double get maxExtent => 56;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    final percent = (progress * 100).round();
    final isPinned = shrinkOffset > 0 || overlapsContent;
    final barColor = areaColor ?? AppTheme.colorPrimary;
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: bgColor,
        boxShadow: isPinned
            ? [BoxShadow(color: Colors.black.withAlpha(15), blurRadius: 6, offset: const Offset(0, 2))]
            : null,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: [
          Text(
            '$percent%',
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: barColor,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 8,
                backgroundColor: context.dividerColor,
                valueColor: AlwaysStoppedAnimation<Color>(barColor),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            '$completed/$total',
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: context.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  @override
  bool shouldRebuild(covariant _StickyProgressDelegate oldDelegate) =>
      oldDelegate.progress != progress ||
      oldDelegate.completed != completed ||
      oldDelegate.total != total ||
      oldDelegate.brightness != brightness ||
      oldDelegate.areaColor != areaColor ||
      oldDelegate.bgColor != bgColor;
}

// ── Detection chips for Hoy add-task sheet ──────────────────────────────────

class _HoyDetectionChips extends StatelessWidget {
  final ParsedTask parsed;
  const _HoyDetectionChips({required this.parsed});

  String _dayLabel(String dayId) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final parts = dayId.split('-');
    if (parts.length != 3) return dayId;
    final d = DateTime(int.parse(parts[0]), int.parse(parts[1]), int.parse(parts[2]));
    final diff = d.difference(today).inDays;
    if (diff == 0) return 'Hoy';
    if (diff == 1) return 'Ma\u{00F1}ana';
    if (diff == -1) return 'Ayer';
    if (diff == 2) return 'Pasado ma\u{00F1}ana';
    if (diff > 0 && diff < 7) return DateFormat('EEEE', 'es').format(d);
    return DateFormat('d MMM', 'es').format(d);
  }

  String _priorityLabel(TaskPriority p) => switch (p) {
    TaskPriority.primordial   => 'Primordial',
    TaskPriority.importante   => 'Importante',
    TaskPriority.puedeEsperar => 'Puede esperar',
    TaskPriority.secundaria   => 'Side quest',
  };

  Color _priorityColor(TaskPriority p) => switch (p) {
    TaskPriority.primordial   => AppTheme.colorDanger,
    TaskPriority.importante   => AppTheme.colorWarning,
    TaskPriority.puedeEsperar => AppTheme.colorPrimary,
    TaskPriority.secundaria   => AppTheme.neutral400,
  };

  @override
  Widget build(BuildContext context) {
    final chips = <Widget>[];
    if (parsed.dayId != null) {
      chips.add(_chip(icon: Icons.event_rounded, label: _dayLabel(parsed.dayId!), color: AppTheme.colorPrimary));
    }
    if (parsed.scheduledTime != null) {
      chips.add(_chip(icon: Icons.schedule_rounded, label: parsed.scheduledTime!, color: AppTheme.colorAccent));
    }
    if (parsed.priority != null) {
      chips.add(_chip(icon: Icons.flag_rounded, label: _priorityLabel(parsed.priority!), color: _priorityColor(parsed.priority!)));
    }
    if (parsed.areaId != null) {
      final area = getTaskArea(parsed.areaId);
      if (area != null) {
        chips.add(_chip(emoji: area.emoji, label: area.label, color: area.color));
      }
    }
    return SizedBox(
      height: 26,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: chips,
      ),
    );
  }

  Widget _chip({IconData? icon, String? emoji, required String label, required Color color}) {
    return Container(
      margin: const EdgeInsets.only(right: 6),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withAlpha(22),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withAlpha(80)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (emoji != null)
            Text(emoji, style: const TextStyle(fontSize: 11))
          else if (icon != null)
            Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Compact header icon ───────────────────────────────────────────────────
class _HeaderIcon extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _HeaderIcon({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        child: Icon(icon, size: 20, color: context.textSecondary),
      ),
    );
  }
}

// ── "+" tab ────────────────────────────────────────────────────────────────
// Minimal pill at the end of the area tab row. Taps go to the ManageAreas
// page where the user can create / edit / reorder / delete areas.
class _AddAreaTab extends StatelessWidget {
  final VoidCallback onTap;
  const _AddAreaTab({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        margin: const EdgeInsets.only(right: 6, top: 4, bottom: 2),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: context.surfaceCard,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: context.dividerColor,
            style: BorderStyle.solid,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.add_rounded, size: 16, color: context.textSecondary),
            const SizedBox(width: 4),
            Text(
              'Nueva',
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: context.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Tree view for "Todo" tab ───────────────────────────────────────────────
// Lays out today's tasks as a side tree:
//   └─ Sin área (tasks without an area)
//       ├─ PRIMORDIAL
//       ├─ IMPORTANTE
//       └─ OTRAS
//   └─ Trabajo
//       ├─ PRIMORDIAL
//       └─ …
//   └─ Facultad
//       └─ …
// Each area section is collapsible and colored with its own color so the
// visual grouping matches the area tabs above.
class _TreeByAreaView extends StatefulWidget {
  final List<TaskArea> areas;
  final List<Task> primordial;
  final List<Task> importante;
  final List<Task> puedeEsperar;
  final Function(String) onComplete;
  final Function(String) onUncomplete;
  final Function(String) onDefer;
  final Function(String) onDelete;

  const _TreeByAreaView({
    required this.areas,
    required this.primordial,
    required this.importante,
    required this.puedeEsperar,
    required this.onComplete,
    required this.onUncomplete,
    required this.onDefer,
    required this.onDelete,
  });

  @override
  State<_TreeByAreaView> createState() => _TreeByAreaViewState();
}

class _TreeByAreaViewState extends State<_TreeByAreaView> {
  // Collapsed-state keyed by area id; `null` key = "Sin área" branch.
  // Empieza vacío = todas expandidas por default.
  final Set<String?> _collapsed = <String?>{};

  bool _isCollapsed(String? areaId) => _collapsed.contains(areaId);
  void _toggle(String? areaId) {
    setState(() {
      if (_collapsed.contains(areaId)) {
        _collapsed.remove(areaId);
      } else {
        _collapsed.add(areaId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Agrupamos las tareas por `task.area` directamente. Antes iterábamos
    // `widget.areas` y filtrábamos por `area.id`, pero si una tarea tenía
    // `area` apuntando a un id que ya no existe en el DB (área borrada o
    // cambio de IDs), quedaba invisible. Con groupBy garantizamos que
    // suma(visibles) == suma(pasadas).

    final allTasks = [
      ...widget.primordial,
      ...widget.importante,
      ...widget.puedeEsperar,
    ];
    // Map<areaId?, [primordial, importante, puedeEsperar]>
    final Map<String?, List<List<Task>>> grouped = {};
    void put(Task t, int bucket) {
      final key = (t.area == null || t.area!.isEmpty) ? null : t.area;
      final row = grouped.putIfAbsent(key, () => [[], [], []]);
      row[bucket].add(t);
    }
    for (final t in widget.primordial) {
      put(t, 0);
    }
    for (final t in widget.importante) {
      put(t, 1);
    }
    for (final t in widget.puedeEsperar) {
      put(t, 2);
    }

    // Resolvemos el look-up de metadata (label/emoji/color) a partir de
    // widget.areas primero; si el area id es orfan, caemos a los
    // built-ins; y si tampoco está ahí, usamos placeholder genérico.
    TaskArea? resolveArea(String areaId) =>
        getTaskAreaFrom(widget.areas, areaId) ?? getTaskArea(areaId);

    // Orden: primero las áreas conocidas en el orden de widget.areas,
    // después "Sin área", después cualquier área huérfana.
    final orderedKeys = <String?>[];
    for (final a in widget.areas) {
      if (grouped.containsKey(a.id)) orderedKeys.add(a.id);
    }
    if (grouped.containsKey(null)) orderedKeys.add(null);
    for (final key in grouped.keys) {
      if (key == null) continue;
      if (orderedKeys.contains(key)) continue;
      orderedKeys.add(key);
    }

    final branches = <Widget>[];
    for (final key in orderedKeys) {
      final buckets = grouped[key]!;
      if (buckets[0].isEmpty && buckets[1].isEmpty && buckets[2].isEmpty) {
        continue;
      }
      final TaskArea? area = key == null ? null : resolveArea(key);
      final label = area?.label ?? (key ?? 'Sin área');
      final emoji = area?.emoji ?? (key == null ? '\u{1F4CC}' : '\u{1F4C2}');
      final color = area?.color ?? context.textSecondary;
      branches.add(_AreaBranch(
        areaId: key,
        label: label,
        emoji: emoji,
        color: color,
        primordial: buckets[0],
        importante: buckets[1],
        puedeEsperar: buckets[2],
        collapsed: _isCollapsed(key),
        onToggle: () => _toggle(key),
        onComplete: widget.onComplete,
        onUncomplete: widget.onUncomplete,
        onDefer: widget.onDefer,
        onDelete: widget.onDelete,
      ));
    }

    // Sanity-check para desarrollo: si el total pasado no matchea el total
    // renderizado, loggeamos. En producción, la lista sigue funcionando.
    assert(() {
      final passed = allTasks.length;
      var rendered = 0;
      for (final buckets in grouped.values) {
        rendered += buckets[0].length + buckets[1].length + buckets[2].length;
      }
      if (passed != rendered) {
        debugPrint('[_TreeByAreaView] task count mismatch: '
            'passed=$passed, rendered=$rendered');
      }
      return true;
    }());

    if (branches.isEmpty) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(20, 40, 20, 40),
        child: Center(
          child: Column(
            children: [
              Icon(Icons.spa_rounded, size: 40, color: context.textTertiary),
              const SizedBox(height: 10),
              Text(
                'Ninguna tarea pendiente para hoy',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: context.textTertiary,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: branches,
    );
  }
}

// ── One area branch ────────────────────────────────────────────────────────
class _AreaBranch extends StatelessWidget {
  final String? areaId;
  final String label;
  final String emoji;
  final Color color;
  final List<Task> primordial;
  final List<Task> importante;
  final List<Task> puedeEsperar;
  final bool collapsed;
  final VoidCallback onToggle;
  final Function(String) onComplete;
  final Function(String) onUncomplete;
  final Function(String) onDefer;
  final Function(String) onDelete;

  const _AreaBranch({
    required this.areaId,
    required this.label,
    required this.emoji,
    required this.color,
    required this.primordial,
    required this.importante,
    required this.puedeEsperar,
    required this.collapsed,
    required this.onToggle,
    required this.onComplete,
    required this.onUncomplete,
    required this.onDefer,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final total = primordial.length + importante.length + puedeEsperar.length;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Area header — tap anywhere to collapse/expand.
          GestureDetector(
            onTap: onToggle,
            behavior: HitTestBehavior.opaque,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: color.withAlpha(18),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: color.withAlpha(60)),
              ),
              child: Row(
                children: [
                  Text(emoji, style: const TextStyle(fontSize: 18)),
                  const SizedBox(width: 8),
                  Text(
                    label,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: color,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 1),
                    decoration: BoxDecoration(
                      color: color.withAlpha(40),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '$total',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: color,
                      ),
                    ),
                  ),
                  const Spacer(),
                  AnimatedRotation(
                    turns: collapsed ? -0.25 : 0,
                    duration: const Duration(milliseconds: 180),
                    child: Icon(Icons.expand_more_rounded, color: color),
                  ),
                ],
              ),
            ),
          ),
          // Tree contents — indented with a left color rail.
          if (!collapsed)
            Padding(
              padding: const EdgeInsets.only(top: 6, left: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Vertical "branch" rail.
                  Container(
                    width: 2,
                    margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    color: color.withAlpha(60),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (primordial.isNotEmpty)
                          _PrioritySubSection(
                            priority: TaskPriority.primordial,
                            tasks: primordial,
                            onComplete: onComplete,
                            onUncomplete: onUncomplete,
                            onDefer: onDefer,
                            onDelete: onDelete,
                          ),
                        if (importante.isNotEmpty)
                          _PrioritySubSection(
                            priority: TaskPriority.importante,
                            tasks: importante,
                            onComplete: onComplete,
                            onUncomplete: onUncomplete,
                            onDefer: onDefer,
                            onDelete: onDelete,
                          ),
                        if (puedeEsperar.isNotEmpty)
                          _PrioritySubSection(
                            priority: TaskPriority.puedeEsperar,
                            tasks: puedeEsperar,
                            onComplete: onComplete,
                            onUncomplete: onUncomplete,
                            onDefer: onDefer,
                            onDelete: onDelete,
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

// ── Priority sub-section inside a branch ──────────────────────────────────
class _PrioritySubSection extends StatelessWidget {
  final TaskPriority priority;
  final List<Task> tasks;
  final Function(String) onComplete;
  final Function(String) onUncomplete;
  final Function(String) onDefer;
  final Function(String) onDelete;

  const _PrioritySubSection({
    required this.priority,
    required this.tasks,
    required this.onComplete,
    required this.onUncomplete,
    required this.onDefer,
    required this.onDelete,
  });

  Color _priorityColor(BuildContext context) => switch (priority) {
    TaskPriority.primordial   => AppTheme.colorDanger,
    TaskPriority.importante   => AppTheme.colorWarning,
    TaskPriority.puedeEsperar => context.neutral400,
    TaskPriority.secundaria   => context.neutral400,
  };

  String _priorityLabel(TaskPriority p) => switch (p) {
    TaskPriority.primordial   => 'PRIMORDIAL',
    TaskPriority.importante   => 'IMPORTANTE',
    TaskPriority.puedeEsperar => 'OTRAS',
    TaskPriority.secundaria   => 'SIDE',
  };

  @override
  Widget build(BuildContext context) {
    final c = _priorityColor(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Sub-priority pill label.
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 4, 0, 6),
            child: Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: c,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  _priorityLabel(priority),
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: c,
                    letterSpacing: 0.6,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  '${tasks.length}',
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    color: context.textTertiary,
                  ),
                ),
              ],
            ),
          ),
          ...tasks.map((t) => TaskCard(
                task: t,
                onComplete: () => onComplete(t.id),
                onUncomplete: () => onUncomplete(t.id),
                onDefer: () => onDefer(t.id),
                onDelete: () => onDelete(t.id),
              )),
        ],
      ),
    );
  }
}
