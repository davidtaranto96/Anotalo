import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uuid/uuid.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../domain/models/habit.dart';
import '../providers/habit_provider.dart';

const _presetColors = [
  Color(0xFFC44B4B), // red
  Color(0xFFC15F3C), // terracotta
  Color(0xFFC4963A), // golden
  Color(0xFF5B8A5E), // green
  Color(0xFF5B7E9E), // blue
  Color(0xFF7B5EA7), // purple
  Color(0xFFD97757), // coral
  Color(0xFF4A4540), // dark
];

const _presetEmojis = [
  '\u{1F3CB}\u{FE0F}', // weight lifting
  '\u{1F4DA}', // books
  '\u{1F34E}', // apple
  '\u{1F48A}', // pill
  '\u{1F9D8}', // yoga
  '\u{1F4A7}', // water
  '\u{1F3C3}', // running
  '\u{1F4A4}', // sleep
  '\u{1F3B5}', // music
  '\u{270D}\u{FE0F}', // writing
  '\u{1F9F9}', // broom
  '\u{1F64F}', // prayer
  '\u{1F6B6}', // walking
  '\u{1F957}', // salad
  '\u{1F4D6}', // book
  '\u{1F4AA}', // flexed biceps
];

class AddHabitBottomSheet extends ConsumerStatefulWidget {
  final Habit? initialHabit;

  const AddHabitBottomSheet({super.key, this.initialHabit});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const AddHabitBottomSheet(),
    );
  }

  static void showEdit(BuildContext context, Habit habit) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AddHabitBottomSheet(initialHabit: habit),
    );
  }

  @override
  ConsumerState<AddHabitBottomSheet> createState() => _State();
}

class _State extends ConsumerState<AddHabitBottomSheet> {
  final _controller = TextEditingController();
  HabitFrequency _frequency = HabitFrequency.daily;
  Color _selectedColor = _presetColors[3]; // green default
  String? _selectedEmoji;
  static const _uuid = Uuid();

  @override
  void initState() {
    super.initState();
    if (widget.initialHabit != null) {
      _controller.text = widget.initialHabit?.title ?? '';
      _frequency = widget.initialHabit?.frequency ?? HabitFrequency.daily;
      if (widget.initialHabit?.color != null) {
        try {
          _selectedColor = Color(int.parse(widget.initialHabit!.color!, radix: 16));
        } catch (_) {
          // keep default
        }
      }
      _selectedEmoji = widget.initialHabit?.icon;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _save() {
    final title = _controller.text.trim();
    if (title.isEmpty) return;
    final colorHex = _selectedColor.toARGB32().toRadixString(16).padLeft(8, '0').toUpperCase();
    if (widget.initialHabit != null) {
      ref.read(habitServiceProvider).updateHabit(
        widget.initialHabit!.id,
        title: title,
        frequency: _frequency,
        color: colorHex,
        icon: _selectedEmoji,
      );
    } else {
      ref.read(habitServiceProvider).addHabit(Habit(
        id: _uuid.v4(),
        title: title,
        frequency: _frequency,
        color: colorHex,
        icon: _selectedEmoji,
        createdAt: DateTime.now(),
      ));
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    final isEditing = widget.initialHabit != null;
    final maxHeight = MediaQuery.of(context).size.height * 0.85;
    return Container(
      constraints: BoxConstraints(maxHeight: maxHeight),
      padding: EdgeInsets.fromLTRB(24, 12, 24, 20 + bottom),
      decoration: BoxDecoration(
        color: context.surfaceSheet,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: AppTheme.shadowLg,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
          Center(
            child: Container(
              width: 40, height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: context.dividerColor,
                borderRadius: const BorderRadius.all(Radius.circular(999)),
              ),
            ),
          ),
          Text(
            isEditing ? 'Editar hábito' : 'Nuevo habito',
            style: GoogleFonts.fraunces(fontSize: 20, fontWeight: FontWeight.w600, color: context.textPrimary),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _controller,
            autofocus: true,
            style: GoogleFonts.inter(color: context.textPrimary, fontSize: 15),
            decoration: const InputDecoration(hintText: '¿Que habito queres formar?'),
            onSubmitted: (_) => _save(),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _FreqOption(
                label: 'Diario',
                selected: _frequency == HabitFrequency.daily,
                onTap: () => setState(() => _frequency = HabitFrequency.daily),
              ),
              const SizedBox(width: 10),
              _FreqOption(
                label: 'Semanal',
                selected: _frequency == HabitFrequency.weekly,
                onTap: () => setState(() => _frequency = HabitFrequency.weekly),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Color picker
          Align(
            alignment: Alignment.centerLeft,
            child: Text('Color',
                style: GoogleFonts.inter(
                    fontSize: 13, fontWeight: FontWeight.w600, color: AppTheme.textSecondary)),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: _presetColors.map((color) {
              final isSelected = _selectedColor == color;
              return GestureDetector(
                onTap: () => setState(() => _selectedColor = color),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                    border: isSelected
                        ? Border.all(color: context.textPrimary, width: 2)
                        : null,
                  ),
                  child: isSelected
                      ? const Icon(Icons.check, size: 14, color: Colors.white)
                      : null,
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          // Emoji picker
          Align(
            alignment: Alignment.centerLeft,
            child: Text('Icono',
                style: GoogleFonts.inter(
                    fontSize: 13, fontWeight: FontWeight.w600, color: AppTheme.textSecondary)),
          ),
          const SizedBox(height: 8),
          GridView.count(
            crossAxisCount: 4,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 6,
            crossAxisSpacing: 6,
            childAspectRatio: 1.6,
            children: _presetEmojis.map((emoji) {
              final isSelected = _selectedEmoji == emoji;
              return GestureDetector(
                onTap: () => setState(() {
                  _selectedEmoji = isSelected ? null : emoji;
                }),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  decoration: BoxDecoration(
                    color: isSelected ? AppTheme.colorPrimaryLight : context.surfaceCard,
                    borderRadius: AppTheme.r8,
                    border: Border.all(
                      color: isSelected ? AppTheme.colorPrimary : context.dividerColor,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(emoji, style: const TextStyle(fontSize: 20)),
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
            child: Text(
              isEditing ? 'Guardar cambios' : 'Agregar habito',
              style: GoogleFonts.inter(fontWeight: FontWeight.w600),
            ),
          ),
        ],
        ),
      ),
    );
  }
}

class _FreqOption extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _FreqOption({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: selected ? AppTheme.colorPrimaryLight : context.surfaceCard,
            borderRadius: AppTheme.r8,
            border: Border.all(
              color: selected ? AppTheme.colorPrimary : context.dividerColor,
            ),
          ),
          child: Text(label, textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w600,
                color: selected ? AppTheme.colorPrimary : AppTheme.textTertiary,
              )),
        ),
      ),
    );
  }
}
