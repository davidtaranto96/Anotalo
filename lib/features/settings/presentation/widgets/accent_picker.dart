import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/feedback/feedback_service.dart';
import '../../../../core/providers/accent_provider.dart';
import '../../../../core/theme/accent.dart';
import '../../../../core/theme/app_colors.dart';

/// Grid de 6 swatches del acento + tira de preview arriba.
/// El preview pinta un botón, un chip y un checkbox con el acento
/// actual para que el usuario vea en qué se está metiendo antes de
/// confirmar. Live swap: apenas toca el swatch, el MaterialApp se
/// repinta gracias al `accentProvider`.
class AccentPicker extends ConsumerWidget {
  const AccentPicker({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final current = ref.watch(accentProvider);
    final palette = accentPalettes[current]!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Preview en vivo
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: palette.primarySurface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: palette.primaryBorder),
          ),
          child: Row(
            children: [
              // Mini botón
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: palette.primary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Guardar',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              // Mini chip
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: palette.primary.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: palette.primary.withValues(alpha: 0.4)),
                ),
                child: Text(
                  palette.label,
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: palette.primary,
                  ),
                ),
              ),
              const Spacer(),
              // Checkbox ilustrativo
              Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: palette.primary,
                ),
                child: const Icon(Icons.check, size: 14, color: Colors.white),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        // Grid de 6 swatches
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 6,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          childAspectRatio: 1,
          children: AnotaloAccent.values.map((a) {
            final pal = accentPalettes[a]!;
            final active = a == current;
            return GestureDetector(
              onTap: () {
                FeedbackService.instance.toggle();
                ref.read(accentProvider.notifier).set(a);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                curve: Curves.easeOut,
                decoration: BoxDecoration(
                  color: active ? pal.primarySurface : Colors.transparent,
                  border: Border.all(
                    color: active ? pal.primary : context.dividerColor,
                    width: active ? 1.5 : 1,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Container(
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      color: pal.primary,
                      shape: BoxShape.circle,
                      boxShadow: active
                          ? [
                              BoxShadow(
                                color: pal.primary.withValues(alpha: 0.45),
                                blurRadius: 0,
                                spreadRadius: 2,
                              ),
                            ]
                          : null,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 8),
        // Etiqueta con el nombre del acento actual
        Align(
          alignment: Alignment.centerRight,
          child: Text(
            palette.label,
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: palette.primary,
              letterSpacing: 0.3,
            ),
          ),
        ),
      ],
    );
  }
}
