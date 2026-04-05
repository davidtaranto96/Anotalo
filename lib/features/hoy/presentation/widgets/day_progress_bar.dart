import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../core/theme/app_theme.dart';

class DayProgressBar extends StatelessWidget {
  final double progress;
  final int completed;
  final int total;

  const DayProgressBar({
    super.key,
    required this.progress,
    required this.completed,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Progreso del día',
                  style: GoogleFonts.inter(
                      color: AppTheme.colorNeutral, fontSize: 12)),
              Text('$completed / $total',
                  style: GoogleFonts.inter(
                      color: AppTheme.colorNeutral, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: progress.clamp(0.0, 1.0)),
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOutCubic,
              builder: (_, value, __) => LinearProgressIndicator(
                value: value,
                minHeight: 6,
                backgroundColor: AppTheme.surfaceCard,
                valueColor: const AlwaysStoppedAnimation(AppTheme.colorPrimary),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
