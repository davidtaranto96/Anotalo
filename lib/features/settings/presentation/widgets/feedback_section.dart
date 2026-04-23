import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/feedback/feedback_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';

/// Tarjeta de "Sonido & Hápticos" — dos toggles + 4 chips de prueba.
/// Escucha al FeedbackService para reflejar cambios sin reconstruir toda
/// la Settings page.
class FeedbackSection extends StatefulWidget {
  const FeedbackSection({super.key});

  @override
  State<FeedbackSection> createState() => _FeedbackSectionState();
}

class _FeedbackSectionState extends State<FeedbackSection> {
  @override
  void initState() {
    super.initState();
    FeedbackService.instance.addListener(_onChange);
  }

  @override
  void dispose() {
    FeedbackService.instance.removeListener(_onChange);
    super.dispose();
  }

  void _onChange() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final soundsOn = FeedbackService.instance.soundsOn;
    final hapticsOn = FeedbackService.instance.hapticsOn;

    return Container(
      decoration: BoxDecoration(
        color: theme.cardTheme.color ?? theme.colorScheme.surface,
        borderRadius: AppTheme.r16,
        border: Border.all(color: theme.dividerColor),
      ),
      child: Column(
        children: [
          SwitchListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            shape: RoundedRectangleBorder(borderRadius: AppTheme.r16),
            secondary: _IconBadge(
              icon: soundsOn
                  ? Icons.volume_up_rounded
                  : Icons.volume_off_rounded,
              color: theme.colorScheme.primary,
            ),
            title: Text(
              'Sonidos',
              style: GoogleFonts.inter(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: theme.colorScheme.onSurface,
              ),
            ),
            subtitle: Text(
              soundsOn ? 'Activados' : 'Desactivados',
              style: GoogleFonts.inter(
                fontSize: 13,
                color: theme.textTheme.bodyMedium?.color,
              ),
            ),
            value: soundsOn,
            activeTrackColor:
                theme.colorScheme.primary.withValues(alpha: 0.3),
            activeThumbColor: theme.colorScheme.primary,
            onChanged: (v) async {
              await FeedbackService.instance.setSoundsOn(v);
              if (v) FeedbackService.instance.toggle();
            },
          ),
          Divider(
            height: 1,
            indent: 16,
            endIndent: 16,
            color: theme.dividerColor,
          ),
          SwitchListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            shape: RoundedRectangleBorder(borderRadius: AppTheme.r16),
            secondary: _IconBadge(
              icon: hapticsOn
                  ? Icons.vibration_rounded
                  : Icons.do_not_disturb_on_rounded,
              color: AppTheme.colorAccent,
            ),
            title: Text(
              'Vibración',
              style: GoogleFonts.inter(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: theme.colorScheme.onSurface,
              ),
            ),
            subtitle: Text(
              hapticsOn ? 'Activada' : 'Desactivada',
              style: GoogleFonts.inter(
                fontSize: 13,
                color: theme.textTheme.bodyMedium?.color,
              ),
            ),
            value: hapticsOn,
            activeTrackColor: AppTheme.colorAccent.withAlpha(80),
            activeThumbColor: AppTheme.colorAccent,
            onChanged: (v) async {
              await FeedbackService.instance.setHapticsOn(v);
              if (v) FeedbackService.instance.toggle();
            },
          ),
          Divider(
            height: 1,
            indent: 16,
            endIndent: 16,
            color: theme.dividerColor,
          ),
          // Fila de chips de prueba
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Probar',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: context.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _TestChip(
                      label: 'Tick',
                      color: theme.colorScheme.onSurfaceVariant,
                      onTap: () => FeedbackService.instance.tick(),
                    ),
                    _TestChip(
                      label: 'Success',
                      color: AppTheme.colorSuccess,
                      onTap: () => FeedbackService.instance.success(),
                    ),
                    _TestChip(
                      label: 'Warn',
                      color: AppTheme.colorWarning,
                      onTap: () => FeedbackService.instance.warn(),
                    ),
                    _TestChip(
                      label: 'Danger',
                      color: AppTheme.colorDanger,
                      onTap: () => FeedbackService.instance.danger(),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _IconBadge extends StatelessWidget {
  final IconData icon;
  final Color color;
  const _IconBadge({required this.icon, required this.color});
  @override
  Widget build(BuildContext context) => Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: color.withAlpha(20),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: color, size: 20),
      );
}

class _TestChip extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback onTap;
  const _TestChip({
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.14),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: color.withValues(alpha: 0.45)),
        ),
        child: Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ),
    );
  }
}
