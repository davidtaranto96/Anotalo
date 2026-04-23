import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/app_colors.dart';

enum ToastTone { success, warn, info }

/// Toast transitorio del sistema 1.6 — fire-and-forget, 2.2s.
/// Montado sobre ScaffoldMessenger para aprovechar el stack existente.
void showAnotaloToast(
  BuildContext context,
  String message, {
  ToastTone tone = ToastTone.success,
  Duration duration = const Duration(milliseconds: 2200),
  IconData? leading,
}) {
  final scaffold = ScaffoldMessenger.of(context);
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
