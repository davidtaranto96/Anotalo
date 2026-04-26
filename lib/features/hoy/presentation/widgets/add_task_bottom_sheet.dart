import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uuid/uuid.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/models/task_area.dart';
import '../../../../../core/providers/task_area_provider.dart';
import '../../../../../core/utils/format_utils.dart';
import '../../../../../core/widgets/voice_input_button.dart';
import '../../../../../core/logic/task_parser.dart';
import '../../../../../core/logic/user_prefs.dart';
import '../../domain/models/task.dart';
import '../providers/task_provider.dart';

class AddTaskBottomSheet extends ConsumerStatefulWidget {
  /// When provided, the sheet opens in edit mode: fields are pre-filled
  /// and the "Agregar tarea" button updates the task instead of inserting.
  final Task? existing;

  /// When provided (and not in edit mode), pre-selects this area in the
  /// area pills row. Used when the user opens the sheet from a filtered
  /// view (e.g. tapping "+" while inside the "Salud" tab in Hoy).
  final String? prefillArea;

  /// Día específico al que pertenece la nueva tarea. Si es null, usa
  /// `todayId()`. Lo usa la vista mensual al "Agregar tarea" desde un
  /// día puntual.
  final String? prefillDayId;

  const AddTaskBottomSheet({
    super.key,
    this.existing,
    this.prefillArea,
    this.prefillDayId,
  });

  static void show(
    BuildContext context, {
    Task? existing,
    String? prefillArea,
    String? prefillDayId,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AddTaskBottomSheet(
        existing: existing,
        prefillArea: prefillArea,
        prefillDayId: prefillDayId,
      ),
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
  ParsedTask? _parsed;
  bool _initialized = false;
  static const _uuid = Uuid();

  bool get _isEditing => widget.existing != null;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      final existing = widget.existing;
      if (existing != null) {
        // Edit mode → pre-fill from the task.
        _controller.text = existing.title;
        _priority = existing.priority;
        _area = existing.area;
        if (existing.reminder != null) {
          final parts = existing.reminder!.split(':');
          if (parts.length == 2) {
            final h = int.tryParse(parts[0]);
            final m = int.tryParse(parts[1]);
            if (h != null && m != null) {
              _reminderTime = TimeOfDay(hour: h, minute: m);
            }
          }
        }
        _initialized = true;
      } else {
        final prefs = ref.read(userPrefsProvider);
        setState(() {
          _priority = prefs.defaultPriority;
          // prefillArea (vista filtrada) gana sobre la default global.
          _area = widget.prefillArea ?? prefs.defaultArea;
          _initialized = true;
        });
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _updateParsed(String text) {
    if (text.trim().isEmpty) {
      if (_parsed != null) setState(() => _parsed = null);
      return;
    }
    setState(() => _parsed = TaskParser.parse(text));
  }

  Future<void> _submit() async {
    final raw = _controller.text.trim();
    if (raw.isEmpty) return;
    final parsed = _parsed ?? TaskParser.parse(raw);
    // When editing, don't let the parser change priority/area/day silently —
    // honour the current form values (user may have tweaked them in the UI).
    final title = parsed.cleanTitle.isNotEmpty ? parsed.cleanTitle : raw;
    final priority = _isEditing ? _priority : (parsed.priority ?? _priority);
    final area = _isEditing ? _area : (parsed.areaId ?? _area);
    String? reminderStr;
    if (!_isEditing && parsed.scheduledTime != null) {
      reminderStr = parsed.scheduledTime;
    } else if (_reminderTime != null) {
      reminderStr =
          '${_reminderTime!.hour.toString().padLeft(2, '0')}:${_reminderTime!.minute.toString().padLeft(2, '0')}';
    }
    HapticFeedback.lightImpact();
    final service = ref.read(taskServiceProvider);
    if (_isEditing) {
      await service.updateTask(
        id: widget.existing!.id,
        title: title,
        priority: priority,
        area: area,
        clearArea: area == null,
        reminder: reminderStr,
        clearReminder: reminderStr == null,
      );
    } else {
      await service.addTask(Task(
        id: _uuid.v4(),
        title: title,
        priority: priority,
        status: TaskStatus.pending,
        area: area,
        reminder: reminderStr,
        // Prioridad de fuentes: parser ("mañana") > prefillDayId
        // (vista mensual: día seleccionado) > today.
        dayId: parsed.dayId ?? widget.prefillDayId ?? todayId(),
        createdAt: DateTime.now(),
      ));
    }
    if (mounted) Navigator.of(context).pop();
  }

  String _parseVoiceInput(String text) {
    final parsed = TaskParser.parse(text);
    setState(() {
      _parsed = parsed;
      if (parsed.priority != null) _priority = parsed.priority!;
      if (parsed.areaId != null) _area = parsed.areaId;
      if (parsed.scheduledTime != null) {
        final parts = parsed.scheduledTime!.split(':');
        if (parts.length == 2) {
          final h = int.tryParse(parts[0]);
          final m = int.tryParse(parts[1]);
          if (h != null && m != null) {
            _reminderTime = TimeOfDay(hour: h, minute: m);
          }
        }
      }
    });
    return parsed.cleanTitle;
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
            _isEditing ? 'Editar tarea' : 'Nueva tarea',
            style: GoogleFonts.fraunces(
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
                  onChanged: _updateParsed,
                  onSubmitted: (_) => _submit(),
                ),
              ),
              const SizedBox(width: 8),
              VoiceInputButton(
                onResult: (text) => setState(
                    () => _controller.text = _parseVoiceInput(text)),
                onPartialResult: (text) {
                  _controller.value = TextEditingValue(
                    text: text,
                    selection: TextSelection.collapsed(offset: text.length),
                  );
                  _updateParsed(text);
                },
                size: 44,
              ),
            ],
          ),
          if (_parsed?.hasDetections == true) ...[
            const SizedBox(height: 10),
            _SheetDetectionChips(parsed: _parsed!),
          ],
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
          // Usa la lista de áreas reactiva (incluye las editadas/creadas
          // por el usuario), no las built-in hardcodeadas.
          Builder(builder: (_) {
            final liveAreas = ref.watch(taskAreasSyncProvider);
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _areaPill(null, 'Sin área', '📋'),
                  ...liveAreas.map((a) => _areaPill(a.id, a.label, a.emoji)),
                ],
              ),
            );
          }),
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
              child: Text(_isEditing ? 'Guardar cambios' : 'Agregar tarea',
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
    final liveAreas = ref.watch(taskAreasSyncProvider);
    final c = id != null
        ? (getTaskAreaFrom(liveAreas, id)?.color ?? context.textSecondary)
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

// ── Detection chips (parser feedback) ───────────────────────────────────────

class _SheetDetectionChips extends StatelessWidget {
  final ParsedTask parsed;
  const _SheetDetectionChips({required this.parsed});

  String _dayLabel(String dayId) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final parts = dayId.split('-');
    if (parts.length != 3) return dayId;
    final d = DateTime(int.parse(parts[0]), int.parse(parts[1]), int.parse(parts[2]));
    final diff = d.difference(today).inDays;
    if (diff == 0) return 'Hoy';
    if (diff == 1) return 'Ma\u{00F1}ana';
    if (diff == -1) return 'Ayer';
    if (diff == 2) return 'Pasado ma\u{00F1}ana';
    return '${d.day}/${d.month}';
  }

  String _priorityLabel(TaskPriority p) => switch (p) {
    TaskPriority.primordial   => 'Primordial',
    TaskPriority.importante   => 'Importante',
    TaskPriority.puedeEsperar => 'Puede esperar',
    TaskPriority.secundaria   => 'Side quest',
  };

  Color _priorityColor(TaskPriority p) => switch (p) {
    TaskPriority.primordial   => AppTheme.colorDanger,
    TaskPriority.importante   => AppTheme.colorWarning,
    TaskPriority.puedeEsperar => AppTheme.colorPrimary,
    TaskPriority.secundaria   => AppTheme.neutral400,
  };

  @override
  Widget build(BuildContext context) {
    final chips = <Widget>[];
    if (parsed.dayId != null) {
      chips.add(_chip(icon: Icons.event_rounded, label: _dayLabel(parsed.dayId!), color: AppTheme.colorPrimary));
    }
    if (parsed.scheduledTime != null) {
      chips.add(_chip(icon: Icons.schedule_rounded, label: parsed.scheduledTime!, color: AppTheme.colorAccent));
    }
    if (parsed.priority != null) {
      chips.add(_chip(icon: Icons.flag_rounded, label: _priorityLabel(parsed.priority!), color: _priorityColor(parsed.priority!)));
    }
    if (parsed.areaId != null) {
      final area = getTaskArea(parsed.areaId);
      if (area != null) {
        chips.add(_chip(emoji: area.emoji, label: area.label, color: area.color));
      }
    }
    return SizedBox(
      height: 26,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: chips,
      ),
    );
  }

  Widget _chip({IconData? icon, String? emoji, required String label, required Color color}) {
    return Container(
      margin: const EdgeInsets.only(right: 6),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withAlpha(22),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withAlpha(80)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (emoji != null)
            Text(emoji, style: const TextStyle(fontSize: 11))
          else if (icon != null)
            Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
