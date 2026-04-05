import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/format_utils.dart';
import '../../domain/models/journal_entry.dart';
import '../providers/journal_provider.dart';

class RevisionPage extends ConsumerStatefulWidget {
  const RevisionPage({super.key});

  @override
  ConsumerState<RevisionPage> createState() => _RevisionPageState();
}

class _RevisionPageState extends ConsumerState<RevisionPage> {
  final _reflectionCtrl = TextEditingController();
  final _gratitudeCtrl = TextEditingController();
  final _lessonsCtrl = TextEditingController();
  final _tomorrowCtrl = TextEditingController();
  int _mood = 3;
  bool _initialized = false;

  @override
  void dispose() {
    _reflectionCtrl.dispose();
    _gratitudeCtrl.dispose();
    _lessonsCtrl.dispose();
    _tomorrowCtrl.dispose();
    super.dispose();
  }

  void _initFromEntry(JournalEntry? entry) {
    if (_initialized || entry == null) return;
    _initialized = true;
    _reflectionCtrl.text = entry.reflection;
    _gratitudeCtrl.text = entry.gratitude ?? '';
    _lessonsCtrl.text = entry.lessonsLearned ?? '';
    _tomorrowCtrl.text = entry.tomorrowFocus ?? '';
    _mood = entry.mood ?? 3;
  }

  void _save() {
    final entry = JournalEntry(
      id: '',
      dayId: todayId(),
      reflection: _reflectionCtrl.text.trim(),
      mood: _mood,
      gratitude: _gratitudeCtrl.text.trim().isEmpty ? null : _gratitudeCtrl.text.trim(),
      lessonsLearned: _lessonsCtrl.text.trim().isEmpty ? null : _lessonsCtrl.text.trim(),
      tomorrowFocus: _tomorrowCtrl.text.trim().isEmpty ? null : _tomorrowCtrl.text.trim(),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    ref.read(journalServiceProvider).saveEntry(entry);
    Navigator.of(context, rootNavigator: true).pop();
  }

  @override
  Widget build(BuildContext context) {
    final entryAsync = ref.watch(todayJournalProvider);
    entryAsync.whenData(_initFromEntry);

    return Scaffold(
      backgroundColor: AppTheme.surfaceBase,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            floating: true,
            backgroundColor: AppTheme.surfaceBase,
            surfaceTintColor: Colors.transparent,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_rounded),
              onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
            ),
            title: Text('Revisión diaria',
                style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.w700)),
            actions: [
              TextButton(
                onPressed: _save,
                child: Text('Guardar',
                    style: GoogleFonts.inter(
                        color: AppTheme.colorPrimary, fontWeight: FontWeight.w600)),
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _SectionLabel('Estado de ánimo'),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: List.generate(5, (i) {
                      final val = i + 1;
                      return GestureDetector(
                        onTap: () => setState(() => _mood = val),
                        child: Text(
                          ['😔', '😕', '😐', '🙂', '😄'][i],
                          style: TextStyle(
                            fontSize: _mood == val ? 36 : 28,
                            color: _mood == val ? null : const Color(0x80FFFFFF),
                          ),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 24),
                  const _SectionLabel('Reflexión del día'),
                  const SizedBox(height: 8),
                  _TextArea(controller: _reflectionCtrl, hint: '¿Cómo fue tu día?'),
                  const SizedBox(height: 20),
                  const _SectionLabel('Gratitud'),
                  const SizedBox(height: 8),
                  _TextArea(controller: _gratitudeCtrl, hint: '¿Por qué estás agradecido hoy?'),
                  const SizedBox(height: 20),
                  const _SectionLabel('Aprendizajes'),
                  const SizedBox(height: 8),
                  _TextArea(controller: _lessonsCtrl, hint: '¿Qué aprendiste hoy?'),
                  const SizedBox(height: 20),
                  const _SectionLabel('Enfoque de mañana'),
                  const SizedBox(height: 8),
                  _TextArea(controller: _tomorrowCtrl, hint: '¿En qué vas a enfocar mañana?'),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppTheme.colorNeutral,
      ),
    );
  }
}

class _TextArea extends StatelessWidget {
  final TextEditingController controller;
  final String hint;

  const _TextArea({required this.controller, required this.hint});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: 4,
      style: GoogleFonts.inter(color: const Color(0xFFF0F0FF), fontSize: 14),
      decoration: InputDecoration(hintText: hint),
    );
  }
}
