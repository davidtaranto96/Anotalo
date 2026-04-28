import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../../core/feedback/feedback_service.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/voice_input_button.dart';
import '../../../hoy/presentation/widgets/add_task_bottom_sheet.dart';
import '../../../proyectos/presentation/widgets/add_project_bottom_sheet.dart';
import '../../domain/models/quick_note.dart';
import '../providers/inbox_provider.dart';

/// Inbox estilo Google Keep / Samsung Notes.
///
/// Layout:
///   - AppBar simple con back + "Inbox" (sin emoji).
///   - Search bar para filtrar por contenido.
///   - Capture row arriba (tipo + textfield + voz + capturar).
///   - Grid masonry 2 columnas (Wrap con cards de altura natural).
///   - Sección "FIJADAS" (pinned) si hay alguna pin'd.
///   - Sección "OTRAS" con el resto.
///   - Sección "PROCESADAS" colapsable al fondo.
///
/// Long-press en una card entra en modo selección — la AppBar cambia a
/// barra de acciones (pin, procesar, borrar).
///
/// Tap en una card abre un sheet con: editar, pin, cambiar tipo,
/// procesar (convertir en tarea/proyecto/archivar), borrar.
class InboxPage extends ConsumerStatefulWidget {
  const InboxPage({super.key});

  @override
  ConsumerState<InboxPage> createState() => _InboxPageState();
}

class _InboxPageState extends ConsumerState<InboxPage> {
  final _captureCtrl = TextEditingController();
  final _searchCtrl = TextEditingController();
  QuickNoteType _selectedType = QuickNoteType.nota;
  bool _showProcessed = false;
  String _query = '';

  /// IDs seleccionadas en multi-select. Set vacío = no estamos en
  /// selection mode.
  final Set<String> _selected = {};
  bool get _selectionMode => _selected.isNotEmpty;

  @override
  void dispose() {
    _captureCtrl.dispose();
    _searchCtrl.dispose();
    super.dispose();
  }

  Future<void> _capture() async {
    final content = _captureCtrl.text.trim();
    if (content.isEmpty) return;
    FeedbackService.instance.success();
    await ref
        .read(quickNoteServiceProvider)
        .addNoteWithType(content, _selectedType);
    _captureCtrl.clear();
  }

  void _toggleSelection(String id) {
    FeedbackService.instance.toggle();
    setState(() {
      if (_selected.contains(id)) {
        _selected.remove(id);
      } else {
        _selected.add(id);
      }
    });
  }

  void _exitSelection() {
    setState(_selected.clear);
  }

  Future<void> _bulkPin() async {
    FeedbackService.instance.success();
    final svc = ref.read(quickNoteServiceProvider);
    for (final id in _selected) {
      await svc.setPinned(id, true);
    }
    if (mounted) _exitSelection();
  }

  Future<void> _bulkDelete() async {
    FeedbackService.instance.danger();
    final svc = ref.read(quickNoteServiceProvider);
    for (final id in _selected) {
      await svc.deleteNote(id);
    }
    if (mounted) _exitSelection();
  }

  Future<void> _bulkArchive() async {
    FeedbackService.instance.success();
    final svc = ref.read(quickNoteServiceProvider);
    for (final id in _selected) {
      await svc.processNote(id, processedToType: 'archived');
    }
    if (mounted) _exitSelection();
  }

  /// Sheet con acciones reales para una nota: convertir a tarea o
  /// proyecto (con prefill), archivar, pin/unpin, editar texto, borrar.
  void _showNoteActions(QuickNote note) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (sheetCtx) => _NoteActionsSheet(
        note: note,
        onEdit: () => _showEditDialog(note),
        onPinToggle: () => ref
            .read(quickNoteServiceProvider)
            .setPinned(note.id, !note.isPinned),
        onConvertToTask: () => _convertToTask(note),
        onConvertToProject: () => _convertToProject(note),
        onArchive: () => ref.read(quickNoteServiceProvider).processNote(
              note.id,
              processedToType: 'archived',
            ),
        onDelete: () {
          FeedbackService.instance.danger();
          ref.read(quickNoteServiceProvider).deleteNote(note.id);
        },
      ),
    );
  }

  Future<void> _showEditDialog(QuickNote note) async {
    final ctrl = TextEditingController(text: note.content);
    QuickNoteType type = note.type;
    final result = await showDialog<bool>(
      context: context,
      builder: (dctx) => StatefulBuilder(
        builder: (sCtx, setS) => AlertDialog(
          title: Text('Editar nota',
              style: GoogleFonts.fraunces(
                  fontSize: 18, fontWeight: FontWeight.w600)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: ctrl,
                autofocus: true,
                maxLines: 6,
                minLines: 3,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    isDense: true),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 6,
                children: QuickNoteType.values.map((t) {
                  final sel = t == type;
                  return GestureDetector(
                    onTap: () => setS(() => type = t),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: sel
                            ? _typeColor(t).withValues(alpha: 0.2)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: sel
                              ? _typeColor(t)
                              : sCtx.dividerColor,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(_typeIcon(t),
                              size: 13,
                              color: sel
                                  ? _typeColor(t)
                                  : sCtx.textSecondary),
                          const SizedBox(width: 4),
                          Text(
                        _typeLabel(t),
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: sel
                              ? FontWeight.w600
                              : FontWeight.w400,
                          color: sel
                              ? _typeColor(t)
                              : sCtx.textSecondary,
                        ),
                      ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dctx, false),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(dctx, true),
              child: const Text('Guardar'),
            ),
          ],
        ),
      ),
    );
    if (result == true) {
      await ref.read(quickNoteServiceProvider).updateNote(
            note.id,
            content: ctrl.text.trim(),
            type: type,
          );
    }
    ctrl.dispose();
  }

  Future<void> _convertToTask(QuickNote note) async {
    if (!mounted) return;
    AddTaskBottomSheet.show(context, prefillTitle: note.content);
    // Marcamos la nota como procesada apenas se abre el sheet — si el
    // user cancela, queda procesada igual, pero el contenido no se
    // pierde porque está en el processedToType='task'. Idealmente
    // deberíamos esperar el resultado, pero el sheet no devuelve nada.
    await ref.read(quickNoteServiceProvider).processNote(
          note.id,
          processedToType: 'task',
        );
  }

  Future<void> _convertToProject(QuickNote note) async {
    if (!mounted) return;
    AddProjectBottomSheet.show(context, prefillTitle: note.content);
    await ref.read(quickNoteServiceProvider).processNote(
          note.id,
          processedToType: 'project',
        );
  }

  @override
  Widget build(BuildContext context) {
    final notesAsync = ref.watch(unprocessedNotesProvider);
    final processedAsync = ref.watch(processedNotesProvider);

    return Scaffold(
      backgroundColor: context.surfaceBase,
      appBar: _buildAppBar(context),
      body: SafeArea(
        top: false,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // Search
            if (!_selectionMode)
              SliverToBoxAdapter(child: _buildSearchBar(context)),

            // Capture row
            if (!_selectionMode)
              SliverToBoxAdapter(child: _buildCaptureRow(context)),

            // Notas no procesadas (con filtro de search aplicado)
            notesAsync.when(
              data: (notes) {
                final filtered = _query.isEmpty
                    ? notes
                    : notes
                        .where((n) =>
                            n.content.toLowerCase().contains(_query.toLowerCase()))
                        .toList();
                if (filtered.isEmpty && _query.isEmpty) {
                  return SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Center(
                        child: Column(
                          children: [
                            Icon(Icons.inbox_rounded,
                                color: context.neutral400, size: 40),
                            const SizedBox(height: 8),
                            Text('Inbox vacío',
                                style: GoogleFonts.inter(
                                    color: context.textTertiary,
                                    fontSize: 14)),
                          ],
                        ),
                      ),
                    ),
                  );
                }
                if (filtered.isEmpty) {
                  return SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Text(
                        'Sin resultados para "$_query"',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                            color: context.textTertiary, fontSize: 14),
                      ),
                    ),
                  );
                }
                final pinned =
                    filtered.where((n) => n.isPinned).toList();
                final others =
                    filtered.where((n) => !n.isPinned).toList();
                return SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (pinned.isNotEmpty) ...[
                          _SectionLabel('FIJADAS · ${pinned.length}'),
                          _NotesGrid(
                            notes: pinned,
                            selected: _selected,
                            onTap: _onCardTap,
                            onLongPress: (n) => _toggleSelection(n.id),
                          ),
                          const SizedBox(height: 8),
                        ],
                        if (others.isNotEmpty) ...[
                          if (pinned.isNotEmpty)
                            _SectionLabel('OTRAS · ${others.length}'),
                          _NotesGrid(
                            notes: others,
                            selected: _selected,
                            onTap: _onCardTap,
                            onLongPress: (n) => _toggleSelection(n.id),
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              },
              loading: () => const SliverToBoxAdapter(
                  child: Center(child: CircularProgressIndicator())),
              error: (e, _) =>
                  SliverToBoxAdapter(child: Center(child: Text('$e'))),
            ),

            // Procesadas (colapsable)
            processedAsync.when(
              data: (processed) {
                if (processed.isEmpty || _selectionMode) {
                  return const SliverToBoxAdapter(child: SizedBox.shrink());
                }
                return SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () => setState(
                              () => _showProcessed = !_showProcessed),
                          child: Padding(
                            padding:
                                const EdgeInsets.fromLTRB(8, 18, 8, 8),
                            child: Row(
                              children: [
                                Text(
                                  'PROCESADAS · ${processed.length}',
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
                          _NotesGrid(
                            notes: processed,
                            selected: const {},
                            isProcessed: true,
                            onTap: (n) => _showProcessedActions(n),
                            onLongPress: (n) => _showProcessedActions(n),
                          ),
                      ],
                    ),
                  ),
                );
              },
              loading: () =>
                  const SliverToBoxAdapter(child: SizedBox.shrink()),
              error: (_, __) =>
                  const SliverToBoxAdapter(child: SizedBox.shrink()),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 80)),
          ],
        ),
      ),
    );
  }

  void _onCardTap(QuickNote note) {
    if (_selectionMode) {
      _toggleSelection(note.id);
    } else {
      FeedbackService.instance.tick();
      _showNoteActions(note);
    }
  }

  void _showProcessedActions(QuickNote note) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (sheetCtx) => Container(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        decoration: BoxDecoration(
          color: sheetCtx.surfaceSheet,
          borderRadius:
              const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _SheetHandle(),
            const SizedBox(height: 4),
            ListTile(
              leading: Icon(Icons.unarchive_rounded,
                  color: context.colorPrimary),
              title: const Text('Volver al inbox'),
              onTap: () {
                Navigator.pop(sheetCtx);
                ref.read(quickNoteServiceProvider).reopenNote(note.id);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete_rounded,
                  color: AppTheme.colorDanger),
              title: const Text('Borrar para siempre'),
              onTap: () {
                Navigator.pop(sheetCtx);
                ref.read(quickNoteServiceProvider).deleteNote(note.id);
              },
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    if (_selectionMode) {
      return AppBar(
        backgroundColor: context.surfaceBase,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: _exitSelection,
        ),
        title: Text(
          '${_selected.length} seleccionada${_selected.length == 1 ? '' : 's'}',
          style: GoogleFonts.fraunces(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: context.textPrimary,
          ),
        ),
        actions: [
          IconButton(
            tooltip: 'Fijar',
            icon: const Icon(Icons.push_pin_rounded),
            onPressed: _bulkPin,
          ),
          IconButton(
            tooltip: 'Archivar',
            icon: const Icon(Icons.archive_rounded),
            onPressed: _bulkArchive,
          ),
          IconButton(
            tooltip: 'Borrar',
            icon: const Icon(Icons.delete_rounded,
                color: AppTheme.colorDanger),
            onPressed: _bulkDelete,
          ),
        ],
      );
    }
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back_rounded, color: context.textSecondary),
        onPressed: () => context.pop(),
      ),
      title: Text(
        'Inbox',
        style: GoogleFonts.fraunces(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: context.textPrimary,
          letterSpacing: -0.3,
        ),
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          color: context.surfaceCard,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: context.dividerColor),
        ),
        child: Row(
          children: [
            Icon(Icons.search_rounded, size: 18, color: context.textTertiary),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                controller: _searchCtrl,
                style: GoogleFonts.inter(
                    fontSize: 13.5, color: context.textPrimary),
                decoration: InputDecoration(
                  hintText: 'Buscar en tus notas...',
                  hintStyle: GoogleFonts.inter(
                      fontSize: 13.5, color: context.textTertiary),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(vertical: 10),
                ),
                onChanged: (v) => setState(() => _query = v.trim()),
              ),
            ),
            if (_query.isNotEmpty)
              IconButton(
                tooltip: 'Limpiar',
                icon: const Icon(Icons.close_rounded, size: 16),
                onPressed: () {
                  _searchCtrl.clear();
                  setState(() => _query = '');
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCaptureRow(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: context.surfaceCard,
          borderRadius: AppTheme.r16,
          border: Border.all(color: context.dividerColor),
          boxShadow: AppTheme.shadowSm,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Type chips
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: QuickNoteType.values
                    .where((t) => t != QuickNoteType.general)
                    .map((t) {
                  final sel = _selectedType == t;
                  final color = _typeColor(t);
                  return GestureDetector(
                    onTap: () => setState(() => _selectedType = t),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      margin: const EdgeInsets.only(right: 6),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: sel
                            ? color.withValues(alpha: 0.18)
                            : context.surfaceBase,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: sel ? color : context.dividerColor,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(_typeIcon(t),
                              size: 13,
                              color:
                                  sel ? color : context.textSecondary),
                          const SizedBox(width: 4),
                          Text(
                            _typeLabel(t),
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: sel
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                              color:
                                  sel ? color : context.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _captureCtrl,
              maxLines: 3,
              style: GoogleFonts.inter(
                  fontSize: 14, color: context.textPrimary, height: 1.5),
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
                  onResult: (String text) {
                    _captureCtrl.text = text;
                  },
                  size: 36,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: FilledButton(
                    onPressed: _capture,
                    style: FilledButton.styleFrom(
                      minimumSize: const Size(double.infinity, 44),
                      backgroundColor: context.colorPrimary,
                    ),
                    child: Text(
                      'Capturar',
                      style:
                          GoogleFonts.inter(fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Helpers globales ─────────────────────────────────────────────────────────

Color _typeColor(QuickNoteType t) => switch (t) {
      QuickNoteType.idea => const Color(0xFFC4963A),
      QuickNoteType.nota => const Color(0xFF5B7E9E),
      QuickNoteType.tarea => const Color(0xFF5B8A5E),
      QuickNoteType.proyecto => const Color(0xFFC15F3C),
      QuickNoteType.general => const Color(0xFFB1ADA1),
    };

/// Icono Material minimalista por tipo. Cambiamos los emojis (💡 📋 ✓
/// 🎯 📝) por outlines tintados — quedan más limpios y se mantienen
/// consistentes en dark mode.
IconData _typeIcon(QuickNoteType t) => switch (t) {
      QuickNoteType.idea => Icons.lightbulb_outline_rounded,
      QuickNoteType.nota => Icons.sticky_note_2_outlined,
      QuickNoteType.tarea => Icons.task_alt_rounded,
      QuickNoteType.proyecto => Icons.folder_outlined,
      QuickNoteType.general => Icons.notes_rounded,
    };

String _typeLabel(QuickNoteType t) => switch (t) {
      QuickNoteType.idea => 'Idea',
      QuickNoteType.nota => 'Nota',
      QuickNoteType.tarea => 'Tarea',
      QuickNoteType.proyecto => 'Proyecto',
      QuickNoteType.general => 'General',
    };

// ─── Section label ────────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.label);
  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 6),
      child: Text(
        label,
        style: GoogleFonts.inter(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: context.textTertiary,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

// ─── Sheet handle ─────────────────────────────────────────────────────────────

class _SheetHandle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 40,
        height: 4,
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: context.dividerColor,
          borderRadius: BorderRadius.circular(999),
        ),
      ),
    );
  }
}

// ─── Notes grid (Wrap masonry 2-col) ──────────────────────────────────────────

/// Grid masonry simple usando Wrap. Cada card ocupa el 50% del ancho
/// disponible menos un gutter de 8 — altura natural según contenido.
class _NotesGrid extends StatelessWidget {
  const _NotesGrid({
    required this.notes,
    required this.selected,
    required this.onTap,
    required this.onLongPress,
    this.isProcessed = false,
  });

  final List<QuickNote> notes;
  final Set<String> selected;
  final void Function(QuickNote) onTap;
  final void Function(QuickNote) onLongPress;
  final bool isProcessed;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (ctx, constraints) {
        final itemWidth = (constraints.maxWidth - 8) / 2;
        return Wrap(
          spacing: 8,
          runSpacing: 8,
          children: notes
              .map((n) => SizedBox(
                    width: itemWidth,
                    child: _NoteCard(
                      note: n,
                      isProcessed: isProcessed,
                      isSelected: selected.contains(n.id),
                      onTap: () => onTap(n),
                      onLongPress: () => onLongPress(n),
                    ),
                  ))
              .toList(),
        );
      },
    );
  }
}

// ─── Note card (Keep style) ───────────────────────────────────────────────────

class _NoteCard extends StatelessWidget {
  const _NoteCard({
    required this.note,
    required this.isSelected,
    required this.onTap,
    required this.onLongPress,
    this.isProcessed = false,
  });

  final QuickNote note;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  final bool isProcessed;

  @override
  Widget build(BuildContext context) {
    final color = _typeColor(note.type);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    // Tinted bg estilo Keep: la card entera lleva el color del tipo
    // (más fuerte en dark, más suave en light) en lugar de borde.
    final bg = isProcessed
        ? context.neutral50
        : Color.lerp(context.surfaceCard, color, isDark ? 0.18 : 0.12)!;
    final border = isSelected
        ? context.colorPrimary
        : (isProcessed ? context.dividerColor : color.withAlpha(80));

    return Stack(
      children: [
        Material(
          color: bg,
          borderRadius: BorderRadius.circular(14),
          child: InkWell(
            onTap: onTap,
            onLongPress: onLongPress,
            borderRadius: BorderRadius.circular(14),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                    color: border, width: isSelected ? 2 : 1),
                boxShadow: isProcessed ? null : AppTheme.shadowSm,
              ),
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Pin top-right
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          note.content,
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: isProcessed
                                ? context.textTertiary
                                : context.textPrimary,
                            height: 1.4,
                          ),
                          maxLines: 12,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      // Si está seleccionada, el check del Stack overlay
                      // toma el rol — escondemos el pin para no chocar.
                      if (note.isPinned && !isSelected)
                        Padding(
                          padding: const EdgeInsets.only(left: 6, top: 2),
                          child: Icon(Icons.push_pin_rounded,
                              size: 14, color: color),
                        ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: color.withValues(alpha: 0.20),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                              color: color.withValues(alpha: 0.55)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(_typeIcon(note.type),
                                size: 11, color: color),
                            const SizedBox(width: 3),
                            Text(
                              _typeLabel(note.type),
                              style: GoogleFonts.inter(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: color,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      Text(
                        DateFormat('d MMM', 'es').format(note.createdAt),
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          color: context.textTertiary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        // Selection check overlay — top-right (donde está el pin), más
        // chico para no tapar texto. Cuando está seleccionada el pin
        // se oculta para no chocar.
        if (isSelected)
          Positioned(
            top: 6,
            right: 6,
            child: Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: context.colorPrimary,
                border: Border.all(color: context.surfaceCard, width: 2),
              ),
              child: const Icon(Icons.check_rounded,
                  size: 12, color: Colors.white),
            ),
          ),
      ],
    );
  }
}

// ─── Note actions sheet ───────────────────────────────────────────────────────

class _NoteActionsSheet extends StatelessWidget {
  const _NoteActionsSheet({
    required this.note,
    required this.onEdit,
    required this.onPinToggle,
    required this.onConvertToTask,
    required this.onConvertToProject,
    required this.onArchive,
    required this.onDelete,
  });

  final QuickNote note;
  final VoidCallback onEdit;
  final VoidCallback onPinToggle;
  final VoidCallback onConvertToTask;
  final VoidCallback onConvertToProject;
  final VoidCallback onArchive;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final color = _typeColor(note.type);
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      decoration: BoxDecoration(
        color: context.surfaceSheet,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: AppTheme.shadowLg,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _SheetHandle(),
          // Preview de la nota
          Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: color.withValues(alpha: 0.55)),
            ),
            child: Text(
              note.content,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.inter(
                fontSize: 13,
                color: context.textPrimary,
                height: 1.4,
              ),
            ),
          ),
          // Acción primaria según tipo
          if (note.type == QuickNoteType.tarea ||
              note.type == QuickNoteType.idea ||
              note.type == QuickNoteType.general ||
              note.type == QuickNoteType.nota)
            ListTile(
              leading: const Icon(Icons.task_alt_rounded,
                  color: AppTheme.colorSuccess),
              title: const Text('Convertir en tarea'),
              subtitle: const Text('Abre Nueva tarea con este texto'),
              onTap: () {
                Navigator.pop(context);
                onConvertToTask();
              },
            ),
          if (note.type == QuickNoteType.proyecto ||
              note.type == QuickNoteType.idea ||
              note.type == QuickNoteType.general)
            ListTile(
              leading: const Icon(Icons.folder_rounded,
                  color: AppTheme.colorPrimary),
              title: const Text('Convertir en proyecto'),
              subtitle: const Text('Abre Nuevo proyecto con este texto'),
              onTap: () {
                Navigator.pop(context);
                onConvertToProject();
              },
            ),
          ListTile(
            leading: Icon(
              note.isPinned
                  ? Icons.push_pin_outlined
                  : Icons.push_pin_rounded,
              color: AppTheme.colorWarning,
            ),
            title: Text(note.isPinned ? 'Desfijar' : 'Fijar arriba'),
            onTap: () {
              Navigator.pop(context);
              onPinToggle();
            },
          ),
          ListTile(
            leading:
                Icon(Icons.edit_rounded, color: context.colorPrimary),
            title: const Text('Editar texto / tipo'),
            onTap: () {
              Navigator.pop(context);
              onEdit();
            },
          ),
          ListTile(
            leading: Icon(Icons.archive_outlined,
                color: context.textSecondary),
            title: const Text('Archivar (sin convertir)'),
            subtitle: const Text('Pasa a Procesadas, recuperable después'),
            onTap: () {
              Navigator.pop(context);
              onArchive();
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete_rounded,
                color: AppTheme.colorDanger),
            title: const Text('Borrar para siempre'),
            onTap: () {
              Navigator.pop(context);
              onDelete();
            },
          ),
        ],
      ),
    );
  }
}
