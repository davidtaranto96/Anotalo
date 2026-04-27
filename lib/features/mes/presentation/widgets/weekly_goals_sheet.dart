import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/feedback/feedback_service.dart';
import '../../../../core/logic/weekly_plan_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/format_utils.dart';
import '../providers/weekly_plan_provider.dart';

/// Bottom sheet con las metas primordiales de una semana específica.
/// Permite agregar / completar / borrar metas. Persiste en
/// `WeeklyPlansTable` via `WeeklyPlanService` (compartido con la
/// pantalla Semana original).
class WeeklyGoalsSheet extends ConsumerStatefulWidget {
  const WeeklyGoalsSheet({super.key, required this.weekStart});

  /// Lunes (00:00) de la semana en cuestión.
  final DateTime weekStart;

  static Future<void> show(BuildContext context, DateTime weekStart) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => WeeklyGoalsSheet(weekStart: weekStart),
    );
  }

  @override
  ConsumerState<WeeklyGoalsSheet> createState() => _WeeklyGoalsSheetState();
}

class _WeeklyGoalsSheetState extends ConsumerState<WeeklyGoalsSheet> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String get _weekStartId => dateToId(widget.weekStart);
  String get _weekEndId =>
      dateToId(widget.weekStart.add(const Duration(days: 6)));

  Future<void> _addGoal(List<String> currentGoals) async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    FeedbackService.instance.success();
    final service = ref.read(weeklyPlanServiceProvider);
    await service.getOrCreatePlan(_weekStartId, _weekEndId);
    final updated = List<String>.from(currentGoals)..add(text);
    await service.updatePrimordialGoals(_weekStartId, updated);
    _controller.clear();
  }

  Future<void> _toggleGoal(List<String> goals, int index) async {
    FeedbackService.instance.success();
    final service = ref.read(weeklyPlanServiceProvider);
    await service.toggleGoalCompletion(_weekStartId, goals, index);
  }

  Future<void> _removeGoal(List<String> goals, int index) async {
    FeedbackService.instance.danger();
    final service = ref.read(weeklyPlanServiceProvider);
    final updated = List<String>.from(goals)..removeAt(index);
    await service.updatePrimordialGoals(_weekStartId, updated);
  }

  @override
  Widget build(BuildContext context) {
    final planAsync = ref.watch(_weekPlanFamily(_weekStartId));
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final goals = planAsync.valueOrNull == null
        ? const <String>[]
        : ref
            .read(weeklyPlanServiceProvider)
            .decodePrimordialGoals(planAsync.valueOrNull);

    final start = widget.weekStart;
    final end = start.add(const Duration(days: 6));
    final months = [
      'ene', 'feb', 'mar', 'abr', 'may', 'jun',
      'jul', 'ago', 'sep', 'oct', 'nov', 'dic'
    ];
    final rangeLabel =
        '${start.day} ${months[start.month - 1]} – ${end.day} ${months[end.month - 1]}';

    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.78,
        ),
        decoration: BoxDecoration(
          color: context.surfaceCard,
          borderRadius:
              const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: context.dividerColor,
                borderRadius: BorderRadius.circular(999),
              ),
            ),
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 4),
              child: Row(
                children: [
                  const Icon(Icons.star_rounded,
                      color: AppTheme.colorDanger, size: 22),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Lo primordial',
                          style: GoogleFonts.fraunces(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: context.textPrimary,
                            letterSpacing: -0.2,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          rangeLabel,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: context.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (goals.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppTheme.colorDanger.withAlpha(28),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        '${goals.where(WeeklyPlanService.isGoalDone).length}/${goals.length}',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.colorDanger,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            // Lista
            Flexible(
              child: goals.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.all(32),
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.flag_outlined,
                                size: 36, color: context.textTertiary),
                            const SizedBox(height: 8),
                            Text(
                              'Sin metas para esta semana',
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                color: context.textTertiary,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Anotá lo que SÍ o SÍ querés cerrar',
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                color: context.textTertiary,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : ListView.separated(
                      shrinkWrap: true,
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                      itemCount: goals.length,
                      separatorBuilder: (_, __) =>
                          const SizedBox(height: 6),
                      itemBuilder: (_, i) {
                        final isDone =
                            WeeklyPlanService.isGoalDone(goals[i]);
                        final text = WeeklyPlanService.goalText(goals[i]);
                        return Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 8),
                          decoration: BoxDecoration(
                            color: isDone
                                ? AppTheme.colorSuccess.withAlpha(20)
                                : context.surfaceBase,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: isDone
                                  ? AppTheme.colorSuccess.withAlpha(70)
                                  : context.dividerColor,
                            ),
                          ),
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () => _toggleGoal(goals, i),
                                child: Container(
                                  width: 22,
                                  height: 22,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: isDone
                                        ? AppTheme.colorSuccess
                                        : Colors.transparent,
                                    border: Border.all(
                                      color: AppTheme.colorSuccess,
                                      width: 2,
                                    ),
                                  ),
                                  child: isDone
                                      ? const Icon(Icons.check,
                                          size: 14, color: Colors.white)
                                      : null,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  text,
                                  style: GoogleFonts.inter(
                                    fontSize: 13.5,
                                    fontWeight: FontWeight.w500,
                                    color: isDone
                                        ? context.textTertiary
                                        : context.textPrimary,
                                    decoration: isDone
                                        ? TextDecoration.lineThrough
                                        : null,
                                  ),
                                ),
                              ),
                              IconButton(
                                tooltip: 'Borrar',
                                icon: const Icon(
                                    Icons.delete_outline_rounded,
                                    size: 18),
                                color: AppTheme.colorDanger.withAlpha(180),
                                onPressed: () => _removeGoal(goals, i),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
            // Input
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      style: GoogleFonts.inter(
                          fontSize: 14, color: context.textPrimary),
                      decoration: InputDecoration(
                        hintText: 'Agregar meta...',
                        hintStyle: GoogleFonts.inter(
                            fontSize: 14, color: context.textTertiary),
                        filled: true,
                        fillColor: context.surfaceBase,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              BorderSide(color: context.dividerColor),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              BorderSide(color: context.dividerColor),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                              color: AppTheme.colorDanger, width: 1.5),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 10),
                      ),
                      onSubmitted: (_) => _addGoal(goals),
                    ),
                  ),
                  const SizedBox(width: 8),
                  FilledButton(
                    onPressed: () => _addGoal(goals),
                    style: FilledButton.styleFrom(
                      minimumSize: const Size(48, 44),
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                    ),
                    child: const Icon(Icons.add_rounded, size: 20),
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

/// Provider familia que escucha el plan semanal por weekStart.
/// Local al sheet — el de Semana usa otro distinto basado en
/// weekDaysProvider.
final _weekPlanFamily =
    StreamProvider.family<dynamic, String>((ref, weekStartId) {
  return ref
      .watch(weeklyPlanServiceProvider)
      .watchWeeklyPlan(weekStartId);
});
