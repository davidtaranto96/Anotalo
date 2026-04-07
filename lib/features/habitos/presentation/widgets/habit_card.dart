import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/utils/format_utils.dart';
import '../../domain/models/habit.dart';
import '../providers/habit_provider.dart';

class HabitCard extends ConsumerWidget {
  final Habit habit;
  final bool isCompleted;
  final VoidCallback? onLongPress;

  const HabitCard({super.key, required this.habit, required this.isCompleted, this.onLongPress});

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
    final streakAsync = ref.watch(habitStreakProvider(habit.id));
    final habitColor = _parseHabitColor() ?? AppTheme.colorPrimary;

    return GestureDetector(
      onLongPress: onLongPress,
      child: Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isCompleted
            ? AppTheme.colorSuccessLight.withAlpha(180)
            : context.surfaceCard,
        borderRadius: AppTheme.r12,
        border: Border.all(
          color: isCompleted
              ? AppTheme.colorSuccess.withAlpha(60)
              : context.dividerColor,
        ),
        boxShadow: AppTheme.shadowSm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top row: emoji + title + streak + check
          Row(
            children: [
              if (habit.icon != null && habit.icon!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Text(habit.icon!, style: const TextStyle(fontSize: 20)),
                ),
              Expanded(
                child: Text(
                  habit.title,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: context.textPrimary,
                  ),
                ),
              ),
              // Streak
              streakAsync.when(
                data: (streak) => streak > 0
                    ? Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppTheme.colorWarningLight,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.local_fire_department_rounded,
                                color: AppTheme.colorWarning, size: 14),
                            const SizedBox(width: 2),
                            Text('$streak',
                                style: GoogleFonts.inter(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: AppTheme.colorWarning)),
                          ],
                        ),
                      )
                    : const SizedBox.shrink(),
                loading: () => const SizedBox.shrink(),
                error: (_, __) => const SizedBox.shrink(),
              ),
              const SizedBox(width: 8),
              // Completion circle
              GestureDetector(
                onTap: () {
                  HapticFeedback.lightImpact();
                  ref
                      .read(habitServiceProvider)
                      .toggleCompletion(habit.id, todayId());
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isCompleted ? habitColor : Colors.transparent,
                    border: Border.all(
                      color: isCompleted ? habitColor : context.neutral400,
                      width: 2,
                    ),
                  ),
                  child: isCompleted
                      ? const Icon(Icons.check, size: 15, color: Colors.white)
                      : null,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Weekly progress bar
          _WeeklyProgressBar(habitId: habit.id, habitColor: habitColor),
          const SizedBox(height: 8),
          // Mini heatmap: last 30 days
          _MiniHeatmap(habitId: habit.id, habitColor: habitColor),
        ],
      ),
    ),
    );
  }
}

// ─── Weekly Progress Bar ─────────────────────────────────────────────────────

class _WeeklyProgressBar extends ConsumerWidget {
  final String habitId;
  final Color habitColor;
  const _WeeklyProgressBar(
      {required this.habitId, required this.habitColor});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allCompletionsAsync = ref.watch(_habitAllCompletionsProvider(habitId));
    return allCompletionsAsync.when(
      data: (completions) {
        final now = DateTime.now();
        final last7Days = List.generate(
            7, (i) => dateToId(now.subtract(Duration(days: i))));
        final completedDays = completions.map((c) => c.dayId).toSet();
        final count =
            last7Days.where((d) => completedDays.contains(d)).length;
        final fraction = count / 7;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  '$count/7 esta semana',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: context.textTertiary,
                  ),
                ),
                const Spacer(),
                Text(
                  '${(fraction * 100).round()}%',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: fraction >= 0.7
                        ? AppTheme.colorSuccess
                        : fraction >= 0.4
                            ? AppTheme.colorWarning
                            : context.textTertiary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            ClipRRect(
              borderRadius: BorderRadius.circular(3),
              child: LinearProgressIndicator(
                value: fraction,
                minHeight: 4,
                backgroundColor: context.neutral200,
                valueColor: AlwaysStoppedAnimation<Color>(
                  fraction >= 0.7
                      ? AppTheme.colorSuccess
                      : fraction >= 0.4
                          ? AppTheme.colorWarning
                          : context.neutral400,
                ),
              ),
            ),
          ],
        );
      },
      loading: () => const SizedBox(height: 20),
      error: (_, __) => const SizedBox(height: 20),
    );
  }
}

// ─── Mini Heatmap (last 30 days, 5 rows x 6 cols) ───────────────────────────

class _MiniHeatmap extends ConsumerWidget {
  final String habitId;
  final Color habitColor;
  const _MiniHeatmap({required this.habitId, required this.habitColor});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allCompletionsAsync = ref.watch(_habitAllCompletionsProvider(habitId));
    return allCompletionsAsync.when(
      data: (completions) {
        final completedDays = completions.map((c) => c.dayId).toSet();
        final now = DateTime.now();
        // Last 30 days, arranged in 5 rows of 6
        final days = List.generate(
            30, (i) => dateToId(now.subtract(Duration(days: 29 - i))));

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Ultimos 30 dias',
              style: GoogleFonts.inter(
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: context.textTertiary,
              ),
            ),
            const SizedBox(height: 4),
            Wrap(
              spacing: 3,
              runSpacing: 3,
              children: days.map((dayId) {
                final completed = completedDays.contains(dayId);
                return Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2),
                    color: completed
                        ? habitColor.withAlpha(200)
                        : context.neutral200,
                  ),
                );
              }).toList(),
            ),
          ],
        );
      },
      loading: () => const SizedBox(height: 20),
      error: (_, __) => const SizedBox(height: 20),
    );
  }
}

// ─── Shared provider ─────────────────────────────────────────────────────────

final _habitAllCompletionsProvider =
    StreamProvider.family<List<HabitCompletion>, String>(
  (ref, habitId) {
    final service = ref.watch(habitServiceProvider);
    return service.watchAllCompletionsForHabit(habitId);
  },
);
