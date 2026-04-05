import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/utils/format_utils.dart';
import '../../../habitos/domain/models/habit.dart';
import '../../../habitos/presentation/providers/habit_provider.dart';

class HabitRowWidget extends ConsumerWidget {
  final Habit habit;
  final bool isCompleted;

  const HabitRowWidget({
    super.key,
    required this.habit,
    required this.isCompleted,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final streakAsync = ref.watch(habitStreakProvider(habit.id));

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 3),
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.surfaceCard,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isCompleted
                ? AppTheme.colorAccent.withAlpha((0.3 * 255).round())
                : Colors.white.withAlpha((0.07 * 255).round()),
          ),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
          leading: GestureDetector(
            onTap: () {
              HapticFeedback.lightImpact();
              ref.read(habitServiceProvider).toggleCompletion(habit.id, todayId());
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              width: 26,
              height: 26,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isCompleted ? AppTheme.colorAccent : Colors.transparent,
                border: Border.all(
                  color: isCompleted ? AppTheme.colorAccent : AppTheme.colorNeutral,
                  width: 2,
                ),
              ),
              child: isCompleted
                  ? const Icon(Icons.check, size: 14, color: Colors.white)
                  : null,
            ),
          ),
          title: Text(
            habit.title,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: isCompleted ? AppTheme.colorNeutral : const Color(0xFFF0F0FF),
              decoration: isCompleted ? TextDecoration.lineThrough : null,
            ),
          ),
          trailing: streakAsync.when(
            data: (streak) => streak > 0
                ? Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.local_fire_department_rounded,
                          color: AppTheme.colorWarning, size: 16),
                      const SizedBox(width: 2),
                      Text(
                        '$streak',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.colorWarning,
                        ),
                      ),
                    ],
                  )
                : null,
            loading: () => null,
            error: (_, __) => null,
          ),
        ),
      ),
    );
  }
}
