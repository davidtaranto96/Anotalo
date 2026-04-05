import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/utils/format_utils.dart';
import '../../domain/models/habit.dart';
import '../providers/habit_provider.dart';
import 'habit_calendar_grid.dart';

class HabitCard extends ConsumerWidget {
  final Habit habit;
  final bool isCompleted;

  const HabitCard({super.key, required this.habit, required this.isCompleted});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final streakAsync = ref.watch(habitStreakProvider(habit.id));

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isCompleted
              ? AppTheme.colorAccent.withAlpha((0.25 * 255).round())
              : Colors.white.withAlpha((0.07 * 255).round()),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  HapticFeedback.lightImpact();
                  ref.read(habitServiceProvider).toggleCompletion(habit.id, todayId());
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isCompleted ? AppTheme.colorAccent : Colors.transparent,
                    border: Border.all(
                      color: isCompleted ? AppTheme.colorAccent : AppTheme.colorNeutral,
                      width: 2,
                    ),
                  ),
                  child: isCompleted
                      ? const Icon(Icons.check, size: 16, color: Colors.white)
                      : null,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  habit.title,
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFFF0F0FF),
                  ),
                ),
              ),
              streakAsync.when(
                data: (streak) => streak > 0
                    ? Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.local_fire_department_rounded,
                              color: AppTheme.colorWarning, size: 18),
                          const SizedBox(width: 2),
                          Text('$streak',
                              style: GoogleFonts.inter(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: AppTheme.colorWarning)),
                        ],
                      )
                    : const SizedBox.shrink(),
                loading: () => const SizedBox.shrink(),
                error: (_, __) => const SizedBox.shrink(),
              ),
            ],
          ),
          // Calendar grid — show last 28 days
          const SizedBox(height: 12),
          _CompletionsGridLoader(habitId: habit.id),
        ],
      ),
    );
  }
}

class _CompletionsGridLoader extends ConsumerWidget {
  final String habitId;
  const _CompletionsGridLoader({required this.habitId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch all completions for this habit using a family provider
    final allCompletionsAsync = ref.watch(_habitAllCompletionsProvider(habitId));
    return allCompletionsAsync.when(
      data: (completions) => HabitCalendarGrid(completions: completions),
      loading: () => const SizedBox(height: 20),
      error: (_, __) => const SizedBox(height: 20),
    );
  }
}

final _habitAllCompletionsProvider = StreamProvider.family<List<HabitCompletion>, String>(
  (ref, habitId) {
    final service = ref.watch(habitServiceProvider);
    // Watch all completions for this habit (not day-scoped)
    return service.watchAllCompletionsForHabit(habitId);
  },
);
