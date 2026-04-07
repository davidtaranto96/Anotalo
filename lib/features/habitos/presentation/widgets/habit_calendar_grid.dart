import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/utils/format_utils.dart';
import '../../../habitos/domain/models/habit.dart';

class HabitCalendarGrid extends StatelessWidget {
  final List<HabitCompletion> completions;
  final Color? habitColor;

  const HabitCalendarGrid({
    super.key,
    required this.completions,
    this.habitColor,
  });

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final todayStr = todayId();
    final completedDays = completions.map((c) => c.dayId).toSet();
    final activeColor = habitColor ?? AppTheme.colorSuccess;

    // Calculate the 28 days (4 weeks) ending today
    // We want rows aligned to weekdays: L M M J V S D (Mon-Sun)
    final days = List.generate(28, (i) => now.subtract(Duration(days: 27 - i)));

    const dayHeaders = ['L', 'M', 'M', 'J', 'V', 'S', 'D'];

    return Column(
      children: [
        // Day headers
        Row(
          children: dayHeaders.map((d) => Expanded(
            child: Center(
              child: Text(d,
                  style: GoogleFonts.inter(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textTertiary)),
            ),
          )).toList(),
        ),
        const SizedBox(height: 4),
        // Build 4 week rows
        ...List.generate(4, (week) {
          final weekDays = days.sublist(week * 7, (week + 1) * 7);
          return Padding(
            padding: const EdgeInsets.only(bottom: 3),
            child: Row(
              children: weekDays.map((d) {
                final id = dateToId(d);
                final done = completedDays.contains(id);
                final isToday = id == todayStr;
                return Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    decoration: isToday
                        ? BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(
                                color: AppTheme.colorPrimary.withAlpha(80), width: 1),
                          )
                        : null,
                    child: Column(
                      children: [
                        Text(
                          '${d.day}',
                          style: GoogleFonts.inter(
                            fontSize: 9,
                            fontWeight: isToday ? FontWeight.w700 : FontWeight.w500,
                            color: isToday
                                ? AppTheme.textPrimary
                                : AppTheme.textTertiary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(2),
                            color: done ? activeColor : AppTheme.neutral300,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          );
        }),
      ],
    );
  }
}
