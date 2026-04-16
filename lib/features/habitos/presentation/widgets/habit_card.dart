import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/utils/format_utils.dart';
import '../../domain/models/habit.dart';
import '../providers/habit_provider.dart';
import 'add_habit_bottom_sheet.dart';

class HabitCard extends ConsumerWidget {
  final Habit habit;
  final bool isCompleted;
  final VoidCallback? onLongPress;

  const HabitCard({
    super.key,
    required this.habit,
    required this.isCompleted,
    this.onLongPress,
  });

  Color? _parseHabitColor() {
    if (habit.color == null || habit.color!.isEmpty) return null;
    try {
      return Color(int.parse(habit.color!, radix: 16));
    } catch (_) {
      return null;
    }
  }

  String _frequencyLabel() =>
      habit.frequency == HabitFrequency.daily ? 'Diario' : 'Semanal';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final streakAsync = ref.watch(habitStreakProvider(habit.id));
    final habitColor = _parseHabitColor() ?? AppTheme.colorPrimary;
    final completionsAsync =
        ref.watch(_habitAllCompletionsProvider(habit.id));

    // Compute "X/7 esta semana" without a full sub-widget.
    final now = DateTime.now();
    final last7 = List.generate(
        7, (i) => dateToId(now.subtract(Duration(days: i))));
    final doneThisWeek = completionsAsync.valueOrNull
            ?.map((c) => c.dayId)
            .where(last7.contains)
            .length ??
        0;

    final inner = GestureDetector(
      onLongPress: onLongPress,
      onTap: () {
        HapticFeedback.lightImpact();
        ref.read(habitServiceProvider).toggleCompletion(habit.id, todayId());
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          // When completed: tint card with the habit's own color instead of
          // a generic light-green that clashed with dark mode.
          color: isCompleted
              ? Color.lerp(context.surfaceCard, habitColor, 0.22)
              : context.surfaceCard,
          borderRadius: AppTheme.r16,
          border: Border.all(
            color: isCompleted
                ? habitColor.withAlpha(140)
                : context.dividerColor,
            width: isCompleted ? 1.5 : 1,
          ),
          boxShadow: isCompleted
              ? [
                  BoxShadow(
                    color: habitColor.withAlpha(45),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ]
              : AppTheme.shadowSm,
        ),
        child: Row(
          children: [
            // ── Emoji badge ─────────────────────────────────────────────
            Container(
              width: 44,
              height: 44,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: habitColor.withAlpha(isCompleted ? 55 : 30),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                habit.icon != null && habit.icon!.isNotEmpty
                    ? habit.icon!
                    : '✨',
                style: const TextStyle(fontSize: 22),
              ),
            ),
            const SizedBox(width: 12),
            // ── Title + pills ──────────────────────────────────────────
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    habit.title,
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: context.textPrimary,
                      decoration: isCompleted
                          ? TextDecoration.lineThrough
                          : null,
                      decorationColor: context.textTertiary,
                      decorationThickness: 1.5,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 7, vertical: 2),
                        decoration: BoxDecoration(
                          color: habitColor.withAlpha(40),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          _frequencyLabel(),
                          style: GoogleFonts.inter(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: habitColor,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          '$doneThisWeek/7 esta semana',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            color: context.textTertiary,
                            fontWeight: FontWeight.w500,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // ── Streak badge ───────────────────────────────────────────
            streakAsync.when(
              data: (streak) => streak > 1
                  ? Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.local_fire_department_rounded,
                              color: AppTheme.colorWarning, size: 16),
                          Text(
                            '$streak',
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              color: AppTheme.colorWarning,
                            ),
                          ),
                        ],
                      ),
                    )
                  : const SizedBox.shrink(),
              loading: () => const SizedBox.shrink(),
              error: (_, __) => const SizedBox.shrink(),
            ),
            // ── Big checkbox ──────────────────────────────────────────
            GestureDetector(
              onTap: () {
                HapticFeedback.mediumImpact();
                ref
                    .read(habitServiceProvider)
                    .toggleCompletion(habit.id, todayId());
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: isCompleted ? habitColor : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isCompleted
                        ? habitColor
                        : context.neutral400,
                    width: 2,
                  ),
                  boxShadow: isCompleted
                      ? [
                          BoxShadow(
                            color: habitColor.withAlpha(90),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: isCompleted
                    ? const Icon(Icons.check_rounded,
                        size: 22, color: Colors.white)
                    : null,
              ),
            ),
          ],
        ),
      ),
    );

    // Wrap with Slidable: right swipe toggles completion, left swipe gives
    // edit + delete actions. Matches the gesture pattern used by TaskCard.
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      child: Slidable(
        key: ValueKey(habit.id),
        startActionPane: ActionPane(
          motion: const DrawerMotion(),
          extentRatio: 0.28,
          children: [
            SlidableAction(
              onPressed: (_) {
                HapticFeedback.mediumImpact();
                ref
                    .read(habitServiceProvider)
                    .toggleCompletion(habit.id, todayId());
              },
              backgroundColor: isCompleted
                  ? AppTheme.colorPrimary
                  : AppTheme.colorSuccess,
              foregroundColor: Colors.white,
              icon: isCompleted
                  ? Icons.undo_rounded
                  : Icons.check_rounded,
              label: isCompleted ? 'Deshacer' : 'Listo',
              borderRadius:
                  const BorderRadius.horizontal(left: Radius.circular(16)),
            ),
          ],
        ),
        endActionPane: ActionPane(
          motion: const DrawerMotion(),
          extentRatio: 0.5,
          children: [
            SlidableAction(
              onPressed: (ctx) {
                HapticFeedback.lightImpact();
                AddHabitBottomSheet.showEdit(ctx, habit);
              },
              backgroundColor: AppTheme.colorWarning,
              foregroundColor: Colors.white,
              icon: Icons.edit_rounded,
              label: 'Editar',
              borderRadius:
                  const BorderRadius.horizontal(left: Radius.circular(16)),
            ),
            SlidableAction(
              onPressed: (ctx) async {
                HapticFeedback.heavyImpact();
                final confirm = await showDialog<bool>(
                  context: ctx,
                  builder: (dctx) => AlertDialog(
                    title: const Text('¿Borrar hábito?'),
                    content: Text(
                      'Se archivará "${habit.title}" y dejará de aparecer.',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(dctx, false),
                        child: const Text('Cancelar'),
                      ),
                      FilledButton(
                        style: FilledButton.styleFrom(
                          backgroundColor: AppTheme.colorDanger,
                        ),
                        onPressed: () => Navigator.pop(dctx, true),
                        child: const Text('Borrar'),
                      ),
                    ],
                  ),
                );
                if (confirm == true) {
                  await ref.read(habitServiceProvider).archiveHabit(habit.id);
                }
              },
              backgroundColor: AppTheme.colorDanger,
              foregroundColor: Colors.white,
              icon: Icons.delete_rounded,
              label: 'Borrar',
              borderRadius:
                  const BorderRadius.horizontal(right: Radius.circular(16)),
            ),
          ],
        ),
        child: inner,
      ),
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
