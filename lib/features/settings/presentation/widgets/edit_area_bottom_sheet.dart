import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:arquitectura_enfoque/core/models/task_area.dart';
import 'package:arquitectura_enfoque/core/providers/task_area_provider.dart';
import 'package:arquitectura_enfoque/core/theme/app_colors.dart';
import 'package:arquitectura_enfoque/core/theme/app_theme.dart';

/// Modal bottom sheet used to create a new task area or edit an existing one.
///
/// Call [show] from a widget that has a [BuildContext]. Pass an [area] to
/// enter edit mode; leave it null for create mode.
class EditAreaBottomSheet extends ConsumerStatefulWidget {
  const EditAreaBottomSheet({super.key, this.area});

  final TaskArea? area;

  static Future<void> show(BuildContext context, {TaskArea? area}) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: context.surfaceCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => EditAreaBottomSheet(area: area),
    );
  }

  @override
  ConsumerState<EditAreaBottomSheet> createState() =>
      _EditAreaBottomSheetState();
}

class _EditAreaBottomSheetState extends ConsumerState<EditAreaBottomSheet> {
  late final TextEditingController _labelCtrl;
  late final TextEditingController _emojiCtrl;
  late Color _color;
  bool _saving = false;

  bool get _isEdit => widget.area != null;

  @override
  void initState() {
    super.initState();
    final area = widget.area;
    _labelCtrl = TextEditingController(text: area?.label ?? '');
    _emojiCtrl = TextEditingController(text: area?.emoji ?? '');
    _color = area?.color ?? kAreaColorPalette.first;
  }

  @override
  void dispose() {
    _labelCtrl.dispose();
    _emojiCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final label = _labelCtrl.text.trim();
    if (label.isEmpty || _saving) return;

    setState(() => _saving = true);
    HapticFeedback.lightImpact();

    final service = ref.read(taskAreaServiceProvider);
    try {
      if (_isEdit) {
        await service.updateArea(
          id: widget.area!.id,
          label: label,
          emoji: _emojiCtrl.text,
          colorHex: colorToHex(_color),
        );
      } else {
        await service.addArea(
          label: label,
          emoji: _emojiCtrl.text,
          colorHex: colorToHex(_color),
        );
      }
      if (mounted) Navigator.of(context).pop();
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _confirmDelete() async {
    final area = widget.area;
    // Built-ins ahora también se pueden borrar — no todos los usuarios
    // quieren las mismas categorías por defecto.
    if (area == null) return;

    HapticFeedback.mediumImpact();

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: ctx.surfaceCard,
        shape: RoundedRectangleBorder(borderRadius: AppTheme.r16),
        title: Text(
          'Borrar area',
          style: GoogleFonts.fraunces(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: ctx.textPrimary,
          ),
        ),
        content: Text(
          'Borrar area \u00ab${area.label}\u00bb? Las tareas que la usan quedan sin area.',
          style: GoogleFonts.inter(
            fontSize: 14,
            color: ctx.textSecondary,
            height: 1.4,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(
              'Cancelar',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: ctx.textSecondary,
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(
              'Borrar',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppTheme.colorDanger,
              ),
            ),
          ),
        ],
      ),
    );

    if (confirmed != true) return;
    if (!mounted) return;

    setState(() => _saving = true);
    final service = ref.read(taskAreaServiceProvider);
    await service.deleteArea(area.id);
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    // Cualquier área existente se puede borrar (incluidas las built-in).
    final showDelete = _isEdit;

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Drag handle.
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: context.dividerColor,
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
              const SizedBox(height: 18),

              // Title.
              Text(
                _isEdit ? 'Editar area' : 'Nueva area',
                style: GoogleFonts.fraunces(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: context.textPrimary,
                ),
              ),
              const SizedBox(height: 18),

              // Label field.
              TextField(
                controller: _labelCtrl,
                autofocus: !_isEdit,
                textCapitalization: TextCapitalization.sentences,
                style: GoogleFonts.inter(
                  fontSize: 15,
                  color: context.textPrimary,
                ),
                decoration: InputDecoration(
                  hintText: 'Nombre del area (ej: Finanzas)',
                  hintStyle: GoogleFonts.inter(
                    fontSize: 15,
                    color: context.textTertiary,
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Emoji field.
              TextField(
                controller: _emojiCtrl,
                maxLength: 2,
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 18,
                  color: context.textPrimary,
                ),
                decoration: InputDecoration(
                  hintText: 'Emoji (opcional)',
                  counterText: '',
                  hintStyle: GoogleFonts.inter(
                    fontSize: 15,
                    color: context.textTertiary,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Color palette label.
              Text(
                'COLOR',
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: context.textTertiary,
                  letterSpacing: 0.8,
                ),
              ),
              const SizedBox(height: 10),

              _ColorPalette(
                selected: _color,
                onSelect: (c) {
                  HapticFeedback.lightImpact();
                  setState(() => _color = c);
                },
              ),

              const SizedBox(height: 24),

              if (showDelete) ...[
                _DeleteRow(onPressed: _saving ? null : _confirmDelete),
                const SizedBox(height: 16),
              ],

              // Save button.
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _saving ? null : _save,
                  style: FilledButton.styleFrom(
                    backgroundColor: AppTheme.colorPrimary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: AppTheme.r12),
                  ),
                  child: _saving
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : Text(
                          _isEdit ? 'Guardar' : 'Crear',
                          style: GoogleFonts.inter(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 8),

              // Cancel link.
              Center(
                child: TextButton(
                  onPressed: _saving ? null : () => Navigator.of(context).pop(),
                  child: Text(
                    'Cancelar',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: context.textSecondary,
                    ),
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

class _ColorPalette extends StatelessWidget {
  const _ColorPalette({required this.selected, required this.onSelect});

  final Color selected;
  final ValueChanged<Color> onSelect;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        for (final c in kAreaColorPalette)
          _ColorSwatch(
            color: c,
            selected: c == selected,
            onTap: () => onSelect(c),
          ),
      ],
    );
  }
}

class _ColorSwatch extends StatelessWidget {
  const _ColorSwatch({
    required this.color,
    required this.selected,
    required this.onTap,
  });

  final Color color;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: selected
              ? Border.all(color: Colors.white, width: 3)
              : Border.all(color: Colors.transparent, width: 3),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: color.withAlpha(90),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                  ...AppTheme.shadowSm,
                ]
              : AppTheme.shadowSm,
        ),
      ),
    );
  }
}

class _DeleteRow extends StatelessWidget {
  const _DeleteRow({required this.onPressed});

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: AppTheme.r12,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        child: Row(
          children: [
            const Icon(
              Icons.delete_outline_rounded,
              size: 20,
              color: AppTheme.colorDanger,
            ),
            const SizedBox(width: 10),
            Text(
              'Borrar area',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppTheme.colorDanger,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
