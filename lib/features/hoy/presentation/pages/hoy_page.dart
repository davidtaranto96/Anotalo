import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/format_utils.dart';
import '../../domain/models/task.dart';
import '../providers/task_provider.dart';
import '../../../habitos/domain/models/habit.dart';
import '../../../habitos/presentation/providers/habit_provider.dart';
import '../widgets/day_progress_bar.dart';
import '../widgets/priority_section.dart';
import '../widgets/habit_row_widget.dart';

class HoyPage extends ConsumerWidget {
  const HoyPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todayTasksAsync = ref.watch(todayTasksProvider);
    final primordial = ref.watch(primordialTasksProvider);
    final importante = ref.watch(importanteTasksProvider);
    final puedeEsperar = ref.watch(puedeEsperarTasksProvider);
    final completed = ref.watch(completedTasksProvider);
    final progress = ref.watch(dayProgressProvider);

    final habitsAsync = ref.watch(activeHabitsProvider);
    final completionsAsync = ref.watch(todayCompletionsProvider);

    final taskService = ref.read(taskServiceProvider);

    final now = DateTime.now();
    final dateStr = DateFormat('EEEE d \'de\' MMMM', 'es').format(now);
    final hour = now.hour;
    final greeting = hour < 12 ? 'Buenos días' : hour < 18 ? 'Buenas tardes' : 'Buenas noches';

    final totalTasks = todayTasksAsync.valueOrNull?.length ?? 0;
    final completedCount = completed.length;

    return Scaffold(
      backgroundColor: AppTheme.surfaceBase,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // AppBar
          SliverAppBar(
            floating: true,
            backgroundColor: AppTheme.surfaceBase,
            surfaceTintColor: Colors.transparent,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  greeting,
                  style: GoogleFonts.inter(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFFF0F0FF),
                  ),
                ),
                Text(
                  dateStr,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: AppTheme.colorNeutral,
                  ),
                ),
              ],
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.inbox_rounded, color: AppTheme.colorNeutral),
                onPressed: () {}, // TODO: navigate to inbox
              ),
            ],
          ),

          // Progress bar
          SliverToBoxAdapter(
            child: DayProgressBar(
              progress: progress,
              completed: completedCount,
              total: totalTasks,
            ),
          ),

          // Primordial tasks
          SliverToBoxAdapter(
            child: PrioritySection(
              priority: TaskPriority.primordial,
              tasks: primordial,
              onComplete: taskService.completeTask,
              onDefer: (id) => taskService.deferTask(id, _tomorrow()),
              onDelete: taskService.deleteTask,
            ),
          ),

          // Importante tasks
          SliverToBoxAdapter(
            child: PrioritySection(
              priority: TaskPriority.importante,
              tasks: importante,
              onComplete: taskService.completeTask,
              onDefer: (id) => taskService.deferTask(id, _tomorrow()),
              onDelete: taskService.deleteTask,
            ),
          ),

          // Puede esperar tasks
          SliverToBoxAdapter(
            child: PrioritySection(
              priority: TaskPriority.puedeEsperar,
              tasks: puedeEsperar,
              onComplete: taskService.completeTask,
              onDefer: (id) => taskService.deferTask(id, _tomorrow()),
              onDelete: taskService.deleteTask,
            ),
          ),

          // Habits section
          habitsAsync.when(
            data: (habits) {
              if (habits.isEmpty) return const SliverToBoxAdapter(child: SizedBox.shrink());
              final completionIds = completionsAsync.valueOrNull
                  ?.map((c) => c.habitId).toSet() ?? {};

              return SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
                      child: Text(
                        'HÁBITOS',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.colorAccent,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    ...habits.where((h) => h.frequency == HabitFrequency.daily)
                        .map((h) => HabitRowWidget(
                          habit: h,
                          isCompleted: completionIds.contains(h.id),
                        )),
                  ],
                ),
              );
            },
            loading: () => const SliverToBoxAdapter(child: SizedBox.shrink()),
            error: (_, __) => const SliverToBoxAdapter(child: SizedBox.shrink()),
          ),

          // Completed tasks section
          if (completed.isNotEmpty)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
                child: Text(
                  'COMPLETADAS (${completed.length})',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.colorNeutral,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),

          // Bottom padding for FAB + nav bar
          const SliverToBoxAdapter(
            child: SizedBox(height: 140),
          ),
        ],
      ),
    );
  }

  String _tomorrow() {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return dateToId(tomorrow);
  }
}
