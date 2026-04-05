import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uuid/uuid.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/utils/format_utils.dart';
import '../../domain/models/task.dart';
import '../providers/task_provider.dart';

class AddTaskBottomSheet extends ConsumerStatefulWidget {
  const AddTaskBottomSheet({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const AddTaskBottomSheet(),
    );
  }

  @override
  ConsumerState<AddTaskBottomSheet> createState() => _AddTaskBottomSheetState();
}

class _AddTaskBottomSheetState extends ConsumerState<AddTaskBottomSheet> {
  final _controller = TextEditingController();
  TaskPriority _priority = TaskPriority.puedeEsperar;
  static const _uuid = Uuid();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _save() {
    final title = _controller.text.trim();
    if (title.isEmpty) return;

    final task = Task(
      id: _uuid.v4(),
      title: title,
      priority: _priority,
      status: TaskStatus.pending,
      dayId: todayId(),
      createdAt: DateTime.now(),
    );

    ref.read(taskServiceProvider).addTask(task);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;

    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.92,
      ),
      child: Container(
        padding: EdgeInsets.fromLTRB(20, 12, 20, 20 + bottom),
        decoration: const BoxDecoration(
          color: AppTheme.surfaceSheet,
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: Colors.white.withAlpha((0.1 * 255).round()),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Text('Nueva tarea',
                style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFFF0F0FF))),
            const SizedBox(height: 20),
            TextField(
              controller: _controller,
              autofocus: true,
              style: GoogleFonts.inter(color: const Color(0xFFF0F0FF)),
              decoration: InputDecoration(
                hintText: '¿Qué hay que hacer?',
                hintStyle: GoogleFonts.inter(color: AppTheme.colorNeutral),
              ),
              onSubmitted: (_) => _save(),
            ),
            const SizedBox(height: 16),
            // Priority selector
            Row(
              children: TaskPriority.values.map((p) {
                final selected = p == _priority;
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3),
                    child: GestureDetector(
                      onTap: () => setState(() => _priority = p),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          color: selected
                              ? _priorityColor(p).withAlpha((0.2 * 255).round())
                              : AppTheme.surfaceCard,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: selected
                                ? _priorityColor(p)
                                : Colors.white.withAlpha((0.07 * 255).round()),
                          ),
                        ),
                        child: Text(
                          _priorityShortLabel(p),
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: selected ? _priorityColor(p) : AppTheme.colorNeutral,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: _save,
              style: FilledButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: AppTheme.colorPrimary,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: Text('Agregar', style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
            ),
          ],
        ),
      ),
    );
  }

  Color _priorityColor(TaskPriority p) => switch (p) {
    TaskPriority.primordial   => AppTheme.colorDanger,
    TaskPriority.importante   => AppTheme.colorWarning,
    TaskPriority.puedeEsperar => AppTheme.colorPrimary,
    TaskPriority.secundaria   => AppTheme.colorNeutral,
  };

  String _priorityShortLabel(TaskPriority p) => switch (p) {
    TaskPriority.primordial   => 'PRIM',
    TaskPriority.importante   => 'IMP',
    TaskPriority.puedeEsperar => 'PUEDE',
    TaskPriority.secundaria   => 'SEC',
  };
}
