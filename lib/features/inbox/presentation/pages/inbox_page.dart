import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/voice_input_button.dart';
import '../../domain/models/quick_note.dart';
import '../providers/inbox_provider.dart';

class InboxPage extends ConsumerStatefulWidget {
  const InboxPage({super.key});

  @override
  ConsumerState<InboxPage> createState() => _InboxPageState();
}

class _InboxPageState extends ConsumerState<InboxPage> {
  final _ctrl = TextEditingController();
  QuickNoteType _selectedType = QuickNoteType.nota;
  bool _showProcessed = false;

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Future<void> _capture() async {
    final content = _ctrl.text.trim();
    if (content.isEmpty) return;
    HapticFeedback.lightImpact();
    await ref.read(quickNoteServiceProvider).addNoteWithType(content, _selectedType);
    _ctrl.clear();
  }

  @override
  Widget build(BuildContext context) {
    final notesAsync = ref.watch(unprocessedNotesProvider);
    final processedAsync = ref.watch(processedNotesProvider);
    final service = ref.read(quickNoteServiceProvider);

    return Scaffold(
      backgroundColor: context.surfaceBase,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // ── AppBar ─────────────────────────────────────────────────
          SliverAppBar(
            floating: true,
            backgroundColor: Colors.transparent,
            surfaceTintColor: Colors.transparent,
            leading: IconButton(
              icon: Icon(Icons.arrow_back_rounded, color: context.textSecondary),
              onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('📥 Inbox',
                    style: GoogleFonts.fraunces(
                      fontSize: 22, fontWeight: FontWeight.w600,
                      color: context.textPrimary, letterSpacing: -0.3,
                    )),
                Text(
                  'Anotá lo que quieras. Después decidís qué hacer.',
                  style: GoogleFonts.inter(fontSize: 11, color: context.textSecondary),
                ),
              ],
            ),
            toolbarHeight: 64,
          ),

          // ── Inline capture ─────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: context.surfaceCard,
                  borderRadius: AppTheme.r16,
                  border: Border.all(color: context.dividerColor),
                  boxShadow: AppTheme.shadowSm,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Category selector
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: QuickNoteType.values
                            .where((t) => t != QuickNoteType.general)
                            .map((t) {
                          final sel = _selectedType == t;
                          return GestureDetector(
                            onTap: () => setState(() => _selectedType = t),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 150),
                              margin: const EdgeInsets.only(right: 6),
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: sel ? AppTheme.colorPrimaryLight : context.surfaceBase,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: sel ? AppTheme.colorPrimary : context.dividerColor,
                                ),
                              ),
                              child: Text(
                                '${_typeEmoji(t)} ${_typeLabel(t)}',
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  fontWeight: sel ? FontWeight.w600 : FontWeight.w400,
                                  color: sel ? AppTheme.colorPrimary : context.textSecondary,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _ctrl,
                      maxLines: 3,
                      style: GoogleFonts.inter(fontSize: 14, color: context.textPrimary, height: 1.5),
                      decoration: InputDecoration(
                        hintText: 'Anotá lo que tengas en mente...',
                        hintStyle: GoogleFonts.inter(color: context.textTertiary),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                        isDense: true,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        VoiceInputButton(
                          onResult: (String text) { _ctrl.text = text; },
                          size: 36,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: FilledButton(
                            onPressed: _capture,
                            style: FilledButton.styleFrom(
                              minimumSize: const Size(double.infinity, 44),
                              backgroundColor: AppTheme.colorAccent,
                            ),
                            child: Text(
                              'Capturar',
                              style: GoogleFonts.inter(fontWeight: FontWeight.w600),
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

          // ── Unprocessed notes (grouped by type) ────────────────────
          notesAsync.when(
            data: (notes) {
              if (notes.isEmpty) {
                return SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Center(
                      child: Column(
                        children: [
                          Icon(Icons.inbox_rounded, color: context.neutral400, size: 40),
                          const SizedBox(height: 8),
                          Text('Inbox vacío',
                              style: GoogleFonts.inter(color: context.textTertiary, fontSize: 14)),
                        ],
                      ),
                    ),
                  ),
                );
              }

              // Group notes by type
              const groupOrder = [
                QuickNoteType.idea,
                QuickNoteType.nota,
                QuickNoteType.tarea,
                QuickNoteType.proyecto,
                QuickNoteType.general,
              ];
              const groupHeaders = {
                QuickNoteType.idea: '\u{1F4A1} Ideas',
                QuickNoteType.nota: '\u{1F4CB} Notas',
                QuickNoteType.tarea: '\u2713 Tareas',
                QuickNoteType.proyecto: '\u{1F3AF} Proyectos',
                QuickNoteType.general: '\u{1F4DD} General',
              };
              final grouped = <QuickNoteType, List<QuickNote>>{};
              for (final note in notes) {
                grouped.putIfAbsent(note.type, () => []).add(note);
              }

              // Build flat list of widgets: headers + cards
              final widgets = <Widget>[];
              for (final type in groupOrder) {
                final group = grouped[type];
                if (group == null || group.isEmpty) continue;
                // Section header
                widgets.add(
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 6),
                    child: Text(
                      '${groupHeaders[type]} \u00B7 ${group.length}',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: context.textTertiary,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                );
                // Note cards
                for (final n in group) {
                  widgets.add(
                    _NoteCard(
                      note: n,
                      onProcess: () => service.processNote(
                        n.id,
                        processedToType: 'manual',
                      ),
                      onDelete: () {
                        HapticFeedback.heavyImpact();
                        service.deleteNote(n.id);
                      },
                    ),
                  );
                }
              }

              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (_, i) => widgets[i],
                  childCount: widgets.length,
                ),
              );
            },
            loading: () => const SliverToBoxAdapter(child: Center(child: CircularProgressIndicator())),
            error: (e, _) => SliverToBoxAdapter(child: Center(child: Text('$e'))),
          ),

          // ── Processed section (colapsable) ─────────────────────────
          processedAsync.when(
            data: (processed) {
              if (processed.isEmpty) return const SliverToBoxAdapter(child: SizedBox.shrink());
              return SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () => setState(() => _showProcessed = !_showProcessed),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                        child: Row(
                          children: [
                            Text(
                              'PROCESADOS · ${processed.length}',
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: context.textTertiary,
                                letterSpacing: 0.5,
                              ),
                            ),
                            const Spacer(),
                            Icon(
                              _showProcessed
                                  ? Icons.expand_less_rounded
                                  : Icons.expand_more_rounded,
                              size: 18,
                              color: context.textTertiary,
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (_showProcessed)
                      ...processed.map((n) => _NoteCard(
                        note: n,
                        onProcess: () {},
                        onDelete: () => service.deleteNote(n.id),
                        isProcessed: true,
                      )),
                  ],
                ),
              );
            },
            loading: () => const SliverToBoxAdapter(child: SizedBox.shrink()),
            error: (_, __) => const SliverToBoxAdapter(child: SizedBox.shrink()),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }

  String _typeEmoji(QuickNoteType t) => switch (t) {
    QuickNoteType.idea    => '💡',
    QuickNoteType.nota    => '📋',
    QuickNoteType.tarea   => '✓',
    QuickNoteType.proyecto => '🎯',
    QuickNoteType.general => '📝',
  };

  String _typeLabel(QuickNoteType t) => switch (t) {
    QuickNoteType.idea    => 'Idea',
    QuickNoteType.nota    => 'Nota',
    QuickNoteType.tarea   => 'Tarea',
    QuickNoteType.proyecto => 'Proyecto',
    QuickNoteType.general => 'General',
  };
}

class _NoteCard extends StatelessWidget {
  final QuickNote note;
  final VoidCallback onProcess;
  final VoidCallback onDelete;
  final bool isProcessed;

  const _NoteCard({
    required this.note,
    required this.onProcess,
    required this.onDelete,
    this.isProcessed = false,
  });

  Color get _borderColor => switch (note.type) {
    QuickNoteType.idea     => const Color(0xFFC4963A),
    QuickNoteType.nota     => const Color(0xFF5B7E9E),
    QuickNoteType.tarea    => const Color(0xFF5B8A5E),
    QuickNoteType.proyecto => const Color(0xFFC15F3C),
    QuickNoteType.general  => const Color(0xFFB1ADA1),
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      decoration: BoxDecoration(
        color: isProcessed ? context.neutral50 : context.surfaceCard,
        borderRadius: AppTheme.r16,
        border: Border.all(color: context.dividerColor),
        boxShadow: isProcessed ? null : AppTheme.shadowSm,
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Container(
              width: 4,
              decoration: BoxDecoration(
                color: _borderColor,
                borderRadius: const BorderRadius.horizontal(left: Radius.circular(16)),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            note.content,
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              color: isProcessed ? context.textTertiary : context.textPrimary,
                              height: 1.5,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: onDelete,
                          child: Icon(Icons.close_rounded, size: 18, color: context.textTertiary),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        _TypeBadge(type: note.type),
                        const SizedBox(width: 8),
                        Text(
                          DateFormat('d MMM, HH:mm', 'es').format(note.createdAt),
                          style: GoogleFonts.inter(fontSize: 11, color: context.textTertiary),
                        ),
                        const Spacer(),
                        if (!isProcessed)
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
                              child: Text(
                                'Procesar',
                                style: GoogleFonts.inter(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.colorPrimary,
                                ),
                              ),
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
    );
  }
}

class _TypeBadge extends StatelessWidget {
  final QuickNoteType type;
  const _TypeBadge({required this.type});

  @override
  Widget build(BuildContext context) {
    final (emoji, label) = switch (type) {
      QuickNoteType.idea    => ('💡', 'Idea'),
      QuickNoteType.nota    => ('📋', 'Nota'),
      QuickNoteType.tarea   => ('✓', 'Tarea'),
      QuickNoteType.proyecto => ('🎯', 'Proyecto'),
      QuickNoteType.general => ('📝', 'Nota'),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        color: context.neutral100,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: context.dividerColor),
      ),
      child: Text(
        '$emoji $label',
        style: GoogleFonts.inter(fontSize: 10, color: context.textSecondary),
      ),
    );
  }
}
