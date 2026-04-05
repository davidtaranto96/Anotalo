import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';
import '../providers/inbox_provider.dart';
import '../widgets/quick_note_card.dart';
import '../widgets/quick_capture_bottom_sheet.dart';

class InboxPage extends ConsumerWidget {
  const InboxPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notesAsync = ref.watch(unprocessedNotesProvider);

    return Scaffold(
      backgroundColor: AppTheme.surfaceBase,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            floating: true,
            backgroundColor: AppTheme.surfaceBase,
            surfaceTintColor: Colors.transparent,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_rounded),
              onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
            ),
            title: Text('Inbox',
                style: GoogleFonts.inter(fontSize: 22, fontWeight: FontWeight.w700)),
            actions: [
              IconButton(
                icon: const Icon(Icons.add_rounded, color: AppTheme.colorAccent),
                onPressed: () => QuickCaptureBottomSheet.show(context),
              ),
            ],
          ),
          notesAsync.when(
            data: (notes) {
              if (notes.isEmpty) {
                return SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.inbox_rounded,
                            color: AppTheme.colorNeutral, size: 48),
                        const SizedBox(height: 16),
                        Text('Inbox vacío',
                            style: GoogleFonts.inter(
                                color: AppTheme.colorNeutral, fontSize: 16)),
                      ],
                    ),
                  ),
                );
              }
              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (_, i) => QuickNoteCard(
                    note: notes[i],
                    onProcess: () => ref.read(quickNoteServiceProvider)
                        .processNote(notes[i].id, processedToType: 'manual'),
                  ),
                  childCount: notes.length,
                ),
              );
            },
            loading: () => const SliverFillRemaining(
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (e, _) => SliverFillRemaining(child: Center(child: Text('$e'))),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 40)),
        ],
      ),
    );
  }
}
