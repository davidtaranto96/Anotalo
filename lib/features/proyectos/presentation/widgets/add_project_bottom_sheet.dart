import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
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
  // ignore: prefer_final_fields
  ProjectCategory _category = ProjectCategory.personal;
  String _color = '#7C6EF7';
  static const _uuid = Uuid();

  static const _colors = ['#7C6EF7', '#5ECFB1', '#FF5C6E', '#FFB347', '#60A5FA', '#F472B6'];

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
      createdAt: DateTime.now(),
    ));
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.92),
      child: Container(
        padding: EdgeInsets.fromLTRB(20, 12, 20, 20 + bottom),
        decoration: const BoxDecoration(
          color: AppTheme.surfaceSheet,
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
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
                    color: Colors.white.withAlpha(25),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Text('Nuevo proyecto',
                  style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w700, color: const Color(0xFFF0F0FF))),
              const SizedBox(height: 20),
              TextField(
                controller: _titleController,
                autofocus: true,
                style: GoogleFonts.inter(color: const Color(0xFFF0F0FF)),
                decoration: const InputDecoration(hintText: 'Nombre del proyecto'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _descController,
                style: GoogleFonts.inter(color: const Color(0xFFF0F0FF)),
                decoration: const InputDecoration(hintText: 'Descripción (opcional)'),
                maxLines: 2,
              ),
              const SizedBox(height: 16),
              // Color picker
              Text('Color', style: GoogleFonts.inter(fontSize: 13, color: AppTheme.colorNeutral)),
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
                          color: _color == c ? Colors.white : Colors.transparent,
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
                  backgroundColor: AppTheme.colorPrimary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
