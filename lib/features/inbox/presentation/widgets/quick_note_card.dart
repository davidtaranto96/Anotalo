import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../domain/models/quick_note.dart';

class QuickNoteCard extends StatelessWidget {
  final QuickNote note;
  final VoidCallback onProcess;

  const QuickNoteCard({super.key, required this.note, required this.onProcess});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceCard,
        borderRadius: AppTheme.r16,
        border: Border.all(color: AppTheme.divider),
        boxShadow: AppTheme.shadowSm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(note.content,
              style: GoogleFonts.inter(fontSize: 14, color: AppTheme.textPrimary, height: 1.5)),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                DateFormat('d MMM, HH:mm', 'es').format(note.createdAt),
                style: GoogleFonts.inter(fontSize: 11, color: AppTheme.textTertiary),
              ),
              GestureDetector(
                onTap: () {
                  HapticFeedback.lightImpact();
                  onProcess();
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.colorPrimaryLight,
                    borderRadius: AppTheme.r8,
                  ),
                  child: Text('Procesar',
                      style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.colorPrimary)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
