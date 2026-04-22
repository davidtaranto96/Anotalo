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
            version: '1.7.0',
            date: 'Abril 2026',
            isLatest: true,
            changes: [
              _Change(icon: Icons.water_drop_rounded, text: 'Rollover automático: las tareas pendientes de días anteriores siguen apareciendo en Hoy hasta que las completes, difieras o borres'),
              _Change(icon: Icons.history_rounded, text: 'Indicador "de ayer" / "de hace N días" en cada tarea arrastrada para que sepas de cuándo viene'),
              _Change(icon: Icons.text_fields_rounded, text: 'Título "¿Qué vas a lograr hoy?" en su propia línea — los iconos arriba ya no lo cortan'),
              _Change(icon: Icons.delete_sweep_rounded, text: 'Áreas built-in (Trabajo, Facultad, Personal, Casa, Salud) ahora se pueden borrar — armá el set que vos uses'),
              _Change(icon: Icons.auto_awesome_rounded, text: 'Crear tarea desde una categoría filtrada la asigna automáticamente a esa área'),
              _Change(icon: Icons.refresh_rounded, text: 'El selector de área en "Nueva tarea" usa la lista en vivo — ves tus áreas editadas/creadas, no las defaults'),
            ],
          ),
          SizedBox(height: 20),
          _VersionEntry(
            version: '1.6.0',
            date: 'Abril 2026',
            changes: [
              _Change(icon: Icons.rate_review_rounded, text: 'Revisión diaria en Hoy — repasá tareas, hábitos, ánimo y cerrá el día con un toque'),
              _Change(icon: Icons.history_rounded, text: 'Historial de revisiones — volvé atrás, editá o borrá revisiones pasadas'),
              _Change(icon: Icons.mood_rounded, text: 'Diario del día: cómo te sentiste, patrones, si fumaste y tomaste medicación'),
              _Change(icon: Icons.lock_rounded, text: 'Al completar la revisión se bloquea — reabrila cuando quieras para editar'),
              _Change(icon: Icons.account_tree_rounded, text: 'Vista "Todo" en árbol — categorías con sus primordiales, importantes y otras'),
              _Change(icon: Icons.push_pin_rounded, text: 'Tareas sin área aparecen en su propia rama "Sin área" al principio del árbol'),
              _Change(icon: Icons.palette_rounded, text: 'Áreas editables — creá, cambiá nombre/color/emoji y reordená tus categorías'),
              _Change(icon: Icons.add_circle_rounded, text: 'Pestaña "+ Nueva" al final de las áreas para crear categorías al vuelo'),
              _Change(icon: Icons.touch_app_rounded, text: 'Mantené presionada una pestaña de área para editarla directamente'),
              _Change(icon: Icons.drag_handle_rounded, text: 'Arrastrá las áreas en Configuración para ordenarlas como quieras'),
              _Change(icon: Icons.cloud_download_rounded, text: 'Backup automático en Descargas — se guarda solo, restaurar no requiere buscar el archivo'),
              _Change(icon: Icons.folder_open_rounded, text: 'Si no encuentra backup en Descargas, te deja elegir el archivo manualmente'),
              _Change(icon: Icons.format_quote_rounded, text: 'Más de mil frases nuevas — filosóficas, divertidas, que te hacen pensar y te alientan'),
              _Change(icon: Icons.cleaning_services_rounded, text: 'Se sacaron los refranes genéricos — ahora todas las frases tienen peso'),
            ],
          ),
          SizedBox(height: 20),
          _VersionEntry(
            version: '1.5.0',
            date: 'Abril 2026',
            changes: [
              _Change(icon: Icons.palette_rounded, text: 'Tinte del área elegida pinta el fondo de Hoy — pestañas siempre visibles con su color'),
              _Change(icon: Icons.swipe_rounded, text: 'Swipe en tareas y hábitos: derecha = completar, izquierda = posponer + editar + borrar'),
              _Change(icon: Icons.schedule_rounded, text: 'Posponer con presets: mañana, en 2/3 días, sábado, lunes próximo o fecha libre'),
              _Change(icon: Icons.today_rounded, text: 'Botón "Volver a hoy" en Semana cuando navegás otras semanas'),
              _Change(icon: Icons.swipe_left_rounded, text: 'Gesto horizontal en la barra inferior cambia de pestaña'),
              _Change(icon: Icons.check_circle_outline_rounded, text: 'Hábitos redesignados: emoji grande, pill de frecuencia, contador semanal y check grande'),
              _Change(icon: Icons.donut_large_rounded, text: 'Anillo de progreso diario en Hábitos con mensaje motivacional'),
              _Change(icon: Icons.auto_graph_rounded, text: 'Sección Hábitos Atómicos: mejor racha, cumplimiento 30 días, mejor día e identidad'),
              _Change(icon: Icons.dark_mode_rounded, text: 'Reloj del enfoque legible en modo oscuro'),
              _Change(icon: Icons.notifications_active_rounded, text: 'Sonido + vibración triple al terminar sesión de enfoque'),
              _Change(icon: Icons.more_time_rounded, text: 'Diálogo al terminar: completar tarea o sumar +5 / +10 / +15 minutos'),
              _Change(icon: Icons.bug_report_rounded, text: 'Arranque corregido — la app ya no queda trabada en el logo'),
              _Change(icon: Icons.crop_square_rounded, text: 'Formulario de Nuevo hábito sin overflow del teclado'),
              _Change(icon: Icons.cloud_sync_rounded, text: 'Respaldo automático de Android — tus datos sobreviven a cada actualización del Play Store'),
              _Change(icon: Icons.backup_rounded, text: 'Backup manual en Configuración — exportá todo a JSON y restauralo cuando quieras'),
              _Change(icon: Icons.format_quote_rounded, text: 'Frase motivacional se renueva cada vez que volvés a Hoy — más citas de libros y películas épicas'),
            ],
          ),
          SizedBox(height: 20),
          _VersionEntry(
            version: '1.4.0',
            date: 'Abril 2026',
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
