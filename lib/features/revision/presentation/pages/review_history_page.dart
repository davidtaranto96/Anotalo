import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/format_utils.dart';
import '../../domain/models/daily_review.dart';
import '../providers/daily_review_provider.dart';
import 'daily_review_page.dart';

/// Lists every past daily review, newest first. Tap opens it in the
/// full review wizard (locked to read-only if already closed).
class ReviewHistoryPage extends ConsumerWidget {
  const ReviewHistoryPage({super.key});

  static const _faces = ['😞', '😕', '😐', '🙂', '😄'];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reviewsAsync = ref.watch(allDailyReviewsProvider);

    return Scaffold(
      backgroundColor: context.surfaceBase,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon:
              Icon(Icons.arrow_back_rounded, color: context.textSecondary),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: Text(
          'Historial de revisiones',
          style: GoogleFonts.lora(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: context.textPrimary,
          ),
        ),
        titleSpacing: 0,
      ),
      body: reviewsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Text(
            'Error: $e',
            style: GoogleFonts.inter(color: context.textSecondary),
          ),
        ),
        data: (reviews) {
          if (reviews.isEmpty) return const _EmptyHistory();
          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            itemCount: reviews.length,
            itemBuilder: (ctx, i) {
              final r = reviews[i];
              return _ReviewCard(
                review: r,
                onTap: () {
                  HapticFeedback.selectionClick();
                  Navigator.of(ctx).push(
                    MaterialPageRoute(
                      builder: (_) => DailyReviewPage(dayId: r.dayId),
                    ),
                  );
                },
                onDelete: () async {
                  await ref
                      .read(dailyReviewServiceProvider)
                      .delete(r.id);
                },
              );
            },
          );
        },
      ),
    );
  }

  static String moodEmoji(int? mood) {
    if (mood == null || mood < 1 || mood > 5) return '—';
    return _faces[mood - 1];
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// EMPTY STATE
// ═══════════════════════════════════════════════════════════════════════════

class _EmptyHistory extends StatelessWidget {
  const _EmptyHistory();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: context.surfaceCard,
              shape: BoxShape.circle,
              border: Border.all(color: context.dividerColor),
            ),
            child: Icon(
              Icons.auto_stories_rounded,
              size: 34,
              color: context.textTertiary,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Todavía no hiciste ninguna revisión',
            style: GoogleFonts.lora(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: context.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 48),
            child: Text(
              'Al final de cada día, cerrá la revisión para verla acá.',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 13,
                color: context.textSecondary,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// REVIEW CARD
// ═══════════════════════════════════════════════════════════════════════════

class _ReviewCard extends StatelessWidget {
  final DailyReview review;
  final VoidCallback onTap;
  final Future<void> Function() onDelete;

  const _ReviewCard({
    required this.review,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final date = idToDate(review.dayId);
    final weekdayDay =
        DateFormat("EEEE d", 'es').format(date); // e.g. "martes 15"
    final cap = weekdayDay.isEmpty
        ? weekdayDay
        : weekdayDay[0].toUpperCase() + weekdayDay.substring(1);
    final monthYear = DateFormat.yMMMM('es').format(date);
    final emoji = ReviewHistoryPage.moodEmoji(review.mood);
    final patterns = review.patterns?.trim() ?? '';

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Dismissible(
        key: ValueKey('review-${review.id}'),
        direction: DismissDirection.endToStart,
        background: _DismissBg(),
        confirmDismiss: (_) async => _confirmDelete(context),
        onDismissed: (_) => onDelete(),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: AppTheme.r16,
            onTap: onTap,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: context.surfaceCard,
                borderRadius: AppTheme.r16,
                border: Border.all(color: context.dividerColor),
                boxShadow: AppTheme.shadowSm,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header row: date / status
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              cap,
                              style: GoogleFonts.lora(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: context.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              monthYear,
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: context.textTertiary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      _StatusPill(completed: review.isCompleted),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Mood + preview
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: context.surfaceElevated,
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: emoji == '—'
                            ? Text(
                                '—',
                                style: GoogleFonts.inter(
                                  fontSize: 16,
                                  color: context.textTertiary,
                                ),
                              )
                            : Text(
                                emoji,
                                style: const TextStyle(fontSize: 22),
                              ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          patterns.isEmpty
                              ? 'Sin notas'
                              : patterns,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            color: patterns.isEmpty
                                ? context.textTertiary
                                : context.textSecondary,
                            height: 1.4,
                            fontStyle: patterns.isEmpty
                                ? FontStyle.italic
                                : FontStyle.normal,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> _confirmDelete(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          'Borrar revisión',
          style: GoogleFonts.lora(fontWeight: FontWeight.w600),
        ),
        content: Text(
          '¿Seguro que querés eliminar esta revisión? No se puede deshacer.',
          style: GoogleFonts.inter(fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(
              'Cancelar',
              style: GoogleFonts.inter(color: ctx.textSecondary),
            ),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
                backgroundColor: AppTheme.colorDanger),
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(
              'Borrar',
              style: GoogleFonts.inter(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
    return result ?? false;
  }
}

class _DismissBg extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 24),
      alignment: Alignment.centerRight,
      decoration: BoxDecoration(
        color: AppTheme.colorDanger.withAlpha(36),
        borderRadius: AppTheme.r16,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const Icon(Icons.delete_outline_rounded,
              color: AppTheme.colorDanger, size: 22),
          const SizedBox(width: 6),
          Text(
            'Borrar',
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppTheme.colorDanger,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  final bool completed;
  const _StatusPill({required this.completed});

  @override
  Widget build(BuildContext context) {
    final color =
        completed ? AppTheme.colorSuccess : AppTheme.colorWarning;
    final label = completed ? 'Cerrada' : 'Abierta';
    final icon =
        completed ? Icons.lock_rounded : Icons.edit_note_rounded;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withAlpha(32),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withAlpha(80)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
