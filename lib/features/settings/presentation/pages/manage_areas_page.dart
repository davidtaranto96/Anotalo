import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:arquitectura_enfoque/core/models/task_area.dart';
import 'package:arquitectura_enfoque/core/providers/task_area_provider.dart';
import 'package:arquitectura_enfoque/core/theme/app_colors.dart';
import 'package:arquitectura_enfoque/core/theme/app_theme.dart';
import 'package:arquitectura_enfoque/features/settings/presentation/widgets/edit_area_bottom_sheet.dart';

/// Settings sub-page that lets the user add, edit, reorder, and delete
/// task areas. Built-in areas can be edited but not deleted.
class ManageAreasPage extends ConsumerWidget {
  const ManageAreasPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncAreas = ref.watch(taskAreasStreamProvider);

    return Scaffold(
      backgroundColor: context.surfaceBase,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_rounded,
            color: context.textSecondary,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Areas',
          style: GoogleFonts.fraunces(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: context.textPrimary,
          ),
        ),
      ),
      body: asyncAreas.when(
        data: (areas) => _buildBody(context, ref, areas),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              'Error: $e',
              style: GoogleFonts.inter(
                fontSize: 14,
                color: context.textSecondary,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, WidgetRef ref, List<TaskArea> areas) {
    return Column(
      children: [
        Expanded(
          child: ReorderableListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            buildDefaultDragHandles: false,
            itemCount: areas.length,
            onReorder: (oldIndex, newIndex) {
              HapticFeedback.mediumImpact();
              final ids = areas.map((a) => a.id).toList();
              var insertAt = newIndex;
              if (insertAt > oldIndex) insertAt -= 1;
              final moved = ids.removeAt(oldIndex);
              ids.insert(insertAt, moved);
              ref.read(taskAreaServiceProvider).reorderAreas(ids);
            },
            itemBuilder: (ctx, index) {
              final area = areas[index];
              return Padding(
                key: ValueKey(area.id),
                padding: const EdgeInsets.only(bottom: 10),
                child: _AreaTile(
                  area: area,
                  index: index,
                  onTap: () {
                    HapticFeedback.lightImpact();
                    EditAreaBottomSheet.show(context, area: area);
                  },
                  onLongPress: () {
                    HapticFeedback.mediumImpact();
                    EditAreaBottomSheet.show(context, area: area);
                  },
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
          child: _AddAreaButton(
            onTap: () {
              HapticFeedback.lightImpact();
              EditAreaBottomSheet.show(context);
            },
          ),
        ),
      ],
    );
  }
}

class _AreaTile extends StatelessWidget {
  const _AreaTile({
    required this.area,
    required this.index,
    required this.onTap,
    required this.onLongPress,
  });

  final TaskArea area;
  final int index;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        borderRadius: AppTheme.r16,
        child: Container(
          decoration: BoxDecoration(
            color: context.surfaceCard,
            borderRadius: AppTheme.r16,
            border: Border.all(color: context.dividerColor),
            boxShadow: AppTheme.shadowSm,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              _AreaBadge(area: area),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      area.label,
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: context.textPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (area.isBuiltin) ...[
                      const SizedBox(height: 4),
                      const _BuiltinBadge(),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 8),
              ReorderableDragStartListener(
                index: index,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
                  child: Icon(
                    Icons.drag_handle_rounded,
                    color: context.textTertiary,
                    size: 22,
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

class _AreaBadge extends StatelessWidget {
  const _AreaBadge({required this.area});

  final TaskArea area;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: area.color.withAlpha(60),
        shape: BoxShape.circle,
        border: Border.all(color: area.color.withAlpha(120), width: 1),
      ),
      alignment: Alignment.center,
      child: area.icon != null
          ? Icon(area.icon, size: 20, color: area.color)
          : Text(
              area.emoji.isEmpty ? area.label.characters.first : area.emoji,
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: area.color,
              ),
            ),
    );
  }
}

class _BuiltinBadge extends StatelessWidget {
  const _BuiltinBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: context.surfaceElevated,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        'Incorporada',
        style: GoogleFonts.inter(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: context.textTertiary,
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}

class _AddAreaButton extends StatelessWidget {
  const _AddAreaButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppTheme.r16,
        child: DottedBorderBox(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.add_rounded,
                  size: 20,
                  color: AppTheme.colorPrimary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Nueva area',
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.colorPrimary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Lightweight dashed-border container implemented with a CustomPainter so we
/// don't pull in an extra package just for this one button.
class DottedBorderBox extends StatelessWidget {
  const DottedBorderBox({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _DashedBorderPainter(
        color: context.dividerColor,
        radius: 16,
      ),
      child: ClipRRect(
        borderRadius: AppTheme.r16,
        child: child,
      ),
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  _DashedBorderPainter({required this.color, required this.radius});

  final Color color;
  final double radius;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    final rrect = RRect.fromRectAndRadius(
      Offset.zero & size,
      Radius.circular(radius),
    );
    final path = Path()..addRRect(rrect);

    const dashLength = 6.0;
    const gapLength = 4.0;

    for (final metric in path.computeMetrics()) {
      double distance = 0;
      while (distance < metric.length) {
        final next = distance + dashLength;
        final extract = metric.extractPath(distance, next);
        canvas.drawPath(extract, paint);
        distance = next + gapLength;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DashedBorderPainter old) =>
      old.color != color || old.radius != radius;
}
