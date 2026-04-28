import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/format_utils.dart';
import '../../../../core/widgets/defer_picker.dart';
import '../../../habitos/domain/models/habit.dart';
import '../../../habitos/presentation/providers/habit_provider.dart';
import '../../../hoy/domain/models/task.dart';
import '../../../hoy/presentation/providers/task_provider.dart';
import '../../domain/models/daily_review.dart';
import '../providers/daily_review_provider.dart';

/// Guided end-of-day review wizard.
///
/// Defaults to today. Pass [dayId] to review a past day read-only-ish
/// (interactivity for tasks / habits is disabled for past days; only the
/// journal fields remain editable).
class DailyReviewPage extends ConsumerStatefulWidget {
  final String? dayId;
  const DailyReviewPage({super.key, this.dayId});

  @override
  ConsumerState<DailyReviewPage> createState() => _DailyReviewPageState();
}

class _DailyReviewPageState extends ConsumerState<DailyReviewPage> {
  late final String _effectiveDayId;
  late final PageController _pageCtrl;

  int _step = 0;

  final _patternsCtrl = TextEditingController();
  final _moodNoteCtrl = TextEditingController();
  final _patternsFocus = FocusNode();
  final _moodNoteFocus = FocusNode();

  int? _mood;
  bool? _smoked;
  bool? _tookMedication;

  String? _reviewId;
  bool _syncedOnce = false;
  Timer? _debounce;

  bool get _isToday => _effectiveDayId == todayId();

  @override
  void initState() {
    super.initState();
    _effectiveDayId = widget.dayId ?? todayId();
    _pageCtrl = PageController();
    // Ensure a review row exists for this day.
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final service = ref.read(dailyReviewServiceProvider);
      final review = await service.getOrCreate(_effectiveDayId);
      if (mounted) setState(() => _reviewId = review.id);
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _pageCtrl.dispose();
    _patternsCtrl.dispose();
    _moodNoteCtrl.dispose();
    _patternsFocus.dispose();
    _moodNoteFocus.dispose();
    super.dispose();
  }

  // ── Auto-save (debounced) ────────────────────────────────────────────────
  void _scheduleSave() {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), _flush);
  }

  Future<void> _flush() async {
    final id = _reviewId;
    if (id == null) return;
    await ref.read(dailyReviewServiceProvider).update(
          id,
          patterns: _patternsCtrl.text,
          moodNote: _moodNoteCtrl.text,
        );
  }

  // ── Sync controllers when the review stream emits ────────────────────────
  void _syncFromReview(DailyReview? review) {
    if (review == null) return;
    // Always keep id up to date.
    if (_reviewId != review.id) _reviewId = review.id;

    if (_syncedOnce) return;
    _syncedOnce = true;

    if (!_patternsFocus.hasFocus) {
      _patternsCtrl.text = review.patterns ?? '';
    }
    if (!_moodNoteFocus.hasFocus) {
      _moodNoteCtrl.text = review.moodNote ?? '';
    }
    setState(() {
      _mood = review.mood;
      _smoked = review.smoked;
      _tookMedication = review.tookMedication;
    });
  }

  // ── Step navigation ──────────────────────────────────────────────────────
  void _goToStep(int step) {
    final clamped = step.clamp(0, 3);
    setState(() => _step = clamped);
    _pageCtrl.animateToPage(
      clamped,
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeOutCubic,
    );
  }

  Future<void> _closeDay() async {
    final id = _reviewId;
    if (id == null) return;
    await _flush();
    await ref.read(dailyReviewServiceProvider).markCompleted(id);
    if (!mounted) return;
    HapticFeedback.mediumImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Día cerrado',
          style: GoogleFonts.inter(fontWeight: FontWeight.w500),
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
    Navigator.of(context).maybePop();
  }

  Future<void> _reopen() async {
    final id = _reviewId;
    if (id == null) return;
    HapticFeedback.lightImpact();
    await ref.read(dailyReviewServiceProvider).reopen(id);
  }

  @override
  Widget build(BuildContext context) {
    // Listen to review updates for syncing controllers / flags.
    ref.listen<AsyncValue<DailyReview?>>(
      dailyReviewForDayProvider(_effectiveDayId),
      (_, next) => next.whenData(_syncFromReview),
    );

    final reviewAsync = ref.watch(dailyReviewForDayProvider(_effectiveDayId));
    final review = reviewAsync.valueOrNull;
    final isCompleted = review?.isCompleted ?? false;
    final readOnly = isCompleted;

    // Cuando la revisión ya está cerrada (read-only), mostramos un
    // resumen unificado en una sola pantalla scrollable — antes había
    // que apretar "Siguiente" 3 veces para ver toda la info.
    if (readOnly && review != null) {
      return Scaffold(
        backgroundColor: context.surfaceBase,
        appBar: _buildAppBar(context),
        body: SafeArea(
          top: false,
          child: Column(
            children: [
              _CompletedBanner(
                completedAt: review.completedAt!,
                onEdit: _reopen,
              ),
              Expanded(
                child: _ReadOnlyReviewSummary(
                  review: review,
                  dayId: _effectiveDayId,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: context.surfaceBase,
      appBar: _buildAppBar(context),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            if (isCompleted && review != null)
              _CompletedBanner(
                completedAt: review.completedAt!,
                onEdit: _reopen,
              ),
            Expanded(
              child: PageView(
                controller: _pageCtrl,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (i) => setState(() => _step = i),
                children: [
                  _StepTareas(
                    dayId: _effectiveDayId,
                    isToday: _isToday,
                    readOnly: readOnly,
                  ),
                  _StepHabitos(
                    dayId: _effectiveDayId,
                    isToday: _isToday,
                    readOnly: readOnly,
                  ),
                  _StepDiario(
                    mood: _mood,
                    smoked: _smoked,
                    tookMedication: _tookMedication,
                    moodNoteCtrl: _moodNoteCtrl,
                    patternsCtrl: _patternsCtrl,
                    moodNoteFocus: _moodNoteFocus,
                    patternsFocus: _patternsFocus,
                    readOnly: readOnly,
                    onMoodChanged: (m) {
                      HapticFeedback.selectionClick();
                      setState(() => _mood = m);
                      final id = _reviewId;
                      if (id != null) {
                        ref.read(dailyReviewServiceProvider).update(id, mood: m);
                      }
                    },
                    onMoodSkipped: () {
                      HapticFeedback.lightImpact();
                      setState(() => _mood = null);
                      final id = _reviewId;
                      if (id != null) {
                        ref
                            .read(dailyReviewServiceProvider)
                            .update(id, clearMood: true);
                      }
                    },
                    onSmokedChanged: (v) {
                      HapticFeedback.selectionClick();
                      setState(() => _smoked = v);
                      final id = _reviewId;
                      if (id == null) return;
                      if (v == null) {
                        ref
                            .read(dailyReviewServiceProvider)
                            .update(id, clearSmoked: true);
                      } else {
                        ref
                            .read(dailyReviewServiceProvider)
                            .update(id, smoked: v);
                      }
                    },
                    onMedicationChanged: (v) {
                      HapticFeedback.selectionClick();
                      setState(() => _tookMedication = v);
                      final id = _reviewId;
                      if (id == null) return;
                      if (v == null) {
                        ref
                            .read(dailyReviewServiceProvider)
                            .update(id, clearMedication: true);
                      } else {
                        ref
                            .read(dailyReviewServiceProvider)
                            .update(id, tookMedication: v);
                      }
                    },
                    onTextChanged: _scheduleSave,
                  ),
                  _StepCerrar(
                    dayId: _effectiveDayId,
                    isToday: _isToday,
                    mood: _mood,
                    patterns: _patternsCtrl.text,
                    isCompleted: isCompleted,
                    onClose: _closeDay,
                    onBack: () => _goToStep(2),
                  ),
                ],
              ),
            ),
            _StepIndicator(current: _step, total: 4),
            _BottomBar(
              step: _step,
              isLastStep: _step == 3,
              readOnly: readOnly,
              onPrev: () => _goToStep(_step - 1),
              onNext: () {
                if (_step == 3) {
                  _closeDay();
                } else {
                  _goToStep(_step + 1);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    final date = idToDate(_effectiveDayId);
    String subtitle = DateFormat('EEEE, d MMMM', 'es').format(date);
    subtitle = subtitle[0].toUpperCase() + subtitle.substring(1);

    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back_rounded, color: context.textSecondary),
        onPressed: () => Navigator.of(context).maybePop(),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Revisión del día',
            style: GoogleFonts.fraunces(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: context.textPrimary,
            ),
          ),
          Text(
            subtitle,
            style: GoogleFonts.inter(
              fontSize: 12,
              color: context.textTertiary,
            ),
          ),
        ],
      ),
      titleSpacing: 0,
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// COMPLETED BANNER
// ═══════════════════════════════════════════════════════════════════════════

class _CompletedBanner extends StatelessWidget {
  final DateTime completedAt;
  final VoidCallback onEdit;

  const _CompletedBanner({required this.completedAt, required this.onEdit});

  @override
  Widget build(BuildContext context) {
    final stamp = DateFormat('dd/MM HH:mm').format(completedAt);
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppTheme.colorSuccessLight,
        borderRadius: AppTheme.r12,
        border: Border.all(color: AppTheme.colorSuccess.withAlpha(70)),
      ),
      child: Row(
        children: [
          const Icon(Icons.lock_rounded,
              color: AppTheme.colorSuccess, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Revisión cerrada el $stamp',
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppTheme.colorSuccess,
              ),
            ),
          ),
          TextButton(
            onPressed: onEdit,
            style: TextButton.styleFrom(
              foregroundColor: AppTheme.colorSuccess,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              'Editar',
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// STEP INDICATOR & BOTTOM BAR
// ═══════════════════════════════════════════════════════════════════════════

class _StepIndicator extends StatelessWidget {
  final int current;
  final int total;

  const _StepIndicator({required this.current, required this.total});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4, bottom: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(total, (i) {
          final active = i == current;
          return AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            margin: const EdgeInsets.symmetric(horizontal: 4),
            width: active ? 18 : 8,
            height: 8,
            decoration: BoxDecoration(
              color: active ? context.colorPrimary : context.neutral300,
              borderRadius: BorderRadius.circular(4),
            ),
          );
        }),
      ),
    );
  }
}

class _BottomBar extends StatelessWidget {
  final int step;
  final bool isLastStep;
  final bool readOnly;
  final VoidCallback onPrev;
  final VoidCallback onNext;

  const _BottomBar({
    required this.step,
    required this.isLastStep,
    required this.readOnly,
    required this.onPrev,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    final nextLabel = isLastStep
        ? (readOnly ? 'Listo' : 'Cerrar día')
        : 'Siguiente';
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
      child: Row(
        children: [
          if (step > 0)
            Expanded(
              child: OutlinedButton(
                onPressed: onPrev,
                style: OutlinedButton.styleFrom(
                  foregroundColor: context.textSecondary,
                  side: BorderSide(color: context.dividerColor),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: AppTheme.r12),
                ),
                child: Text(
                  'Anterior',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: context.textSecondary,
                  ),
                ),
              ),
            ),
          if (step > 0) const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: FilledButton(
              onPressed: (isLastStep && readOnly)
                  ? () => Navigator.of(context).maybePop()
                  : onNext,
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: AppTheme.r12),
              ),
              child: Text(
                nextLabel,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// STEP 0 — TAREAS
// ═══════════════════════════════════════════════════════════════════════════

class _StepTareas extends ConsumerStatefulWidget {
  final String dayId;
  final bool isToday;
  final bool readOnly;

  const _StepTareas({
    required this.dayId,
    required this.isToday,
    required this.readOnly,
  });

  @override
  ConsumerState<_StepTareas> createState() => _StepTareasState();
}

class _StepTareasState extends ConsumerState<_StepTareas> {
  bool _showCompleted = true;
  bool _showPending = true;

  @override
  Widget build(BuildContext context) {
    final tasksAsync = widget.isToday
        ? ref.watch(todayTasksProvider)
        : ref.watch(_tasksForDayProvider(widget.dayId));

    return tasksAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(
        child: Text('Error: $e',
            style: GoogleFonts.inter(color: context.textSecondary)),
      ),
      data: (tasks) {
        final own =
            tasks.where((t) => t.parentProjectId == null).toList();
        final completed =
            own.where((t) => t.status == TaskStatus.done).toList();
        final pending =
            own.where((t) => t.status != TaskStatus.done).toList();

        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '¿Qué hiciste hoy?',
                style: GoogleFonts.fraunces(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: context.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                own.isEmpty
                    ? 'No tenés tareas para este día.'
                    : '${completed.length} de ${own.length} completadas',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: context.textSecondary,
                ),
              ),
              const SizedBox(height: 18),
              _SectionHeader(
                title: 'Completadas',
                count: completed.length,
                expanded: _showCompleted,
                onToggle: () =>
                    setState(() => _showCompleted = !_showCompleted),
              ),
              if (_showCompleted) ...[
                if (completed.isEmpty)
                  const _EmptyBox(text: 'Aún no completaste nada.'),
                ...completed.map((t) => _TaskRow(
                      task: t,
                      isCompleted: true,
                      interactive: widget.isToday && !widget.readOnly,
                      onToggle: () => ref
                          .read(taskServiceProvider)
                          .uncompleteTask(t.id),
                      onDefer: (newDay) => ref
                          .read(taskServiceProvider)
                          .deferTask(t.id, newDay),
                      onDelete: () =>
                          ref.read(taskServiceProvider).deleteTask(t.id),
                    )),
              ],
              const SizedBox(height: 16),
              _SectionHeader(
                title: 'Pendientes',
                count: pending.length,
                expanded: _showPending,
                onToggle: () =>
                    setState(() => _showPending = !_showPending),
              ),
              if (_showPending) ...[
                if (pending.isEmpty)
                  const _EmptyBox(text: 'No quedó nada pendiente.'),
                ...pending.map((t) => _TaskRow(
                      task: t,
                      isCompleted: false,
                      interactive: widget.isToday && !widget.readOnly,
                      onToggle: () =>
                          ref.read(taskServiceProvider).completeTask(t.id),
                      onDefer: (newDay) => ref
                          .read(taskServiceProvider)
                          .deferTask(t.id, newDay),
                      onDelete: () =>
                          ref.read(taskServiceProvider).deleteTask(t.id),
                    )),
              ],
            ],
          ),
        );
      },
    );
  }
}

/// Per-day task stream provider family (used only when showing past days).
final _tasksForDayProvider =
    StreamProvider.family<List<Task>, String>((ref, dayId) {
  return ref.watch(taskServiceProvider).watchTasksByDay(dayId);
});

class _SectionHeader extends StatelessWidget {
  final String title;
  final int count;
  final bool expanded;
  final VoidCallback onToggle;

  const _SectionHeader({
    required this.title,
    required this.count,
    required this.expanded,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onToggle,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Icon(
              expanded
                  ? Icons.expand_more_rounded
                  : Icons.chevron_right_rounded,
              size: 18,
              color: context.textSecondary,
            ),
            const SizedBox(width: 4),
            Text(
              title,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: context.textPrimary,
              ),
            ),
            const SizedBox(width: 6),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: context.neutral200,
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                '$count',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: context.textSecondary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyBox extends StatelessWidget {
  final String text;
  const _EmptyBox({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Text(
        text,
        style: GoogleFonts.inter(
          fontSize: 13,
          color: context.textTertiary,
        ),
      ),
    );
  }
}

class _TaskRow extends StatelessWidget {
  final Task task;
  final bool isCompleted;
  final bool interactive;
  final VoidCallback onToggle;
  final void Function(String newDayId) onDefer;
  final VoidCallback onDelete;

  const _TaskRow({
    required this.task,
    required this.isCompleted,
    required this.interactive,
    required this.onToggle,
    required this.onDefer,
    required this.onDelete,
  });

  Color _priorityColor() => switch (task.priority) {
        TaskPriority.primordial => AppTheme.colorDanger,
        TaskPriority.importante => AppTheme.colorWarning,
        TaskPriority.puedeEsperar => AppTheme.colorPrimary,
        TaskPriority.secundaria => AppTheme.neutral400,
      };

  String _priorityLabel() => switch (task.priority) {
        TaskPriority.primordial => 'Primordial',
        TaskPriority.importante => 'Importante',
        TaskPriority.puedeEsperar => 'Puede esperar',
        TaskPriority.secundaria => 'Secundaria',
      };

  @override
  Widget build(BuildContext context) {
    final color = _priorityColor();

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.fromLTRB(12, 10, 6, 10),
      decoration: BoxDecoration(
        color: context.surfaceCard,
        borderRadius: AppTheme.r12,
        border: Border.all(color: context.dividerColor),
      ),
      child: Row(
        children: [
          // Toggle
          GestureDetector(
            onTap: interactive
                ? () {
                    HapticFeedback.lightImpact();
                    onToggle();
                  }
                : null,
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isCompleted
                    ? AppTheme.colorSuccess
                    : Colors.transparent,
                border: Border.all(
                  color: isCompleted
                      ? AppTheme.colorSuccess
                      : context.neutral300,
                  width: 2,
                ),
              ),
              child: isCompleted
                  ? const Icon(Icons.check_rounded,
                      size: 16, color: Colors.white)
                  : null,
            ),
          ),
          const SizedBox(width: 10),
          // Priority dot + title + priority pill
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: color,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        task.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: context.textPrimary,
                          decoration: isCompleted
                              ? TextDecoration.lineThrough
                              : null,
                          decorationColor: context.textTertiary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Padding(
                  padding: const EdgeInsets.only(left: 14),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: color.withAlpha(24),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      _priorityLabel(),
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: color,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Overflow menu for pending items (interactive)
          if (interactive && !isCompleted)
            _TaskMenu(
              onDeferTomorrow: () {
                final tomorrow = dateToId(
                    DateTime.now().add(const Duration(days: 1)));
                onDefer(tomorrow);
              },
              onPickDate: () async {
                final picked = await showDeferPicker(context);
                if (picked != null) onDefer(picked);
              },
              onDelete: () async {
                final ok = await _confirmDelete(context);
                if (ok == true) onDelete();
              },
            ),
        ],
      ),
    );
  }

  Future<bool?> _confirmDelete(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Borrar tarea',
            style: GoogleFonts.fraunces(fontWeight: FontWeight.w600)),
        content: Text('¿Seguro que querés borrar esta tarea?',
            style: GoogleFonts.inter(fontSize: 14)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text('Cancelar',
                style: GoogleFonts.inter(color: ctx.textSecondary)),
          ),
          FilledButton(
            style:
                FilledButton.styleFrom(backgroundColor: AppTheme.colorDanger),
            onPressed: () => Navigator.pop(ctx, true),
            child: Text('Borrar',
                style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}

class _TaskMenu extends StatelessWidget {
  final VoidCallback onDeferTomorrow;
  final VoidCallback onPickDate;
  final VoidCallback onDelete;

  const _TaskMenu({
    required this.onDeferTomorrow,
    required this.onPickDate,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: Icon(Icons.more_vert_rounded,
          color: context.textTertiary, size: 20),
      tooltip: 'Acciones',
      onSelected: (v) {
        switch (v) {
          case 'tomorrow':
            onDeferTomorrow();
            break;
          case 'pick':
            onPickDate();
            break;
          case 'delete':
            onDelete();
            break;
        }
      },
      itemBuilder: (_) => [
        PopupMenuItem(
          value: 'tomorrow',
          child: Row(
            children: [
              const Icon(Icons.wb_sunny_rounded,
                  size: 18, color: AppTheme.colorWarning),
              const SizedBox(width: 10),
              Text('Posponer a mañana', style: GoogleFonts.inter(fontSize: 13)),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'pick',
          child: Row(
            children: [
              const Icon(Icons.event_rounded,
                  size: 18, color: AppTheme.colorPrimary),
              const SizedBox(width: 10),
              Text('Elegir fecha', style: GoogleFonts.inter(fontSize: 13)),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'delete',
          child: Row(
            children: [
              const Icon(Icons.delete_outline_rounded,
                  size: 18, color: AppTheme.colorDanger),
              const SizedBox(width: 10),
              Text('Borrar',
                  style: GoogleFonts.inter(
                      fontSize: 13, color: AppTheme.colorDanger)),
            ],
          ),
        ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// STEP 1 — HÁBITOS
// ═══════════════════════════════════════════════════════════════════════════

class _StepHabitos extends ConsumerWidget {
  final String dayId;
  final bool isToday;
  final bool readOnly;

  const _StepHabitos({
    required this.dayId,
    required this.isToday,
    required this.readOnly,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final habitsAsync = ref.watch(activeHabitsProvider);
    final completionsAsync = isToday
        ? ref.watch(todayCompletionsProvider)
        : ref.watch(_completionsForDayProvider(dayId));

    return habitsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(
        child: Text('Error: $e',
            style: GoogleFonts.inter(color: context.textSecondary)),
      ),
      data: (habits) {
        final completions = completionsAsync.valueOrNull ?? const [];
        final doneIds = completions.map((c) => c.habitId).toSet();
        final doneCount =
            habits.where((h) => doneIds.contains(h.id)).length;
        final total = habits.length;
        final progress = total == 0 ? 0.0 : doneCount / total;

        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Tus hábitos de hoy',
                style: GoogleFonts.fraunces(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: context.textPrimary,
                ),
              ),
              const SizedBox(height: 14),
              _HabitSummary(
                doneCount: doneCount,
                total: total,
                progress: progress,
              ),
              const SizedBox(height: 18),
              if (habits.isEmpty)
                const _EmptyBox(text: 'No tenés hábitos activos.'),
              ...habits.map((h) {
                final done = doneIds.contains(h.id);
                return _HabitRow(
                  habit: h,
                  done: done,
                  interactive: isToday && !readOnly,
                  onToggle: () {
                    HapticFeedback.selectionClick();
                    ref
                        .read(habitServiceProvider)
                        .toggleCompletion(h.id, dayId);
                  },
                );
              }),
            ],
          ),
        );
      },
    );
  }
}

final _completionsForDayProvider =
    StreamProvider.family<List<HabitCompletion>, String>((ref, dayId) {
  return ref.watch(habitServiceProvider).watchCompletionsForDay(dayId);
});

class _HabitSummary extends StatelessWidget {
  final int doneCount;
  final int total;
  final double progress;

  const _HabitSummary({
    required this.doneCount,
    required this.total,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.surfaceCard,
        borderRadius: AppTheme.r16,
        border: Border.all(color: context.dividerColor),
        boxShadow: AppTheme.shadowSm,
      ),
      child: Row(
        children: [
          SizedBox(
            width: 44,
            height: 44,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 44,
                  height: 44,
                  child: CircularProgressIndicator(
                    value: progress,
                    strokeWidth: 4,
                    backgroundColor: context.neutral200,
                    valueColor: AlwaysStoppedAnimation<Color>(
                        context.colorPrimary),
                  ),
                ),
                Text(
                  '${(progress * 100).round()}%',
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: context.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$doneCount de $total hábitos',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: context.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  total == 0
                      ? 'Agregá hábitos para empezar'
                      : (doneCount == total
                          ? '¡Todo hecho!'
                          : 'Seguí, te falta poco'),
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: context.textSecondary,
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

class _HabitRow extends StatelessWidget {
  final Habit habit;
  final bool done;
  final bool interactive;
  final VoidCallback onToggle;

  const _HabitRow({
    required this.habit,
    required this.done,
    required this.interactive,
    required this.onToggle,
  });

  Color _parseColor() {
    final c = habit.color;
    if (c == null || c.isEmpty) return AppTheme.colorPrimary;
    try {
      var hex = c.replaceAll('#', '');
      if (hex.length == 6) hex = 'FF$hex';
      return Color(int.parse(hex, radix: 16));
    } catch (_) {
      return AppTheme.colorPrimary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _parseColor();
    final icon = habit.icon ?? '•';

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: AppTheme.r12,
          onTap: interactive ? onToggle : null,
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: context.surfaceCard,
              borderRadius: AppTheme.r12,
              border: Border.all(
                color: done
                    ? AppTheme.colorSuccess.withAlpha(110)
                    : context.dividerColor,
                width: done ? 1.5 : 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: color.withAlpha(38),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    icon,
                    style: const TextStyle(fontSize: 22),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    habit.title,
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: context.textPrimary,
                    ),
                  ),
                ),
                _StatusPill(done: done),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  final bool done;
  const _StatusPill({required this.done});

  @override
  Widget build(BuildContext context) {
    final bg = done
        ? AppTheme.colorSuccess.withAlpha(32)
        : context.neutral200;
    final fg = done ? AppTheme.colorSuccess : context.textTertiary;
    final label = done ? 'Hecho' : 'Pendiente';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: GoogleFonts.inter(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: fg,
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// STEP 2 — DIARIO
// ═══════════════════════════════════════════════════════════════════════════

class _StepDiario extends StatelessWidget {
  final int? mood;
  final bool? smoked;
  final bool? tookMedication;
  final TextEditingController moodNoteCtrl;
  final TextEditingController patternsCtrl;
  final FocusNode moodNoteFocus;
  final FocusNode patternsFocus;
  final bool readOnly;
  final ValueChanged<int> onMoodChanged;
  final VoidCallback onMoodSkipped;
  final ValueChanged<bool?> onSmokedChanged;
  final ValueChanged<bool?> onMedicationChanged;
  final VoidCallback onTextChanged;

  const _StepDiario({
    required this.mood,
    required this.smoked,
    required this.tookMedication,
    required this.moodNoteCtrl,
    required this.patternsCtrl,
    required this.moodNoteFocus,
    required this.patternsFocus,
    required this.readOnly,
    required this.onMoodChanged,
    required this.onMoodSkipped,
    required this.onSmokedChanged,
    required this.onMedicationChanged,
    required this.onTextChanged,
  });

  static const _faces = ['😞', '😕', '😐', '🙂', '😄'];

  static Color _moodColor(int m) => switch (m) {
        1 => AppTheme.colorDanger,
        2 => AppTheme.colorWarning,
        3 => AppTheme.neutral500,
        4 => AppTheme.colorSuccess,
        5 => AppTheme.colorAccent,
        _ => AppTheme.neutral400,
      };

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '¿Cómo te fue?',
            style: GoogleFonts.fraunces(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: context.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Solo lo que quieras. Todo es opcional.',
            style: GoogleFonts.inter(
              fontSize: 13,
              color: context.textSecondary,
            ),
          ),
          const SizedBox(height: 20),

          // ── Mood row ─────────────────────────────────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(5, (i) {
              final val = i + 1;
              final active = mood == val;
              final color = _moodColor(val);
              return GestureDetector(
                onTap: readOnly ? null : () => onMoodChanged(val),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color:
                        active ? color.withAlpha(40) : Colors.transparent,
                    border: Border.all(
                      color: active ? color : Colors.transparent,
                      width: 2,
                    ),
                  ),
                  child: Text(
                    _faces[i],
                    style: TextStyle(fontSize: active ? 34 : 28),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: readOnly ? null : onMoodSkipped,
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                'Prefiero no responder',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: context.textTertiary,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ),

          // ── Mood note ────────────────────────────────────────────────
          const SizedBox(height: 8),
          TextField(
            controller: moodNoteCtrl,
            focusNode: moodNoteFocus,
            readOnly: readOnly,
            maxLines: 2,
            onChanged: (_) => onTextChanged(),
            style: GoogleFonts.inter(
              fontSize: 14,
              color: context.textPrimary,
              height: 1.5,
            ),
            decoration: InputDecoration(
              hintText: '¿Cómo te sentiste? (opcional)',
              filled: true,
              fillColor: context.surfaceElevated,
            ),
          ),

          // ── Toggles ──────────────────────────────────────────────────
          const SizedBox(height: 20),
          _ToggleRow(
            label: 'Fumé',
            value: smoked,
            trueColor: AppTheme.colorDanger,
            readOnly: readOnly,
            onChanged: onSmokedChanged,
          ),
          const SizedBox(height: 10),
          _ToggleRow(
            label: 'Tomé la medicación',
            value: tookMedication,
            trueColor: AppTheme.colorSuccess,
            readOnly: readOnly,
            onChanged: onMedicationChanged,
          ),

          // ── Patterns ─────────────────────────────────────────────────
          const SizedBox(height: 20),
          Text(
            'Cosas que noté / patrones',
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: context.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: patternsCtrl,
            focusNode: patternsFocus,
            readOnly: readOnly,
            minLines: 4,
            maxLines: 8,
            onChanged: (_) => onTextChanged(),
            style: GoogleFonts.inter(
              fontSize: 14,
              color: context.textPrimary,
              height: 1.5,
            ),
            decoration: InputDecoration(
              hintText: '¿Qué se repitió hoy? ¿Qué aprendiste de vos?',
              filled: true,
              fillColor: context.surfaceElevated,
            ),
          ),
        ],
      ),
    );
  }
}

class _ToggleRow extends StatelessWidget {
  final String label;
  final bool? value;
  final Color trueColor;
  final bool readOnly;
  final ValueChanged<bool?> onChanged;

  const _ToggleRow({
    required this.label,
    required this.value,
    required this.trueColor,
    required this.readOnly,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 10, 10, 10),
      decoration: BoxDecoration(
        color: context.surfaceCard,
        borderRadius: AppTheme.r12,
        border: Border.all(color: context.dividerColor),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: context.textPrimary,
              ),
            ),
          ),
          _ChoicePill(
            label: 'Sí',
            active: value == true,
            activeColor: trueColor,
            onTap: readOnly ? null : () => onChanged(true),
          ),
          const SizedBox(width: 6),
          _ChoicePill(
            label: 'No',
            active: value == false,
            activeColor: context.neutral500,
            onTap: readOnly ? null : () => onChanged(false),
          ),
          const SizedBox(width: 6),
          TextButton(
            onPressed: readOnly ? null : () => onChanged(null),
            style: TextButton.styleFrom(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              'No responder',
              style: GoogleFonts.inter(
                fontSize: 11,
                color: context.textTertiary,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ChoicePill extends StatelessWidget {
  final String label;
  final bool active;
  final Color activeColor;
  final VoidCallback? onTap;

  const _ChoicePill({
    required this.label,
    required this.active,
    required this.activeColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bg = active ? activeColor.withAlpha(32) : context.neutral100;
    final fg = active ? activeColor : context.textSecondary;
    final border = active ? activeColor : context.dividerColor;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: border, width: active ? 1.5 : 1),
        ),
        child: Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: fg,
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// STEP 3 — CERRAR EL DÍA
// ═══════════════════════════════════════════════════════════════════════════

class _StepCerrar extends ConsumerWidget {
  final String dayId;
  final bool isToday;
  final int? mood;
  final String patterns;
  final bool isCompleted;
  final VoidCallback onClose;
  final VoidCallback onBack;

  const _StepCerrar({
    required this.dayId,
    required this.isToday,
    required this.mood,
    required this.patterns,
    required this.isCompleted,
    required this.onClose,
    required this.onBack,
  });

  static const _faces = ['😞', '😕', '😐', '🙂', '😄'];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasksAsync = isToday
        ? ref.watch(todayTasksProvider)
        : ref.watch(_tasksForDayProvider(dayId));
    final habitsAsync = ref.watch(activeHabitsProvider);
    final completionsAsync = isToday
        ? ref.watch(todayCompletionsProvider)
        : ref.watch(_completionsForDayProvider(dayId));

    final tasks = tasksAsync.valueOrNull ?? const [];
    final own = tasks.where((t) => t.parentProjectId == null).toList();
    final tasksDone =
        own.where((t) => t.status == TaskStatus.done).length;
    final tasksTotal = own.length;

    final habits = habitsAsync.valueOrNull ?? const [];
    final completions = completionsAsync.valueOrNull ?? const [];
    final doneIds = completions.map((c) => c.habitId).toSet();
    final habitsDone =
        habits.where((h) => doneIds.contains(h.id)).length;
    final habitsTotal = habits.length;

    final moodEmoji = (mood != null && mood! >= 1 && mood! <= 5)
        ? _faces[mood! - 1]
        : '—';

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: context.surfaceCard,
              borderRadius: AppTheme.r16,
              border: Border.all(color: context.dividerColor),
              boxShadow: AppTheme.shadowSm,
            ),
            child: Column(
              children: [
                const SizedBox(height: 8),
                const Text('🌙', style: TextStyle(fontSize: 44)),
                const SizedBox(height: 12),
                Text(
                  isCompleted
                      ? 'Revisión guardada'
                      : '¿Estás listo para cerrar el día?',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.fraunces(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: context.textPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  isCompleted
                      ? 'Podés reabrir para editar en cualquier momento.'
                      : 'Tomate un segundo para mirar lo que pasó.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: context.textSecondary,
                  ),
                ),
                const SizedBox(height: 20),
                // 2x2 recap grid
                Row(
                  children: [
                    Expanded(
                      child: _StatTile(
                        label: 'Tareas',
                        value: '$tasksDone/$tasksTotal',
                        icon: Icons.task_alt_rounded,
                        color: AppTheme.colorSuccess,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _StatTile(
                        label: 'Hábitos',
                        value: '$habitsDone/$habitsTotal',
                        icon: Icons.loop_rounded,
                        color: AppTheme.colorPrimary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: _StatTile(
                        label: 'Ánimo',
                        value: moodEmoji,
                        icon: Icons.favorite_rounded,
                        color: AppTheme.colorAccent,
                        isEmoji: true,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _StatTile(
                        label: 'Notas',
                        value: patterns.trim().isEmpty
                            ? '—'
                            : patterns.trim().length.toString(),
                        icon: Icons.edit_note_rounded,
                        color: AppTheme.colorWarning,
                        subtitle: patterns.trim().isEmpty
                            ? 'sin notas'
                            : 'caracteres',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          if (!isCompleted)
            FilledButton(
              onPressed: onClose,
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: AppTheme.r12),
              ),
              child: Text(
                'Cerrar el día',
                style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: onBack,
            child: Text(
              'Volver',
              style: GoogleFonts.inter(
                fontSize: 14,
                color: context.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  final bool isEmoji;
  final String? subtitle;

  const _StatTile({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    this.isEmoji = false,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: context.surfaceElevated,
        borderRadius: AppTheme.r12,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 14, color: color),
              const SizedBox(width: 6),
              Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: context.textTertiary,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: isEmoji
                ? const TextStyle(fontSize: 28)
                : GoogleFonts.fraunces(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: context.textPrimary,
                  ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 2),
            Text(
              subtitle!,
              style: GoogleFonts.inter(
                fontSize: 11,
                color: context.textTertiary,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// READ-ONLY SUMMARY VIEW (revisión cerrada)
// ═══════════════════════════════════════════════════════════════════════════

/// Vista unificada en una sola pantalla scrollable. Muestra todo el
/// detalle de una revisión cerrada — tareas, hábitos, ánimo y notas —
/// sin necesidad de apretar "Siguiente". Se reserva para `readOnly`;
/// cuando la revisión está abierta seguimos con el wizard de 4 pasos.
class _ReadOnlyReviewSummary extends ConsumerWidget {
  const _ReadOnlyReviewSummary({required this.review, required this.dayId});

  final DailyReview review;
  final String dayId;

  static const _faces = ['😞', '😕', '😐', '🙂', '😄'];
  static const _moodLabels = ['Muy mal', 'Mal', 'Neutral', 'Bien', 'Genial'];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
      children: [
        // ── Tareas ────────────────────────────────────────────────────
        const _RoSectionTitle(label: 'TAREAS', color: AppTheme.colorSuccess),
        const SizedBox(height: 8),
        StreamBuilder<List<Task>>(
          stream: ref.read(taskServiceProvider).watchTasksByDay(dayId),
          builder: (_, snap) {
            final tasks = snap.data ?? const <Task>[];
            final own = tasks
                .where((t) => t.parentProjectId == null ||
                    t.parentProjectId!.isEmpty)
                .toList();
            final completed =
                own.where((t) => t.status == TaskStatus.done).toList();
            final pending =
                own.where((t) => t.status != TaskStatus.done).toList();
            return _RoCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _RoStat(
                    label: 'Completadas',
                    value: '${completed.length}',
                    tone: AppTheme.colorSuccess,
                  ),
                  _RoStat(
                    label: 'Pendientes',
                    value: '${pending.length}',
                    tone: pending.isEmpty ? null : AppTheme.colorWarning,
                  ),
                  if (completed.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Divider(height: 1, color: context.dividerColor),
                    const SizedBox(height: 8),
                    Text(
                      'COMPLETASTE',
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: context.textTertiary,
                        letterSpacing: 0.6,
                      ),
                    ),
                    const SizedBox(height: 6),
                    for (final t in completed)
                      _RoTaskRow(task: t, isDone: true),
                  ],
                  if (pending.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Divider(height: 1, color: context.dividerColor),
                    const SizedBox(height: 8),
                    Text(
                      'QUEDARON PENDIENTES',
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: context.textTertiary,
                        letterSpacing: 0.6,
                      ),
                    ),
                    const SizedBox(height: 6),
                    for (final t in pending) _RoTaskRow(task: t, isDone: false),
                  ],
                ],
              ),
            );
          },
        ),

        const SizedBox(height: 20),

        // ── Hábitos ───────────────────────────────────────────────────
        const _RoSectionTitle(label: 'HÁBITOS', color: AppTheme.colorPrimary),
        const SizedBox(height: 8),
        _RoHabitsCard(dayId: dayId),

        const SizedBox(height: 20),

        // ── Diario ────────────────────────────────────────────────────
        const _RoSectionTitle(
            label: 'DIARIO DEL DÍA', color: AppTheme.colorAccent),
        const SizedBox(height: 8),
        _RoCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (review.mood != null)
                _RoStat(
                  label: 'Ánimo',
                  value:
                      '${_faces[review.mood! - 1]}  ${_moodLabels[review.mood! - 1]}',
                )
              else
                const _RoStat(label: 'Ánimo', value: '—'),
              _RoStat(
                label: 'Fumaste',
                value: review.smoked == null
                    ? '—'
                    : (review.smoked! ? 'Sí' : 'No'),
                tone: review.smoked == true ? AppTheme.colorDanger : null,
              ),
              _RoStat(
                label: 'Medicación',
                value: review.tookMedication == null
                    ? '—'
                    : (review.tookMedication! ? 'Sí' : 'No'),
                tone: review.tookMedication == true
                    ? AppTheme.colorPrimary
                    : null,
              ),
              if ((review.moodNote ?? '').trim().isNotEmpty) ...[
                const SizedBox(height: 10),
                Divider(height: 1, color: context.dividerColor),
                const SizedBox(height: 10),
                Text(
                  '¿CÓMO TE SENTISTE?',
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: context.textTertiary,
                    letterSpacing: 0.6,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  review.moodNote!,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: context.textPrimary,
                    height: 1.45,
                  ),
                ),
              ],
              if ((review.patterns ?? '').trim().isNotEmpty) ...[
                const SizedBox(height: 10),
                Divider(height: 1, color: context.dividerColor),
                const SizedBox(height: 10),
                Text(
                  'PATRONES / NOTAS',
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: context.textTertiary,
                    letterSpacing: 0.6,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  review.patterns!,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: context.textPrimary,
                    height: 1.45,
                  ),
                ),
              ],
              if ((review.highlights ?? '').trim().isNotEmpty) ...[
                const SizedBox(height: 10),
                Divider(height: 1, color: context.dividerColor),
                const SizedBox(height: 10),
                Text(
                  'HIGHLIGHTS',
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: context.textTertiary,
                    letterSpacing: 0.6,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  review.highlights!,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: context.textPrimary,
                    height: 1.45,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _RoSectionTitle extends StatelessWidget {
  const _RoSectionTitle({required this.label, required this.color});
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(shape: BoxShape.circle, color: color),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: color,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }
}

class _RoCard extends StatelessWidget {
  const _RoCard({required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      decoration: BoxDecoration(
        color: context.surfaceCard,
        borderRadius: AppTheme.r12,
        border: Border.all(color: context.dividerColor),
      ),
      child: child,
    );
  }
}

class _RoStat extends StatelessWidget {
  const _RoStat({required this.label, required this.value, this.tone});
  final String label;
  final String value;
  final Color? tone;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 13,
                color: context.textSecondary,
              ),
            ),
          ),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: tone ?? context.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class _RoTaskRow extends StatelessWidget {
  const _RoTaskRow({required this.task, required this.isDone});
  final Task task;
  final bool isDone;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            isDone
                ? Icons.check_circle_rounded
                : Icons.radio_button_unchecked_rounded,
            size: 16,
            color: isDone ? AppTheme.colorSuccess : context.textTertiary,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              task.title,
              style: GoogleFonts.inter(
                fontSize: 13,
                color: isDone ? context.textTertiary : context.textPrimary,
                decoration: isDone ? TextDecoration.lineThrough : null,
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RoHabitsCard extends ConsumerWidget {
  const _RoHabitsCard({required this.dayId});
  final String dayId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return StreamBuilder<List<Habit>>(
      stream: ref.read(habitServiceProvider).watchActiveHabits(),
      builder: (_, habitSnap) {
        return StreamBuilder<List<HabitCompletion>>(
          stream:
              ref.read(habitServiceProvider).watchCompletionsForDay(dayId),
          builder: (_, compSnap) {
            final habits = habitSnap.data ?? const <Habit>[];
            final doneIds =
                (compSnap.data ?? const []).map((c) => c.habitId).toSet();
            final done =
                habits.where((h) => doneIds.contains(h.id)).toList();
            final missed =
                habits.where((h) => !doneIds.contains(h.id)).toList();

            return _RoCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _RoStat(
                    label: 'Cumplidos',
                    value: '${done.length} / ${habits.length}',
                    tone: done.length == habits.length && habits.isNotEmpty
                        ? AppTheme.colorSuccess
                        : null,
                  ),
                  if (done.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Divider(height: 1, color: context.dividerColor),
                    const SizedBox(height: 8),
                    for (final h in done)
                      _RoHabitRow(habit: h, isDone: true),
                  ],
                  if (missed.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Divider(height: 1, color: context.dividerColor),
                    const SizedBox(height: 8),
                    Text(
                      'NO CUMPLISTE',
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: context.textTertiary,
                        letterSpacing: 0.6,
                      ),
                    ),
                    const SizedBox(height: 6),
                    for (final h in missed)
                      _RoHabitRow(habit: h, isDone: false),
                  ],
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class _RoHabitRow extends StatelessWidget {
  const _RoHabitRow({required this.habit, required this.isDone});
  final Habit habit;
  final bool isDone;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(
            habit.icon != null && habit.icon!.isNotEmpty ? habit.icon! : '•',
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              habit.title,
              style: GoogleFonts.inter(
                fontSize: 13,
                color: isDone ? context.textPrimary : context.textTertiary,
              ),
            ),
          ),
          Icon(
            isDone
                ? Icons.check_circle_rounded
                : Icons.cancel_outlined,
            size: 16,
            color:
                isDone ? AppTheme.colorSuccess : context.textTertiary,
          ),
        ],
      ),
    );
  }
}
