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
                        style: GoogleFonts.lora(
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
                  style: GoogleFonts.lora(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: context.textPrimary)),
              error: (_, __) => Text('Habitos',
                  style: GoogleFonts.lora(
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

              return SliverList(
                delegate: SliverChildListDelegate([
                  // Weekly Tracker Board
                  _WeeklyTrackerBoard(
                    habits: filtered,
                    weekCompletions: weekData,
                  ),
                  // Motivational message
                  if (completedIds.length == habits.length && habits.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 4),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 10),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              AppTheme.colorSuccessLight,
                              Color(0xFFD4EDDA),
                            ],
                          ),
                          borderRadius: AppTheme.r12,
                          border: Border.all(
                              color: AppTheme.colorSuccess.withAlpha(60)),
                        ),
                        child: Row(
                          children: [
                            const Text('\u{1F389}',
                                style: TextStyle(fontSize: 18)),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'Todos los habitos de hoy completados!',
                                style: GoogleFonts.inter(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.colorSuccess,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  // Section header
                  Padding(
                    padding:
                        const EdgeInsets.fromLTRB(16, 16, 16, 8),
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
                          'DETALLE',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: context.textTertiary,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Individual habit cards
                  ...filtered.map((habit) => HabitCard(
                        habit: habit,
                        isCompleted: completedIds.contains(habit.id),
                        onLongPress: () {
                          HapticFeedback.mediumImpact();
                          AddHabitBottomSheet.showEdit(context, habit);
                        },
                      )),
                  const SizedBox(height: 140),
                ]),
              );
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
