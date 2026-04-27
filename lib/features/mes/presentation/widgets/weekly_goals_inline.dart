import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/feedback/feedback_service.dart';
import '../../../../core/logic/weekly_plan_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/format_utils.dart';
import '../../../semana/presentation/providers/semana_provider.dart';

/// Sección de metas primordiales de una semana, embebida en la
/// pantalla (no es bottom sheet). Reutiliza la lógica del sheet
/// pero sin el handle/scaffold de modal.
class WeeklyGoalsInline extends ConsumerStatefulWidget {
  const WeeklyGoalsInline({super.key, required this.weekStart});

  /// Lunes (00:00) de la semana.
  final DateTime weekStart;

  @override
  ConsumerState<WeeklyGoalsInline> createState() =>
      _WeeklyGoalsInlineState();
}

class _WeeklyGoalsInlineState extends ConsumerState<WeeklyGoalsInline> {
  final _controller = TextEditingController();
  // Default colapsado para que no ocupe espacio. El user expande
  // cuando quiere editar/ver las metas.
  bool _expanded = false;

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
    final planAsync = ref.watch(weekPlanFamily(_weekStartId));
    final goals = planAsync.valueOrNull == null
        ? const <String>[]
        : ref
            .read(weeklyPlanServiceProvider)
            .decodePrimordialGoals(planAsync.valueOrNull);

    final doneCount = goals.where(WeeklyPlanService.isGoalDone).length;

    return Container(
      margin: const EdgeInsets.fromLTRB(12, 0, 12, 8),
      decoration: BoxDecoration(
        color: context.surfaceCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.colorDanger.withAlpha(50)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header tappeable para colapsar/expandir.
          InkWell(
            onTap: () {
              FeedbackService.instance.tick();
              setState(() => _expanded = !_expanded);
            },
            borderRadius: BorderRadius.circular(14),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 10, 10),
              child: Row(
                children: [
                  const Icon(Icons.star_rounded,
                      color: AppTheme.colorDanger, size: 18),
                  const SizedBox(width: 6),
                  Text(
                    'Lo primordial',
                    style: GoogleFonts.fraunces(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.colorDanger,
                      letterSpacing: -0.2,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 7, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppTheme.colorDanger.withAlpha(30),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      goals.isEmpty
                          ? 'agregar'
                          : '$doneCount/${goals.length}',
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.colorDanger,
                      ),
                    ),
                  ),
                  const Spacer(),
                  AnimatedRotation(
                    turns: _expanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 180),
                    child: Icon(Icons.expand_more_rounded,
                        color: context.textSecondary, size: 20),
                  ),
                ],
              ),
            ),
          ),
          // Contenido expandido — animado para que no aparezca de golpe.
          AnimatedSize(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOutCubic,
            alignment: Alignment.topCenter,
            child: !_expanded
                ? const SizedBox(width: double.infinity, height: 0)
                : Padding(
                    padding: const EdgeInsets.fromLTRB(12, 0, 12, 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (goals.isEmpty)
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(vertical: 8),
                            child: Text(
                              'Anotá lo que SÍ o SÍ querés cerrar esta semana',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                fontStyle: FontStyle.italic,
                                color: context.textTertiary,
                              ),
                            ),
                          )
                        else
                          for (var i = 0; i < goals.length; i++)
                            _GoalRow(
                              key: ValueKey('goal-$_weekStartId-$i'),
                              isDone:
                                  WeeklyPlanService.isGoalDone(goals[i]),
                              text: WeeklyPlanService.goalText(goals[i]),
                              onToggle: () => _toggleGoal(goals, i),
                              onDelete: () => _removeGoal(goals, i),
                            ),
                        const SizedBox(height: 6),
                        // Input agregar
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _controller,
                                style: GoogleFonts.inter(
                                    fontSize: 13.5,
                                    color: context.textPrimary),
                                decoration: InputDecoration(
                                  hintText: 'Agregar meta...',
                                  hintStyle: GoogleFonts.inter(
                                      fontSize: 13.5,
                                      color: context.textTertiary),
                                  filled: true,
                                  fillColor: context.surfaceBase,
                                  isDense: true,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(
                                        color: context.dividerColor),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(
                                        color: context.dividerColor),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: const BorderSide(
                                        color: AppTheme.colorDanger,
                                        width: 1.5),
                                  ),
                                  contentPadding:
                                      const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 8),
                                ),
                                onSubmitted: (_) => _addGoal(goals),
                              ),
                            ),
                            const SizedBox(width: 6),
                            SizedBox(
                              width: 38,
                              height: 38,
                              child: FilledButton(
                                onPressed: () => _addGoal(goals),
                                style: FilledButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  backgroundColor: AppTheme.colorDanger,
                                ),
                                child: const Icon(Icons.add_rounded,
                                    size: 18),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

class _GoalRow extends StatelessWidget {
  const _GoalRow({
    super.key,
    required this.isDone,
    required this.text,
    required this.onToggle,
    required this.onDelete,
  });
  final bool isDone;
  final String text;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: isDone
            ? AppTheme.colorSuccess.withAlpha(20)
            : context.surfaceBase,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isDone
              ? AppTheme.colorSuccess.withAlpha(70)
              : context.dividerColor,
        ),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: onToggle,
            child: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isDone ? AppTheme.colorSuccess : Colors.transparent,
                border:
                    Border.all(color: AppTheme.colorSuccess, width: 2),
              ),
              child: isDone
                  ? const Icon(Icons.check, size: 12, color: Colors.white)
                  : null,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color:
                    isDone ? context.textTertiary : context.textPrimary,
                decoration: isDone ? TextDecoration.lineThrough : null,
              ),
            ),
          ),
          IconButton(
            tooltip: 'Borrar',
            icon: const Icon(Icons.close_rounded, size: 16),
            color: AppTheme.colorDanger.withAlpha(180),
            constraints:
                const BoxConstraints(minWidth: 28, minHeight: 28),
            padding: EdgeInsets.zero,
            onPressed: onDelete,
          ),
        ],
      ),
    );
  }
}

/// Provider familia compartido entre el inline y el sheet.
final weekPlanFamily =
    StreamProvider.family<dynamic, String>((ref, weekStartId) {
  return ref
      .watch(weeklyPlanServiceProvider)
      .watchWeeklyPlan(weekStartId);
});
