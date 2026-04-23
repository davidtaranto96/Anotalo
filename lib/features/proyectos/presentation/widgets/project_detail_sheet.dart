import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/widgets/voice_input_button.dart';
import '../../../hoy/domain/models/task.dart';
import '../../../hoy/presentation/providers/task_provider.dart';
import '../../domain/models/project.dart';
import '../../domain/models/project_note.dart';
import '../providers/project_provider.dart';
import '../../../../../core/utils/format_utils.dart';

class ProjectDetailSheet extends ConsumerStatefulWidget {
  final Project project;

  const ProjectDetailSheet({super.key, required this.project});

  static void show(BuildContext context, Project project) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ProjectDetailSheet(project: project),
    );
  }

  @override
  ConsumerState<ProjectDetailSheet> createState() => _ProjectDetailSheetState();
}

class _ProjectDetailSheetState extends ConsumerState<ProjectDetailSheet> {
  final TextEditingController _addTaskController = TextEditingController();
  final TextEditingController _newNoteController = TextEditingController();
  final TextEditingController _editNoteController = TextEditingController();
  TaskPriority _addTaskPriority = TaskPriority.puedeEsperar;
  List<ProjectNote> _notes = [];
  String? _editingNoteId;
  static const _uuid = Uuid();

  TaskPriority _nextPriority(TaskPriority p) => switch (p) {
    TaskPriority.primordial   => TaskPriority.importante,
    TaskPriority.importante   => TaskPriority.puedeEsperar,
    TaskPriority.puedeEsperar => TaskPriority.primordial,
    TaskPriority.secundaria   => TaskPriority.primordial,
  };

  @override
  void initState() {
    super.initState();
    _notes = _decodeNotes(widget.project.notes);
  }

  @override
  void dispose() {
    _addTaskController.dispose();
    _newNoteController.dispose();
    _editNoteController.dispose();
    super.dispose();
  }

  List<ProjectNote> _decodeNotes(String? raw) {
    if (raw == null || raw.isEmpty) return [];
    try {
      final list = jsonDecode(raw) as List;
      return list.map((e) => ProjectNote.fromJson(e as Map<String, dynamic>)).toList();
    } catch (_) {
      // Legacy: plain text stored as notes — migrate to single note
      if (raw.trim().isNotEmpty) {
        return [ProjectNote(id: _uuid.v4(), text: raw.trim(), createdAt: widget.project.createdAt)];
      }
      return [];
    }
  }

  String _encodeNotes(List<ProjectNote> notes) => jsonEncode(notes.map((n) => n.toJson()).toList());

  Future<void> _saveNotes() async {
    await ref.read(projectServiceProvider).updateNotes(
      widget.project.id,
      _encodeNotes(_notes),
    );
  }

  void _addNote(String text) {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return;
    setState(() {
      _notes = [
        ProjectNote(id: _uuid.v4(), text: trimmed, createdAt: DateTime.now()),
        ..._notes,
      ];
    });
    _newNoteController.clear();
    _saveNotes();
  }

  void _deleteNote(String id) {
    setState(() => _notes = _notes.where((n) => n.id != id).toList());
    _saveNotes();
  }

  void _commitEdit(String id) {
    final newText = _editNoteController.text.trim();
    if (newText.isNotEmpty) {
      setState(() {
        _notes = _notes.map((n) => n.id == id ? ProjectNote(id: n.id, text: newText, createdAt: n.createdAt) : n).toList();
      });
      _saveNotes();
    }
    setState(() => _editingNoteId = null);
  }

  Color _parseColor(String hex) {
    try {
      return Color(int.parse(hex.replaceFirst('#', 'FF'), radix: 16));
    } catch (_) {
      return AppTheme.colorPrimary;
    }
  }

  (String, String) _categoryInfo(ProjectCategory c) => switch (c) {
    ProjectCategory.professional => ('Profesional', '💼'),
    ProjectCategory.personal     => ('Personal', '🏠'),
    ProjectCategory.health       => ('Salud', '🏥'),
    ProjectCategory.learning     => ('Estudio', '📚'),
    ProjectCategory.travel       => ('Viaje', '✈️'),
  };

  (String, Color, Color) _statusInfo(ProjectStatus s) => switch (s) {
    ProjectStatus.active    => ('Activo', AppTheme.colorSuccess, AppTheme.colorSuccessLight),
    ProjectStatus.paused    => ('Pausado', AppTheme.colorWarning, AppTheme.colorWarningLight),
    ProjectStatus.completed => ('Completado', AppTheme.colorInfo, const Color(0xFFE3EDF5)),
    ProjectStatus.archived  => ('Archivado', AppTheme.textTertiary, AppTheme.neutral100),
  };

  Color _priorityColor(TaskPriority p) => switch (p) {
    TaskPriority.primordial   => AppTheme.colorDanger,
    TaskPriority.importante   => AppTheme.colorWarning,
    TaskPriority.puedeEsperar => AppTheme.colorPrimary,
    TaskPriority.secundaria   => AppTheme.neutral400,
  };

  @override
  Widget build(BuildContext context) {
    final project = widget.project;
    final color = _parseColor(project.color);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppTheme.darkSurfaceSheet : AppTheme.surfaceSheet;
    final textColor = isDark ? AppTheme.darkTextPrimary : AppTheme.textPrimary;
    final secondaryTextColor = isDark ? AppTheme.darkTextSecondary : AppTheme.textSecondary;
    final tertiaryTextColor = isDark ? AppTheme.darkTextTertiary : AppTheme.textTertiary;
    final dividerColor = isDark ? AppTheme.darkDivider : AppTheme.divider;

    return DefaultTabController(
      length: 3,
      child: DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.92,
        minChildSize: 0.4,
        builder: (context, scrollController) {
          return Container(
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              boxShadow: AppTheme.shadowLg,
            ),
            child: Column(
              children: [
                // Handle
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(top: 12, bottom: 16),
                    decoration: BoxDecoration(
                      color: dividerColor,
                      borderRadius: AppTheme.rFull,
                    ),
                  ),
                ),
                // Header
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: color,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              project.title,
                              style: GoogleFonts.fraunces(
                                fontSize: 22,
                                fontWeight: FontWeight.w600,
                                color: textColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (project.description != null) ...[
                        const SizedBox(height: 8),
                        Text(
                          project.description!,
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: secondaryTextColor,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                // Tab bar
                TabBar(
                  labelColor: AppTheme.colorPrimary,
                  unselectedLabelColor: tertiaryTextColor,
                  indicatorColor: AppTheme.colorPrimary,
                  indicatorSize: TabBarIndicatorSize.label,
                  labelStyle: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600),
                  unselectedLabelStyle: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w400),
                  dividerColor: dividerColor,
                  tabs: const [
                    Tab(text: 'Tareas'),
                    Tab(text: 'Notas'),
                    Tab(text: 'Info'),
                  ],
                ),
                // Tab content
                Expanded(
                  child: TabBarView(
                    children: [
                      _buildTareasTab(scrollController),
                      _buildNotasTab(),
                      _buildInfoTab(project, color),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // ── Tareas tab ──
  Widget _buildTareasTab(ScrollController scrollController) {
    final taskService = ref.read(taskServiceProvider);
    final projectService = ref.read(projectServiceProvider);

    return StreamBuilder<List<Task>>(
      stream: taskService.watchTasksByProject(widget.project.id),
      builder: (context, snapshot) {
        final tasks = snapshot.data ?? [];
        final total = tasks.length;
        final done = tasks.where((t) => t.status == TaskStatus.done).length;
        final progress = total == 0 ? 0.0 : done / total;

        return ListView.builder(
          controller: scrollController,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          itemCount: tasks.length + 2, // +1 progress header, +1 add row
          itemBuilder: (_, i) {
            // Progress header
            if (i == 0) {
              if (total == 0) return const SizedBox.shrink();
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '$done de $total tareas completadas',
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            color: context.textSecondary,
                          ),
                        ),
                        Text(
                          '${(progress * 100).round()}%',
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.colorPrimary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 6,
                        backgroundColor: context.dividerColor,
                        valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.colorPrimary),
                      ),
                    ),
                  ],
                ),
              );
            }

            // Add task row (last item)
            if (i == tasks.length + 1) {
              return Container(
                margin: const EdgeInsets.only(top: 4, bottom: 8),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: context.surfaceInput,
                  borderRadius: AppTheme.r12,
                  border: Border.all(color: context.dividerColor),
                ),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => setState(() => _addTaskPriority = _nextPriority(_addTaskPriority)),
                      child: Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: _priorityColor(_addTaskPriority).withAlpha(30),
                          shape: BoxShape.circle,
                          border: Border.all(color: _priorityColor(_addTaskPriority), width: 1.5),
                        ),
                        child: Center(
                          child: Text(
                            _addTaskPriority.name[0].toUpperCase(),
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: _priorityColor(_addTaskPriority),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: _addTaskController,
                        style: GoogleFonts.inter(fontSize: 14, color: context.textPrimary),
                        decoration: InputDecoration(
                          hintText: 'Agregar tarea...',
                          hintStyle: GoogleFonts.inter(fontSize: 14, color: context.textTertiary),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(vertical: 10),
                        ),
                        onSubmitted: (value) async {
                          final title = value.trim();
                          if (title.isEmpty) return;
                          final taskId = _uuid.v4();
                          final task = Task(
                            id: taskId,
                            title: title,
                            priority: _addTaskPriority,
                            status: TaskStatus.pending,
                            parentProjectId: widget.project.id,
                            dayId: todayId(),
                            createdAt: DateTime.now(),
                          );
                          await taskService.addTask(task);
                          await projectService.addTaskToProject(widget.project.id, taskId);
                          _addTaskController.clear();
                        },
                      ),
                    ),
                  ],
                ),
              );
            }

            final task = tasks[i - 1]; // offset by 1 for progress header
            final isDone = task.status == TaskStatus.done;
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isDone ? context.neutral50 : context.surfaceCard,
                borderRadius: AppTheme.r12,
                border: Border.all(color: context.dividerColor),
              ),
              child: Row(
                children: [
                  // Priority dot (tappable — cycles priority)
                  GestureDetector(
                    onTap: () => taskService.updatePriority(task.id, _nextPriority(task.priority)),
                    child: Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _priorityColor(task.priority).withAlpha(35),
                        border: Border.all(color: _priorityColor(task.priority), width: 1.5),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Complete/uncomplete circle
                  GestureDetector(
                    onTap: () {
                      if (isDone) {
                        taskService.uncompleteTask(task.id);
                      } else {
                        taskService.completeTask(task.id);
                      }
                    },
                    child: Container(
                      width: 22,
                      height: 22,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isDone ? AppTheme.colorSuccess : Colors.transparent,
                        border: Border.all(
                          color: isDone ? AppTheme.colorSuccess : AppTheme.neutral400,
                          width: 2,
                        ),
                      ),
                      child: isDone
                          ? const Icon(Icons.check, size: 12, color: Colors.white)
                          : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      task.title,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: isDone ? context.textTertiary : context.textPrimary,
                        decoration: isDone ? TextDecoration.lineThrough : null,
                      ),
                    ),
                  ),
                  // Delete button
                  GestureDetector(
                    onTap: () async {
                      await projectService.removeTaskFromProject(
                        widget.project.id,
                        task.id,
                      );
                      await taskService.deleteTask(task.id);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: Icon(
                        Icons.close_rounded,
                        size: 16,
                        color: context.textTertiary,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // ── Notas tab ──
  Widget _buildNotasTab() {
    final dateFormatter = DateFormat('d MMM, HH:mm', 'es');
    return Column(
      children: [
        // Notes list
        Expanded(
          child: _notes.isEmpty
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.notes_rounded, size: 40, color: context.textTertiary.withAlpha(80)),
                      const SizedBox(height: 8),
                      Text(
                        'Sin notas todavía',
                        style: GoogleFonts.inter(fontSize: 14, color: context.textTertiary),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                  itemCount: _notes.length,
                  itemBuilder: (_, i) {
                    final note = _notes[i];
                    final isEditing = _editingNoteId == note.id;
                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                        color: context.surfaceCard,
                        borderRadius: AppTheme.r12,
                        border: Border.all(color: context.dividerColor),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(14, 12, 8, 4),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: isEditing
                                      ? TextField(
                                          controller: _editNoteController,
                                          autofocus: true,
                                          maxLines: null,
                                          style: GoogleFonts.inter(fontSize: 14, color: context.textPrimary, height: 1.5),
                                          decoration: const InputDecoration(
                                            border: InputBorder.none,
                                            contentPadding: EdgeInsets.zero,
                                            isDense: true,
                                          ),
                                          onSubmitted: (_) => _commitEdit(note.id),
                                        )
                                      : GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              _editingNoteId = note.id;
                                              _editNoteController.text = note.text;
                                              _editNoteController.selection = TextSelection.collapsed(offset: note.text.length);
                                            });
                                          },
                                          child: Text(
                                            note.text,
                                            style: GoogleFonts.inter(fontSize: 14, color: context.textPrimary, height: 1.5),
                                          ),
                                        ),
                                ),
                                if (isEditing)
                                  GestureDetector(
                                    onTap: () => _commitEdit(note.id),
                                    child: const Padding(
                                      padding: EdgeInsets.only(left: 4),
                                      child: Icon(Icons.check_rounded, size: 18, color: AppTheme.colorSuccess),
                                    ),
                                  )
                                else
                                  GestureDetector(
                                    onTap: () => _deleteNote(note.id),
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 4),
                                      child: Icon(Icons.close_rounded, size: 16, color: context.textTertiary),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(14, 0, 14, 10),
                            child: Text(
                              dateFormatter.format(note.createdAt),
                              style: GoogleFonts.inter(fontSize: 11, color: context.textTertiary),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
        ),
        // Add note row
        Container(
          margin: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: context.surfaceInput,
            borderRadius: AppTheme.r12,
            border: Border.all(color: context.dividerColor),
          ),
          child: Row(
            children: [
              VoiceInputButton(
                size: 36,
                onResult: (text) {
                  final current = _newNoteController.text;
                  final sep = current.isNotEmpty ? ' ' : '';
                  _newNoteController.text = '$current$sep$text';
                  _newNoteController.selection = TextSelection.collapsed(offset: _newNoteController.text.length);
                },
              ),
              const SizedBox(width: 6),
              Expanded(
                child: TextField(
                  controller: _newNoteController,
                  maxLines: null,
                  style: GoogleFonts.inter(fontSize: 14, color: context.textPrimary),
                  decoration: InputDecoration(
                    hintText: 'Agregar nota...',
                    hintStyle: GoogleFonts.inter(fontSize: 14, color: context.textTertiary),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 10),
                    isDense: true,
                  ),
                  onSubmitted: _addNote,
                ),
              ),
              GestureDetector(
                onTap: () => _addNote(_newNoteController.text),
                child: const Padding(
                  padding: EdgeInsets.all(6),
                  child: Icon(Icons.send_rounded, size: 20, color: AppTheme.colorPrimary),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ── Info tab ──
  Widget _buildInfoTab(Project project, Color color) {
    final (catLabel, catEmoji) = _categoryInfo(project.category);
    final (statusLabel, statusColor, statusBg) = _statusInfo(project.status);
    final textColor = context.textPrimary;
    final secondaryTextColor = context.textSecondary;
    final tertiaryTextColor = context.textTertiary;
    final dividerColor = context.dividerColor;
    final cardColor = context.surfaceCard;

    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        // Category
        _infoRow(
          'Categoría',
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(catEmoji, style: const TextStyle(fontSize: 16)),
              const SizedBox(width: 6),
              Text(catLabel, style: GoogleFonts.inter(fontSize: 14, color: textColor)),
            ],
          ),
          secondaryTextColor,
        ),
        const SizedBox(height: 16),

        // Status
        _infoRow(
          'Estado',
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: statusBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              statusLabel,
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: statusColor,
              ),
            ),
          ),
          secondaryTextColor,
        ),
        const SizedBox(height: 16),

        // Created date
        _infoRow(
          'Creado',
          Text(
            DateFormat('d MMM yyyy', 'es').format(project.createdAt),
            style: GoogleFonts.inter(fontSize: 14, color: textColor),
          ),
          secondaryTextColor,
        ),
        const SizedBox(height: 16),

        // Target date
        if (project.targetDate != null) ...[
          _infoRow(
            'Fecha límite',
            Text(
              _formatTargetDate(project.targetDate!),
              style: GoogleFonts.inter(fontSize: 14, color: textColor),
            ),
            secondaryTextColor,
          ),
          const SizedBox(height: 16),
        ],

        // Color
        _infoRow(
          'Color',
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color,
              border: Border.all(color: dividerColor),
            ),
          ),
          secondaryTextColor,
        ),
        const SizedBox(height: 24),

        Divider(color: dividerColor),
        const SizedBox(height: 16),

        // Action buttons
        Text(
          'ACCIONES',
          style: GoogleFonts.inter(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: tertiaryTextColor,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 12),
        ..._buildActionButtons(project, cardColor, dividerColor),
      ],
    );
  }

  Widget _infoRow(String label, Widget value, Color labelColor) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 110,
          child: Text(
            label,
            style: GoogleFonts.inter(fontSize: 13, color: labelColor),
          ),
        ),
        value,
      ],
    );
  }

  String _formatTargetDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('d MMM yyyy', 'es').format(date);
    } catch (_) {
      return dateStr;
    }
  }

  List<Widget> _buildActionButtons(Project project, Color cardColor, Color dividerColor) {
    final buttons = <Widget>[];

    if (project.status == ProjectStatus.active) {
      buttons.add(_actionButton(
        'Pausar',
        Icons.pause_circle_outline,
        AppTheme.colorWarning,
        () => _updateStatus(ProjectStatus.paused),
        cardColor,
        dividerColor,
      ));
      buttons.add(const SizedBox(height: 8));
      buttons.add(_actionButton(
        'Completar',
        Icons.check_circle_outline,
        AppTheme.colorSuccess,
        () => _updateStatus(ProjectStatus.completed),
        cardColor,
        dividerColor,
      ));
    } else if (project.status == ProjectStatus.paused) {
      buttons.add(_actionButton(
        'Reanudar',
        Icons.play_circle_outline,
        AppTheme.colorSuccess,
        () => _updateStatus(ProjectStatus.active),
        cardColor,
        dividerColor,
      ));
      buttons.add(const SizedBox(height: 8));
      buttons.add(_actionButton(
        'Completar',
        Icons.check_circle_outline,
        AppTheme.colorInfo,
        () => _updateStatus(ProjectStatus.completed),
        cardColor,
        dividerColor,
      ));
    } else if (project.status == ProjectStatus.completed) {
      buttons.add(_actionButton(
        'Reabrir',
        Icons.replay,
        AppTheme.colorPrimary,
        () => _updateStatus(ProjectStatus.active),
        cardColor,
        dividerColor,
      ));
    }

    // Archive is always available unless already archived
    if (project.status != ProjectStatus.archived) {
      buttons.add(const SizedBox(height: 8));
      buttons.add(_actionButton(
        'Archivar',
        Icons.archive_outlined,
        AppTheme.textTertiary,
        () => _updateStatus(ProjectStatus.archived),
        cardColor,
        dividerColor,
      ));
    }

    return buttons;
  }

  Widget _actionButton(String label, IconData icon, Color color, VoidCallback onTap, Color cardColor, Color dividerColor) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: AppTheme.r12,
          border: Border.all(color: dividerColor),
        ),
        child: Row(
          children: [
            Icon(icon, size: 20, color: color),
            const SizedBox(width: 12),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _updateStatus(ProjectStatus status) {
    ref.read(projectServiceProvider).updateStatus(widget.project.id, status);
    Navigator.of(context).pop();
  }
}
