import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../domain/models/project.dart';
import '../providers/project_provider.dart';

class AddProjectBottomSheet extends ConsumerStatefulWidget {
  const AddProjectBottomSheet({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const AddProjectBottomSheet(),
    );
  }

  @override
  ConsumerState<AddProjectBottomSheet> createState() => _State();
}

class _State extends ConsumerState<AddProjectBottomSheet> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  ProjectCategory _category = ProjectCategory.personal;
  String _color = '#C15F3C';
  DateTime? _targetDate;
  static const _uuid = Uuid();

  static const _colors = [
    '#C15F3C', '#D97757', '#5B8A5E', '#C4963A', '#5B7E9E', '#C44B4B',
    '#7B5EA7', '#4A4540',
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  void _save() {
    final title = _titleController.text.trim();
    if (title.isEmpty) return;
    ref.read(projectServiceProvider).addProject(Project(
      id: _uuid.v4(),
      title: title,
      description: _descController.text.trim().isEmpty ? null : _descController.text.trim(),
      category: _category,
      status: ProjectStatus.active,
      color: _color,
      targetDate: _targetDate != null
          ? DateFormat('yyyy-MM-dd').format(_targetDate!)
          : null,
      createdAt: DateTime.now(),
    ));
    Navigator.of(context).pop();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _targetDate ?? DateTime.now().add(const Duration(days: 7)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 3)),
      locale: const Locale('es'),
    );
    if (picked != null) {
      setState(() => _targetDate = picked);
    }
  }

  (String, String) _categoryInfo(ProjectCategory c) => switch (c) {
    ProjectCategory.professional => ('Profesional', '💼'),
    ProjectCategory.personal     => ('Personal', '🏠'),
    ProjectCategory.health       => ('Salud', '🏥'),
    ProjectCategory.learning     => ('Estudio', '📚'),
    ProjectCategory.travel       => ('Viaje', '✈️'),
  };

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.92),
      child: Container(
        padding: EdgeInsets.fromLTRB(24, 12, 24, 20 + bottom),
        decoration: BoxDecoration(
          color: AppTheme.surfaceSheet,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          boxShadow: AppTheme.shadowLg,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40, height: 4,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: AppTheme.divider,
                    borderRadius: AppTheme.rFull,
                  ),
                ),
              ),
              Text('Nuevo proyecto',
                  style: GoogleFonts.fraunces(fontSize: 20, fontWeight: FontWeight.w600, color: AppTheme.textPrimary)),
              const SizedBox(height: 20),
              TextField(
                controller: _titleController,
                autofocus: true,
                style: GoogleFonts.inter(color: AppTheme.textPrimary, fontSize: 15),
                decoration: const InputDecoration(hintText: 'Nombre del proyecto'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _descController,
                style: GoogleFonts.inter(color: AppTheme.textPrimary, fontSize: 15),
                decoration: const InputDecoration(hintText: 'Descripción (opcional)'),
                maxLines: 2,
              ),
              const SizedBox(height: 16),

              // Category selector
              Text('Categoría', style: GoogleFonts.inter(fontSize: 13, color: AppTheme.textSecondary)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: ProjectCategory.values.map((cat) {
                  final (label, emoji) = _categoryInfo(cat);
                  final selected = _category == cat;
                  return GestureDetector(
                    onTap: () => setState(() => _category = cat),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: selected ? AppTheme.colorPrimaryLight : AppTheme.surfaceInput,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: selected ? AppTheme.colorPrimary : AppTheme.divider,
                          width: selected ? 1.5 : 1,
                        ),
                      ),
                      child: Text(
                        '$emoji $label',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                          color: selected ? AppTheme.colorPrimary : AppTheme.textSecondary,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),

              // Target date picker
              Text('Fecha límite (opcional)', style: GoogleFonts.inter(fontSize: 13, color: AppTheme.textSecondary)),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: _pickDate,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceInput,
                    borderRadius: AppTheme.r12,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.calendar_today_outlined,
                        size: 18,
                        color: _targetDate != null ? AppTheme.colorPrimary : AppTheme.textTertiary,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        _targetDate != null
                            ? DateFormat('d MMM yyyy', 'es').format(_targetDate!)
                            : 'Seleccionar fecha',
                        style: GoogleFonts.inter(
                          fontSize: 15,
                          color: _targetDate != null ? AppTheme.textPrimary : AppTheme.textTertiary,
                        ),
                      ),
                      const Spacer(),
                      if (_targetDate != null)
                        GestureDetector(
                          onTap: () => setState(() => _targetDate = null),
                          child: const Icon(Icons.close, size: 18, color: AppTheme.textTertiary),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              Text('Color', style: GoogleFonts.inter(fontSize: 13, color: AppTheme.textSecondary)),
              const SizedBox(height: 8),
              Row(
                children: _colors.map((c) {
                  final color = Color(int.parse(c.replaceFirst('#', 'FF'), radix: 16));
                  return GestureDetector(
                    onTap: () => setState(() => _color = c),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.only(right: 10),
                      width: 32, height: 32,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: color,
                        border: Border.all(
                          color: _color == c ? AppTheme.textPrimary : Colors.transparent,
                          width: 2,
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
                ),
                child: Text('Crear proyecto', style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
