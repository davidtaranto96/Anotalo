import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/format_utils.dart';
import '../../../../core/logic/user_prefs.dart';
import '../providers/timer_provider.dart';
import '../../domain/models/timer_state.dart';
import '../../../hoy/domain/models/task.dart';
import '../../../hoy/presentation/providers/task_provider.dart';
import '../widgets/timer_ring.dart';
import '../widgets/timer_mode_selector.dart';

class EnfoquePage extends ConsumerWidget {
  const EnfoquePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(timerNotifierProvider);
    final notifier = ref.read(timerNotifierProvider.notifier);
    final todayTasksAsync = ref.watch(todayTasksProvider);

    // Apply user's preferred default timer mode on idle (fires when prefs load
    // and when user changes the default in Settings).
    ref.listen<UserPrefs>(userPrefsProvider, (prev, next) {
      if (state.status == TimerStatus.idle && state.mode != next.defaultTimerMode) {
        notifier.setMode(next.defaultTimerMode);
      }
    });

    // Show completion dialog when a session ends. If a task is linked we ask
    // whether to mark it done or add more time to finish it.
    ref.listen<TimerState>(timerNotifierProvider, (prev, next) {
      final justCompleted = prev?.status != TimerStatus.completed &&
          next.status == TimerStatus.completed;
      if (!justCompleted) return;
      final tasks = ref.read(todayTasksProvider).valueOrNull ?? [];
      Task? linked;
      if (next.linkedTaskId != null) {
        try {
          linked = tasks.firstWhere((t) => t.id == next.linkedTaskId);
        } catch (_) {}
      }
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!context.mounted) return;
        _showCompletionSheet(context, ref, linked);
      });
    });

    final todayTasks = (todayTasksAsync.valueOrNull ?? [])
        .where((t) => t.status != TaskStatus.done && t.status != TaskStatus.deleted)
        .toList();

    // Find linked task title
    Task? linkedTask;
    if (state.linkedTaskId != null) {
      try {
        linkedTask = todayTasks.firstWhere((t) => t.id == state.linkedTaskId);
      } catch (_) {}
    }

    return Scaffold(
      backgroundColor: context.surfaceBase,
      body: SafeArea(
        child: Column(
          children: [
            // ── Header ──────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '🎯 Enfoque',
                        style: GoogleFonts.lora(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          color: context.textPrimary,
                          letterSpacing: -0.3,
                        ),
                      ),
                      Text(
                        'Mantené el foco',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          color: context.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  if (state.sessionsCompleted > 0)
                    Row(
                      children: [
                        const Icon(Icons.bolt_rounded, color: AppTheme.colorWarning, size: 18),
                        const SizedBox(width: 2),
                        Text(
                          '${state.sessionsCompleted} sesiones',
                          style: GoogleFonts.inter(fontSize: 13, color: AppTheme.colorWarning),
                        ),
                      ],
                    ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // ── Task dropdown ────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: GestureDetector(
                onTap: () => _showTaskPicker(context, todayTasks, state.linkedTaskId, notifier),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: context.surfaceCard,
                    borderRadius: AppTheme.r12,
                    border: Border.all(color: context.dividerColor),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.task_alt_rounded, size: 16, color: context.textTertiary),
                      const SizedBox(width: 8),
                      if (linkedTask != null) ...[
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _priorityColor(linkedTask.priority),
                          ),
                        ),
                        const SizedBox(width: 6),
                      ],
                      Expanded(
                        child: Text(
                          linkedTask?.title ?? 'Seleccionar tarea (opcional)',
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            color: linkedTask != null ? context.textPrimary : context.textTertiary,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Icon(Icons.expand_more_rounded, size: 18, color: context.textTertiary),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),

            // ── Mode selector ────────────────────────────────────────────
            TimerModeSelector(
              selected: state.mode,
              onSelect: (mode) {
                if (state.status != TimerStatus.running) {
                  notifier.setMode(mode);
                }
              },
            ),

            const Spacer(),

            // ── Timer ring ───────────────────────────────────────────────
            TimerRing(
              progress: state.progress,
              timeDisplay: formatDuration(state.remainingSeconds),
              isRunning: state.status == TimerStatus.running,
            ),
            const SizedBox(height: 12),

            // Mode label
            Text(
              _modeLabel(state.mode),
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: context.textTertiary,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              _statusLabel(state.status),
              style: GoogleFonts.inter(fontSize: 14, color: context.textSecondary),
            ),

            const Spacer(),

            // ── Controls ─────────────────────────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (state.status != TimerStatus.idle)
                  IconButton(
                    onPressed: notifier.stop,
                    icon: const Icon(Icons.stop_rounded),
                    color: AppTheme.colorDanger,
                    iconSize: 32,
                    style: IconButton.styleFrom(
                      backgroundColor: AppTheme.colorDangerLight,
                      padding: const EdgeInsets.all(16),
                    ),
                  ),
                const SizedBox(width: 20),
                GestureDetector(
                  onTap: notifier.toggle,
                  child: Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppTheme.colorPrimary,
                      boxShadow: AppTheme.shadowMd,
                    ),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 250),
                      child: Icon(
                        key: ValueKey(state.status),
                        state.status == TimerStatus.running
                            ? Icons.pause_rounded
                            : state.status == TimerStatus.completed
                                ? Icons.refresh_rounded
                                : Icons.play_arrow_rounded,
                        color: Colors.white,
                        size: 36,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  void _showTaskPicker(
    BuildContext context,
    List<Task> tasks,
    String? currentId,
    dynamic notifier,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
        decoration: BoxDecoration(
          color: context.surfaceSheet,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          boxShadow: AppTheme.shadowLg,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40, height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: context.dividerColor,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),
            Text(
              'Tarea a enfocar',
              style: GoogleFonts.lora(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: context.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            // No task option
            _TaskOption(
              title: 'Sin tarea específica',
              isSelected: currentId == null,
              onTap: () {
                notifier.setLinkedTask(null);
                Navigator.pop(context);
              },
            ),
            ...tasks.map((t) => _TaskOption(
              title: t.title,
              priority: t.priority,
              isSelected: t.id == currentId,
              onTap: () {
                notifier.setLinkedTask(t.id);
                Navigator.pop(context);
              },
            )),
          ],
        ),
      ),
    );
  }

  String _modeLabel(TimerMode m) => switch (m) {
    TimerMode.pomodoro25 => '\u{1F345} POMODORO 25 MIN',
    TimerMode.pomodoro50 => '\u{1F525} POMODORO 50 MIN',
    TimerMode.deepWork90 => '\u{1F9E0} TRABAJO PROFUNDO 90 MIN',
    TimerMode.quick5     => '\u26A1 R\u00c1PIDO 5 MIN',
    TimerMode.break5     => '\u2615 DESCANSO 5 MIN',
    TimerMode.break10    => '\u2615 DESCANSO 10 MIN',
    TimerMode.break15    => '\u2615 DESCANSO 15 MIN',
  };

  Color _priorityColor(TaskPriority p) => switch (p) {
    TaskPriority.primordial  => AppTheme.colorDanger,
    TaskPriority.importante  => AppTheme.colorWarning,
    TaskPriority.puedeEsperar => AppTheme.colorPrimary,
    TaskPriority.secundaria  => AppTheme.neutral400,
  };

  String _statusLabel(TimerStatus s) => switch (s) {
    TimerStatus.idle      => 'Listo para comenzar',
    TimerStatus.running   => 'En progreso...',
    TimerStatus.paused    => 'Pausado',
    TimerStatus.completed => '¡Sesión completada!',
  };
}

/// Bottom sheet shown when a focus session ends. Offers to mark the linked
/// task as done, extend the timer by N minutes, or close.
void _showCompletionSheet(BuildContext context, WidgetRef ref, Task? linkedTask) {
  HapticFeedback.mediumImpact();
  showModalBottomSheet<void>(
    context: context,
    isDismissible: true,
    backgroundColor: Colors.transparent,
    builder: (sheetCtx) {
      return Container(
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
        decoration: BoxDecoration(
          color: sheetCtx.surfaceSheet,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          boxShadow: AppTheme.shadowLg,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 14),
                decoration: BoxDecoration(
                  color: sheetCtx.dividerColor,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),
            Row(
              children: [
                const Text('🎉', style: TextStyle(fontSize: 26)),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    '¡Sesión completada!',
                    style: GoogleFonts.lora(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: sheetCtx.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
            if (linkedTask != null) ...[
              const SizedBox(height: 8),
              Text(
                '¿Completaste "${linkedTask.title}"?',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: sheetCtx.textSecondary,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: () async {
                        HapticFeedback.lightImpact();
                        await ref
                            .read(taskServiceProvider)
                            .completeTask(linkedTask.id);
                        ref.read(timerNotifierProvider.notifier).resetToIdle();
                        if (sheetCtx.mounted) Navigator.of(sheetCtx).pop();
                      },
                      icon: const Icon(Icons.check_rounded),
                      label: const Text('Completada'),
                      style: FilledButton.styleFrom(
                        backgroundColor: AppTheme.colorSuccess,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
            ] else ...[
              const SizedBox(height: 10),
              Text(
                '¿Querés agregar más tiempo o terminar?',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: sheetCtx.textSecondary,
                ),
              ),
              const SizedBox(height: 16),
            ],
            Text(
              'Agregar tiempo',
              style: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: sheetCtx.textTertiary,
                letterSpacing: 1.0,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                for (final mins in const [5, 10, 15])
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(right: mins == 15 ? 0 : 6),
                      child: OutlinedButton(
                        onPressed: () {
                          HapticFeedback.lightImpact();
                          ref
                              .read(timerNotifierProvider.notifier)
                              .extendBy(mins * 60);
                          if (sheetCtx.mounted) Navigator.of(sheetCtx).pop();
                        },
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          side: BorderSide(color: sheetCtx.dividerColor),
                          foregroundColor: AppTheme.colorPrimary,
                        ),
                        child: Text('+$mins min',
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            )),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () {
                ref.read(timerNotifierProvider.notifier).resetToIdle();
                if (sheetCtx.mounted) Navigator.of(sheetCtx).pop();
              },
              child: Text(
                'Terminar',
                style: GoogleFonts.inter(
                  color: sheetCtx.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}

class _TaskOption extends StatelessWidget {
  final String title;
  final TaskPriority? priority;
  final bool isSelected;
  final VoidCallback onTap;

  const _TaskOption({
    required this.title,
    this.priority,
    required this.isSelected,
    required this.onTap,
  });

  static Color _priorityColor(TaskPriority p) => switch (p) {
    TaskPriority.primordial   => AppTheme.colorDanger,
    TaskPriority.importante   => AppTheme.colorWarning,
    TaskPriority.puedeEsperar => AppTheme.colorPrimary,
    TaskPriority.secundaria   => AppTheme.neutral400,
  };

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 6),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.colorPrimaryLight : Colors.transparent,
          borderRadius: AppTheme.r12,
          border: Border.all(
            color: isSelected ? AppTheme.colorPrimary : context.dividerColor,
          ),
        ),
        child: Row(
          children: [
            if (priority != null) ...[
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _priorityColor(priority!),
                ),
              ),
              const SizedBox(width: 8),
            ],
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: isSelected ? AppTheme.colorPrimary : context.textPrimary,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ),
            if (isSelected)
              const Icon(Icons.check_rounded, color: AppTheme.colorPrimary, size: 18),
          ],
        ),
      ),
    );
  }
}
