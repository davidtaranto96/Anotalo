import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/format_utils.dart';
import '../../../habitos/presentation/providers/habit_provider.dart';
import '../../../hoy/presentation/providers/task_provider.dart';
import '../providers/daily_review_provider.dart';
import 'review_history_page.dart' show ReviewHistoryPage;

/// Resumen semanal — agrega los daily reviews + tasks + habits de los
/// últimos 7 días (lunes a domingo de la semana actual). Mostrá
/// completadas, mejor día, mood promedio, hábitos cumplidos, días que
/// fumó / tomó medicación, y los highlights/patrones del journal.
class WeeklyReviewPage extends ConsumerWidget {
  const WeeklyReviewPage({super.key});

  /// Devuelve los 7 dayIds (lunes → domingo) de la semana actual.
  List<String> _currentWeekIds() {
    final now = DateTime.now();
    final monday = DateTime(now.year, now.month, now.day)
        .subtract(Duration(days: now.weekday - 1));
    return List.generate(7, (i) => dateToId(monday.add(Duration(days: i))));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weekIds = _currentWeekIds();
    final monday = idToDate(weekIds.first);
    final sunday = idToDate(weekIds.last);
    final rangeLabel =
        '${DateFormat('d MMM', 'es').format(monday)} – ${DateFormat('d MMM', 'es').format(sunday)}';

    return Scaffold(
      backgroundColor: context.surfaceBase,
      appBar: AppBar(
        title: Text(
          'Resumen semanal',
          style: GoogleFonts.fraunces(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: context.textPrimary,
            letterSpacing: -0.3,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
          children: [
            // Encabezado con rango
            Text(
              'Semana del $rangeLabel',
              style: GoogleFonts.fraunces(
                fontSize: 26,
                fontWeight: FontWeight.w600,
                color: context.textPrimary,
                letterSpacing: -0.3,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Lo que pasó en estos 7 días, en una mirada.',
              style: GoogleFonts.inter(
                fontSize: 13,
                color: context.textSecondary,
                height: 1.45,
              ),
            ),
            const SizedBox(height: 24),

            // Logros (tareas completadas)
            const _SectionTitle('LOGROS', AppTheme.colorSuccess),
            const SizedBox(height: 8),
            _TasksSummary(weekIds: weekIds),

            const SizedBox(height: 20),

            // Hábitos
            const _SectionTitle('HÁBITOS', AppTheme.colorPrimary),
            const SizedBox(height: 8),
            _HabitsSummary(weekIds: weekIds),

            const SizedBox(height: 20),

            // Mood + journal flags
            const _SectionTitle('SALUD Y ÁNIMO', AppTheme.colorAccent),
            const SizedBox(height: 8),
            _MoodSummary(weekIds: weekIds),

            const SizedBox(height: 20),

            // Highlights + patrones del journal de la semana
            const _SectionTitle('NOTAS DE LA SEMANA', AppTheme.colorWarning),
            const SizedBox(height: 8),
            _JournalSummary(weekIds: weekIds),
          ],
        ),
      ),
    );
  }
}

// ─── Section title ────────────────────────────────────────────────────────────

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.label, this.color);
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

// ─── Card wrapper ─────────────────────────────────────────────────────────────

class _StatsCard extends StatelessWidget {
  const _StatsCard({required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: context.surfaceCard,
        borderRadius: AppTheme.r12,
        border: Border.all(color: context.dividerColor),
      ),
      child: child,
    );
  }
}

class _Pair extends StatelessWidget {
  const _Pair({required this.label, required this.value, this.tone});
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

// ─── Tasks summary ────────────────────────────────────────────────────────────

class _TasksSummary extends ConsumerWidget {
  const _TasksSummary({required this.weekIds});
  final List<String> weekIds;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder<_TaskWeekStats>(
      future: _calc(ref),
      builder: (_, snap) {
        if (snap.connectionState != ConnectionState.done) {
          return const _StatsCard(child: _Loading());
        }
        final s = snap.data!;
        final percent = s.total == 0
            ? 0
            : ((s.completed / s.total) * 100).round();
        return _StatsCard(
          child: Column(
            children: [
              _Pair(
                label: 'Tareas completadas',
                value: '${s.completed} / ${s.total}',
                tone: AppTheme.colorSuccess,
              ),
              _Pair(label: 'Tasa de completado', value: '$percent%'),
              if (s.bestDayLabel != null)
                _Pair(label: 'Mejor día', value: s.bestDayLabel!),
              _Pair(
                label: 'Pendientes que quedan',
                value: '${s.total - s.completed}',
                tone: s.total - s.completed > 0
                    ? AppTheme.colorWarning
                    : null,
              ),
            ],
          ),
        );
      },
    );
  }

  Future<_TaskWeekStats> _calc(WidgetRef ref) async {
    final svc = ref.read(taskServiceProvider);
    var total = 0;
    var completed = 0;
    int bestDayCount = 0;
    String? bestDay;
    for (final id in weekIds) {
      final t = await svc.countTotalToday(id);
      final c = await svc.countCompletedToday(id);
      total += t;
      completed += c;
      if (c > bestDayCount) {
        bestDayCount = c;
        bestDay = id;
      }
    }
    final bestDayLabel = bestDay == null
        ? null
        : '${DateFormat('EEEE', 'es').format(idToDate(bestDay))} ($bestDayCount)';
    return _TaskWeekStats(
      total: total,
      completed: completed,
      bestDayLabel: bestDayLabel,
    );
  }
}

class _TaskWeekStats {
  final int total;
  final int completed;
  final String? bestDayLabel;
  _TaskWeekStats({
    required this.total,
    required this.completed,
    required this.bestDayLabel,
  });
}

// ─── Habits summary ───────────────────────────────────────────────────────────

class _HabitsSummary extends ConsumerWidget {
  const _HabitsSummary({required this.weekIds});
  final List<String> weekIds;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final habitsAsync = ref.watch(activeHabitsProvider);
    return habitsAsync.when(
      loading: () => const _StatsCard(child: _Loading()),
      error: (_, __) => _StatsCard(
        child: Text(
          'No se pudieron cargar los hábitos.',
          style: GoogleFonts.inter(fontSize: 13, color: context.textTertiary),
        ),
      ),
      data: (habits) {
        if (habits.isEmpty) {
          return _StatsCard(
            child: Text(
              'No tenés hábitos activos esta semana.',
              style:
                  GoogleFonts.inter(fontSize: 13, color: context.textTertiary),
            ),
          );
        }
        return _StatsCard(
          child: Column(
            children: [
              for (final h in habits) _HabitWeeklyRow(habit: h, weekIds: weekIds),
            ],
          ),
        );
      },
    );
  }
}

class _HabitWeeklyRow extends ConsumerWidget {
  const _HabitWeeklyRow({required this.habit, required this.weekIds});
  final dynamic habit; // Habit
  final List<String> weekIds;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder<int>(
      future: _doneCount(ref),
      builder: (_, snap) {
        final done = snap.data ?? 0;
        final tone = done >= weekIds.length
            ? AppTheme.colorSuccess
            : (done >= weekIds.length ~/ 2 ? AppTheme.colorWarning : null);
        return _Pair(
          label: '${habit.icon ?? "•"}  ${habit.title}',
          value: '$done / ${weekIds.length}',
          tone: tone,
        );
      },
    );
  }

  Future<int> _doneCount(WidgetRef ref) async {
    final svc = ref.read(habitServiceProvider);
    final completions =
        await svc.watchAllCompletionsForHabit(habit.id).first;
    final ids = (completions as List).map((c) => c.dayId).toSet();
    return weekIds.where(ids.contains).length;
  }
}

// ─── Mood + flags summary ─────────────────────────────────────────────────────

class _MoodSummary extends ConsumerWidget {
  const _MoodSummary({required this.weekIds});
  final List<String> weekIds;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder<_MoodWeekStats>(
      future: _calc(ref),
      builder: (_, snap) {
        if (snap.connectionState != ConnectionState.done) {
          return const _StatsCard(child: _Loading());
        }
        final s = snap.data!;
        final moodLabel = s.avgMood == null
            ? '—'
            : '${ReviewHistoryPage.moodEmoji(s.avgMood!.round())}  ${s.avgMood!.toStringAsFixed(1)}/5';
        return _StatsCard(
          child: Column(
            children: [
              _Pair(label: 'Ánimo promedio', value: moodLabel),
              _Pair(
                label: 'Días que fumaste',
                value: '${s.smokedDays} / ${s.daysWithReview}',
                tone: s.smokedDays > 0 ? AppTheme.colorDanger : null,
              ),
              _Pair(
                label: 'Días con medicación',
                value: '${s.medDays} / ${s.daysWithReview}',
                tone: AppTheme.colorPrimary,
              ),
              _Pair(
                label: 'Revisiones cerradas',
                value: '${s.daysWithReview} / 7',
                tone: s.daysWithReview >= 5 ? AppTheme.colorSuccess : null,
              ),
            ],
          ),
        );
      },
    );
  }

  Future<_MoodWeekStats> _calc(WidgetRef ref) async {
    final svc = ref.read(dailyReviewServiceProvider);
    int moodSum = 0;
    int moodCount = 0;
    int smokedDays = 0;
    int medDays = 0;
    int daysWithReview = 0;
    for (final id in weekIds) {
      final r = await svc.getByDayOnce(id);
      if (r == null || !r.isCompleted) continue;
      daysWithReview++;
      if (r.mood != null) {
        moodSum += r.mood!;
        moodCount++;
      }
      if (r.smoked == true) smokedDays++;
      if (r.tookMedication == true) medDays++;
    }
    return _MoodWeekStats(
      avgMood: moodCount == 0 ? null : moodSum / moodCount,
      smokedDays: smokedDays,
      medDays: medDays,
      daysWithReview: daysWithReview,
    );
  }
}

class _MoodWeekStats {
  final double? avgMood;
  final int smokedDays;
  final int medDays;
  final int daysWithReview;
  _MoodWeekStats({
    required this.avgMood,
    required this.smokedDays,
    required this.medDays,
    required this.daysWithReview,
  });
}

// ─── Journal summary ──────────────────────────────────────────────────────────

class _JournalSummary extends ConsumerWidget {
  const _JournalSummary({required this.weekIds});
  final List<String> weekIds;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder<List<_JournalEntry>>(
      future: _gather(ref),
      builder: (_, snap) {
        if (snap.connectionState != ConnectionState.done) {
          return const _StatsCard(child: _Loading());
        }
        final entries = snap.data ?? [];
        if (entries.isEmpty) {
          return _StatsCard(
            child: Text(
              'No anotaste highlights ni patrones esta semana.',
              style:
                  GoogleFonts.inter(fontSize: 13, color: context.textTertiary),
            ),
          );
        }
        return _StatsCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (final e in entries) ...[
                Text(
                  DateFormat('EEEE d', 'es').format(idToDate(e.dayId)),
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: context.textTertiary,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 4),
                if (e.highlights != null && e.highlights!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Text(
                      '★ ${e.highlights!}',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: context.textPrimary,
                        height: 1.4,
                      ),
                    ),
                  ),
                if (e.patterns != null && e.patterns!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Text(
                      '↻ ${e.patterns!}',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: context.textSecondary,
                        height: 1.4,
                      ),
                    ),
                  ),
              ],
            ],
          ),
        );
      },
    );
  }

  Future<List<_JournalEntry>> _gather(WidgetRef ref) async {
    final svc = ref.read(dailyReviewServiceProvider);
    final out = <_JournalEntry>[];
    for (final id in weekIds) {
      final r = await svc.getByDayOnce(id);
      if (r == null || !r.isCompleted) continue;
      final hasHighlights = (r.highlights ?? '').trim().isNotEmpty;
      final hasPatterns = (r.patterns ?? '').trim().isNotEmpty;
      if (hasHighlights || hasPatterns) {
        out.add(_JournalEntry(
          dayId: id,
          highlights: r.highlights,
          patterns: r.patterns,
        ));
      }
    }
    return out;
  }
}

class _JournalEntry {
  final String dayId;
  final String? highlights;
  final String? patterns;
  _JournalEntry({required this.dayId, this.highlights, this.patterns});
}

// ─── Loading ──────────────────────────────────────────────────────────────────

class _Loading extends StatelessWidget {
  const _Loading();
  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 60,
      child: Center(
        child: SizedBox(
          width: 22,
          height: 22,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      ),
    );
  }
}
