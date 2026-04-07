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
import '../widgets/priority_section.dart';
import '../widgets/task_card.dart';
import '../../../../core/models/task_area.dart';
import '../../../../core/widgets/voice_input_button.dart';
import 'dart:math' as math;


const _quotes = [
  {'q': 'La vida es lo que pasa mientras haces otros planes.', 'a': 'John Lennon'},
  {'q': 'Soy el amo de mi destino, el capitán de mi alma.', 'a': 'Nelson Mandela'},
  {'q': 'La imaginación es más importante que el conocimiento.', 'a': 'Albert Einstein'},
  {'q': 'Haz o no hagas. No hay intentar.', 'a': 'Yoda'},
  {'q': 'El único modo de hacer un gran trabajo es amar lo que haces.', 'a': 'Steve Jobs'},
  {'q': 'Que la fuerza te acompañe.', 'a': 'Star Wars'},
  {'q': 'Todo lo que puedes imaginar es real.', 'a': 'Pablo Picasso'},
  {'q': 'El futuro pertenece a quienes creen en sus sueños.', 'a': 'Eleanor Roosevelt'},
  {'q': 'Cada día es una nueva oportunidad para cambiar tu vida.', 'a': 'Paulo Coelho'},
  {'q': 'Lo esencial es invisible a los ojos.', 'a': 'El Principito'},
  {'q': 'A veces ganar es simplemente no rendirse.', 'a': 'Rocky Balboa'},
  {'q': 'No cuentes los días. Haz que los días cuenten.', 'a': 'Muhammad Ali'},
  {'q': 'La creatividad es contagiosa. Pásala.', 'a': 'Albert Einstein'},
  {'q': 'El éxito no es definitivo, el fracaso no es fatal.', 'a': 'Winston Churchill'},
  {'q': 'Sé el cambio que quieres ver en el mundo.', 'a': 'Gandhi'},
  {'q': 'Después de todo, mañana será otro día.', 'a': 'Lo que el viento se llevó'},
  {'q': 'No hay caminos para la paz; la paz es el camino.', 'a': 'Gandhi'},
  {'q': 'Nunca es tarde para ser lo que podrías haber sido.', 'a': 'George Eliot'},
  {'q': 'El secreto de salir adelante es empezar.', 'a': 'Mark Twain'},
  {'q': 'La vida es muy simple, pero insistimos en hacerla complicada.', 'a': 'Confucio'},
  {'q': 'Yo soy inevitable.', 'a': 'Thanos'},
  {'q': 'Vive como si fueras a morir mañana. Aprende como si fueras a vivir siempre.', 'a': 'Gandhi'},
  {'q': 'Houston, tenemos un problema.', 'a': 'Apollo 13'},
  {'q': 'La mejor forma de predecir el futuro es crearlo.', 'a': 'Peter Drucker'},
  {'q': 'Locura es hacer lo mismo y esperar resultados diferentes.', 'a': 'Albert Einstein'},
  {'q': 'El coraje no es la ausencia de miedo, sino el triunfo sobre él.', 'a': 'Nelson Mandela'},
  {'q': 'Hoy no, viejo amigo. Hoy no.', 'a': 'Gladiator'},
  {'q': 'Primero lo primordial. Todo lo demás puede esperar.', 'a': 'Stephen Covey'},
  {'q': 'Solo sé que no sé nada.', 'a': 'Sócrates'},
  {'q': 'La disciplina es el puente entre metas y logros.', 'a': 'Jim Rohn'},
];

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

  @override
  void initState() {
    super.initState();
    final idx = math.Random().nextInt(_quotes.length);
    _quote = _quotes[idx]['q']!;
    _quoteAuthor = _quotes[idx]['a']!;
  }

  @override
  Widget build(BuildContext context) {
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

    return Scaffold(
      backgroundColor: context.surfaceBase,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // ── Header ──────────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '¿Qué vas a lograr hoy?',
                          style: GoogleFonts.lora(
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                            color: context.textPrimary,
                            letterSpacing: -0.3,
                          ),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.settings_rounded, color: context.textSecondary),
                              onPressed: () => context.push('/settings'),
                            ),
                            IconButton(
                              icon: Icon(Icons.inbox_rounded, color: context.textSecondary),
                              onPressed: () => context.go('/inbox'),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Text(
                      dateStr,
                      style: GoogleFonts.inter(fontSize: 13, color: context.textSecondary),
                    ),
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
              child: Container(
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: context.dividerColor, width: 1)),
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      _AreaTab(
                        label: 'Todo',
                        emoji: '\u{1F4CB}',
                        selected: _selectedArea == null,
                        onTap: () => setState(() => _selectedArea = null),
                      ),
                      ...kTaskAreas.map((area) => _AreaTab(
                        label: area.label,
                        emoji: area.emoji,
                        color: area.color,
                        selected: _selectedArea == area.id,
                        onTap: () => setState(() => _selectedArea = area.id),
                      )),
                    ],
                  ),
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
            ),
          ),

          // ── Priority sections ──────────────────────────────────────────
          SliverToBoxAdapter(
            child: PrioritySection(
              priority: TaskPriority.primordial,
              tasks: filteredPrimordial,
              onComplete: taskService.completeTask,
              onUncomplete: taskService.uncompleteTask,
              onDefer: (id) => taskService.deferTask(id, _tomorrow()),
              onDelete: taskService.deleteTask,
            ),
          ),
          SliverToBoxAdapter(
            child: PrioritySection(
              priority: TaskPriority.importante,
              tasks: filteredImportante,
              onComplete: taskService.completeTask,
              onUncomplete: taskService.uncompleteTask,
              onDefer: (id) => taskService.deferTask(id, _tomorrow()),
              onDelete: taskService.deleteTask,
            ),
          ),

          // ── Hábitos ────────────────────────────────────────────────────
          habitsAsync.when(
            data: (habits) {
              final daily = habits.where((h) => h.frequency == HabitFrequency.daily).toList();
              if (daily.isEmpty) return const SliverToBoxAdapter(child: SizedBox.shrink());
              final completionIds =
                  completionsAsync.valueOrNull?.map((c) => c.habitId).toSet() ?? {};
              final doneCount = daily.where((h) => completionIds.contains(h.id)).length;

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
                            '$doneCount/${daily.length}',
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
                        children: daily.map((h) => _HabitPill(
                          habit: h,
                          isCompleted: completionIds.contains(h.id),
                          onToggle: () {
                            HapticFeedback.lightImpact();
                            ref.read(habitServiceProvider).toggleCompletion(h.id, todayId());
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

          // ── Otras tareas (colapsable) ──────────────────────────────────
          if (filteredPuedeEsperar.isNotEmpty)
            SliverToBoxAdapter(
              child: _OtrasSection(
                tasks: filteredPuedeEsperar,
                expanded: _showOtras,
                onToggle: () => setState(() => _showOtras = !_showOtras),
                onComplete: taskService.completeTask,
                onDefer: (id) => taskService.deferTask(id, _tomorrow()),
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
                      onDefer: () => taskService.deferTask(task.id, _tomorrow()),
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
    );
  }

  String _tomorrow() {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return dateToId(tomorrow);
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

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final title = _controller.text.trim();
    if (title.isEmpty) return;
    String? reminderStr;
    if (_reminderTime != null) {
      reminderStr = '${_reminderTime!.hour.toString().padLeft(2, '0')}:${_reminderTime!.minute.toString().padLeft(2, '0')}';
    }
    await widget.onAdd(title, _priority, _area, reminderStr);
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
    final lower = text.toLowerCase();
    if (lower.contains('para trabajo') || lower.contains('de trabajo') || lower.contains('del trabajo')) {
      setState(() => _area = 'trabajo');
      text = text.replaceAll(RegExp(r'(para|de|del)\s+trabajo', caseSensitive: false), '').trim();
    } else if (lower.contains('para la facu') || lower.contains('de la facu') || lower.contains('facultad')) {
      setState(() => _area = 'estudio');
      text = text.replaceAll(RegExp(r'(para|de)\s+(la\s+)?facu(ltad)?', caseSensitive: false), '').trim();
    } else if (lower.contains('personal') || lower.contains('para m\u{00ED}')) {
      setState(() => _area = 'personal');
      text = text.replaceAll(RegExp(r'personal|para\s+m[ií]', caseSensitive: false), '').trim();
    } else if (lower.contains('para casa') || lower.contains('de casa') || lower.contains('de la casa')) {
      setState(() => _area = 'casa');
      text = text.replaceAll(RegExp(r'(para|de)\s+(la\s+)?casa', caseSensitive: false), '').trim();
    }
    if (lower.contains('urgente') || lower.contains('primordial')) {
      setState(() => _priority = TaskPriority.primordial);
      text = text.replaceAll(RegExp(r'urgente|primordial', caseSensitive: false), '').trim();
    } else if (lower.contains('importante')) {
      setState(() => _priority = TaskPriority.importante);
      text = text.replaceAll(RegExp(r'importante', caseSensitive: false), '').trim();
    }
    return text;
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
            style: GoogleFonts.lora(
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
                  onSubmitted: (_) => _submit(),
                ),
              ),
              const SizedBox(width: 8),
              VoiceInputButton(
                onResult: (text) {
                  _controller.text = _parseVoiceInput(text);
                },
                size: 44,
              ),
            ],
          ),
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

  const _AreaTab({
    required this.label,
    required this.emoji,
    this.color,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final pillColor = color ?? context.textSecondary;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 2),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected
              ? pillColor.withAlpha(25)
              : pillColor.withAlpha(10),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
          border: selected
              ? Border(
                  top: BorderSide(color: pillColor, width: 2.5),
                  left: BorderSide(color: pillColor.withAlpha(60)),
                  right: BorderSide(color: pillColor.withAlpha(60)),
                )
              : Border.all(color: Colors.transparent),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 13)),
            const SizedBox(width: 5),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                color: selected ? pillColor : pillColor.withAlpha(180),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


// ── Habit pill ─────────────────────────────────────────────────────────────
class _HabitPill extends StatelessWidget {
  final Habit habit;
  final bool isCompleted;
  final VoidCallback onToggle;

  const _HabitPill({required this.habit, required this.isCompleted, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onToggle,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isCompleted ? AppTheme.colorSuccessLight : context.surfaceCard,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isCompleted ? AppTheme.colorSuccess.withAlpha(80) : context.dividerColor,
          ),
          boxShadow: isCompleted ? null : AppTheme.shadowSm,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (habit.icon != null && habit.icon!.isNotEmpty)
              Text(habit.icon!, style: const TextStyle(fontSize: 16)),
            if (habit.icon != null && habit.icon!.isNotEmpty)
              const SizedBox(width: 6),
            Text(
              habit.title,
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: isCompleted ? AppTheme.colorSuccess : context.textPrimary,
                decoration: isCompleted ? TextDecoration.lineThrough : null,
              ),
            ),
            if (isCompleted) ...[
              const SizedBox(width: 4),
              const Icon(Icons.check_circle_rounded, size: 14, color: AppTheme.colorSuccess),
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

  _StickyProgressDelegate({
    required this.progress,
    required this.completed,
    required this.total,
    required this.brightness,
  });

  @override
  double get minExtent => 56;
  @override
  double get maxExtent => 56;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    final percent = (progress * 100).round();
    final isPinned = shrinkOffset > 0 || overlapsContent;
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: context.surfaceBase,
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
              color: context.textPrimary,
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
                valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.colorPrimary),
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
      oldDelegate.brightness != brightness;
}

