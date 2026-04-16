import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:arquitectura_enfoque/core/theme/app_theme.dart';
import 'package:arquitectura_enfoque/core/theme/app_colors.dart';
import 'package:arquitectura_enfoque/core/providers/backup_provider.dart';
import 'package:arquitectura_enfoque/core/providers/theme_provider.dart';
import 'package:arquitectura_enfoque/core/logic/notification_service.dart';
import 'package:arquitectura_enfoque/core/logic/user_prefs.dart';
import 'package:arquitectura_enfoque/core/models/task_area.dart';
import 'package:arquitectura_enfoque/features/hoy/domain/models/task.dart';
import 'package:arquitectura_enfoque/features/enfoque/domain/models/timer_state.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(isDarkModeProvider);
    final prefs = ref.watch(userPrefsProvider);
    final prefsNotifier = ref.read(userPrefsProvider.notifier);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: context.surfaceBase,
      appBar: AppBar(
        title: Text(
          'Configuracion',
          style: GoogleFonts.lora(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        iconTheme: IconThemeData(color: colorScheme.onSurface),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        children: [
          // ── Apariencia ──
          const _SectionLabel('APARIENCIA'),
          const SizedBox(height: 12),
          _Card(
            child: SwitchListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              shape: RoundedRectangleBorder(borderRadius: AppTheme.r16),
              secondary: Icon(
                isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                color: isDark ? AppTheme.colorAccent : AppTheme.colorWarning,
              ),
              title: const _Title('Modo oscuro'),
              subtitle: _Subtitle(isDark ? 'Activado' : 'Desactivado'),
              value: isDark,
              activeTrackColor: AppTheme.colorPrimary.withAlpha(80),
              activeThumbColor: AppTheme.colorPrimary,
              onChanged: (_) => ref.read(isDarkModeProvider.notifier).toggle(),
            ),
          ),

          const SizedBox(height: 32),

          // ── Notificaciones ──
          const _SectionLabel('NOTIFICACIONES'),
          const SizedBox(height: 12),
          const _ReminderTile(),

          const SizedBox(height: 32),

          // ── Datos (backup / restore) ──
          const _SectionLabel('DATOS'),
          const SizedBox(height: 12),
          _Card(
            child: Column(
              children: [
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  shape: RoundedRectangleBorder(borderRadius: AppTheme.r16),
                  leading: const _IconBadge(
                    icon: Icons.cloud_upload_rounded,
                    color: AppTheme.colorPrimary,
                  ),
                  title: const _Title('Hacer backup'),
                  subtitle: const _Subtitle('Exporta todos tus datos a un archivo JSON'),
                  trailing: Icon(Icons.chevron_right_rounded, color: theme.textTheme.bodyMedium?.color),
                  onTap: () => _doBackup(context, ref),
                ),
                Divider(height: 1, indent: 16, endIndent: 16, color: theme.dividerColor),
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  shape: RoundedRectangleBorder(borderRadius: AppTheme.r16),
                  leading: const _IconBadge(
                    icon: Icons.cloud_download_rounded,
                    color: AppTheme.colorDanger,
                  ),
                  title: const _Title('Restaurar backup'),
                  subtitle: const _Subtitle('Reemplaza los datos actuales con los del archivo'),
                  trailing: Icon(Icons.chevron_right_rounded, color: theme.textTheme.bodyMedium?.color),
                  onTap: () => _doRestore(context, ref),
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // ── Hoy ──
          const _SectionLabel('HOY'),
          const SizedBox(height: 12),
          _Card(
            child: Column(
              children: [
                SwitchListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  shape: RoundedRectangleBorder(borderRadius: AppTheme.r16),
                  secondary: const _IconBadge(
                    icon: Icons.format_quote_rounded,
                    color: AppTheme.colorAccent,
                  ),
                  title: const _Title('Mostrar frases'),
                  subtitle: const _Subtitle('Citas inspiracionales en la cabecera'),
                  value: prefs.showQuotes,
                  activeTrackColor: AppTheme.colorAccent.withAlpha(80),
                  activeThumbColor: AppTheme.colorAccent,
                  onChanged: prefsNotifier.setShowQuotes,
                ),
                Divider(height: 1, indent: 16, endIndent: 16, color: theme.dividerColor),
                SwitchListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  shape: RoundedRectangleBorder(borderRadius: AppTheme.r16),
                  secondary: const _IconBadge(
                    icon: Icons.loop_rounded,
                    color: AppTheme.colorSuccess,
                  ),
                  title: const _Title('Mostrar habitos en Hoy'),
                  subtitle: const _Subtitle('Pills de habitos en la vista diaria'),
                  value: prefs.showHabitsInHoy,
                  activeTrackColor: AppTheme.colorSuccess.withAlpha(80),
                  activeThumbColor: AppTheme.colorSuccess,
                  onChanged: prefsNotifier.setShowHabitsInHoy,
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // ── Areas (categorías) ──
          const _SectionLabel('AREAS'),
          const SizedBox(height: 12),
          _Card(
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              shape: RoundedRectangleBorder(borderRadius: AppTheme.r16),
              leading: const _IconBadge(
                icon: Icons.palette_rounded,
                color: AppTheme.colorAccent,
              ),
              title: const _Title('Administrar areas'),
              subtitle: const _Subtitle('Crear, editar, reordenar o borrar categorias'),
              trailing: Icon(Icons.chevron_right_rounded, color: theme.textTheme.bodyMedium?.color),
              onTap: () => context.push('/manage-areas'),
            ),
          ),

          const SizedBox(height: 32),

          // ── Revision diaria ──
          const _SectionLabel('REVISION'),
          const SizedBox(height: 12),
          _Card(
            child: Column(
              children: [
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  shape: RoundedRectangleBorder(borderRadius: AppTheme.r16),
                  leading: const _IconBadge(
                    icon: Icons.rate_review_rounded,
                    color: AppTheme.colorPrimary,
                  ),
                  title: const _Title('Revision de hoy'),
                  subtitle: const _Subtitle('Tareas, habitos, animo y cierre del dia'),
                  trailing: Icon(Icons.chevron_right_rounded, color: theme.textTheme.bodyMedium?.color),
                  onTap: () => context.push('/review'),
                ),
                Divider(height: 1, indent: 16, endIndent: 16, color: theme.dividerColor),
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  shape: RoundedRectangleBorder(borderRadius: AppTheme.r16),
                  leading: const _IconBadge(
                    icon: Icons.history_rounded,
                    color: AppTheme.colorAccent,
                  ),
                  title: const _Title('Historial de revisiones'),
                  subtitle: const _Subtitle('Revisiones pasadas — ver, editar o borrar'),
                  trailing: Icon(Icons.chevron_right_rounded, color: theme.textTheme.bodyMedium?.color),
                  onTap: () => context.push('/review-history'),
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // ── Tareas ──
          const _SectionLabel('TAREAS'),
          const SizedBox(height: 12),
          _Card(
            child: Column(
              children: [
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                  leading: _IconBadge(
                    icon: Icons.flag_rounded,
                    color: _priorityColor(prefs.defaultPriority),
                  ),
                  title: const _Title('Prioridad por defecto'),
                  subtitle: const _Subtitle('Al crear una tarea nueva'),
                  trailing: _PriorityChip(priority: prefs.defaultPriority),
                  onTap: () => _showPriorityPicker(context, prefs.defaultPriority, prefsNotifier),
                ),
                Divider(height: 1, indent: 16, endIndent: 16, color: theme.dividerColor),
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                  leading: _IconBadge(
                    icon: Icons.category_rounded,
                    color: getTaskArea(prefs.defaultArea)?.color ?? AppTheme.colorPrimary,
                  ),
                  title: const _Title('Area por defecto'),
                  subtitle: _Subtitle(
                    prefs.defaultArea == null
                        ? 'Sin area'
                        : getTaskArea(prefs.defaultArea)?.label ?? 'Sin area',
                  ),
                  trailing: Icon(Icons.chevron_right_rounded, color: theme.textTheme.bodyMedium?.color),
                  onTap: () => _showAreaPicker(context, prefs.defaultArea, prefsNotifier),
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // ── Enfoque (timer) ──
          const _SectionLabel('ENFOQUE'),
          const SizedBox(height: 12),
          _Card(
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
              leading: const _IconBadge(
                icon: Icons.timer_rounded,
                color: AppTheme.colorDanger,
              ),
              title: const _Title('Modo por defecto'),
              subtitle: _Subtitle(prefs.defaultTimerMode.label),
              trailing: Icon(Icons.chevron_right_rounded, color: theme.textTheme.bodyMedium?.color),
              onTap: () => _showTimerModePicker(context, prefs.defaultTimerMode, prefsNotifier),
            ),
          ),

          const SizedBox(height: 32),

          // ── Novedades ──
          const _SectionLabel('NOVEDADES'),
          const SizedBox(height: 12),
          _Card(
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              shape: RoundedRectangleBorder(borderRadius: AppTheme.r16),
              leading: const _IconBadge(
                icon: Icons.new_releases_rounded,
                color: AppTheme.colorPrimary,
              ),
              title: const _Title('Novedades'),
              subtitle: const _Subtitle('Ultimas actualizaciones de la app'),
              trailing: Icon(Icons.chevron_right_rounded, color: theme.textTheme.bodyMedium?.color),
              onTap: () => context.push('/novedades'),
            ),
          ),

          const SizedBox(height: 32),

          // ── Acerca de ──
          const _SectionLabel('ACERCA DE'),
          const SizedBox(height: 12),
          _Card(
            child: Column(
              children: [
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                  leading: Icon(Icons.info_outline_rounded, color: theme.textTheme.bodyMedium?.color),
                  title: const _Title('Version'),
                  trailing: Text(
                    '1.6.0',
                    style: GoogleFonts.inter(fontSize: 13, color: theme.textTheme.bodyMedium?.color),
                  ),
                ),
                Divider(height: 1, indent: 16, endIndent: 16, color: theme.dividerColor),
                const ListTile(
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                  leading: Icon(Icons.favorite_rounded, color: AppTheme.colorDanger),
                  title: _Title('Hecho con cuidado'),
                  subtitle: _Subtitle('Anotalo - tu sistema de enfoque'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Pickers ────────────────────────────────────────────────────────────────

  void _showPriorityPicker(BuildContext context, TaskPriority current, UserPrefsNotifier notifier) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).cardTheme.color,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Container(width: 40, height: 4, decoration: BoxDecoration(
              color: Theme.of(ctx).dividerColor, borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Align(alignment: Alignment.centerLeft,
                child: Text('Prioridad por defecto',
                  style: GoogleFonts.lora(fontSize: 18, fontWeight: FontWeight.w600,
                    color: Theme.of(ctx).colorScheme.onSurface))),
            ),
            for (final p in TaskPriority.values)
              ListTile(
                leading: Container(
                  width: 12, height: 12,
                  decoration: BoxDecoration(color: _priorityColor(p), shape: BoxShape.circle),
                ),
                title: Text(_priorityLabel(p), style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: p == current ? FontWeight.w700 : FontWeight.w500,
                  color: Theme.of(ctx).colorScheme.onSurface,
                )),
                trailing: p == current ? Icon(Icons.check_rounded, color: _priorityColor(p)) : null,
                onTap: () {
                  notifier.setDefaultPriority(p);
                  Navigator.pop(ctx);
                },
              ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void _showAreaPicker(BuildContext context, String? current, UserPrefsNotifier notifier) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).cardTheme.color,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Container(width: 40, height: 4, decoration: BoxDecoration(
              color: Theme.of(ctx).dividerColor, borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Align(alignment: Alignment.centerLeft,
                child: Text('Area por defecto',
                  style: GoogleFonts.lora(fontSize: 18, fontWeight: FontWeight.w600,
                    color: Theme.of(ctx).colorScheme.onSurface))),
            ),
            ListTile(
              leading: const Icon(Icons.block_rounded, size: 20),
              title: Text('Sin area', style: GoogleFonts.inter(
                fontSize: 15,
                fontWeight: current == null ? FontWeight.w700 : FontWeight.w500,
                color: Theme.of(ctx).colorScheme.onSurface,
              )),
              trailing: current == null ? const Icon(Icons.check_rounded) : null,
              onTap: () {
                notifier.setDefaultArea(null);
                Navigator.pop(ctx);
              },
            ),
            for (final a in kTaskAreas)
              ListTile(
                leading: Text(a.emoji, style: const TextStyle(fontSize: 20)),
                title: Text(a.label, style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: a.id == current ? FontWeight.w700 : FontWeight.w500,
                  color: Theme.of(ctx).colorScheme.onSurface,
                )),
                trailing: a.id == current ? Icon(Icons.check_rounded, color: a.color) : null,
                onTap: () {
                  notifier.setDefaultArea(a.id);
                  Navigator.pop(ctx);
                },
              ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void _showTimerModePicker(BuildContext context, TimerMode current, UserPrefsNotifier notifier) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).cardTheme.color,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Container(width: 40, height: 4, decoration: BoxDecoration(
              color: Theme.of(ctx).dividerColor, borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Align(alignment: Alignment.centerLeft,
                child: Text('Modo por defecto',
                  style: GoogleFonts.lora(fontSize: 18, fontWeight: FontWeight.w600,
                    color: Theme.of(ctx).colorScheme.onSurface))),
            ),
            for (final m in TimerMode.values)
              ListTile(
                title: Text(m.label, style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: m == current ? FontWeight.w700 : FontWeight.w500,
                  color: Theme.of(ctx).colorScheme.onSurface,
                )),
                trailing: m == current ? const Icon(Icons.check_rounded, color: AppTheme.colorDanger) : null,
                onTap: () {
                  notifier.setDefaultTimerMode(m);
                  Navigator.pop(ctx);
                },
              ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  // ── Backup / Restore ───────────────────────────────────────────────────────

  Future<void> _doBackup(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: AppTheme.r16),
        title: Text(
          'Crear backup',
          style: GoogleFonts.lora(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        content: Text(
          'Se va a guardar un archivo JSON con todos tus datos directamente en la carpeta Descargas. Vas a poder compartirlo o restaurarlo despues.',
          style: GoogleFonts.inter(fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text('Cancelar', style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppTheme.colorPrimary),
            onPressed: () => Navigator.pop(ctx, true),
            child: Text('Guardar backup', style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;

    final messenger = ScaffoldMessenger.of(context);
    try {
      final service = ref.read(backupServiceProvider);
      final file = await service.saveBackupToDownloads();
      final name = file.path.split(Platform.pathSeparator).last;
      messenger.showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          // Snackbars with actions normally stay until the user taps, which
          // felt "stuck" to the user. 3s auto-dismiss matches the rest of
          // the app and still gives time to reach the Compartir button.
          duration: const Duration(seconds: 3),
          backgroundColor: AppTheme.colorSuccess,
          content: Text(
            'Guardado en Descargas/$name',
            style: GoogleFonts.inter(fontWeight: FontWeight.w600),
          ),
          action: SnackBarAction(
            label: 'Compartir',
            textColor: Colors.white,
            onPressed: () {
              Share.shareXFiles(
                [XFile(file.path, mimeType: 'application/json')],
                subject: 'Backup Anotalo',
              );
            },
          ),
        ),
      );
    } catch (e) {
      messenger.showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 3),
          backgroundColor: AppTheme.colorDanger,
          content: Text('Error al crear backup: $e', style: GoogleFonts.inter()),
        ),
      );
    }
  }

  Future<void> _doRestore(BuildContext context, WidgetRef ref) async {
    final service = ref.read(backupServiceProvider);

    // 1) Try auto-detect in Downloads.
    File? pickedFile;
    try {
      pickedFile = await service.findLatestBackupInDownloads();
    } catch (_) {
      pickedFile = null;
    }

    // 2) If not found, fall back to the SAF file picker.
    if (pickedFile == null) {
      if (!context.mounted) return;
      final useManual = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: AppTheme.r16),
          title: Text(
            'Sin backup en Descargas',
            style: GoogleFonts.lora(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          content: Text(
            'No encontre ningun archivo de backup de Anotalo en la carpeta Descargas. Queres buscarlo manualmente?',
            style: GoogleFonts.inter(fontSize: 14),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: Text('Cancelar', style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
            ),
            FilledButton(
              style: FilledButton.styleFrom(backgroundColor: AppTheme.colorPrimary),
              onPressed: () => Navigator.pop(ctx, true),
              child: Text('Buscar archivo', style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
            ),
          ],
        ),
      );
      if (useManual != true) return;
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
        withData: false,
      );
      if (result == null || result.files.isEmpty) return;
      final path = result.files.single.path;
      if (path == null) return;
      pickedFile = File(path);
    }

    String jsonStr;
    try {
      jsonStr = await pickedFile.readAsString();
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppTheme.colorDanger,
          content: Text('No se pudo leer el archivo: $e', style: GoogleFonts.inter()),
        ),
      );
      return;
    }

    final summary = service.summarizeJson(jsonStr);
    if (!context.mounted) return;
    if (summary == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppTheme.colorDanger,
          content: Text(
            'El archivo no es un backup valido de Anotalo',
            style: GoogleFonts.inter(fontWeight: FontWeight.w600),
          ),
        ),
      );
      return;
    }

    final filename = pickedFile.path.split(Platform.pathSeparator).last;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: AppTheme.r16),
        title: Row(
          children: [
            const Icon(Icons.warning_amber_rounded, color: AppTheme.colorDanger),
            const SizedBox(width: 8),
            Text(
              'Restaurar backup',
              style: GoogleFonts.lora(fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.colorDanger.withAlpha(20),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppTheme.colorDanger.withAlpha(60)),
              ),
              child: Text(
                'Esto va a REEMPLAZAR todos tus datos actuales. No se puede deshacer.',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.colorDanger,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Archivo: $filename',
              style: GoogleFonts.inter(fontSize: 12, fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 4),
            Text(
              summary.createdAt != null
                  ? 'Backup del ${DateFormat('dd/MM/yyyy HH:mm').format(summary.createdAt!)}'
                  : 'Backup sin fecha',
              style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            _SummaryRow(label: 'Tareas', count: summary.tasks),
            _SummaryRow(label: 'Habitos', count: summary.habits),
            _SummaryRow(label: 'Completaciones', count: summary.habitCompletions),
            _SummaryRow(label: 'Proyectos', count: summary.projects),
            _SummaryRow(label: 'Notas rapidas', count: summary.quickNotes),
            _SummaryRow(label: 'Entradas de diario', count: summary.journalEntries),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text('Cancelar', style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppTheme.colorDanger),
            onPressed: () => Navigator.pop(ctx, true),
            child: Text('Restaurar', style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;

    final messenger = ScaffoldMessenger.of(context);
    try {
      await service.importFromJson(jsonStr);
      messenger.showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 3),
          backgroundColor: AppTheme.colorSuccess,
          content: Text(
            'Datos restaurados correctamente',
            style: GoogleFonts.inter(fontWeight: FontWeight.w600),
          ),
        ),
      );
    } catch (e) {
      messenger.showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 3),
          backgroundColor: AppTheme.colorDanger,
          content: Text('Error al restaurar: $e', style: GoogleFonts.inter()),
        ),
      );
    }
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final int count;
  const _SummaryRow({required this.label, required this.count});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 2),
    child: Row(
      children: [
        Text('· ', style: GoogleFonts.inter(fontSize: 13, color: AppTheme.colorPrimary)),
        Text(
          label,
          style: GoogleFonts.inter(fontSize: 13, color: Theme.of(context).colorScheme.onSurface),
        ),
        const Spacer(),
        Text(
          '$count',
          style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w700),
        ),
      ],
    ),
  );
}

// ── Shared helpers ──────────────────────────────────────────────────────────

Color _priorityColor(TaskPriority p) => switch (p) {
  TaskPriority.primordial   => AppTheme.colorDanger,
  TaskPriority.importante   => AppTheme.colorWarning,
  TaskPriority.puedeEsperar => AppTheme.colorPrimary,
  TaskPriority.secundaria   => AppTheme.textTertiary,
};

String _priorityLabel(TaskPriority p) => switch (p) {
  TaskPriority.primordial   => 'Primordial',
  TaskPriority.importante   => 'Importante',
  TaskPriority.puedeEsperar => 'Puede esperar',
  TaskPriority.secundaria   => 'Secundaria',
};

// ── Visual building blocks ──────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);
  @override
  Widget build(BuildContext context) => Text(
    text,
    style: GoogleFonts.inter(
      fontSize: 11, fontWeight: FontWeight.w600,
      color: AppTheme.colorAccent, letterSpacing: 0.5,
    ),
  );
}

class _Title extends StatelessWidget {
  final String text;
  const _Title(this.text);
  @override
  Widget build(BuildContext context) => Text(
    text,
    style: GoogleFonts.inter(
      fontSize: 15, fontWeight: FontWeight.w500,
      color: Theme.of(context).colorScheme.onSurface,
    ),
  );
}

class _Subtitle extends StatelessWidget {
  final String text;
  const _Subtitle(this.text);
  @override
  Widget build(BuildContext context) => Text(
    text,
    style: GoogleFonts.inter(
      fontSize: 13,
      color: Theme.of(context).textTheme.bodyMedium?.color,
    ),
  );
}

class _Card extends StatelessWidget {
  final Widget child;
  const _Card({required this.child});
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.cardTheme.color ?? theme.colorScheme.surface,
        borderRadius: AppTheme.r16,
        border: Border.all(color: theme.dividerColor),
      ),
      child: child,
    );
  }
}

class _IconBadge extends StatelessWidget {
  final IconData icon;
  final Color color;
  const _IconBadge({required this.icon, required this.color});
  @override
  Widget build(BuildContext context) => Container(
    width: 36, height: 36,
    decoration: BoxDecoration(
      color: color.withAlpha(20),
      borderRadius: BorderRadius.circular(10),
    ),
    child: Icon(icon, color: color, size: 20),
  );
}

class _PriorityChip extends StatelessWidget {
  final TaskPriority priority;
  const _PriorityChip({required this.priority});
  @override
  Widget build(BuildContext context) {
    final c = _priorityColor(priority);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: c.withAlpha(20),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: c.withAlpha(80)),
      ),
      child: Text(
        _priorityLabel(priority),
        style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w700, color: c),
      ),
    );
  }
}

// ─── Reminder Tile ────────────────────────────────────────────────────────────

class _ReminderTile extends StatefulWidget {
  const _ReminderTile();

  @override
  State<_ReminderTile> createState() => _ReminderTileState();
}

class _ReminderTileState extends State<_ReminderTile> {
  TimeOfDay _time = const TimeOfDay(hour: 21, minute: 0);
  bool _enabled = true;
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _loadPrefs();
  }

  Future<void> _loadPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      _enabled = prefs.getBool(NotificationService.prefEnabled) ?? true;
      _time = TimeOfDay(
        hour: prefs.getInt(NotificationService.prefHour) ?? 21,
        minute: prefs.getInt(NotificationService.prefMinute) ?? 0,
      );
      _loaded = true;
    });
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(context: context, initialTime: _time);
    if (picked == null) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(NotificationService.prefHour, picked.hour);
    await prefs.setInt(NotificationService.prefMinute, picked.minute);
    if (!mounted) return;
    setState(() => _time = picked);
    if (_enabled) {
      await NotificationService().scheduleDailyReminder(hour: picked.hour, minute: picked.minute);
    }
  }

  Future<void> _toggleEnabled(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(NotificationService.prefEnabled, value);
    setState(() => _enabled = value);
    if (value) {
      await NotificationService().scheduleDailyReminder(hour: _time.hour, minute: _time.minute);
    } else {
      await NotificationService().cancelReminder();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final timeLabel = _loaded
        ? '${_time.hour.toString().padLeft(2, '0')}:${_time.minute.toString().padLeft(2, '0')}'
        : '--:--';

    return _Card(
      child: Column(
        children: [
          SwitchListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            shape: RoundedRectangleBorder(borderRadius: AppTheme.r16),
            secondary: const _IconBadge(icon: Icons.notifications_rounded, color: AppTheme.colorWarning),
            title: Text(
              'Recordatorio nocturno',
              style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w500, color: colorScheme.onSurface),
            ),
            subtitle: Text(
              _enabled ? 'Activado' : 'Desactivado',
              style: GoogleFonts.inter(fontSize: 13, color: theme.textTheme.bodyMedium?.color),
            ),
            value: _enabled,
            activeTrackColor: AppTheme.colorWarning.withAlpha(80),
            activeThumbColor: AppTheme.colorWarning,
            onChanged: _toggleEnabled,
          ),
          if (_enabled) ...[
            Divider(height: 1, indent: 16, endIndent: 16, color: theme.dividerColor),
            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              leading: const Icon(Icons.access_time_rounded, size: 20),
              title: Text(
                'Hora del recordatorio',
                style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500, color: colorScheme.onSurface),
              ),
              trailing: Text(
                timeLabel,
                style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700, color: AppTheme.colorWarning),
              ),
              onTap: _pickTime,
            ),
          ],
        ],
      ),
    );
  }
}
