import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:arquitectura_enfoque/core/theme/app_theme.dart';
import 'package:arquitectura_enfoque/core/theme/app_colors.dart';
import 'package:arquitectura_enfoque/core/providers/backup_provider.dart';
import 'package:arquitectura_enfoque/core/providers/theme_provider.dart';
import 'package:arquitectura_enfoque/core/logic/auth_service.dart';
import 'package:arquitectura_enfoque/core/logic/drive_backup_service.dart';
import 'package:arquitectura_enfoque/core/logic/notification_service.dart';
import 'package:arquitectura_enfoque/core/logic/user_prefs.dart';
import 'package:arquitectura_enfoque/core/models/task_area.dart';
import 'package:arquitectura_enfoque/core/widgets/anotalo_confirm_dialog.dart';
import 'package:arquitectura_enfoque/core/widgets/anotalo_toast.dart';
import 'package:arquitectura_enfoque/core/widgets/first_time_tip.dart';
import 'package:arquitectura_enfoque/features/hoy/domain/models/task.dart';
import 'package:arquitectura_enfoque/features/hoy/presentation/widgets/task_card.dart';
import 'package:arquitectura_enfoque/features/enfoque/domain/models/timer_state.dart';
import 'package:arquitectura_enfoque/features/onboarding/domain/onboarding_prefs.dart';
import 'package:arquitectura_enfoque/features/settings/presentation/widgets/accent_picker.dart';
import 'package:arquitectura_enfoque/features/settings/presentation/widgets/feedback_section.dart';

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
          style: GoogleFonts.fraunces(
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
          // ── Perfil ──
          const _SectionLabel('PERFIL'),
          const SizedBox(height: 12),
          const _Card(child: _NameTile()),

          const SizedBox(height: 32),

          // ── Cuenta ──
          const _SectionLabel('CUENTA'),
          const SizedBox(height: 12),
          const _Card(child: _AccountTile()),

          const SizedBox(height: 32),

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

          // ── Color de acento (1.6) ──
          const _SectionLabel('COLOR DE ACENTO'),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
            decoration: BoxDecoration(
              color: theme.cardTheme.color ?? theme.colorScheme.surface,
              borderRadius: AppTheme.r16,
              border: Border.all(color: theme.dividerColor),
            ),
            child: const AccentPicker(),
          ),

          const SizedBox(height: 32),

          // ── Sonido & Hápticos (1.6) ──
          const _SectionLabel('SONIDO & HÁPTICOS'),
          const SizedBox(height: 12),
          const FeedbackSection(),

          const SizedBox(height: 32),

          // ── Notificaciones ──
          const _SectionLabel('NOTIFICACIONES'),
          const SizedBox(height: 12),
          const _ReminderTile(),

          const SizedBox(height: 32),

          // ── Backup en la nube (Drive) ──
          const _SectionLabel('BACKUP EN LA NUBE'),
          const SizedBox(height: 12),
          const _Card(child: _DriveBackupSection()),

          const SizedBox(height: 32),

          // ── Datos (backup / restore local) ──
          const _SectionLabel('BACKUP LOCAL'),
          const SizedBox(height: 12),
          _Card(
            child: Column(
              children: [
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  shape: RoundedRectangleBorder(borderRadius: AppTheme.r16),
                  leading: const _IconBadge(
                    icon: Icons.download_rounded,
                    color: AppTheme.colorPrimary,
                  ),
                  title: const _Title('Exportar a archivo'),
                  subtitle: const _Subtitle('Guarda un JSON en Descargas — útil offline'),
                  trailing: Icon(Icons.chevron_right_rounded, color: theme.textTheme.bodyMedium?.color),
                  onTap: () => _doBackup(context, ref),
                ),
                Divider(height: 1, indent: 16, endIndent: 16, color: theme.dividerColor),
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  shape: RoundedRectangleBorder(borderRadius: AppTheme.r16),
                  leading: const _IconBadge(
                    icon: Icons.upload_rounded,
                    color: AppTheme.colorDanger,
                  ),
                  title: const _Title('Restaurar desde archivo'),
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
                Divider(height: 1, indent: 16, endIndent: 16, color: theme.dividerColor),
                // Grow-old-tasks: escala el fontSize del título de tareas
                // pendientes según días de rollover. Default on.
                ListenableBuilder(
                  listenable: TaskCardPrefs.instance,
                  builder: (ctx, _) => SwitchListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    shape: RoundedRectangleBorder(borderRadius: AppTheme.r16),
                    secondary: const _IconBadge(
                      icon: Icons.format_size_rounded,
                      color: AppTheme.colorWarning,
                    ),
                    title: const _Title('Agrandar tareas viejas'),
                    subtitle: const _Subtitle(
                        'El título crece y se vuelve más negrita con el paso de los días'),
                    value: TaskCardPrefs.growOldTasks,
                    activeTrackColor: AppTheme.colorWarning.withAlpha(80),
                    activeThumbColor: AppTheme.colorWarning,
                    onChanged: TaskCardPrefs.instance.setGrowOldTasks,
                  ),
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
                  title: const _Title('Versión'),
                  // Versión dinámica desde pubspec.yaml — nunca más
                  // queda desincronizada al subir un release.
                  trailing: FutureBuilder<PackageInfo>(
                    future: PackageInfo.fromPlatform(),
                    builder: (_, snap) {
                      final v = snap.data?.version ?? '...';
                      return Text(
                        v,
                        style: GoogleFonts.inter(
                            fontSize: 13,
                            color: theme.textTheme.bodyMedium?.color),
                      );
                    },
                  ),
                ),
                Divider(height: 1, indent: 16, endIndent: 16, color: theme.dividerColor),
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                  leading: const _IconBadge(
                    icon: Icons.tour_rounded,
                    color: AppTheme.colorAccent,
                  ),
                  title: const _Title('Ver tour otra vez'),
                  subtitle: const _Subtitle('Rehace la bienvenida y el setup inicial'),
                  trailing: Icon(Icons.chevron_right_rounded, color: theme.textTheme.bodyMedium?.color),
                  onTap: () async {
                    // Reset también los coach-marks para que el user vuelva
                    // a verlos al entrar a cada pantalla luego del tour.
                    await OnboardingPrefs.reset();
                    await FirstTimeTip.resetAll();
                    if (!context.mounted) return;
                    GoRouter.of(context).go('/login');
                  },
                ),
                Divider(height: 1, indent: 16, endIndent: 16, color: theme.dividerColor),
                const ListTile(
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                  leading: Icon(Icons.favorite_rounded, color: AppTheme.colorDanger),
                  title: _Title('Hecho con cuidado'),
                  subtitle: _Subtitle('Apunto — tu sistema de enfoque'),
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
                  style: GoogleFonts.fraunces(fontSize: 18, fontWeight: FontWeight.w600,
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
                  style: GoogleFonts.fraunces(fontSize: 18, fontWeight: FontWeight.w600,
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
                  style: GoogleFonts.fraunces(fontSize: 18, fontWeight: FontWeight.w600,
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
    final confirmed = await showAnotaloConfirm(
      context: context,
      title: 'Crear backup',
      body:
          'Se va a guardar un archivo JSON con todos tus datos en la carpeta Descargas. Vas a poder compartirlo o restaurarlo después.',
      confirmLabel: 'Guardar',
      icon: Icons.cloud_upload_rounded,
    );
    if (!confirmed || !context.mounted) return;

    try {
      final service = ref.read(backupServiceProvider);
      final file = await service.saveBackupToDownloads();
      final name = file.path.split(Platform.pathSeparator).last;
      if (!context.mounted) return;
      showAnotaloToast(
        context,
        'Backup guardado en Descargas/$name',
        tone: ToastTone.success,
      );
      // Compartir opcional — shortcut extra: long-press la fila "Hacer backup"
      // (no disponible acá, fallback a share directo si el usuario quiere).
      unawaited(Share.shareXFiles(
        [XFile(file.path, mimeType: 'application/json')],
        subject: 'Backup Apunto',
      ));
    } catch (e) {
      if (!context.mounted) return;
      showAnotaloToast(context, 'Error al crear backup: $e',
          tone: ToastTone.warn);
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
      final useManual = await showAnotaloConfirm(
        context: context,
        title: 'Sin backup en Descargas',
        body:
            'No encontré ningún archivo de backup de Apunto en la carpeta Descargas. ¿Querés buscarlo manualmente?',
        confirmLabel: 'Buscar archivo',
        icon: Icons.folder_open_rounded,
      );
      if (!useManual) return;
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
      showAnotaloToast(context, 'No se pudo leer el archivo: $e',
          tone: ToastTone.warn);
      return;
    }

    final summary = service.summarizeJson(jsonStr);
    if (!context.mounted) return;
    if (summary == null) {
      showAnotaloToast(
        context,
        'El archivo no es un backup válido de Apunto',
        tone: ToastTone.warn,
      );
      return;
    }

    final filename = pickedFile.path.split(Platform.pathSeparator).last;
    final dateStr = summary.createdAt != null
        ? DateFormat('dd/MM/yyyy HH:mm').format(summary.createdAt!)
        : 'sin fecha';
    final body = 'Reemplaza todos tus datos actuales. No se puede deshacer.\n\n'
        'Archivo: $filename\n'
        'Backup: $dateStr\n'
        '• ${summary.tasks} tareas · ${summary.habits} hábitos · '
        '${summary.projects} proyectos';

    final confirmed = await showAnotaloConfirm(
      context: context,
      title: 'Restaurar backup',
      body: body,
      confirmLabel: 'Sí, restaurar',
      danger: true,
      icon: Icons.cloud_download_rounded,
    );
    if (!confirmed || !context.mounted) return;

    try {
      await service.importFromJson(jsonStr);
      if (!context.mounted) return;
      showAnotaloToast(context, 'Datos restaurados correctamente',
          tone: ToastTone.success);
    } catch (e) {
      if (!context.mounted) return;
      showAnotaloToast(context, 'Error al restaurar: $e',
          tone: ToastTone.warn);
    }
  }
}

// Helper local — share_plus devuelve un Future que no queremos await.
void unawaited(Future<void> _) {}

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
          // Avisar N minutos antes (aplica a TODAS las tareas con
          // horario). Convive en la misma card que el recordatorio
          // nocturno porque ambas son configs de notificaciones.
          Divider(height: 1, indent: 16, endIndent: 16, color: theme.dividerColor),
          const _RemindBeforeTile(),
        ],
      ),
    );
  }
}

// ─── Name Tile ────────────────────────────────────────────────────────────────

class _NameTile extends ConsumerWidget {
  const _NameTile();

  Future<void> _editName(BuildContext context, WidgetRef ref, String current) async {
    final controller = TextEditingController(text: current);
    final result = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Tu nombre',
            style: GoogleFonts.fraunces(fontSize: 18, fontWeight: FontWeight.w600)),
        content: TextField(
          controller: controller,
          autofocus: true,
          textCapitalization: TextCapitalization.words,
          decoration: const InputDecoration(hintText: 'Tu nombre (opcional)'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, controller.text.trim()),
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
    if (result != null) {
      await ref.read(userPrefsProvider.notifier).setUserName(result);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final name = ref.watch(userPrefsProvider.select((p) => p.userName));
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      shape: RoundedRectangleBorder(borderRadius: AppTheme.r16),
      leading: const _IconBadge(
        icon: Icons.person_rounded,
        color: AppTheme.colorPrimary,
      ),
      title: const _Title('Tu nombre'),
      subtitle: _Subtitle(
          name.isEmpty ? 'Sin definir — toca para editar' : name),
      trailing: Icon(Icons.edit_rounded,
          size: 18, color: theme.textTheme.bodyMedium?.color),
      onTap: () => _editName(context, ref, name),
    );
  }
}

// ─── Drive Backup Section ─────────────────────────────────────────────────────

/// Bloque de UI para backup automático/manual contra el Drive del user.
/// Si no está logueado, ofrece pasar al login. Si está, muestra:
/// toggle "Backup automático", última copia, y dos acciones manuales.
class _DriveBackupSection extends ConsumerStatefulWidget {
  const _DriveBackupSection();

  @override
  ConsumerState<_DriveBackupSection> createState() =>
      _DriveBackupSectionState();
}

class _DriveBackupSectionState extends ConsumerState<_DriveBackupSection> {
  bool _busy = false;
  DateTime? _lastBackupTime;
  bool _checkedTime = false;

  @override
  void initState() {
    super.initState();
    _refreshLastBackupTime();
  }

  Future<void> _refreshLastBackupTime() async {
    final user = AuthService.instance.currentUser;
    if (user == null) {
      if (mounted) setState(() => _checkedTime = true);
      return;
    }
    final svc = DriveBackupService.instance(ref.read(backupServiceProvider));
    final t = await svc.getLastBackupTime();
    if (!mounted) return;
    setState(() {
      _lastBackupTime = t;
      _checkedTime = true;
    });
  }

  String _humanizeAge(DateTime when) {
    final diff = DateTime.now().difference(when);
    if (diff.inMinutes < 1) return 'Hace instantes';
    if (diff.inMinutes < 60) return 'Hace ${diff.inMinutes} min';
    if (diff.inHours < 24) return 'Hace ${diff.inHours} h';
    if (diff.inDays < 7) return 'Hace ${diff.inDays} d';
    return DateFormat('d MMM yyyy', 'es').format(when);
  }

  Future<void> _uploadNow() async {
    if (_busy) return;
    setState(() => _busy = true);
    final svc = DriveBackupService.instance(ref.read(backupServiceProvider));
    final ok = await svc.uploadBackup();
    if (!mounted) return;
    setState(() => _busy = false);
    if (ok) {
      showAnotaloToast(
        context,
        'Backup subido a tu Drive',
        tone: ToastTone.success,
      );
      await _refreshLastBackupTime();
    } else {
      showAnotaloToast(
        context,
        'No se pudo subir el backup. Revisá la conexión.',
        tone: ToastTone.warn,
      );
    }
  }

  Future<void> _restoreFromCloud() async {
    if (_busy) return;
    final ok = await showAnotaloConfirm(
      context: context,
      title: 'Restaurar desde Drive',
      body:
          'Esto reemplaza TODOS los datos actuales con los de tu última copia en la nube. La acción no se puede deshacer.',
      confirmLabel: 'Restaurar',
      danger: true,
      icon: Icons.cloud_download_rounded,
    );
    if (!ok) return;
    setState(() => _busy = true);
    try {
      final backup = ref.read(backupServiceProvider);
      final drive = DriveBackupService.instance(backup);
      final json = await drive.downloadBackupJson();
      if (json == null) {
        if (!mounted) return;
        setState(() => _busy = false);
        showAnotaloToast(context, 'No hay backups en tu Drive todavía',
            tone: ToastTone.warn);
        return;
      }
      await backup.importFromJson(json);
      if (!mounted) return;
      setState(() => _busy = false);
      showAnotaloToast(context, 'Datos restaurados desde tu Drive',
          tone: ToastTone.success);
    } catch (e) {
      if (!mounted) return;
      setState(() => _busy = false);
      showAnotaloToast(context, 'Error al restaurar: $e',
          tone: ToastTone.warn);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final userAsync = ref.watch(authStateProvider);
    final user = userAsync.valueOrNull;

    if (user == null) {
      return ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: const _IconBadge(
          icon: Icons.cloud_off_rounded,
          color: AppTheme.neutral400,
        ),
        title: const _Title('Iniciá sesión para usar el backup en la nube'),
        subtitle: const _Subtitle(
            'Tu Drive guarda una copia tuya, invisible y privada.'),
        trailing: Icon(Icons.chevron_right_rounded,
            color: theme.textTheme.bodyMedium?.color),
        onTap: () => GoRouter.of(context).go('/login'),
      );
    }

    final auto = ref.watch(userPrefsProvider.select((p) => p.autoBackupToDrive));
    final ageLine = !_checkedTime
        ? 'Comprobando...'
        : _lastBackupTime == null
            ? 'Todavía sin copias en tu Drive'
            : 'Última copia: ${_humanizeAge(_lastBackupTime!)}';

    return Column(
      children: [
        SwitchListTile(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          shape: RoundedRectangleBorder(borderRadius: AppTheme.r16),
          secondary: const _IconBadge(
            icon: Icons.cloud_sync_rounded,
            color: AppTheme.colorSuccess,
          ),
          title: const _Title('Backup automático'),
          subtitle: _Subtitle(ageLine),
          value: auto,
          activeTrackColor: AppTheme.colorSuccess.withAlpha(80),
          activeThumbColor: AppTheme.colorSuccess,
          onChanged: (v) async {
            await ref.read(userPrefsProvider.notifier).setAutoBackupToDrive(v);
            if (!mounted) return;
            if (v) {
              // Apenas se activa, hacemos un primer backup para
              // dejar el Drive sincronizado.
              await _uploadNow();
            }
          },
        ),
        Divider(height: 1, indent: 16, endIndent: 16, color: theme.dividerColor),
        ListTile(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          shape: RoundedRectangleBorder(borderRadius: AppTheme.r16),
          leading: const _IconBadge(
            icon: Icons.cloud_upload_rounded,
            color: AppTheme.colorPrimary,
          ),
          title: const _Title('Subir backup ahora'),
          subtitle: const _Subtitle('Sobrescribe la copia en tu Drive'),
          trailing: _busy
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Icon(Icons.chevron_right_rounded,
                  color: theme.textTheme.bodyMedium?.color),
          onTap: _uploadNow,
        ),
        Divider(height: 1, indent: 16, endIndent: 16, color: theme.dividerColor),
        ListTile(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          shape: RoundedRectangleBorder(borderRadius: AppTheme.r16),
          leading: const _IconBadge(
            icon: Icons.cloud_download_rounded,
            color: AppTheme.colorDanger,
          ),
          title: const _Title('Restaurar desde Drive'),
          subtitle: const _Subtitle('Reemplaza tus datos con la copia en la nube'),
          trailing: Icon(Icons.chevron_right_rounded,
              color: theme.textTheme.bodyMedium?.color),
          onTap: _busy ? null : _restoreFromCloud,
        ),
      ],
    );
  }
}

// ─── Account Tile ─────────────────────────────────────────────────────────────

/// Muestra el usuario logueado (avatar + nombre + email) y un botón
/// "Cerrar sesión" que vuelve al LoginPage. Si no hay user, ofrece
/// loguear con Google directamente desde Settings.
class _AccountTile extends ConsumerWidget {
  const _AccountTile();

  Future<void> _confirmLogout(BuildContext context, WidgetRef ref) async {
    final ok = await showAnotaloConfirm(
      context: context,
      title: 'Cerrar sesión',
      body:
          'Tus datos quedan en este dispositivo. Podés volver a entrar con la misma cuenta cuando quieras.',
      confirmLabel: 'Cerrar sesión',
      danger: true,
      icon: Icons.logout_rounded,
    );
    if (!ok) return;
    await AuthService.instance.signOut();
    if (!context.mounted) return;
    GoRouter.of(context).go('/login');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final userAsync = ref.watch(authStateProvider);
    final user = userAsync.valueOrNull;

    if (user == null) {
      // Sesión local — ofrecer iniciar sesión.
      return ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        shape: RoundedRectangleBorder(borderRadius: AppTheme.r16),
        leading: const _IconBadge(
          icon: Icons.login_rounded,
          color: AppTheme.colorPrimary,
        ),
        title: const _Title('Iniciar sesión con Google'),
        subtitle: const _Subtitle('Sin sesión — tus datos están solo en este teléfono'),
        trailing: Icon(Icons.chevron_right_rounded,
            color: theme.textTheme.bodyMedium?.color),
        onTap: () => GoRouter.of(context).go('/login'),
      );
    }

    final photo = user.photoURL;
    final name = user.displayName ?? user.email ?? 'Usuario';
    final email = user.email ?? '';

    return Column(
      children: [
        ListTile(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          shape: RoundedRectangleBorder(borderRadius: AppTheme.r16),
          leading: photo != null
              ? CircleAvatar(
                  radius: 18,
                  backgroundImage: NetworkImage(photo),
                  backgroundColor: theme.dividerColor,
                )
              : const _IconBadge(
                  icon: Icons.person_rounded,
                  color: AppTheme.colorPrimary,
                ),
          title: _Title(name),
          subtitle: email.isNotEmpty ? _Subtitle(email) : null,
        ),
        Divider(height: 1, indent: 16, endIndent: 16, color: theme.dividerColor),
        ListTile(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          leading: const Icon(Icons.logout_rounded,
              size: 20, color: AppTheme.colorDanger),
          title: Text(
            'Cerrar sesión',
            style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppTheme.colorDanger),
          ),
          onTap: () => _confirmLogout(context, ref),
        ),
      ],
    );
  }
}

// ─── Remind Before Tile ───────────────────────────────────────────────────────

class _RemindBeforeTile extends ConsumerWidget {
  const _RemindBeforeTile();

  static const _options = [0, 5, 15, 30];

  String _label(int m) => m == 0 ? 'Al horario exacto' : '$m min antes';

  Future<void> _pick(BuildContext context, WidgetRef ref, int current) async {
    final picked = await showModalBottomSheet<int>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        decoration: BoxDecoration(
          color: ctx.surfaceSheet,
          borderRadius:
              const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 14),
                decoration: BoxDecoration(
                  color: ctx.dividerColor,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),
            Text('Avisar antes',
                style: GoogleFonts.fraunces(
                    fontSize: 18, fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            for (final m in _options)
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(
                  m == current
                      ? Icons.radio_button_checked_rounded
                      : Icons.radio_button_off_rounded,
                  color: m == current
                      ? AppTheme.colorPrimary
                      : ctx.textTertiary,
                ),
                title: Text(_label(m),
                    style: GoogleFonts.inter(
                        fontSize: 14, fontWeight: FontWeight.w500)),
                onTap: () => Navigator.pop(ctx, m),
              ),
          ],
        ),
      ),
    );
    if (picked != null) {
      await ref.read(userPrefsProvider.notifier).setRemindBeforeMinutes(picked);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final mins =
        ref.watch(userPrefsProvider.select((p) => p.remindBeforeMinutes));
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: const Icon(Icons.alarm_rounded, size: 20),
      title: Text(
        'Avisar antes',
        style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: theme.colorScheme.onSurface),
      ),
      subtitle: const _Subtitle('Aplica a tareas con horario asignado'),
      trailing: Text(
        _label(mins),
        style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppTheme.colorPrimary),
      ),
      onTap: () => _pick(context, ref, mins),
    );
  }
}
