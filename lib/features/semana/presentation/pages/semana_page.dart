import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../hoy/presentation/providers/task_provider.dart';
import '../providers/semana_provider.dart';
import '../widgets/week_day_column.dart';

class SemanaPage extends ConsumerWidget {
  const SemanaPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weekDays = ref.watch(currentWeekDaysProvider);
    final taskService = ref.read(taskServiceProvider);

    final monday = weekDays.first;
    final sunday = weekDays.last;
    final weekLabel =
        '${monday.day} ${DateFormat('MMM', 'es').format(monday)} — '
        '${sunday.day} ${DateFormat('MMM', 'es').format(sunday)}';

    return Scaffold(
      backgroundColor: AppTheme.surfaceBase,
      body: Column(
        children: [
          // AppBar
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Semana',
                            style: GoogleFonts.inter(
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFFF0F0FF))),
                        Text(weekLabel,
                            style: GoogleFonts.inter(
                                fontSize: 13, color: AppTheme.colorNeutral)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          // 7-day grid
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: weekDays.map((date) => Expanded(
                  child: WeekDayColumn(
                    date: date,
                    onTaskDropped: (task, newDayId) {
                      if (task.dayId != newDayId) {
                        taskService.deferTask(task.id, newDayId);
                      }
                    },
                  ),
                )).toList(),
              ),
            ),
          ),
          // Bottom padding for nav bar
          const SizedBox(height: 90),
        ],
      ),
    );
  }
}
