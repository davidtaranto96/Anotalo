import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../feedback/feedback_service.dart';
import '../theme/app_colors.dart';

/// ConfirmDialog del sistema 1.6.
/// - Spring-in 260ms, blur backdrop de 6pt
/// - Variante destructiva pinta el chip de icono y el botón primario en rojo
/// - Reproduce feedback apropiado al abrir, confirmar y cancelar
Future<bool> showAnotaloConfirm({
  required BuildContext context,
  required String title,
  required String body,
  required String confirmLabel,
  String cancelLabel = 'Cancelar',
  bool danger = false,
  IconData icon = Icons.warning_amber_rounded,
}) async {
  unawaited(FeedbackService.instance.warn());
  final ok = await showGeneralDialog<bool>(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'Cerrar',
    barrierColor: Colors.black.withValues(alpha: 0.55),
    transitionDuration: const Duration(milliseconds: 260),
    pageBuilder: (ctx, _, __) => _ConfirmDialogBody(
      title: title,
      body: body,
      confirmLabel: confirmLabel,
      cancelLabel: cancelLabel,
      danger: danger,
      icon: icon,
    ),
    transitionBuilder: (ctx, anim, __, child) {
      final curved = CurvedAnimation(
        parent: anim,
        curve: const Cubic(0.2, 1.2, 0.3, 1.0),
      );
      final scale = Tween(begin: 0.88, end: 1.0).evaluate(curved);
      return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
        child: Opacity(
          opacity: anim.value.clamp(0.0, 1.0),
          child: Transform.scale(
            scale: scale,
            child: Transform.translate(
              offset: Offset(0, (1 - curved.value) * 10),
              child: child,
            ),
          ),
        ),
      );
    },
  );
  return ok ?? false;
}

class _ConfirmDialogBody extends StatelessWidget {
  const _ConfirmDialogBody({
    required this.title,
    required this.body,
    required this.confirmLabel,
    required this.cancelLabel,
    required this.danger,
    required this.icon,
  });

  final String title;
  final String body;
  final String confirmLabel;
  final String cancelLabel;
  final bool danger;
  final IconData icon;

  void unawaited(Future<void> _) {}

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final accent = danger ? scheme.error : scheme.primary;

    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: 340,
          padding: const EdgeInsets.fromLTRB(20, 22, 20, 16),
          decoration: BoxDecoration(
            color: context.surfaceCard,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: context.dividerColor),
            boxShadow: const [
              BoxShadow(
                color: Colors.black54,
                blurRadius: 60,
                offset: Offset(0, 20),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Chip de icono con entrada spring
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: 1),
                duration: const Duration(milliseconds: 380),
                curve: const Cubic(0.2, 1.4, 0.3, 1),
                builder: (_, v, __) => Transform.translate(
                  offset: const Offset(0, 0),
                  child: Opacity(
                    opacity: v.clamp(0.0, 1.0),
                    child: Transform.rotate(
                      angle: (1 - v) * -0.21, // ~-12deg
                      child: Transform.scale(
                        scale: 0.4 + 0.6 * v,
                        child: _IconChip(icon: icon, color: accent),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Text(
                title,
                style: GoogleFonts.fraunces(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: scheme.onSurface,
                  letterSpacing: -0.2,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                body,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  height: 1.45,
                  color: context.textSecondary,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    flex: 10,
                    child: OutlinedButton(
                      onPressed: () {
                        FeedbackService.instance.tick();
                        Navigator.of(context).pop(false);
                      },
                      child: Text(cancelLabel),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    flex: 14,
                    child: FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: accent,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () {
                        if (danger) {
                          FeedbackService.instance.danger();
                        } else {
                          FeedbackService.instance.success();
                        }
                        Navigator.of(context).pop(true);
                      },
                      child: Text(confirmLabel),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _IconChip extends StatelessWidget {
  const _IconChip({required this.icon, required this.color});
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) => Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.094),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: color, size: 22),
      );
}

// Helper para fire-and-forget de Futures donde no nos importa el resultado.
void unawaited(Future<void> _) {}
