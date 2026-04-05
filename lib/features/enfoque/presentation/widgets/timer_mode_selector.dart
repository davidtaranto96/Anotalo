import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../domain/models/timer_state.dart';

class TimerModeSelector extends StatelessWidget {
  final TimerMode selected;
  final Function(TimerMode) onSelect;

  const TimerModeSelector({
    super.key,
    required this.selected,
    required this.onSelect,
  });

  static const _modes = [
    TimerMode.pomodoro25,
    TimerMode.pomodoro50,
    TimerMode.deepWork90,
    TimerMode.quick5,
    TimerMode.break5,
    TimerMode.break10,
    TimerMode.break15,
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _modes.length,
        itemBuilder: (_, i) {
          final mode = _modes[i];
          final isSelected = mode == selected;
          return GestureDetector(
            onTap: () => onSelect(mode),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppTheme.colorPrimary.withAlpha(51)
                    : AppTheme.surfaceCard,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected
                      ? AppTheme.colorPrimary.withAlpha(128)
                      : Colors.white.withAlpha(18),
                ),
              ),
              child: Text(
                mode.label,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  color: isSelected ? AppTheme.colorPrimary : AppTheme.colorNeutral,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
