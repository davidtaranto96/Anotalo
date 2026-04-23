import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/format_utils.dart';
import '../../../hoy/domain/models/task.dart';
import '../../../hoy/presentation/providers/task_provider.dart';
import '../../domain/models/journal_entry.dart';
import '../providers/journal_provider.dart';

class RevisionPage extends ConsumerStatefulWidget {
  const RevisionPage({super.key});

  @override
  ConsumerState<RevisionPage> createState() => _RevisionPageState();
}

class _RevisionPageState extends ConsumerState<RevisionPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabCtrl;

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.surfaceBase,
      body: SafeArea(
        child: Column(
          children: [
            // ── Header ─────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 16, 0),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_rounded, color: AppTheme.textSecondary),
                    onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
                  ),
                  Text(
                    'Revisión',
                    style: GoogleFonts.fraunces(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const Spacer(),
                  // Tab toggle
                  Container(
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceElevated,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: TabBar(
                      controller: _tabCtrl,
                      isScrollable: false,
                      indicator: BoxDecoration(
                        color: AppTheme.colorPrimary,
                        borderRadius: BorderRadius.circular(7),
                      ),
                      indicatorSize: TabBarIndicatorSize.tab,
                      dividerColor: Colors.transparent,
                      tabs: [
                        Tab(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Text(
                              'Hoy',
                              style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                        Tab(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Text(
                              'Historial',
                              style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                      ],
                      labelColor: Colors.white,
                      unselectedLabelColor: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            // ── Content ────────────────────────────────────────────────
            Expanded(
              child: TabBarView(
                controller: _tabCtrl,
                physics: const NeverScrollableScrollPhysics(),
                children: const [
                  _WizardView(),
                  _HistorialView(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// WIZARD VIEW
// ═══════════════════════════════════════════════════════════════════════════
class _WizardView extends ConsumerStatefulWidget {
  const _WizardView();

  @override
  ConsumerState<_WizardView> createState() => _WizardViewState();
}

class _WizardViewState extends ConsumerState<_WizardView> {
  int _step = 0; // 0-3
  final _reflectionCtrl = TextEditingController();
  final _gratitudeCtrl = TextEditingController();
  final _lessonsCtrl = TextEditingController();
  final _tomorrowCtrl = TextEditingController();
  int _mood = 3;
  bool _initialized = false;

  @override
  void dispose() {
    _reflectionCtrl.dispose();
    _gratitudeCtrl.dispose();
    _lessonsCtrl.dispose();
    _tomorrowCtrl.dispose();
    super.dispose();
  }

  void _initFromEntry(JournalEntry? entry) {
    if (_initialized || entry == null) return;
    _initialized = true;
    _reflectionCtrl.text = entry.reflection;
    _gratitudeCtrl.text = entry.gratitude ?? '';
    _lessonsCtrl.text = entry.lessonsLearned ?? '';
    _tomorrowCtrl.text = entry.tomorrowFocus ?? '';
    _mood = entry.mood ?? 3;
  }

  void _next() => setState(() => _step = (_step + 1).clamp(0, 3));
  void _back() => setState(() => _step = (_step - 1).clamp(0, 3));

  void _save() {
    final entry = JournalEntry(
      id: '',
      dayId: todayId(),
      reflection: _reflectionCtrl.text.trim(),
      mood: _mood,
      gratitude: _gratitudeCtrl.text.trim().isEmpty ? null : _gratitudeCtrl.text.trim(),
      lessonsLearned: _lessonsCtrl.text.trim().isEmpty ? null : _lessonsCtrl.text.trim(),
      tomorrowFocus: _tomorrowCtrl.text.trim().isEmpty ? null : _tomorrowCtrl.text.trim(),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    ref.read(journalServiceProvider).saveEntry(entry);
    Navigator.of(context, rootNavigator: true).pop();
  }

  @override
  Widget build(BuildContext context) {
    final entryAsync = ref.watch(todayJournalProvider);
    entryAsync.whenData(_initFromEntry);
    final completedTasks = ref.watch(completedTasksProvider);
    final pendingTasks = [
      ...ref.watch(primordialTasksProvider),
      ...ref.watch(importanteTasksProvider),
      ...ref.watch(puedeEsperarTasksProvider),
    ];
    final taskService = ref.read(taskServiceProvider);

    return Column(
      children: [
        // Progress bar
        const SizedBox(height: 20),
        _StepProgress(current: _step),
        const SizedBox(height: 24),

        // Step content
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            physics: const BouncingScrollPhysics(),
            child: _buildStep(completedTasks, pendingTasks, taskService),
          ),
        ),

        // Buttons
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          child: Row(
            children: [
              if (_step > 0)
                OutlinedButton(
                  onPressed: _back,
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(80, 48),
                  ),
                  child: Text('← Atrás',
                      style: GoogleFonts.inter(color: AppTheme.textSecondary)),
                ),
              if (_step > 0) const SizedBox(width: 12),
              Expanded(
                child: FilledButton(
                  onPressed: _step == 3 ? _save : _next,
                  style: FilledButton.styleFrom(minimumSize: const Size(double.infinity, 48)),
                  child: Text(
                    _step == 3 ? 'Guardar revisión' : 'Siguiente →',
                    style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStep(List<Task> completed, List<Task> pending, taskService) {
    return switch (_step) {
      0 => _Step1(completedTasks: completed, reflectionCtrl: _reflectionCtrl),
      1 => _Step2(
          pendingTasks: pending,
          onDefer: (id) => taskService.deferTask(id, dateToId(DateTime.now().add(const Duration(days: 1)))),
          onDelete: (id) => taskService.deleteTask(id),
        ),
      2 => _Step3(
          mood: _mood,
          onMoodChanged: (v) => setState(() => _mood = v),
          gratitudeCtrl: _gratitudeCtrl,
          lessonsCtrl: _lessonsCtrl,
          tomorrowCtrl: _tomorrowCtrl,
        ),
      _ => const _Step4(),
    };
  }
}

// ── Step progress indicator ────────────────────────────────────────────────
class _StepProgress extends StatelessWidget {
  final int current;
  const _StepProgress({required this.current});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Paso ${current + 1} de 4',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: AppTheme.textTertiary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: List.generate(4, (i) {
              return Expanded(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  height: 4,
                  margin: EdgeInsets.only(right: i < 3 ? 4 : 0),
                  decoration: BoxDecoration(
                    color: i <= current ? AppTheme.colorPrimary : AppTheme.neutral200,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

// ── Step 1: Logros ─────────────────────────────────────────────────────────
class _Step1 extends StatelessWidget {
  final List<Task> completedTasks;
  final TextEditingController reflectionCtrl;
  const _Step1({required this.completedTasks, required this.reflectionCtrl});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '¿Qué lograste hoy?',
          style: GoogleFonts.fraunces(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          completedTasks.isEmpty
              ? 'No completaste tareas hoy. ¡Mañana será mejor!'
              : 'Completaste ${completedTasks.length} tarea${completedTasks.length == 1 ? '' : 's'} hoy.',
          style: GoogleFonts.inter(fontSize: 14, color: AppTheme.textSecondary),
        ),
        const SizedBox(height: 20),
        if (completedTasks.isNotEmpty)
          ...completedTasks.map((t) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: AppTheme.colorSuccessLight,
                borderRadius: AppTheme.r12,
                border: Border.all(color: AppTheme.colorSuccess.withAlpha(60)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.check_circle_rounded,
                      color: AppTheme.colorSuccess, size: 18),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      t.title,
                      style: GoogleFonts.inter(fontSize: 14, color: AppTheme.textPrimary),
                    ),
                  ),
                ],
              ),
            ),
          )),
        const SizedBox(height: 16),
        Text(
          'Otros logros',
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppTheme.textSecondary,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: reflectionCtrl,
          maxLines: 3,
          style: GoogleFonts.inter(color: AppTheme.textPrimary, fontSize: 15, height: 1.5),
          decoration: InputDecoration(
            hintText: '¿Lograste algo que no era una tarea?',
            filled: true,
            fillColor: AppTheme.surfaceInput,
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}

// ── Step 2: Pendientes ─────────────────────────────────────────────────────
class _Step2 extends StatelessWidget {
  final List<Task> pendingTasks;
  final Function(String) onDefer;
  final Function(String) onDelete;

  const _Step2({
    required this.pendingTasks,
    required this.onDefer,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '¿Qué quedó pendiente?',
          style: GoogleFonts.fraunces(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          pendingTasks.isEmpty
              ? '¡No tenés tareas pendientes!'
              : 'Tenés ${pendingTasks.length} tarea${pendingTasks.length == 1 ? '' : 's'} sin completar.',
          style: GoogleFonts.inter(fontSize: 14, color: AppTheme.textSecondary),
        ),
        const SizedBox(height: 20),
        ...pendingTasks.map((t) => _PendingTaskItem(
          task: t,
          onDefer: () => onDefer(t.id),
          onDelete: () => onDelete(t.id),
        )),
      ],
    );
  }
}

class _PendingTaskItem extends StatelessWidget {
  final Task task;
  final VoidCallback onDefer;
  final VoidCallback onDelete;

  const _PendingTaskItem({
    required this.task,
    required this.onDefer,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final color = switch (task.priority) {
      TaskPriority.primordial => AppTheme.colorDanger,
      TaskPriority.importante => AppTheme.colorWarning,
      _ => AppTheme.colorPrimary,
    };

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppTheme.surfaceCard,
          borderRadius: AppTheme.r12,
          border: Border.all(color: AppTheme.divider),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 8, height: 8,
                  decoration: BoxDecoration(shape: BoxShape.circle, color: color),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    task.title,
                    style: GoogleFonts.inter(fontSize: 14, color: AppTheme.textPrimary),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                _PendingBtn(
                  label: 'Mañana',
                  color: AppTheme.colorPrimary,
                  onTap: () {
                    HapticFeedback.lightImpact();
                    onDefer();
                  },
                ),
                const SizedBox(width: 8),
                _PendingBtn(
                  label: 'Ya no importa',
                  color: AppTheme.colorDanger,
                  onTap: () {
                    HapticFeedback.heavyImpact();
                    onDelete();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _PendingBtn extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _PendingBtn({required this.label, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: color.withAlpha(20),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withAlpha(80)),
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

// ── Step 3: Reflexión ──────────────────────────────────────────────────────
class _Step3 extends StatelessWidget {
  final int mood;
  final ValueChanged<int> onMoodChanged;
  final TextEditingController gratitudeCtrl;
  final TextEditingController lessonsCtrl;
  final TextEditingController tomorrowCtrl;

  const _Step3({
    required this.mood,
    required this.onMoodChanged,
    required this.gratitudeCtrl,
    required this.lessonsCtrl,
    required this.tomorrowCtrl,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Reflexión del día',
          style: GoogleFonts.fraunces(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        Text('¿Cómo te sentís?',
            style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: AppTheme.textSecondary)),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(5, (i) {
            final val = i + 1;
            return GestureDetector(
              onTap: () => onMoodChanged(val),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: mood == val ? AppTheme.colorPrimaryLight : Colors.transparent,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  ['😔', '😕', '😐', '🙂', '😄'][i],
                  style: TextStyle(fontSize: mood == val ? 32 : 26),
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 20),
        _FieldLabel('¿Por qué te sentís agradecido hoy?'),
        const SizedBox(height: 8),
        _TextArea(controller: gratitudeCtrl, hint: 'Hoy estoy agradecido por...'),
        const SizedBox(height: 16),
        _FieldLabel('¿Qué aprendiste?'),
        const SizedBox(height: 8),
        _TextArea(controller: lessonsCtrl, hint: 'Hoy aprendí que...'),
        const SizedBox(height: 16),
        _FieldLabel('¿En qué te vas a enfocar mañana?'),
        const SizedBox(height: 8),
        _TextArea(controller: tomorrowCtrl, hint: 'Mañana me voy a enfocar en...'),
        const SizedBox(height: 20),
      ],
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: AppTheme.textSecondary),
    );
  }
}

class _TextArea extends StatelessWidget {
  final TextEditingController controller;
  final String hint;

  const _TextArea({required this.controller, required this.hint});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: 3,
      style: GoogleFonts.inter(color: AppTheme.textPrimary, fontSize: 15, height: 1.5),
      decoration: InputDecoration(hintText: hint),
    );
  }
}

// ── Step 4: Cierre ─────────────────────────────────────────────────────────
class _Step4 extends StatelessWidget {
  const _Step4();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 20),
        const Text('🎉', style: TextStyle(fontSize: 56)),
        const SizedBox(height: 16),
        Text(
          '¡Revisión completa!',
          style: GoogleFonts.fraunces(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: AppTheme.textPrimary,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        Text(
          'Tomaste conciencia de tu día. Eso es lo que importa.',
          style: GoogleFonts.inter(fontSize: 15, color: AppTheme.textSecondary, height: 1.5),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// HISTORIAL VIEW
// ═══════════════════════════════════════════════════════════════════════════
class _HistorialView extends ConsumerWidget {
  const _HistorialView();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entriesAsync = ref.watch(allJournalEntriesProvider);

    return entriesAsync.when(
      data: (entries) {
        if (entries.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.book_rounded, size: 48, color: AppTheme.neutral400),
                const SizedBox(height: 12),
                Text(
                  'No hay revisiones guardadas',
                  style: GoogleFonts.inter(color: AppTheme.textTertiary, fontSize: 15),
                ),
              ],
            ),
          );
        }

        return _HistorialContent(entries: entries, ref: ref);
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('$e')),
    );
  }
}

// ── Historial content with chart + calendar ────────────────────────────────
class _HistorialContent extends StatefulWidget {
  final List<JournalEntry> entries;
  final WidgetRef ref;

  const _HistorialContent({required this.entries, required this.ref});

  @override
  State<_HistorialContent> createState() => _HistorialContentState();
}

class _HistorialContentState extends State<_HistorialContent> {
  int _monthOffset = 0; // 0 = current month, -1 = previous, etc.
  String? _selectedDayId;

  @override
  Widget build(BuildContext context) {
    // Build a map of dayId -> entry for quick lookup
    final entryMap = <String, JournalEntry>{};
    for (final e in widget.entries) {
      entryMap[e.dayId] = e;
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Mood trend chart ──
          if (widget.entries.isNotEmpty) _buildMoodChart(),
          if (widget.entries.isNotEmpty) const SizedBox(height: 24),
          // ── Calendar view ──
          _buildCalendar(entryMap),
          // ── Selected entry detail ──
          if (_selectedDayId != null && entryMap.containsKey(_selectedDayId))
            _buildSelectedEntryCard(entryMap[_selectedDayId]!),
        ],
      ),
    );
  }

  // ── Mood trend line chart ──────────────────────────────────────────────
  Widget _buildMoodChart() {
    // Get entries sorted by date ascending, last 30 entries max
    final sorted = List<JournalEntry>.from(widget.entries)
      ..sort((a, b) => a.dayId.compareTo(b.dayId));
    final withMood = sorted.where((e) => e.mood != null && e.mood! >= 1 && e.mood! <= 5).toList();
    if (withMood.isEmpty) return const SizedBox.shrink();

    final recent = withMood.length > 30 ? withMood.sublist(withMood.length - 30) : withMood;

    final spots = <FlSpot>[];
    for (int i = 0; i < recent.length; i++) {
      spots.add(FlSpot(i.toDouble(), recent[i].mood!.toDouble()));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Estado de ánimo',
          style: GoogleFonts.fraunces(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          height: 150,
          padding: const EdgeInsets.only(right: 16, top: 8),
          decoration: BoxDecoration(
            color: AppTheme.surfaceCard,
            borderRadius: AppTheme.r12,
            border: Border.all(color: AppTheme.divider),
          ),
          child: LineChart(
            LineChartData(
              minY: 0.5,
              maxY: 5.5,
              gridData: FlGridData(
                show: true,
                horizontalInterval: 1,
                drawVerticalLine: false,
                getDrawingHorizontalLine: (value) => FlLine(
                  color: AppTheme.divider,
                  strokeWidth: 0.5,
                ),
              ),
              borderData: FlBorderData(show: false),
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 28,
                    interval: 1,
                    getTitlesWidget: (value, meta) {
                      if (value < 1 || value > 5 || value != value.roundToDouble()) {
                        return const SizedBox.shrink();
                      }
                      return Text(
                        ['', '😔', '😕', '😐', '🙂', '😄'][value.toInt()],
                        style: const TextStyle(fontSize: 12),
                      );
                    },
                  ),
                ),
                rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 22,
                    interval: recent.length > 10 ? (recent.length / 5).ceilToDouble() : 1,
                    getTitlesWidget: (value, meta) {
                      final idx = value.toInt();
                      if (idx < 0 || idx >= recent.length) return const SizedBox.shrink();
                      try {
                        final dt = idToDate(recent[idx].dayId);
                        return Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            '${dt.day}/${dt.month}',
                            style: GoogleFonts.inter(fontSize: 9, color: AppTheme.textTertiary),
                          ),
                        );
                      } catch (_) {
                        return const SizedBox.shrink();
                      }
                    },
                  ),
                ),
              ),
              lineBarsData: [
                LineChartBarData(
                  spots: spots,
                  isCurved: true,
                  curveSmoothness: 0.3,
                  color: AppTheme.colorPrimary,
                  barWidth: 2.5,
                  isStrokeCapRound: true,
                  dotData: FlDotData(
                    show: true,
                    getDotPainter: (spot, percent, barData, index) => FlDotCirclePainter(
                      radius: 3.5,
                      color: AppTheme.colorPrimary,
                      strokeWidth: 1.5,
                      strokeColor: AppTheme.surfaceCard,
                    ),
                  ),
                  belowBarData: BarAreaData(
                    show: true,
                    color: AppTheme.colorPrimary.withAlpha(25),
                  ),
                ),
              ],
              lineTouchData: LineTouchData(
                touchTooltipData: LineTouchTooltipData(
                  getTooltipItems: (spots) {
                    return spots.map((spot) {
                      final idx = spot.x.toInt();
                      if (idx < 0 || idx >= recent.length) return null;
                      final entry = recent[idx];
                      final emoji = ['', '😔', '😕', '😐', '🙂', '😄'][entry.mood ?? 0];
                      return LineTooltipItem(
                        emoji,
                        const TextStyle(fontSize: 16),
                      );
                    }).toList();
                  },
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ── Calendar ───────────────────────────────────────────────────────────
  Widget _buildCalendar(Map<String, JournalEntry> entryMap) {
    final now = DateTime.now();
    final displayMonth = DateTime(now.year, now.month + _monthOffset, 1);
    final monthName = DateFormat('MMMM yyyy', 'es').format(displayMonth);
    // Capitalize first letter
    final monthLabel = '${monthName[0].toUpperCase()}${monthName.substring(1)}';

    // Days in month
    final daysInMonth = DateTime(displayMonth.year, displayMonth.month + 1, 0).day;
    // Weekday of first day (1=Monday in ISO)
    final firstWeekday = DateTime(displayMonth.year, displayMonth.month, 1).weekday; // 1=Mon, 7=Sun

    final today = DateTime.now();
    final todayDayId = todayId();

    return Column(
      children: [
        // Month nav header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(Icons.chevron_left_rounded, color: AppTheme.textSecondary),
              onPressed: () => setState(() {
                _monthOffset--;
                _selectedDayId = null;
              }),
            ),
            Text(
              monthLabel,
              style: GoogleFonts.fraunces(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimary,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.chevron_right_rounded, color: AppTheme.textSecondary),
              onPressed: _monthOffset >= 0
                  ? null
                  : () => setState(() {
                      _monthOffset++;
                      _selectedDayId = null;
                    }),
            ),
          ],
        ),
        const SizedBox(height: 8),

        // Day headers (L M M J V S D)
        Row(
          children: ['L', 'M', 'M', 'J', 'V', 'S', 'D'].map((d) {
            return Expanded(
              child: Center(
                child: Text(
                  d,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textTertiary,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 4),

        // Calendar grid
        _buildCalendarGrid(
          displayMonth: displayMonth,
          daysInMonth: daysInMonth,
          firstWeekday: firstWeekday,
          entryMap: entryMap,
          todayDayId: todayDayId,
          today: today,
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildCalendarGrid({
    required DateTime displayMonth,
    required int daysInMonth,
    required int firstWeekday,
    required Map<String, JournalEntry> entryMap,
    required String todayDayId,
    required DateTime today,
  }) {
    // firstWeekday: 1=Mon => offset 0, 2=Tue => offset 1, ... 7=Sun => offset 6
    final offset = firstWeekday - 1;
    final totalCells = offset + daysInMonth;
    final rows = (totalCells / 7).ceil();

    return Column(
      children: List.generate(rows, (row) {
        return Row(
          children: List.generate(7, (col) {
            final cellIndex = row * 7 + col;
            final dayNum = cellIndex - offset + 1;

            if (dayNum < 1 || dayNum > daysInMonth) {
              return const Expanded(child: SizedBox(height: 44));
            }

            final dayId = dateToId(DateTime(displayMonth.year, displayMonth.month, dayNum));
            final hasEntry = entryMap.containsKey(dayId);
            final isToday = dayId == todayDayId;
            final isSelected = dayId == _selectedDayId;
            final entry = entryMap[dayId];

            return Expanded(
              child: GestureDetector(
                onTap: hasEntry
                    ? () => setState(() {
                        _selectedDayId = _selectedDayId == dayId ? null : dayId;
                      })
                    : null,
                child: Container(
                  height: 44,
                  margin: const EdgeInsets.all(1),
                  decoration: BoxDecoration(
                    color: isSelected ? AppTheme.colorPrimaryLight : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                    border: isToday
                        ? Border.all(color: AppTheme.colorPrimary.withAlpha(100), width: 1.5)
                        : null,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '$dayNum',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: isToday ? FontWeight.w700 : FontWeight.w400,
                          color: hasEntry ? AppTheme.textPrimary : AppTheme.textTertiary,
                        ),
                      ),
                      if (hasEntry) ...[
                        const SizedBox(height: 2),
                        Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _moodColor(entry!.mood),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            );
          }),
        );
      }),
    );
  }

  Color _moodColor(int? mood) {
    return switch (mood) {
      1 => const Color(0xFFE53935), // red
      2 => const Color(0xFFFB8C00), // orange
      3 => const Color(0xFF9E9E9E), // neutral gray
      4 => const Color(0xFF8BC34A), // light green
      5 => const Color(0xFF43A047), // green
      _ => AppTheme.neutral400,
    };
  }

  // ── Selected entry detail card ─────────────────────────────────────────
  Widget _buildSelectedEntryCard(JournalEntry entry) {
    final moodEmoji = ['', '😔', '😕', '😐', '🙂', '😄'][entry.mood ?? 0];
    final dateStr = _formatDayId(entry.dayId);

    return AnimatedSize(
      duration: const Duration(milliseconds: 250),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.surfaceCard,
          borderRadius: AppTheme.r12,
          border: Border.all(color: AppTheme.divider),
          boxShadow: AppTheme.shadowSm,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row
            Row(
              children: [
                if (moodEmoji.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Text(moodEmoji, style: const TextStyle(fontSize: 24)),
                  ),
                Expanded(
                  child: Text(
                    dateStr,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded, size: 18),
                  color: AppTheme.textTertiary,
                  onPressed: () => setState(() => _selectedDayId = null),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
            if (entry.reflection.isNotEmpty) ...[
              const SizedBox(height: 12),
              _entryField('Otros logros', entry.reflection),
            ],
            if (entry.gratitude != null && entry.gratitude!.isNotEmpty) ...[
              const SizedBox(height: 12),
              _entryField('Agradecimiento', entry.gratitude!),
            ],
            if (entry.lessonsLearned != null && entry.lessonsLearned!.isNotEmpty) ...[
              const SizedBox(height: 12),
              _entryField('Aprendizajes', entry.lessonsLearned!),
            ],
            if (entry.tomorrowFocus != null && entry.tomorrowFocus!.isNotEmpty) ...[
              const SizedBox(height: 12),
              _entryField('Enfoque mañana', entry.tomorrowFocus!),
            ],
            const SizedBox(height: 8),
            // Delete button
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: () {
                  widget.ref.read(journalServiceProvider).deleteEntry(entry.dayId);
                  setState(() => _selectedDayId = null);
                },
                icon: const Icon(Icons.delete_outline_rounded, size: 16, color: AppTheme.colorDanger),
                label: Text(
                  'Eliminar',
                  style: GoogleFonts.inter(fontSize: 12, color: AppTheme.colorDanger),
                ),
                style: TextButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 8)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _entryField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: AppTheme.textTertiary,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: GoogleFonts.inter(fontSize: 13, color: AppTheme.textSecondary, height: 1.4),
        ),
      ],
    );
  }

  String _formatDayId(String dayId) {
    try {
      final parts = dayId.split('-');
      final dt = DateTime(int.parse(parts[0]), int.parse(parts[1]), int.parse(parts[2]));
      return DateFormat("EEEE d 'de' MMMM 'de' yyyy", 'es').format(dt);
    } catch (_) {
      return dayId;
    }
  }
}
