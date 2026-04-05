import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uuid/uuid.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../domain/models/habit.dart';
import '../providers/habit_provider.dart';

class AddHabitBottomSheet extends ConsumerStatefulWidget {
  const AddHabitBottomSheet({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const AddHabitBottomSheet(),
    );
  }

  @override
  ConsumerState<AddHabitBottomSheet> createState() => _State();
}

class _State extends ConsumerState<AddHabitBottomSheet> {
  final _controller = TextEditingController();
  HabitFrequency _frequency = HabitFrequency.daily;
  static const _uuid = Uuid();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _save() {
    final title = _controller.text.trim();
    if (title.isEmpty) return;
    ref.read(habitServiceProvider).addHabit(Habit(
      id: _uuid.v4(),
      title: title,
      frequency: _frequency,
      createdAt: DateTime.now(),
    ));
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    return Container(
      padding: EdgeInsets.fromLTRB(20, 12, 20, 20 + bottom),
      decoration: const BoxDecoration(
        color: AppTheme.surfaceSheet,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
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
          Text('Nuevo hábito',
              style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w700, color: const Color(0xFFF0F0FF))),
          const SizedBox(height: 20),
          TextField(
            controller: _controller,
            autofocus: true,
            style: GoogleFonts.inter(color: const Color(0xFFF0F0FF)),
            decoration: const InputDecoration(hintText: '¿Qué hábito querés formar?'),
            onSubmitted: (_) => _save(),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _frequency = HabitFrequency.daily),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: _frequency == HabitFrequency.daily
                          ? AppTheme.colorPrimary.withAlpha(51)
                          : AppTheme.surfaceCard,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: _frequency == HabitFrequency.daily
                            ? AppTheme.colorPrimary
                            : Colors.white.withAlpha(18),
                      ),
                    ),
                    child: Text('Diario', textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w600,
                          color: _frequency == HabitFrequency.daily
                              ? AppTheme.colorPrimary
                              : AppTheme.colorNeutral,
                        )),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _frequency = HabitFrequency.weekly),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: _frequency == HabitFrequency.weekly
                          ? AppTheme.colorPrimary.withAlpha(51)
                          : AppTheme.surfaceCard,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: _frequency == HabitFrequency.weekly
                            ? AppTheme.colorPrimary
                            : Colors.white.withAlpha(18),
                      ),
                    ),
                    child: Text('Semanal', textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w600,
                          color: _frequency == HabitFrequency.weekly
                              ? AppTheme.colorPrimary
                              : AppTheme.colorNeutral,
                        )),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          FilledButton(
            onPressed: _save,
            style: FilledButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
              backgroundColor: AppTheme.colorPrimary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: Text('Agregar hábito', style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}
