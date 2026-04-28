import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/app_colors.dart';

enum ToastTone { success, warn, info }

/// Toast transitorio del sistema 1.6 — fire-and-forget, 2.2s.
/// Montado sobre ScaffoldMessenger para aprovechar el stack existente.
///
/// `centered: true` lo renderiza al medio de la pantalla via Overlay,
/// útil para confirmaciones importantes (backup restaurado, etc) donde
/// el toast inferior queda lejos de la atención del usuario.
void showAnotaloToast(
  BuildContext context,
  String message, {
  ToastTone tone = ToastTone.success,
  Duration duration = const Duration(milliseconds: 2200),
  IconData? leading,
  bool centered = false,
}) {
  final scheme = Theme.of(context).colorScheme;
  final Color color = switch (tone) {
    ToastTone.success => const Color(0xFF7FB069),
    ToastTone.warn => scheme.error,
    ToastTone.info => scheme.primary,
  };
  final IconData icon = leading ??
      switch (tone) {
        ToastTone.success => Icons.check_rounded,
        ToastTone.warn => Icons.warning_amber_rounded,
        ToastTone.info => Icons.info_outline_rounded,
      };

  if (centered) {
    _showCenteredBanner(context, message, color, icon, duration);
    return;
  }

  final scaffold = ScaffoldMessenger.of(context);
  scaffold
    ..clearSnackBars()
    ..showSnackBar(
      SnackBar(
        content: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                message,
                style: GoogleFonts.inter(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w500,
                  color: context.textPrimary,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: context.surfaceCard,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: color.withValues(alpha: 0.55)),
        ),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        elevation: 2,
        duration: duration,
      ),
    );
}

/// Banner centrado via OverlayEntry, ideal para mensajes importantes.
/// Aparece con fade + scale, dura `duration` y se desmonta solo.
void _showCenteredBanner(
  BuildContext context,
  String message,
  Color color,
  IconData icon,
  Duration duration,
) {
  final overlay = Overlay.of(context, rootOverlay: true);
  late OverlayEntry entry;
  entry = OverlayEntry(
    builder: (ctx) => _CenteredBanner(
      message: message,
      color: color,
      icon: icon,
      duration: duration,
      onDone: () => entry.remove(),
    ),
  );
  overlay.insert(entry);
}

class _CenteredBanner extends StatefulWidget {
  const _CenteredBanner({
    required this.message,
    required this.color,
    required this.icon,
    required this.duration,
    required this.onDone,
  });
  final String message;
  final Color color;
  final IconData icon;
  final Duration duration;
  final VoidCallback onDone;

  @override
  State<_CenteredBanner> createState() => _CenteredBannerState();
}

class _CenteredBannerState extends State<_CenteredBanner>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 220),
    )..forward();
    Future.delayed(widget.duration, () async {
      if (!mounted) return;
      await _ctrl.reverse();
      if (mounted) widget.onDone();
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Center(
        child: AnimatedBuilder(
          animation: _ctrl,
          builder: (_, child) => Opacity(
            opacity: _ctrl.value,
            child: Transform.scale(
              scale: 0.92 + 0.08 * _ctrl.value,
              child: child,
            ),
          ),
          child: Material(
            color: Colors.transparent,
            child: Container(
              constraints: const BoxConstraints(maxWidth: 320),
              margin: const EdgeInsets.symmetric(horizontal: 24),
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: context.surfaceCard,
                borderRadius: BorderRadius.circular(14),
                border:
                    Border.all(color: widget.color.withValues(alpha: 0.55)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.25),
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(widget.icon, size: 20, color: widget.color),
                  const SizedBox(width: 10),
                  Flexible(
                    child: Text(
                      widget.message,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: context.textPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
