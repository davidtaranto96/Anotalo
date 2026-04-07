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
  late final TextEditingController _notesController;
  final TextEditingController _addTaskController = TextEditingController();
  static const _uuid = Uuid();

  @override
  void initState() {
    super.initState();
    _notesController = TextEditingController(text: widget.project.notes ?? '');
  }

  @override
  void dispose() {
    _notesController.dispose();
    _addTaskController.dispose();
    super.dispose();
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
                              style: GoogleFonts.lora(
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
                    Icon(Icons.add_rounded, size: 20, color: context.textTertiary),
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
                            priority: TaskPriority.puedeEsperar,
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
                  // Priority dot
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _priorityColor(task.priority),
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
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // Toolbar: voice mic + save button
          Row(
            children: [
              VoiceInputButton(
                size: 40,
                onResult: (text) {
                  final current = _notesController.text;
                  final separator = current.isNotEmpty ? '\n' : '';
                  _notesController.text = '$current$separator$text';
                  _notesController.selection = TextSelection.collapsed(
                    offset: _notesController.text.length,
                  );
                },
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Dictá o escribí tus notas',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: context.textTertiary,
                  ),
                ),
              ),
              FilledButton.tonal(
                onPressed: () {
                  ref.read(projectServiceProvider).updateNotes(
                    widget.project.id,
                    _notesController.text,
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Notas guardadas', style: GoogleFonts.inter()),
                      backgroundColor: AppTheme.colorSuccess,
                      behavior: SnackBarBehavior.floating,
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                ),
                child: Text('Guardar', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Expanded(
            child: TextField(
              controller: _notesController,
              maxLines: null,
              expands: true,
              textAlignVertical: TextAlignVertical.top,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: context.textPrimary,
                height: 1.6,
              ),
              decoration: InputDecoration(
                hintText: 'Ideas, presupuesto, contexto, links...',
                hintStyle: GoogleFonts.inter(color: context.textTertiary, fontSize: 14),
                filled: true,
                fillColor: context.surfaceInput,
                border: OutlineInputBorder(
                  borderRadius: AppTheme.r12,
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.all(16),
              ),
            ),
          ),
        ],
      ),
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
