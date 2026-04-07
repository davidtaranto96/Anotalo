import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:arquitectura_enfoque/core/theme/app_theme.dart';
import 'package:arquitectura_enfoque/core/theme/app_colors.dart';

class NovedadesPage extends StatelessWidget {
  const NovedadesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.surfaceBase,
      appBar: AppBar(
        title: Text(
          'Novedades',
          style: GoogleFonts.lora(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: context.textPrimary,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        iconTheme: IconThemeData(color: context.textSecondary),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        children: const [
          _VersionEntry(
            version: '1.4.0',
            date: 'Abril 2026',
            isLatest: true,
            changes: [
              _Change(icon: Icons.swipe_rounded, text: 'Navegación con PageView real — indicador deslizante sigue el dedo'),
              _Change(icon: Icons.expand_rounded, text: 'Completadas colapsables en Hoy — menos ruido visual'),
              _Change(icon: Icons.undo_rounded, text: 'Deshacer completación — deslizá o mantené presionado la tarea'),
              _Change(icon: Icons.folder_open_rounded, text: 'Proyectos en Semana separados de las tareas del día'),
              _Change(icon: Icons.add_task_rounded, text: 'Nueva tarea inteligente con voz, área, prioridad y recordatorio'),
            ],
          ),
          SizedBox(height: 20),
          _VersionEntry(
            version: '1.3.0',
            date: 'Abril 2026',
            changes: [
              _Change(icon: Icons.tab_rounded, text: 'Tabs de área con colores mejorados — visibles en modo oscuro'),
              _Change(icon: Icons.alarm_rounded, text: 'Recordatorios en nueva tarea'),
              _Change(icon: Icons.view_week_rounded, text: 'Semana más limpia y enfocada'),
              _Change(icon: Icons.new_releases_rounded, text: 'Pantalla de Novedades'),
            ],
          ),
          SizedBox(height: 20),
          _VersionEntry(
            version: '1.2.0',
            date: 'Abril 2026',
            changes: [
              _Change(icon: Icons.dark_mode_rounded, text: 'Modo oscuro funcionando en todas las pantallas'),
              _Change(icon: Icons.swipe_rounded, text: 'Deslizá entre pestañas como en Instagram'),
              _Change(icon: Icons.mic_rounded, text: 'Entrada por voz en nueva tarea — hablá y lo procesa'),
              _Change(icon: Icons.workspaces_rounded, text: 'Áreas: Trabajo, Facultad, Personal, Casa, Salud'),
            ],
          ),
          SizedBox(height: 20),
          _VersionEntry(
            version: '1.1.0',
            date: 'Marzo 2026',
            changes: [
              _Change(icon: Icons.check_circle_rounded, text: 'Deshacer completación de tareas'),
              _Change(icon: Icons.drag_indicator_rounded, text: 'Barra de progreso fija arriba de Hoy'),
              _Change(icon: Icons.format_quote_rounded, text: 'Frases motivacionales de figuras históricas'),
              _Change(icon: Icons.calendar_view_week_rounded, text: 'Semana con pills de días y navegación'),
              _Change(icon: Icons.flag_rounded, text: 'Metas semanales completables'),
            ],
          ),
          SizedBox(height: 20),
          _VersionEntry(
            version: '1.0.0',
            date: 'Marzo 2026',
            changes: [
              _Change(icon: Icons.rocket_launch_rounded, text: 'Lanzamiento inicial de Anotalo'),
              _Change(icon: Icons.task_alt_rounded, text: 'Gestión de tareas con prioridades'),
              _Change(icon: Icons.folder_rounded, text: 'Proyectos con progreso y colores'),
              _Change(icon: Icons.loop_rounded, text: 'Hábitos con racha diaria'),
              _Change(icon: Icons.timer_rounded, text: 'Timer Pomodoro con modos de enfoque'),
            ],
          ),
          SizedBox(height: 32),
        ],
      ),
    );
  }
}

class _Change {
  final IconData icon;
  final String text;
  const _Change({required this.icon, required this.text});
}

class _VersionEntry extends StatelessWidget {
  final String version;
  final String date;
  final bool isLatest;
  final List<_Change> changes;

  const _VersionEntry({
    required this.version,
    required this.date,
    this.isLatest = false,
    required this.changes,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.surfaceCard,
        borderRadius: AppTheme.r16,
        border: Border.all(
          color: isLatest ? AppTheme.colorPrimary.withAlpha(80) : context.dividerColor,
          width: isLatest ? 1.5 : 1,
        ),
        boxShadow: isLatest ? AppTheme.shadowMd : AppTheme.shadowSm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isLatest
                  ? AppTheme.colorPrimary.withAlpha(12)
                  : context.surfaceElevated.withAlpha(80),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
            ),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'v$version',
                          style: GoogleFonts.lora(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: isLatest ? AppTheme.colorPrimary : context.textPrimary,
                          ),
                        ),
                        if (isLatest) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppTheme.colorPrimary,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              'Actual',
                              style: GoogleFonts.inter(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                letterSpacing: 0.3,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    Text(
                      date,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: context.textTertiary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Changes list
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            child: Column(
              children: changes.map((c) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: AppTheme.colorPrimary.withAlpha(15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(c.icon, size: 15, color: AppTheme.colorPrimary),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          c.text,
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            color: context.textPrimary,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
