import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/format_utils.dart';
import '../../domain/models/habit.dart';
import '../providers/habit_provider.dart';
import '../widgets/habit_card.dart';
import '../widgets/add_habit_bottom_sheet.dart';

enum _HabitFilter { all, daily, weekly }

class HabitosPage extends ConsumerStatefulWidget {
  const HabitosPage({super.key});

  @override
  ConsumerState<HabitosPage> createState() => _HabitosPageState();
}

class _HabitosPageState extends ConsumerState<HabitosPage> {
  _HabitFilter _filter = _HabitFilter.all;

  @override
  Widget build(BuildContext context) {
    final habitsAsync = ref.watch(activeHabitsProvider);
    final completionsAsync = ref.watch(todayCompletionsProvider);
    final weekAsync = ref.watch(weekCompletionsProvider);
    final completedIds =
        completionsAsync.valueOrNull?.map((c) => c.habitId).toSet() ?? {};

    return Scaffold(
      backgroundColor: context.surfaceBase,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            floating: true,
            backgroundColor: Colors.transparent,
            surfaceTintColor: Colors.transparent,
            title: habitsAsync.when(
              data: (habits) {
                final todayCount = completedIds.length;
                final total = habits.length;
                return Row(
                  children: [
                    Text('Habitos',
                        style: GoogleFonts.fraunces(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          color: context.textPrimary,
                          letterSpacing: -0.3,
                        )),
                    const SizedBox(width: 10),
                    if (total > 0)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: todayCount == total && total > 0
                              ? AppTheme.colorSuccessLight
                              : context.surfaceElevated,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'Hoy: $todayCount/$total',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: todayCount == total && total > 0
                                ? AppTheme.colorSuccess
                                : context.textSecondary,
                          ),
                        ),
                      ),
                  ],
                );
              },
              loading: () => Text('Habitos',
                  style: GoogleFonts.fraunces(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: context.textPrimary)),
              error: (_, __) => Text('Habitos',
                  style: GoogleFonts.fraunces(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: context.textPrimary)),
            ),
            actions: [
              TextButton.icon(
                onPressed: () => AddHabitBottomSheet.show(context),
                icon: const Icon(Icons.add_rounded,
                    size: 18, color: AppTheme.colorPrimary),
                label: Text('Nuevo',
                    style: GoogleFonts.inter(
                        color: AppTheme.colorPrimary,
                        fontWeight: FontWeight.w600,
                        fontSize: 13)),
              ),
            ],
          ),
          // Filter tabs
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  color: context.neutral100,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Row(
                  children: [
                    _FilterTab(
                      label: 'Todos',
                      selected: _filter == _HabitFilter.all,
                      onTap: () => setState(() => _filter = _HabitFilter.all),
                    ),
                    _FilterTab(
                      label: 'Diario',
                      selected: _filter == _HabitFilter.daily,
                      onTap: () =>
                          setState(() => _filter = _HabitFilter.daily),
                    ),
                    _FilterTab(
                      label: 'Semanal',
                      selected: _filter == _HabitFilter.weekly,
                      onTap: () =>
                          setState(() => _filter = _HabitFilter.weekly),
                    ),
                  ],
                ),
              ),
            ),
          ),
          habitsAsync.when(
            data: (habits) {
              final filtered = _filter == _HabitFilter.all
                  ? habits
                  : habits
                      .where((h) => _filter == _HabitFilter.daily
                          ? h.frequency == HabitFrequency.daily
                          : h.frequency == HabitFrequency.weekly)
                      .toList();

              if (filtered.isEmpty) {
                return SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.loop_rounded,
                            color: context.neutral400, size: 48),
                        const SizedBox(height: 16),
                        Text(
                            habits.isEmpty
                                ? 'Sin habitos todavia'
                                : 'Sin habitos en esta categoria',
                            style: GoogleFonts.inter(
                                color: context.textTertiary, fontSize: 16)),
                        const SizedBox(height: 8),
                        if (habits.isEmpty)
                          Text('Toca Nuevo + para agregar uno',
                              style: GoogleFonts.inter(
                                  color: context.textTertiary, fontSize: 13)),
                      ],
                    ),
                  ),
                );
              }

              final weekData = weekAsync.valueOrNull ?? {};

              final dailyHabits = filtered
                  .where((h) => h.frequency == HabitFrequency.daily)
                  .toList();
              final dailyCompleted = dailyHabits
                  .where((h) => completedIds.contains(h.id))
                  .length;

              // Header de la lista. Los hábitos se muestran en orden manual
              // (drag-and-drop con long-press) y se distinguen los
              // completados por el tintado del card.
              return SliverMainAxisGroup(slivers: [
                SliverToBoxAdapter(
                  child: _DailyProgressHero(
                    completed: dailyCompleted,
                    total: dailyHabits.length,
                  ),
                ),
                SliverToBoxAdapter(
                  child: _AtomicStatsCard(habits: filtered),
                ),
                SliverToBoxAdapter(
                  child: _WeeklyTrackerBoard(
                    habits: filtered,
                    weekCompletions: weekData,
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                    child: Row(
                      children: [
                        Container(
                          width: 3,
                          height: 14,
                          decoration: BoxDecoration(
                            color: AppTheme.colorPrimary,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'TUS HÁBITOS',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: context.textTertiary,
                            letterSpacing: 1.2,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 7, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppTheme.colorPrimary.withAlpha(20),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            '${filtered.length}',
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.colorPrimary,
                            ),
                          ),
                        ),
                        const Spacer(),
                        Text(
                          'Mantené ↕ para reordenar',
                          style: GoogleFonts.inter(
                            fontSize: 10,
                            color: context.textTertiary,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Reorderable: mantener apretado para arrastrar arriba/abajo
                SliverReorderableList(
                  itemCount: filtered.length,
                  itemBuilder: (ctx, i) {
                    final habit = filtered[i];
                    final isCompleted = completedIds.contains(habit.id);
                    return ReorderableDelayedDragStartListener(
                      key: ValueKey('habit-${habit.id}'),
                      index: i,
                      child: HabitCard(
                        habit: habit,
                        isCompleted: isCompleted,
                      ),
                    );
                  },
                  onReorder: (oldIndex, newIndex) async {
                    HapticFeedback.mediumImpact();
                    final updated = List<Habit>.from(filtered);
                    final adjustedNew =
                        newIndex > oldIndex ? newIndex - 1 : newIndex;
                    final moved = updated.removeAt(oldIndex);
                    updated.insert(adjustedNew, moved);
                    await ref
                        .read(habitServiceProvider)
                        .reorderHabits(updated.map((h) => h.id).toList());
                  },
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 140)),
              ]);
            },
            loading: () => const SliverFillRemaining(
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (e, _) =>
                SliverFillRemaining(child: Center(child: Text('$e'))),
          ),
        ],
      ),
    );
  }
}

// ─── Weekly Tracker Board ────────────────────────────────────────────────────

class _WeeklyTrackerBoard extends ConsumerWidget {
  final List<Habit> habits;
  final Map<String, Set<String>> weekCompletions;

  const _WeeklyTrackerBoard({
    required this.habits,
    required this.weekCompletions,
  });

  static const _dayLabels = ['L', 'M', 'M', 'J', 'V', 'S', 'D'];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final now = DateTime.now();
    final monday = now.subtract(Duration(days: now.weekday - 1));
    final weekDays =
        List.generate(7, (i) => monday.add(Duration(days: i)));
    final todayIndex = now.weekday - 1; // 0 = Monday

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Container(
        decoration: BoxDecoration(
          color: context.surfaceCard,
          borderRadius: AppTheme.r16,
          border: Border.all(color: context.dividerColor),
          boxShadow: AppTheme.shadowMd,
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with gradient
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppTheme.colorPrimary,
                    AppTheme.colorAccent,
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
              child: Row(
                children: [
                  const Icon(Icons.calendar_view_week_rounded,
                      color: Colors.white, size: 16),
                  const SizedBox(width: 8),
                  Text(
                    'RACHA DE LA SEMANA',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      letterSpacing: 1.0,
                    ),
                  ),
                ],
              ),
            ),
            // Day headers row
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 10, 14, 0),
              child: Row(
                children: [
                  // Space for emoji + title
                  const SizedBox(width: 100),
                  ...List.generate(7, (i) {
                    final isToday = i == todayIndex;
                    return Expanded(
                      child: Center(
                        child: Container(
                          width: 24,
                          height: 24,
                          decoration: isToday
                              ? BoxDecoration(
                                  color: AppTheme.colorPrimary.withAlpha(20),
                                  shape: BoxShape.circle,
                                )
                              : null,
                          alignment: Alignment.center,
                          child: Text(
                            _dayLabels[i],
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              fontWeight:
                                  isToday ? FontWeight.w800 : FontWeight.w600,
                              color: isToday
                                  ? AppTheme.colorPrimary
                                  : context.textTertiary,
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
            const SizedBox(height: 4),
            // Habit rows
            ...List.generate(habits.length, (index) {
              final habit = habits[index];
              return _HabitWeekRow(
                habit: habit,
                weekDays: weekDays,
                weekCompletions: weekCompletions,
                isEven: index.isEven,
                todayIndex: todayIndex,
              );
            }),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

class _HabitWeekRow extends ConsumerWidget {
  final Habit habit;
  final List<DateTime> weekDays;
  final Map<String, Set<String>> weekCompletions;
  final bool isEven;
  final int todayIndex;

  const _HabitWeekRow({
    required this.habit,
    required this.weekDays,
    required this.weekCompletions,
    required this.isEven,
    required this.todayIndex,
  });

  Color? _parseHabitColor() {
    if (habit.color == null || habit.color!.isEmpty) return null;
    try {
      return Color(int.parse(habit.color!, radix: 16));
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final habitColor = _parseHabitColor() ?? AppTheme.colorPrimary;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      color: isEven ? Colors.transparent : context.surfaceBase.withAlpha(80),
      child: Row(
        children: [
          // Emoji + title
          SizedBox(
            width: 100,
            child: Row(
              children: [
                if (habit.icon != null && habit.icon!.isNotEmpty)
                  Text(habit.icon!, style: const TextStyle(fontSize: 16))
                else
                  Icon(Icons.circle, size: 16, color: context.neutral400),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    habit.title,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: context.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          // 7 day circles
          ...List.generate(7, (dayIndex) {
            final dayId = dateToId(weekDays[dayIndex]);
            final isCompleted =
                weekCompletions[dayId]?.contains(habit.id) ?? false;
            final isToday = dayIndex == todayIndex;
            final isFuture = weekDays[dayIndex].isAfter(DateTime.now());

            return Expanded(
              child: Center(
                child: GestureDetector(
                  onTap: isFuture
                      ? null
                      : () {
                          HapticFeedback.lightImpact();
                          ref
                              .read(habitServiceProvider)
                              .toggleCompletion(habit.id, dayId);
                        },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isCompleted
                          ? habitColor
                          : isFuture
                              ? context.neutral100
                              : Colors.transparent,
                      border: Border.all(
                        color: isCompleted
                            ? habitColor
                            : isToday
                                ? AppTheme.colorPrimary.withAlpha(120)
                                : isFuture
                                    ? context.neutral200
                                    : context.neutral300,
                        width: isToday && !isCompleted ? 2 : 1.5,
                      ),
                      boxShadow: isCompleted
                          ? [
                              BoxShadow(
                                color: habitColor.withAlpha(60),
                                blurRadius: 4,
                                offset: const Offset(0, 1),
                              ),
                            ]
                          : null,
                    ),
                    child: isCompleted
                        ? const Icon(Icons.check_rounded,
                            size: 13, color: Colors.white)
                        : null,
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

// ─── Filter Tab ──────────────────────────────────────────────────────────────

class _FilterTab extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _FilterTab(
      {required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: selected ? context.surfaceCard : Colors.transparent,
            borderRadius: BorderRadius.circular(22),
            boxShadow: selected ? AppTheme.shadowSm : null,
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: selected ? context.textPrimary : context.textTertiary,
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Daily Progress Hero Card ────────────────────────────────────────────────

class _DailyProgressHero extends StatelessWidget {
  final int completed;
  final int total;
  const _DailyProgressHero({required this.completed, required this.total});

  ({String title, String emoji}) _motivational(double pct) {
    if (total == 0) {
      return (title: 'Empezá tu primer hábito', emoji: '🌱');
    }
    if (pct >= 1.0) return (title: '¡Racha perfecta hoy!', emoji: '🔥');
    if (pct >= 0.75) return (title: '¡Casi lo lográs!', emoji: '💪');
    if (pct >= 0.5) return (title: '¡Vas por la mitad!', emoji: '🚀');
    if (pct >= 0.25) return (title: 'Buen comienzo', emoji: '✨');
    return (title: 'Dale, arrancá el día', emoji: '☀️');
  }

  @override
  Widget build(BuildContext context) {
    final pct = total == 0 ? 0.0 : completed / total;
    final msg = _motivational(pct);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          // Subtle gradient like racha_app hero; a bit more tint in dark mode.
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [
                    AppTheme.colorPrimary.withAlpha(30),
                    AppTheme.colorAccent.withAlpha(20),
                  ]
                : [
                    AppTheme.colorPrimary.withAlpha(18),
                    AppTheme.colorAccent.withAlpha(10),
                  ],
          ),
          borderRadius: AppTheme.r16,
          border: Border.all(color: AppTheme.colorPrimary.withAlpha(50)),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 70,
              height: 70,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CustomPaint(
                    size: const Size(70, 70),
                    painter: _ProgressRingPainter(
                      progress: pct,
                      bgColor: context.neutral200,
                      fgColor: AppTheme.colorPrimary,
                    ),
                  ),
                  Text(
                    '${(pct * 100).round()}%',
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: context.textPrimary,
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
                  Row(
                    children: [
                      Text(msg.emoji, style: const TextStyle(fontSize: 18)),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          msg.title,
                          style: GoogleFonts.fraunces(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: context.textPrimary,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    total == 0
                        ? 'Creá tu primer hábito'
                        : '$completed de $total hábitos completados',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: context.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProgressRingPainter extends CustomPainter {
  final double progress;
  final Color bgColor;
  final Color fgColor;

  _ProgressRingPainter({
    required this.progress,
    required this.bgColor,
    required this.fgColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 4;
    const strokeWidth = 6.0;

    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = bgColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth,
    );

    if (progress > 0) {
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        -math.pi / 2,
        2 * math.pi * progress,
        false,
        Paint()
          ..color = fgColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth
          ..strokeCap = StrokeCap.round,
      );
    }
  }

  @override
  bool shouldRepaint(_ProgressRingPainter old) =>
      old.progress != progress ||
      old.bgColor != bgColor ||
      old.fgColor != fgColor;
}

// ─── Atomic Habits stats card ──────────────────────────────────────────────
//
// Inspired by James Clear's "Atomic Habits": identity-first, small compounding
// improvements. Shows: longest streak across all habits, total completions,
// 30-day completion rate, best day of the week, and an identity-style message.

class _AtomicStatsCard extends ConsumerWidget {
  final List<Habit> habits;
  const _AtomicStatsCard({required this.habits});

  static const _dayNames = ['Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb', 'Dom'];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allCompletionsAsync = ref.watch(allCompletionsProvider);

    return allCompletionsAsync.when(
      loading: () => const SizedBox(height: 0),
      error: (_, __) => const SizedBox.shrink(),
      data: (completions) {
        if (habits.isEmpty) return const SizedBox.shrink();

        // ── Total completions
        final totalCompletions = completions.length;

        // ── Longest streak across ALL habits (per-habit streaks, take max)
        int longestStreak = 0;
        // Group completions by habitId
        final byHabit = <String, List<String>>{};
        for (final c in completions) {
          byHabit.putIfAbsent(c.habitId, () => []).add(c.dayId);
        }
        for (final days in byHabit.values) {
          final sorted = List<String>.from(days)..sort((a, b) => b.compareTo(a));
          int run = 0;
          DateTime? expected;
          for (final d in sorted) {
            final date = idToDate(d);
            if (expected == null) {
              run = 1;
              expected = date.subtract(const Duration(days: 1));
            } else if (dateToId(expected) == d) {
              run++;
              expected = date.subtract(const Duration(days: 1));
            } else {
              if (run > longestStreak) longestStreak = run;
              run = 1;
              expected = date.subtract(const Duration(days: 1));
            }
          }
          if (run > longestStreak) longestStreak = run;
        }

        // ── 30-day completion rate
        final today = DateTime.now();
        final last30 = List.generate(30, (i) {
          final d = today.subtract(Duration(days: i));
          return dateToId(DateTime(d.year, d.month, d.day));
        }).toSet();
        final dailyHabitsCount = habits
            .where((h) => h.frequency == HabitFrequency.daily)
            .length;
        final completionsIn30 = completions
            .where((c) => last30.contains(c.dayId))
            .length;
        final expectedIn30 = dailyHabitsCount * 30;
        final rate30 = expectedIn30 == 0
            ? 0.0
            : (completionsIn30 / expectedIn30).clamp(0.0, 1.0);

        // ── Best day of the week
        final perWeekday = List<int>.filled(7, 0);
        for (final c in completions) {
          final d = idToDate(c.dayId);
          perWeekday[d.weekday - 1]++;
        }
        int bestDayIdx = 0;
        for (int i = 1; i < 7; i++) {
          if (perWeekday[i] > perWeekday[bestDayIdx]) bestDayIdx = i;
        }
        final hasBestDay = perWeekday[bestDayIdx] > 0;

        // ── Identity line (Atomic Habits framing)
        final identity = _identityLine(habits, longestStreak, rate30);

        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: context.surfaceCard,
              borderRadius: AppTheme.r16,
              border: Border.all(color: context.dividerColor),
              boxShadow: AppTheme.shadowSm,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text('⚛️', style: TextStyle(fontSize: 16)),
                    const SizedBox(width: 6),
                    Text(
                      'HÁBITOS ATÓMICOS',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: context.textTertiary,
                        letterSpacing: 1.1,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                // Stats grid — 2×2
                Row(
                  children: [
                    Expanded(
                      child: _StatTile(
                        icon: Icons.local_fire_department_rounded,
                        iconColor: AppTheme.colorWarning,
                        value: '$longestStreak',
                        label: 'Mejor racha',
                        sub: longestStreak == 1 ? 'día' : 'días',
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _StatTile(
                        icon: Icons.check_circle_rounded,
                        iconColor: AppTheme.colorSuccess,
                        value: '$totalCompletions',
                        label: 'Completados',
                        sub: 'todo el tiempo',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: _StatTile(
                        icon: Icons.show_chart_rounded,
                        iconColor: AppTheme.colorPrimary,
                        value: '${(rate30 * 100).round()}%',
                        label: 'Cumplimiento',
                        sub: 'últimos 30 días',
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _StatTile(
                        icon: Icons.star_rounded,
                        iconColor: AppTheme.colorAccent,
                        value: hasBestDay ? _dayNames[bestDayIdx] : '—',
                        label: 'Mejor día',
                        sub: hasBestDay
                            ? '${perWeekday[bestDayIdx]} veces'
                            : 'aún no hay datos',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Identity banner
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: AppTheme.colorPrimary.withAlpha(18),
                    borderRadius: AppTheme.r12,
                    border: Border.all(
                        color: AppTheme.colorPrimary.withAlpha(50)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.auto_awesome_rounded,
                          size: 16, color: AppTheme.colorPrimary),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          identity,
                          style: GoogleFonts.inter(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.colorPrimary,
                            height: 1.3,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _identityLine(List<Habit> habits, int longestStreak, double rate30) {
    if (longestStreak == 0) {
      return 'Cada pequeña acción es un voto por la persona que querés ser.';
    }
    if (rate30 >= 0.8) {
      return 'Sos alguien que cumple con lo que se propone.';
    }
    if (rate30 >= 0.5) {
      return 'Paso a paso estás construyendo mejores hábitos.';
    }
    if (longestStreak >= 7) {
      return 'Tu mejor racha demuestra de qué sos capaz.';
    }
    return 'Lo que hacés hoy define lo que serás mañana.';
  }
}

class _StatTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String value;
  final String label;
  final String sub;
  const _StatTile({
    required this.icon,
    required this.iconColor,
    required this.value,
    required this.label,
    required this.sub,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: context.surfaceBase,
        borderRadius: AppTheme.r12,
        border: Border.all(color: context.dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 14, color: iconColor),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  label,
                  style: GoogleFonts.inter(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w600,
                    color: context.textTertiary,
                    letterSpacing: 0.4,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: GoogleFonts.fraunces(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: context.textPrimary,
              height: 1.0,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            sub,
            style: GoogleFonts.inter(
              fontSize: 10.5,
              color: context.textTertiary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
