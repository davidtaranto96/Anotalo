import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uuid/uuid.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/utils/format_utils.dart';
import '../../../hoy/domain/models/task.dart';
import '../../../hoy/presentation/providers/task_provider.dart';
import '../providers/semana_provider.dart';

const _uuid = Uuid();

class WeekDayColumn extends ConsumerStatefulWidget {
  final DateTime date;
  final TaskPriority? filterPriority;
  final Function(Task, String) onTaskDropped;
  final Function(String) onDelete;
  final Function(String) onComplete;

  const WeekDayColumn({
    super.key,
    required this.date,
    required this.onTaskDropped,
    required this.onDelete,
    required this.onComplete,
    this.filterPriority,
  });

  @override
  ConsumerState<WeekDayColumn> createState() => _WeekDayColumnState();
}

class _WeekDayColumnState extends ConsumerState<WeekDayColumn> {
  final _ctrl = TextEditingController();
  TaskPriority _addPriority = TaskPriority.primordial;
  bool _showAdd = false;

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Future<void> _addTask() async {
    final title = _ctrl.text.trim();
    if (title.isEmpty) return;
    HapticFeedback.lightImpact();
    final dayId = dateToId(widget.date);
    await ref.read(taskServiceProvider).addTask(Task(
      id: _uuid.v4(),
      title: title,
      priority: _addPriority,
      status: TaskStatus.pending,
      dayId: dayId,
      createdAt: DateTime.now(),
    ));
    _ctrl.clear();
    setState(() => _showAdd = false);
  }

  @override
  Widget build(BuildContext context) {
    final dayId = dateToId(widget.date);
    final tasksAsync = ref.watch(dayTasksProvider(dayId));
    final isToday = dayId == todayId();

    return DragTarget<Task>(
      onAcceptWithDetails: (details) => widget.onTaskDropped(details.data, dayId),
      builder: (context, candidateData, rejectedData) {
        final isHovered = candidateData.isNotEmpty;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(horizontal: 3),
          decoration: BoxDecoration(
            color: isHovered
                ? AppTheme.colorPrimaryLight
                : isToday
                    ? AppTheme.surfaceCard
                    : AppTheme.surfaceBase,
            borderRadius: AppTheme.r12,
            border: Border.all(
              color: isToday
                  ? AppTheme.colorPrimary.withAlpha(80)
                  : isHovered
                      ? AppTheme.colorPrimary.withAlpha(100)
                      : AppTheme.divider,
            ),
            boxShadow: isToday ? AppTheme.shadowSm : null,
          ),
          child: Column(
            children: [
              // ── Day header ─────────────────────────────────────────
              tasksAsync.when(
                data: (tasks) {
                  final pending = tasks.where(
                    (t) => t.status != TaskStatus.done && t.status != TaskStatus.deleted,
                  ).toList();
                  final done = tasks.where((t) => t.status == TaskStatus.done).length;
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(6, 8, 6, 4),
                    child: Column(
                      children: [
                        Text(
                          shortDayName(widget.date).toUpperCase().substring(0, 3),
                          style: GoogleFonts.inter(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: isToday ? AppTheme.colorPrimary : AppTheme.textTertiary,
                          ),
                        ),
                        Text(
                          '${widget.date.day}',
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: isToday ? AppTheme.colorPrimary : AppTheme.textPrimary,
                          ),
                        ),
                        if (pending.isNotEmpty)
                          Text(
                            '${done}/${pending.length + done}',
                            style: GoogleFonts.inter(
                              fontSize: 9,
                              color: AppTheme.textTertiary,
                            ),
                          ),
                      ],
                    ),
                  );
                },
                loading: () => Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(children: [
                    Text(shortDayName(widget.date).toUpperCase().substring(0, 3),
                        style: GoogleFonts.inter(fontSize: 10, color: AppTheme.textTertiary)),
                    Text('${widget.date.day}',
                        style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700,
                            color: AppTheme.textPrimary)),
                  ]),
                ),
                error: (_, __) => const SizedBox.shrink(),
              ),
              const Divider(height: 1, color: AppTheme.divider),

              // ── Tasks ───────────────────────────────────────────────
              Expanded(
                child: tasksAsync.when(
                  data: (tasks) {
                    var pending = tasks.where(
                      (t) => t.status != TaskStatus.done && t.status != TaskStatus.deleted,
                    ).toList();

                    if (widget.filterPriority != null) {
                      pending = pending.where((t) => t.priority == widget.filterPriority).toList();
                    }

                    return ListView(
                      padding: const EdgeInsets.fromLTRB(4, 4, 4, 0),
                      children: [
                        ...pending.map((t) => _WeekTaskChip(
                          task: t,
                          onDelete: () => widget.onDelete(t.id),
                          onComplete: () => widget.onComplete(t.id),
                        )),
                        // Inline add
                        if (_showAdd) ...[
                          const SizedBox(height: 4),
                          TextField(
                            controller: _ctrl,
                            autofocus: true,
                            maxLines: 1,
                            style: GoogleFonts.inter(fontSize: 11, color: AppTheme.textPrimary),
                            decoration: InputDecoration(
                              hintText: 'Tarea...',
                              hintStyle: GoogleFonts.inter(fontSize: 11, color: AppTheme.textTertiary),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                              isDense: true,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(6),
                                borderSide: BorderSide(color: AppTheme.divider),
                              ),
                            ),
                            onSubmitted: (_) => _addTask(),
                          ),
                          const SizedBox(height: 4),
                          // Priority mini selector
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                TaskPriority.primordial,
                                TaskPriority.importante,
                                TaskPriority.puedeEsperar,
                              ].map((p) {
                                final sel = _addPriority == p;
                                final color = _priorityColor(p);
                                return GestureDetector(
                                  onTap: () => setState(() => _addPriority = p),
                                  child: Container(
                                    margin: const EdgeInsets.only(right: 3),
                                    width: 10, height: 10,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: sel ? color : Colors.transparent,
                                      border: Border.all(color: color, width: 1.5),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                          const SizedBox(height: 4),
                          GestureDetector(
                            onTap: _addTask,
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              decoration: BoxDecoration(
                                color: AppTheme.colorPrimary,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Center(
                                child: Text('Add',
                                    style: GoogleFonts.inter(
                                        fontSize: 11, color: Colors.white, fontWeight: FontWeight.w600)),
                              ),
                            ),
                          ),
                        ] else
                          GestureDetector(
                            onTap: () => setState(() => _showAdd = true),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 6),
                              child: Center(
                                child: Text(
                                  '+ Agregar',
                                  style: GoogleFonts.inter(
                                    fontSize: 10,
                                    color: AppTheme.textTertiary,
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                  loading: () => const SizedBox.shrink(),
                  error: (_, __) => const SizedBox.shrink(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Color _priorityColor(TaskPriority p) => switch (p) {
    TaskPriority.primordial   => AppTheme.colorDanger,
    TaskPriority.importante   => AppTheme.colorWarning,
    TaskPriority.puedeEsperar => AppTheme.colorPrimary,
    TaskPriority.secundaria   => AppTheme.neutral400,
  };
}

class _WeekTaskChip extends StatelessWidget {
  final Task task;
  final VoidCallback onDelete;
  final VoidCallback onComplete;

  const _WeekTaskChip({required this.task, required this.onDelete, required this.onComplete});

  @override
  Widget build(BuildContext context) {
    return LongPressDraggable<Task>(
      data: task,
      feedback: Material(
        color: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: _priorityColor(task.priority),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            task.title,
            style: GoogleFonts.inter(fontSize: 11, color: Colors.white),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
      childWhenDragging: Opacity(opacity: 0.3, child: _chip()),
      child: _chip(),
    );
  }

  Widget _chip() {
    final color = _priorityColor(task.priority);
    return Container(
      margin: const EdgeInsets.only(bottom: 3),
      padding: const EdgeInsets.fromLTRB(5, 3, 3, 3),
      decoration: BoxDecoration(
        color: _priorityBg(task.priority),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withAlpha(80)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              task.title,
              style: GoogleFonts.inter(fontSize: 10, color: AppTheme.textPrimary),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          GestureDetector(
            onTap: () {
              HapticFeedback.lightImpact();
              onDelete();
            },
            child: const Icon(Icons.close_rounded, size: 12, color: AppTheme.textTertiary),
          ),
        ],
      ),
    );
  }

  Color _priorityColor(TaskPriority p) => switch (p) {
    TaskPriority.primordial   => AppTheme.colorDanger,
    TaskPriority.importante   => AppTheme.colorWarning,
    TaskPriority.puedeEsperar => AppTheme.colorPrimary,
    TaskPriority.secundaria   => AppTheme.neutral400,
  };

  Color _priorityBg(TaskPriority p) => switch (p) {
    TaskPriority.primordial   => AppTheme.colorDangerLight,
    TaskPriority.importante   => AppTheme.colorWarningLight,
    TaskPriority.puedeEsperar => AppTheme.colorPrimaryLight,
    TaskPriority.secundaria   => AppTheme.neutral200,
  };
}
