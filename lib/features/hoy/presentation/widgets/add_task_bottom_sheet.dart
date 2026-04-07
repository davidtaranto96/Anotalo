import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uuid/uuid.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/models/task_area.dart';
import '../../../../../core/utils/format_utils.dart';
import '../../../../../core/widgets/voice_input_button.dart';
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
  TaskPriority _priority = TaskPriority.primordial;
  String? _area;
  TimeOfDay? _reminderTime;
  static const _uuid = Uuid();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final title = _controller.text.trim();
    if (title.isEmpty) return;
    String? reminderStr;
    if (_reminderTime != null) {
      reminderStr =
          '${_reminderTime!.hour.toString().padLeft(2, '0')}:${_reminderTime!.minute.toString().padLeft(2, '0')}';
    }
    HapticFeedback.lightImpact();
    await ref.read(taskServiceProvider).addTask(Task(
      id: _uuid.v4(),
      title: title,
      priority: _priority,
      status: TaskStatus.pending,
      area: _area,
      reminder: reminderStr,
      dayId: todayId(),
      createdAt: DateTime.now(),
    ));
    if (mounted) Navigator.of(context).pop();
  }

  String _parseVoiceInput(String text) {
    final lower = text.toLowerCase();
    if (lower.contains('para trabajo') ||
        lower.contains('de trabajo') ||
        lower.contains('del trabajo')) {
      setState(() => _area = 'trabajo');
      text = text
          .replaceAll(
              RegExp(r'(para|de|del)\s+trabajo', caseSensitive: false), '')
          .trim();
    } else if (lower.contains('para la facu') ||
        lower.contains('de la facu') ||
        lower.contains('facultad')) {
      setState(() => _area = 'estudio');
      text = text
          .replaceAll(
              RegExp(r'(para|de)\s+(la\s+)?facu(ltad)?',
                  caseSensitive: false),
              '')
          .trim();
    } else if (lower.contains('personal') || lower.contains('para mí')) {
      setState(() => _area = 'personal');
      text = text
          .replaceAll(
              RegExp(r'personal|para\s+m[ií]', caseSensitive: false), '')
          .trim();
    } else if (lower.contains('para casa') ||
        lower.contains('de casa') ||
        lower.contains('de la casa')) {
      setState(() => _area = 'casa');
      text = text
          .replaceAll(
              RegExp(r'(para|de)\s+(la\s+)?casa', caseSensitive: false), '')
          .trim();
    } else if (lower.contains('para salud') || lower.contains('de salud')) {
      setState(() => _area = 'salud');
      text = text
          .replaceAll(
              RegExp(r'(para|de)\s+salud', caseSensitive: false), '')
          .trim();
    }
    if (lower.contains('urgente') || lower.contains('primordial')) {
      setState(() => _priority = TaskPriority.primordial);
      text = text
          .replaceAll(
              RegExp(r'urgente|primordial', caseSensitive: false), '')
          .trim();
    } else if (lower.contains('importante')) {
      setState(() => _priority = TaskPriority.importante);
      text = text
          .replaceAll(RegExp(r'importante', caseSensitive: false), '')
          .trim();
    }
    return text;
  }

  Future<void> _pickReminderTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _reminderTime ?? TimeOfDay.now(),
    );
    if (picked != null) setState(() => _reminderTime = picked);
  }

  Color _priorityColor(TaskPriority p) => switch (p) {
        TaskPriority.primordial => AppTheme.colorDanger,
        TaskPriority.importante => AppTheme.colorWarning,
        TaskPriority.puedeEsperar => AppTheme.colorPrimary,
        TaskPriority.secundaria => AppTheme.neutral400,
      };

  String _priorityLabel(TaskPriority p) => switch (p) {
        TaskPriority.primordial => 'Primordial',
        TaskPriority.importante => 'Importante',
        TaskPriority.puedeEsperar => 'Puede esperar',
        TaskPriority.secundaria => 'Side quest',
      };

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    return Container(
      padding: EdgeInsets.fromLTRB(20, 16, 20, 16 + bottom),
      decoration: BoxDecoration(
        color: context.surfaceSheet,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: AppTheme.shadowLg,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: context.neutral300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 14),
          Text(
            'Nueva tarea',
            style: GoogleFonts.lora(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: context.textPrimary,
            ),
          ),
          const SizedBox(height: 14),

          // ── Campo de texto + micrófono ──────────────────────────────────
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  autofocus: true,
                  style:
                      GoogleFonts.inter(fontSize: 15, color: context.textPrimary),
                  decoration: InputDecoration(
                    hintText: '¿Qué tenés que hacer?',
                    hintStyle: GoogleFonts.inter(color: context.textTertiary),
                    filled: true,
                    fillColor: context.surfaceInput,
                    border: OutlineInputBorder(
                      borderRadius: AppTheme.r12,
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onSubmitted: (_) => _submit(),
                ),
              ),
              const SizedBox(width: 8),
              VoiceInputButton(
                onResult: (text) => setState(
                    () => _controller.text = _parseVoiceInput(text)),
                size: 44,
              ),
            ],
          ),
          const SizedBox(height: 14),

          // ── Prioridad ───────────────────────────────────────────────────
          Text('Prioridad',
              style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: context.textSecondary)),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: TaskPriority.values.map((p) {
                final sel = _priority == p;
                final c = _priorityColor(p);
                return GestureDetector(
                  onTap: () => setState(() => _priority = p),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    margin: const EdgeInsets.only(right: 6),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: sel ? c.withAlpha(30) : Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                      border:
                          Border.all(color: sel ? c : context.dividerColor),
                    ),
                    child: Text(
                      _priorityLabel(p),
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight:
                            sel ? FontWeight.w600 : FontWeight.w400,
                        color: sel ? c : context.textSecondary,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 14),

          // ── Área ────────────────────────────────────────────────────────
          Text('Área',
              style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: context.textSecondary)),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _areaPill(null, 'Sin área', '📋'),
                ...kTaskAreas.map((a) => _areaPill(a.id, a.label, a.emoji)),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // ── Recordatorio ────────────────────────────────────────────────
          GestureDetector(
            onTap: _pickReminderTime,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: _reminderTime != null
                    ? AppTheme.colorPrimary.withAlpha(20)
                    : context.surfaceInput,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: _reminderTime != null
                      ? AppTheme.colorPrimary
                      : context.dividerColor,
                ),
              ),
              child: Row(
                children: [
                  Icon(Icons.alarm_rounded,
                      size: 18,
                      color: _reminderTime != null
                          ? AppTheme.colorPrimary
                          : context.textTertiary),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _reminderTime != null
                          ? _reminderTime!.format(context)
                          : 'Sin recordatorio — toca para agregar',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: _reminderTime != null
                            ? AppTheme.colorPrimary
                            : context.textTertiary,
                        fontWeight: _reminderTime != null
                            ? FontWeight.w600
                            : FontWeight.w400,
                      ),
                    ),
                  ),
                  if (_reminderTime != null)
                    GestureDetector(
                      onTap: () => setState(() => _reminderTime = null),
                      child: Icon(Icons.close_rounded,
                          size: 16, color: context.textTertiary),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 18),

          // ── Botón agregar ───────────────────────────────────────────────
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: _submit,
              style: FilledButton.styleFrom(
                backgroundColor: AppTheme.colorPrimary,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: Text('Agregar tarea',
                  style: GoogleFonts.inter(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _areaPill(String? id, String label, String emoji) {
    final sel = _area == id;
    final c = id != null
        ? getTaskArea(id)?.color ?? context.textSecondary
        : context.textSecondary;
    return GestureDetector(
      onTap: () => setState(() => _area = id),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        margin: const EdgeInsets.only(right: 6),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: sel ? c.withAlpha(30) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: sel ? c : context.dividerColor),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 12)),
            const SizedBox(width: 4),
            Text(label,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: sel ? FontWeight.w600 : FontWeight.w400,
                  color: sel ? c : context.textSecondary,
                )),
          ],
        ),
      ),
    );
  }
}
