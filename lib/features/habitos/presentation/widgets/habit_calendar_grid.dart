import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/utils/format_utils.dart';
import '../../../habitos/domain/models/habit.dart';

class HabitCalendarGrid extends StatelessWidget {
  final List<HabitCompletion> completions;

  const HabitCalendarGrid({super.key, required this.completions});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final days = List.generate(28, (i) =>
        now.subtract(Duration(days: 27 - i)));
    final completedDays = completions.map((c) => c.dayId).toSet();

    return Wrap(
      spacing: 4,
      runSpacing: 4,
      children: days.map((d) {
        final id = dateToId(d);
        final done = completedDays.contains(id);
        return Tooltip(
          message: id,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2),
              color: done
                  ? AppTheme.colorAccent
                  : Colors.white.withAlpha((0.08 * 255).round()),
            ),
          ),
        );
      }).toList(),
    );
  }
}
