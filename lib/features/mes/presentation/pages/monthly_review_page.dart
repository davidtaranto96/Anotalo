import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../../core/models/task_area.dart';
import '../../../../core/providers/task_area_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/format_utils.dart';
import '../../../habitos/domain/models/habit.dart';
import '../../../habitos/presentation/providers/habit_provider.dart';
import '../../../hoy/domain/models/task.dart';
import '../../../hoy/presentation/providers/task_provider.dart';

/// Pantalla de valoración del mes: completado vs pendiente, ratios por
/// área, hábitos cumplidos, mejor día, etc. Lectura corrida — sin
/// inputs, sólo lectura.
class MonthlyReviewPage extends ConsumerWidget {
  const MonthlyReviewPage({super.key, required this.month});
  final DateTime month;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final from = DateTime(month.year, month.month, 1);
    final to = DateTime(month.year, month.month + 1, 0);
    final fromId = dateToId(from);
    final toId = dateToId(to);

    final tasksAsync = ref.watch(_monthTasksProvider((fromId, toId)));
    final habitsAsync = ref.watch(activeHabitsProvider);
    final completionsAsync = ref.watch(allCompletionsProvider);
    final areas = ref.watch(taskAreasSyncProvider);

    final monthLabel = DateFormat("MMMM 'de' yyyy", 'es')
        .format(month)
        .replaceFirstMapped(
            RegExp(r'^[a-zñáéíóú]'), (m) => m.group(0)!.toUpperCase());

    return Scaffold(
      backgroundColor: context.surfaceBase,
      appBar: AppBar(
        title: Text(
          'Valoración',
          style: GoogleFonts.fraunces(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: context.textPrimary,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        iconTheme: IconThemeData(color: context.textSecondary),
      ),
      body: tasksAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
        data: (tasks) {
          final habits = habitsAsync.valueOrNull ?? const <Habit>[];
          final completions =
              completionsAsync.valueOrNull ?? const [];

          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 40),
            children: [
              Text(
                'NOVEDADES DEL MES',
                style: GoogleFonts.inter(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.colorPrimary,
                  letterSpacing: 1.6,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                monthLabel,
                style: GoogleFonts.fraunces(
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                  color: context.textPrimary,
                  letterSpacing: -0.4,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Cómo te fue este mes — un resumen organizado por áreas, '
                'hábitos y prioridades.',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: context.textSecondary,
                  height: 1.45,
                ),
              ),
              const SizedBox(height: 24),

              // ── Completado vs pendiente ────────────────────────────
              _SectionTitle(label: 'TAREAS', color: AppTheme.colorSuccess),
              const SizedBox(height: 8),
              _CompletionTile(tasks: tasks),

              const SizedBox(height: 20),

              // ── Por área ───────────────────────────────────────────
              _SectionTitle(label: 'POR ÁREA', color: AppTheme.colorPrimary),
              const SizedBox(height: 8),
              _ByAreaTile(tasks: tasks, areas: areas),

              const SizedBox(height: 20),

              // ── Por prioridad ──────────────────────────────────────
              _SectionTitle(label: 'POR PRIORIDAD', color: AppTheme.colorWarning),
              const SizedBox(height: 8),
              _ByPriorityTile(tasks: tasks),

              const SizedBox(height: 20),

              // ── Hábitos ────────────────────────────────────────────
              _SectionTitle(label: 'HÁBITOS', color: AppTheme.colorAccent),
              const SizedBox(height: 8),
              _HabitsRecapTile(
                habits: habits,
                completions: completions,
                month: month,
              ),

              const SizedBox(height: 20),

              // ── Día más productivo ─────────────────────────────────
              _SectionTitle(
                  label: 'MEJOR DÍA', color: AppTheme.colorPrimary),
              const SizedBox(height: 8),
              _BestDayTile(tasks: tasks),

              const SizedBox(height: 20),

              // ── Pendientes que quedaron ────────────────────────────
              _SectionTitle(
                  label: 'TE QUEDA HACER', color: AppTheme.colorDanger),
              const SizedBox(height: 8),
              _PendingTile(tasks: tasks),
            ],
          );
        },
      ),
    );
  }
}

// ─── Provider local: tareas del mes en cuestión ─────────────────────────────

final _monthTasksProvider =
    StreamProvider.family<List<Task>, (String, String)>((ref, range) {
  return ref
      .watch(taskServiceProvider)
      .watchTasksInRange(range.$1, range.$2);
});

// ─── Tiles ───────────────────────────────────────────────────────────────────

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.label, required this.color});
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 3,
          height: 14,
          decoration: BoxDecoration(
              color: color, borderRadius: BorderRadius.circular(2)),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: color,
            letterSpacing: 1.0,
          ),
        ),
      ],
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: context.surfaceCard,
          borderRadius: AppTheme.r16,
          border: Border.all(color: context.dividerColor),
        ),
        child: child,
      );
}

class _CompletionTile extends StatelessWidget {
  const _CompletionTile({required this.tasks});
  final List<Task> tasks;

  @override
  Widget build(BuildContext context) {
    final total = tasks.length;
    final done = tasks.where((t) => t.status == TaskStatus.done).length;
    final pct = total == 0 ? 0 : ((done / total) * 100).round();
    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                '$done',
                style: GoogleFonts.fraunces(
                  fontSize: 36,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.colorSuccess,
                ),
              ),
              const SizedBox(width: 6),
              Padding(
                padding: const EdgeInsets.only(top: 14),
                child: Text(
                  'de $total tareas',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: context.textSecondary,
                  ),
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: AppTheme.colorSuccess.withAlpha(30),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  '$pct%',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.colorSuccess,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: total == 0 ? 0 : done / total,
              minHeight: 8,
              backgroundColor: context.dividerColor,
              valueColor: const AlwaysStoppedAnimation(
                  AppTheme.colorSuccess),
            ),
          ),
        ],
      ),
    );
  }
}

class _ByAreaTile extends StatelessWidget {
  const _ByAreaTile({required this.tasks, required this.areas});
  final List<Task> tasks;
  final List<TaskArea> areas;

  @override
  Widget build(BuildContext context) {
    if (tasks.isEmpty) {
      return _Card(
        child: Text(
          'Sin tareas en el mes.',
          style: GoogleFonts.inter(
            fontSize: 13,
            color: context.textSecondary,
          ),
        ),
      );
    }
    final byArea = <String?, ({int total, int done})>{};
    for (final t in tasks) {
      final key = t.area;
      final cur = byArea[key] ?? (total: 0, done: 0);
      byArea[key] = (
        total: cur.total + 1,
        done: cur.done + (t.status == TaskStatus.done ? 1 : 0),
      );
    }
    final entries = byArea.entries.toList()
      ..sort((a, b) => b.value.total.compareTo(a.value.total));

    return _Card(
      child: Column(
        children: [
          for (final e in entries) ...[
            _AreaRow(
              areaId: e.key,
              total: e.value.total,
              done: e.value.done,
              areas: areas,
            ),
            if (e.key != entries.last.key)
              Divider(height: 14, color: context.dividerColor),
          ],
        ],
      ),
    );
  }
}

class _AreaRow extends StatelessWidget {
  const _AreaRow({
    required this.areaId,
    required this.total,
    required this.done,
    required this.areas,
  });
  final String? areaId;
  final int total;
  final int done;
  final List<TaskArea> areas;

  @override
  Widget build(BuildContext context) {
    final area = areaId == null
        ? null
        : (getTaskAreaFrom(areas, areaId!) ?? getTaskArea(areaId!));
    final label = area?.label ?? (areaId == null ? 'Sin área' : areaId!);
    final color = area?.color ?? context.textSecondary;
    final emoji = area?.emoji ?? '📌';
    final pct = total == 0 ? 0.0 : done / total;
    return Row(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 16)),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      label,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: context.textPrimary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    '$done/$total',
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: color,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              ClipRRect(
                borderRadius: BorderRadius.circular(999),
                child: LinearProgressIndicator(
                  value: pct,
                  minHeight: 5,
                  backgroundColor: context.dividerColor,
                  valueColor: AlwaysStoppedAnimation(color),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ByPriorityTile extends StatelessWidget {
  const _ByPriorityTile({required this.tasks});
  final List<Task> tasks;

  static const _priorities = [
    (TaskPriority.primordial, 'Primordial', AppTheme.colorDanger),
    (TaskPriority.importante, 'Importante', AppTheme.colorWarning),
    (TaskPriority.puedeEsperar, 'Puede esperar', AppTheme.colorPrimary),
    (TaskPriority.secundaria, 'Secundaria', AppTheme.neutral400),
  ];

  @override
  Widget build(BuildContext context) {
    return _Card(
      child: Column(
        children: [
          for (final p in _priorities) ...[
            Builder(builder: (_) {
              final filtered =
                  tasks.where((t) => t.priority == p.$1).toList();
              final total = filtered.length;
              final done = filtered
                  .where((t) => t.status == TaskStatus.done)
                  .length;
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: p.$3,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        p.$2,
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          color: context.textPrimary,
                        ),
                      ),
                    ),
                    Text(
                      '$done/$total',
                      style: GoogleFonts.jetBrainsMono(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: p.$3,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ],
      ),
    );
  }
}

class _HabitsRecapTile extends StatelessWidget {
  const _HabitsRecapTile({
    required this.habits,
    required this.completions,
    required this.month,
  });
  final List<Habit> habits;
  final List<HabitCompletion> completions;
  final DateTime month;

  @override
  Widget build(BuildContext context) {
    if (habits.isEmpty) {
      return _Card(
        child: Text(
          'No tenés hábitos activos.',
          style: GoogleFonts.inter(
            fontSize: 13,
            color: context.textSecondary,
          ),
        ),
      );
    }
    // Días del mes
    final lastDay = DateTime(month.year, month.month + 1, 0).day;
    final monthIds = <String>{
      for (var d = 1; d <= lastDay; d++)
        dateToId(DateTime(month.year, month.month, d))
    };
    // Map<habitId, count en el mes>
    final counts = <String, int>{};
    for (final c in completions) {
      if (!monthIds.contains(c.dayId)) continue;
      counts[c.habitId] = (counts[c.habitId] ?? 0) + 1;
    }
    return _Card(
      child: Column(
        children: [
          for (final h in habits) ...[
            _HabitRecapRow(
              habit: h,
              monthDays: lastDay,
              done: counts[h.id] ?? 0,
            ),
            if (h != habits.last)
              Divider(height: 14, color: context.dividerColor),
          ],
        ],
      ),
    );
  }
}

class _HabitRecapRow extends StatelessWidget {
  const _HabitRecapRow({
    required this.habit,
    required this.monthDays,
    required this.done,
  });
  final Habit habit;
  final int monthDays;
  final int done;

  Color _parseColor() {
    if (habit.color == null || habit.color!.isEmpty) {
      return AppTheme.colorPrimary;
    }
    try {
      return Color(int.parse(habit.color!, radix: 16));
    } catch (_) {
      return AppTheme.colorPrimary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _parseColor();
    // Para "weekly" target = (target/7) * monthDays. Para diario = monthDays.
    final expected = habit.frequency == HabitFrequency.daily
        ? monthDays
        : ((habit.targetPerWeek / 7.0) * monthDays).round();
    final pct = expected == 0 ? 0.0 : (done / expected).clamp(0.0, 1.0);
    return Row(
      children: [
        Text(
          (habit.icon != null && habit.icon!.isNotEmpty)
              ? habit.icon!
              : '✨',
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      habit.title,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: context.textPrimary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    '$done/$expected',
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: color,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              ClipRRect(
                borderRadius: BorderRadius.circular(999),
                child: LinearProgressIndicator(
                  value: pct,
                  minHeight: 5,
                  backgroundColor: context.dividerColor,
                  valueColor: AlwaysStoppedAnimation(color),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _BestDayTile extends StatelessWidget {
  const _BestDayTile({required this.tasks});
  final List<Task> tasks;

  @override
  Widget build(BuildContext context) {
    final done = tasks.where((t) => t.status == TaskStatus.done);
    if (done.isEmpty) {
      return _Card(
        child: Text(
          'Aún no completaste tareas en el mes.',
          style: GoogleFonts.inter(
            fontSize: 13,
            color: context.textSecondary,
          ),
        ),
      );
    }
    final perDay = <String, int>{};
    for (final t in done) {
      // Tareas sin dayId no cuentan para "mejor día".
      final d = t.dayId;
      if (d == null) continue;
      perDay[d] = (perDay[d] ?? 0) + 1;
    }
    final sorted = perDay.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final best = sorted.first;
    final date = idToDate(best.key);
    final label = DateFormat("EEEE d 'de' MMMM", 'es')
        .format(date)
        .replaceFirstMapped(
            RegExp(r'^[a-zñáéíóú]'), (m) => m.group(0)!.toUpperCase());
    return _Card(
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppTheme.colorPrimary.withAlpha(30),
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.center,
            child: const Icon(Icons.star_rounded,
                color: AppTheme.colorPrimary, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: context.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${best.value} ${best.value == 1 ? "tarea" : "tareas"} completadas',
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

class _PendingTile extends StatelessWidget {
  const _PendingTile({required this.tasks});
  final List<Task> tasks;

  @override
  Widget build(BuildContext context) {
    final pending = tasks.where((t) => t.status != TaskStatus.done).toList();
    if (pending.isEmpty) {
      return _Card(
        child: Row(
          children: [
            const Icon(Icons.celebration_rounded,
                color: AppTheme.colorSuccess, size: 18),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Cero pendientes — mes redondo.',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: context.textSecondary,
                ),
              ),
            ),
          ],
        ),
      );
    }
    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${pending.length} ${pending.length == 1 ? "tarea quedó" : "tareas quedaron"} sin terminar',
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: context.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Volvelas a programar desde la vista mensual o el día específico.',
            style: GoogleFonts.inter(
              fontSize: 12,
              color: context.textSecondary,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
