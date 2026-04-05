import 'package:flutter/material.dart';
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
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.surfaceCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withAlpha(18)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(note.content,
              style: GoogleFonts.inter(fontSize: 14, color: const Color(0xFFF0F0FF))),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                DateFormat('d MMM, HH:mm', 'es').format(note.createdAt),
                style: GoogleFonts.inter(fontSize: 11, color: AppTheme.colorNeutral),
              ),
              GestureDetector(
                onTap: onProcess,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.colorPrimary.withAlpha(38),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: AppTheme.colorPrimary.withAlpha(77)),
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
