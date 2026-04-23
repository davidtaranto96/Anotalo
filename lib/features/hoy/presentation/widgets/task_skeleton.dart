import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';

/// Skeleton con shimmer para la primera carga de la lista de Hoy/Semana.
/// Se muestra como máximo 400ms y después se cambia por el contenido real.
/// Si la data llega en <100ms conviene saltarlo directo: el flicker es
/// peor que un frame en blanco.
class TaskSkeletonList extends StatelessWidget {
  const TaskSkeletonList({super.key, this.count = 5});
  final int count;

  @override
  Widget build(BuildContext context) {
    final base = context.surfaceCard;
    final highlight = context.surfaceElevated;
    return Shimmer.fromColors(
      baseColor: base,
      highlightColor: highlight,
      period: const Duration(milliseconds: 1400),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Overline de sección falsa
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
            child: Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: context.dividerColor,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  width: 90,
                  height: 10,
                  color: context.dividerColor,
                ),
              ],
            ),
          ),
          for (var i = 0; i < count; i++) _SkeletonRow(seed: i),
        ],
      ),
    );
  }
}

class _SkeletonRow extends StatelessWidget {
  const _SkeletonRow({required this.seed});
  final int seed;

  @override
  Widget build(BuildContext context) {
    final titleWidth = 180.0 + (seed.isEven ? 40.0 : -20.0);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Container(
        decoration: BoxDecoration(
          color: context.surfaceCard,
          borderRadius: AppTheme.r12,
          border: Border.all(color: context.dividerColor),
        ),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                width: 3,
                decoration: BoxDecoration(
                  color: context.dividerColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    bottomLeft: Radius.circular(12),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 14, 12, 14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 22,
                            height: 22,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: context.dividerColor,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Container(
                            width: titleWidth,
                            height: 14,
                            decoration: BoxDecoration(
                              color: context.dividerColor,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const SizedBox(width: 32),
                          Container(
                            width: 70,
                            height: 10,
                            decoration: BoxDecoration(
                              color: context.dividerColor,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            width: 48,
                            height: 10,
                            decoration: BoxDecoration(
                              color: context.dividerColor,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
