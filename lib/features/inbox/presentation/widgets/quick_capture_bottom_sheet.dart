import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../core/theme/app_theme.dart';
import '../providers/inbox_provider.dart';

class QuickCaptureBottomSheet extends ConsumerStatefulWidget {
  const QuickCaptureBottomSheet({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const QuickCaptureBottomSheet(),
    );
  }

  @override
  ConsumerState<QuickCaptureBottomSheet> createState() => _State();
}

class _State extends ConsumerState<QuickCaptureBottomSheet> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _save() {
    final content = _controller.text.trim();
    if (content.isEmpty) return;
    ref.read(quickNoteServiceProvider).addNote(content);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    return Container(
      padding: EdgeInsets.fromLTRB(20, 12, 20, 20 + bottom),
      decoration: const BoxDecoration(
        color: AppTheme.surfaceSheet,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: Container(
              width: 40, height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(25),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Row(
            children: [
              const Icon(Icons.inbox_rounded, color: AppTheme.colorAccent, size: 20),
              const SizedBox(width: 8),
              Text('Captura rápida',
                  style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFFF0F0FF))),
            ],
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _controller,
            autofocus: true,
            maxLines: 3,
            style: GoogleFonts.inter(color: const Color(0xFFF0F0FF)),
            decoration: InputDecoration(
              hintText: 'Capturo el pensamiento...',
              hintStyle: GoogleFonts.inter(color: AppTheme.colorNeutral),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side: BorderSide(color: Colors.white.withAlpha(30)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text('Cancelar', style: GoogleFonts.inter(color: AppTheme.colorNeutral)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton(
                  onPressed: _save,
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    backgroundColor: AppTheme.colorAccent,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text('Guardar', style: GoogleFonts.inter(fontWeight: FontWeight.w600, color: Colors.black)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
