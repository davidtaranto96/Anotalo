import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../theme/app_colors.dart';
import '../utils/format_utils.dart';

/// Shows a bottom-sheet with quick defer options and returns the selected
/// dayId (`YYYY-MM-DD`) or `null` if the user cancels.
///
/// Quick presets: mañana · en 2 días · en 3 días · sábado · lunes próximo ·
/// elegir fecha…
Future<String?> showDeferPicker(
  BuildContext context, {
  String? currentDayId,
}) {
  return showModalBottomSheet<String>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _DeferSheet(currentDayId: currentDayId),
  );
}

class _DeferSheet extends StatelessWidget {
  final String? currentDayId;
  const _DeferSheet({this.currentDayId});

  static String _id(DateTime d) => dateToId(d);

  static DateTime _nextWeekday(DateTime from, int weekday) {
    var delta = weekday - from.weekday;
    if (delta <= 0) delta += 7;
    return from.add(Duration(days: delta));
  }

  Future<void> _pickCustom(BuildContext context) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now.add(const Duration(days: 1)),
      firstDate: now,
      lastDate: now.add(const Duration(days: 365 * 2)),
      helpText: 'Mover tarea a',
      confirmText: 'Posponer',
      cancelText: 'Cancelar',
    );
    if (!context.mounted) return;
    if (picked != null) {
      Navigator.of(context).pop(_id(picked));
    }
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final tomorrow = now.add(const Duration(days: 1));
    final in2 = now.add(const Duration(days: 2));
    final in3 = now.add(const Duration(days: 3));
    final saturday = _nextWeekday(now, DateTime.saturday);
    final nextMonday = _nextWeekday(now, DateTime.monday);

    final options = <_DeferOption>[
      _DeferOption(
        icon: Icons.wb_sunny_rounded,
        label: 'Mañana',
        sub: _format(tomorrow),
        dayId: _id(tomorrow),
      ),
      _DeferOption(
        icon: Icons.today_rounded,
        label: 'En 2 días',
        sub: _format(in2),
        dayId: _id(in2),
      ),
      _DeferOption(
        icon: Icons.view_day_rounded,
        label: 'En 3 días',
        sub: _format(in3),
        dayId: _id(in3),
      ),
      _DeferOption(
        icon: Icons.weekend_rounded,
        label: 'Este sábado',
        sub: _format(saturday),
        dayId: _id(saturday),
      ),
      _DeferOption(
        icon: Icons.calendar_view_week_rounded,
        label: 'Próximo lunes',
        sub: _format(nextMonday),
        dayId: _id(nextMonday),
      ),
    ];

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
      decoration: BoxDecoration(
        color: context.surfaceSheet,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: AppTheme.shadowLg,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: context.dividerColor,
                borderRadius: BorderRadius.circular(999),
              ),
            ),
          ),
          Row(
            children: [
              const Icon(Icons.schedule_rounded,
                  color: AppTheme.colorWarning, size: 22),
              const SizedBox(width: 8),
              Text(
                'Posponer tarea',
                style: GoogleFonts.fraunces(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: context.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Elegí cuándo volver a verla',
            style: GoogleFonts.inter(fontSize: 12, color: context.textTertiary),
          ),
          const SizedBox(height: 12),
          ...options.map((o) => _DeferRow(
                option: o,
                onTap: () {
                  HapticFeedback.lightImpact();
                  Navigator.of(context).pop(o.dayId);
                },
              )),
          const SizedBox(height: 4),
          GestureDetector(
            onTap: () => _pickCustom(context),
            child: Container(
              margin: const EdgeInsets.only(top: 4),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              decoration: BoxDecoration(
                color: AppTheme.colorPrimary.withAlpha(22),
                borderRadius: AppTheme.r12,
                border: Border.all(color: AppTheme.colorPrimary.withAlpha(80)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.event_rounded,
                      color: AppTheme.colorPrimary, size: 20),
                  const SizedBox(width: 10),
                  Text(
                    'Elegir fecha…',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.colorPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _format(DateTime d) {
    const weekdays = [
      'lunes', 'martes', 'miércoles', 'jueves',
      'viernes', 'sábado', 'domingo'
    ];
    const months = [
      'ene', 'feb', 'mar', 'abr', 'may', 'jun',
      'jul', 'ago', 'sep', 'oct', 'nov', 'dic'
    ];
    return '${weekdays[d.weekday - 1]} ${d.day} ${months[d.month - 1]}';
  }
}

class _DeferOption {
  final IconData icon;
  final String label;
  final String sub;
  final String dayId;
  const _DeferOption({
    required this.icon,
    required this.label,
    required this.sub,
    required this.dayId,
  });
}

class _DeferRow extends StatelessWidget {
  final _DeferOption option;
  final VoidCallback onTap;
  const _DeferRow({required this.option, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        margin: const EdgeInsets.only(bottom: 4),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: context.surfaceCard,
          borderRadius: AppTheme.r12,
          border: Border.all(color: context.dividerColor),
        ),
        child: Row(
          children: [
            Icon(option.icon,
                size: 20, color: context.textSecondary),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    option.label,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: context.textPrimary,
                    ),
                  ),
                  Text(
                    option.sub,
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: context.textTertiary,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded,
                size: 20, color: context.textTertiary),
          ],
        ),
      ),
    );
  }
}
