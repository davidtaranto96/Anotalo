import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:arquitectura_enfoque/core/theme/app_theme.dart';
import 'package:arquitectura_enfoque/core/theme/app_colors.dart';

/// Changelog del sistema 1.6 — timeline vertical con dots, version label en
/// mono, chip "Actual" en la última versión y kind-chips (Nuevo/Mejora/Fix)
/// por item.
class NovedadesPage extends StatelessWidget {
  const NovedadesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    return Scaffold(
      backgroundColor: context.surfaceBase,
      appBar: AppBar(
        title: Text(
          'Historial',
          style: GoogleFonts.fraunces(
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
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
        children: [
          // Overline + bajada editorial
          Text(
            'NOVEDADES',
            style: GoogleFonts.inter(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: primary,
              letterSpacing: 1.6,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Historial de versiones',
            style: GoogleFonts.fraunces(
              fontSize: 26,
              fontWeight: FontWeight.w600,
              color: context.textPrimary,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Todo lo que fuimos sumando en Apunto, versión por versión.',
            style: GoogleFonts.inter(
              fontSize: 13,
              color: context.textSecondary,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 20),
          // Timeline
          for (var i = 0; i < _releases.length; i++)
            _TimelineEntry(
              release: _releases[i],
              isLast: i == _releases.length - 1,
            ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// DATA
// ═══════════════════════════════════════════════════════════════

enum _ChangeKind { newFeature, improvement, fix }

class _ChangelogItem {
  final _ChangeKind kind;
  final IconData icon;
  final String text;
  const _ChangelogItem(this.kind, this.icon, this.text);
}

class _Release {
  final String version;
  final String date;
  final bool isLatest;
  final String? title;
  final List<_ChangelogItem> items;
  const _Release({
    required this.version,
    required this.date,
    this.isLatest = false,
    this.title,
    required this.items,
  });
}

const _nf = _ChangeKind.newFeature;
const _mj = _ChangeKind.improvement;
const _fx = _ChangeKind.fix;

const List<_Release> _releases = [
  _Release(
    version: '1.11.0',
    date: 'Abril 2026',
    isLatest: true,
    title: 'Recordatorios reales, saludo personal y onboarding ampliado',
    items: [
      _ChangelogItem(_nf, Icons.notifications_active_rounded,
          'Recordatorios de tareas funcionando: si le ponés horario a una tarea, ahora SÍ te avisa con notificación al horario exacto. Antes el chip era decorativo.'),
      _ChangelogItem(_nf, Icons.alarm_rounded,
          'Toggle "Avisar antes" en Configuración → Notificaciones. Elegí entre "Al horario exacto", "5 / 15 / 30 min antes" para todas las tareas.'),
      _ChangelogItem(_nf, Icons.person_rounded,
          'Onboarding pide tu nombre — el header de Hoy ahora te saluda con "Buen día / tardes / noches, [nombre]" según la hora.'),
      _ChangelogItem(_nf, Icons.folder_special_rounded,
          'Nuevo paso en el onboarding: anotá hasta 3 proyectos en marcha al arrancar. Quedan listos para sumarles tareas.'),
      _ChangelogItem(_mj, Icons.tune_rounded,
          'Sección "Perfil" nueva en Configuración para editar tu nombre cuando quieras.'),
      _ChangelogItem(_mj, Icons.update_rounded,
          'La versión en Configuración se lee dinámicamente — nunca más queda desactualizada.'),
      _ChangelogItem(_mj, Icons.label_outline_rounded,
          'Sin emojis decorativos en los títulos de Proyectos y Enfoque para que combinen con el resto.'),
      _ChangelogItem(_mj, Icons.cleaning_services_rounded,
          'Áreas elegidas en el onboarding ahora se persisten — la primera queda como categoría default.'),
      _ChangelogItem(_fx, Icons.bug_report_rounded,
          'Limpieza interna: pantalla de revisión vieja borrada (era código muerto que rompía dark mode).'),
    ],
  ),
  _Release(
    version: '1.10.0',
    date: 'Abril 2026',
    title: 'Coherencia visual: Proyectos y Enfoque al estilo Apunto',
    items: [
      _ChangelogItem(_mj, Icons.folder_rounded,
          'Proyectos rediseñados: cards con barra-acento de 3pt y radio chico — misma firma visual que las tareas en Hoy. Avatar circular con la inicial del proyecto en el color elegido.'),
      _ChangelogItem(_mj, Icons.label_important_rounded,
          'Tags de categoría con color: Profesional / Personal / Salud / Estudio / Viaje cada uno con su tinte. Antes era un chip neutro genérico.'),
      _ChangelogItem(_mj, Icons.circle_rounded,
          'Headers de Proyectos con dot de color por estado (verde activo, amarillo pausado, naranja completado, gris archivado) — más rápido de scanear.'),
      _ChangelogItem(_mj, Icons.task_alt_rounded,
          'Las tareas dentro de un proyecto ahora se ven igual que las de Hoy: barra-acento de prioridad + checkbox del color del área. Antes eran rows planos sin jerarquía.'),
      _ChangelogItem(_fx, Icons.bug_report_rounded,
          'Fix Enfoque: el selector de tareas ya no se traba — antes la lista overflowea fuera del modal y no podías tocar las opciones.'),
      _ChangelogItem(_mj, Icons.timer_rounded,
          'Enfoque rediseñado: tarea linkeada con barra-acento por prioridad, modos de timer con bordes redondeados (no más capsules), botón Stop circular emparejado con el Play.'),
      _ChangelogItem(_mj, Icons.bolt_rounded,
          'Pill compacto de "X sesiones" en el header de Enfoque — antes era texto suelto que rompía la línea.'),
      _ChangelogItem(_mj, Icons.dark_mode_rounded,
          'Dark mode arreglado en Proyectos y Enfoque: las sheets y selectores ahora usan los tokens de tema en vez de colores hardcoded.'),
      _ChangelogItem(_mj, Icons.compress_rounded,
          'Metas primordiales en Calendario más compactas — checkbox 18×18, font 13, padding chico. Misma densidad que las tareas para que la vista no se rompa al expandir.'),
    ],
  ),
  _Release(
    version: '1.9.0',
    date: 'Abril 2026',
    title: 'Calendario unificado: Semana y Mes en una sola pestaña',
    items: [
      _ChangelogItem(_mj, Icons.merge_type_rounded,
          'Tabs Semana y Mes fusionadas en una sola "Calendario". Toggle entre vistas con swipe vertical sobre el calendario — al hacer swipe-up se colapsa a 1 semana, swipe-down expande a mes.'),
      _ChangelogItem(_nf, Icons.view_week_rounded,
          'Modo semana con cards estilo días separados (LUN/20, MAR/21…), counts X/N y dot verde si todo se completó. Reemplazó las barras horizontales en este formato.'),
      _ChangelogItem(_nf, Icons.star_rounded,
          'Mini-estrella en cada lunes del mes — tap para abrir las metas primordiales de esa semana. En modo semana hay un botón "Lo primordial de la semana" más visible.'),
      _ChangelogItem(_nf, Icons.checklist_rounded,
          'Metas primordiales de la semana: agregar/marcar/borrar desde un bottom sheet. Se persiste por semana (compartido con la pantalla Semana original que ya no existe).'),
      _ChangelogItem(_nf, Icons.task_alt_rounded,
          'Sección "Completadas" colapsable en el día seleccionado del calendario — antes se mezclaban con las pendientes.'),
      _ChangelogItem(_nf, Icons.drag_indicator_rounded,
          'Drag handle ≡ visible en cada tarea del día — tap-y-arrastrar para reordenar. El cuerpo de la card sigue arrastrable a otro día con long-press.'),
      _ChangelogItem(_mj, Icons.swap_horiz_rounded,
          'Drag-and-drop entre días en modo semana también: soltá una tarea sobre otro día-card y se reasigna.'),
    ],
  ),
  _Release(
    version: '1.8.1',
    date: 'Abril 2026',
    title: 'Pulido: gestos, vista mensual y proyectos sin fecha',
    items: [
      _ChangelogItem(_nf, Icons.calendar_view_month_rounded,
          'Vista mensual estilo Samsung Calendar: barras horizontales por prioridad debajo de cada día. Swipe-up colapsa a 1 semana, swipe-down expande a mes. Tap en día → tareas inline abajo.'),
      _ChangelogItem(_nf, Icons.swipe_left_rounded,
          'Deslizar una tarea más del 50% del ancho la completa automáticamente — antes había que tocar "Completar".'),
      _ChangelogItem(_mj, Icons.swipe_rounded,
          'Acciones por swipe ahora son sólo iconos (sin texto cortado): ✓ completar, ✏️ editar, ⏰ diferir, 🗑 borrar.'),
      _ChangelogItem(_nf, Icons.compress_rounded,
          'Cards de tareas más compactas — saqué los botones inline (Completar/Diferir/✕) porque ya están en el swipe. Más tareas visibles sin scrollear.'),
      _ChangelogItem(_nf, Icons.swap_vert_rounded,
          'Reordenar tareas con long-press en Hoy y Semana: mantené apretada una tarea pendiente y arrastrala arriba o abajo.'),
      _ChangelogItem(_nf, Icons.folder_open_rounded,
          'Tareas creadas dentro de un proyecto NO se asignan a un día por default — quedan "sin programar". Sólo aparecen en Hoy/Semana/Mes si les ponés vencimiento explícito.'),
      _ChangelogItem(_mj, Icons.expand_more_rounded,
          'Sección "Proyectos activos" en Hoy: ahora va abajo de hábitos y se despliega inline. Cada tarea del proyecto tiene checkbox para marcar completa sin salir de Hoy.'),
      _ChangelogItem(_mj, Icons.text_fields_rounded,
          'Título "Agregar tarea" en Semana se mueve arriba de la lista (entre el calendario y las tareas) — más accesible.'),
      _ChangelogItem(_fx, Icons.bug_report_rounded,
          'Fix crítico: ya no crashea Hoy con "_debugRelayoutBoundary..." al renderizar tareas (incompatibilidad entre LayoutBuilder e IntrinsicHeight).'),
      _ChangelogItem(_fx, Icons.touch_app_rounded,
          'Fix: long-press en una tarea ahora SÍ inicia el reorder (antes lo capturaba el editor).'),
      _ChangelogItem(_fx, Icons.visibility_rounded,
          'Fix: hábitos con frecuencia "X veces / semana" ahora se ven en Hoy con su contador "X/N".'),
    ],
  ),
  _Release(
    version: '1.8.0',
    date: 'Abril 2026',
    title: 'Apunto: vista mensual + drag + hábitos N/sem',
    items: [
      _ChangelogItem(_nf, Icons.calendar_month_rounded,
          'Vista mensual nueva: calendario con dots por prioridad por día y bottom sheet con las tareas agrupadas por área al tocar cualquier día.'),
      _ChangelogItem(_nf, Icons.drag_indicator_rounded,
          'Mové tareas entre días con long-press: arrastrá una tarea desde el día A y suéltala en otra celda del mes — se reasigna sola.'),
      _ChangelogItem(_nf, Icons.bar_chart_rounded,
          'Valoración del mes: completado vs pendiente, ratio por área, hábitos cumplidos %, mejor día y lo que te queda hacer.'),
      _ChangelogItem(_nf, Icons.repeat_rounded,
          'Hábitos editables con frecuencia "X veces por semana" (1-7, lunes a domingo). El contador "X/N esta semana" se vuelve verde al cumplir.'),
      _ChangelogItem(_nf, Icons.swap_vert_rounded,
          'Reordená proyectos, hábitos y tareas con long-press: arrastrá arriba o abajo y queda guardado.'),
      _ChangelogItem(_nf, Icons.brush_rounded,
          'Pencil-stroke con confirmación: arrastrá horizontal sobre el título de una tarea pendiente, aparece un botón "Confirmar" — la tarea no se completa hasta tocarlo.'),
      _ChangelogItem(_nf, Icons.folder_special_rounded,
          'Sección "Proyectos activos" en Hoy: las tareas de proyectos ya no se mezclan con las sueltas. Cada proyecto se muestra colapsado con su próxima tarea.'),
      _ChangelogItem(_mj, Icons.label_rounded,
          'Renombré la app a "Apunto" — más corto, más directo.'),
      _ChangelogItem(_mj, Icons.swipe_rounded,
          'Swipe en Semana: ahora se ve solo el icono (sin texto cortado) en cards angostas.'),
      _ChangelogItem(_mj, Icons.format_size_rounded,
          'Toggle nuevo en Configuración: "Agrandar tareas viejas" — el título crece y se vuelve más negrita con el paso de los días.'),
    ],
  ),
  _Release(
    version: '1.7.0',
    date: 'Abril 2026',
    title: 'Continuidad y contexto',
    items: [
      _ChangelogItem(_nf, Icons.water_drop_rounded,
          'Rollover automático: las tareas pendientes de días anteriores siguen apareciendo en Hoy hasta que las completes, difieras o borres.'),
      _ChangelogItem(_mj, Icons.history_rounded,
          'Indicador "de ayer" / "de hace N días" en cada tarea arrastrada para que sepas de cuándo viene.'),
      _ChangelogItem(_mj, Icons.text_fields_rounded,
          'Título "¿Qué vas a lograr hoy?" en su propia línea — los iconos arriba ya no lo cortan.'),
      _ChangelogItem(_mj, Icons.delete_sweep_rounded,
          'Áreas built-in (Trabajo, Facultad, Personal, Casa, Salud) ahora se pueden borrar — armá el set que vos uses.'),
      _ChangelogItem(_mj, Icons.auto_awesome_rounded,
          'Crear tarea desde una categoría filtrada la asigna automáticamente a esa área.'),
      _ChangelogItem(_fx, Icons.refresh_rounded,
          'El selector de área en "Nueva tarea" usa la lista en vivo — ves tus áreas editadas/creadas, no las defaults.'),
    ],
  ),
  _Release(
    version: '1.6.0',
    date: 'Abril 2026',
    title: 'Color, sonidos y hábitos',
    items: [
      _ChangelogItem(_nf, Icons.rate_review_rounded,
          'Revisión diaria en Hoy — repasá tareas, hábitos, ánimo y cerrá el día con un toque.'),
      _ChangelogItem(_nf, Icons.history_rounded,
          'Historial de revisiones — volvé atrás, editá o borrá revisiones pasadas.'),
      _ChangelogItem(_nf, Icons.mood_rounded,
          'Diario del día: cómo te sentiste, patrones, si fumaste y tomaste medicación.'),
      _ChangelogItem(_mj, Icons.lock_rounded,
          'Al completar la revisión se bloquea — reabrila cuando quieras para editar.'),
      _ChangelogItem(_nf, Icons.account_tree_rounded,
          'Vista "Todo" en árbol — categorías con sus primordiales, importantes y otras.'),
      _ChangelogItem(_mj, Icons.push_pin_rounded,
          'Tareas sin área aparecen en su propia rama "Sin área" al principio del árbol.'),
      _ChangelogItem(_nf, Icons.palette_rounded,
          'Áreas editables — creá, cambiá nombre/color/emoji y reordená tus categorías.'),
      _ChangelogItem(_mj, Icons.add_circle_rounded,
          'Pestaña "+ Nueva" al final de las áreas para crear categorías al vuelo.'),
      _ChangelogItem(_mj, Icons.touch_app_rounded,
          'Mantené presionada una pestaña de área para editarla directamente.'),
      _ChangelogItem(_mj, Icons.drag_handle_rounded,
          'Arrastrá las áreas en Configuración para ordenarlas como quieras.'),
      _ChangelogItem(_nf, Icons.cloud_download_rounded,
          'Backup automático en Descargas — se guarda solo, restaurar no requiere buscar el archivo.'),
      _ChangelogItem(_mj, Icons.folder_open_rounded,
          'Si no encuentra backup en Descargas, te deja elegir el archivo manualmente.'),
      _ChangelogItem(_nf, Icons.format_quote_rounded,
          'Más de mil frases nuevas — filosóficas, divertidas, que te hacen pensar y te alientan.'),
      _ChangelogItem(_mj, Icons.cleaning_services_rounded,
          'Se sacaron los refranes genéricos — ahora todas las frases tienen peso.'),
    ],
  ),
  _Release(
    version: '1.5.0',
    date: 'Abril 2026',
    title: 'Tinte, swipes y enfoque',
    items: [
      _ChangelogItem(_nf, Icons.palette_rounded,
          'Tinte del área elegida pinta el fondo de Hoy — pestañas siempre visibles con su color.'),
      _ChangelogItem(_nf, Icons.swipe_rounded,
          'Swipe en tareas y hábitos: derecha = completar, izquierda = posponer + editar + borrar.'),
      _ChangelogItem(_mj, Icons.schedule_rounded,
          'Posponer con presets: mañana, en 2/3 días, sábado, lunes próximo o fecha libre.'),
      _ChangelogItem(_mj, Icons.today_rounded,
          'Botón "Volver a hoy" en Semana cuando navegás otras semanas.'),
      _ChangelogItem(_mj, Icons.swipe_left_rounded,
          'Gesto horizontal en la barra inferior cambia de pestaña.'),
      _ChangelogItem(_nf, Icons.check_circle_outline_rounded,
          'Hábitos redesignados: emoji grande, pill de frecuencia, contador semanal y check grande.'),
      _ChangelogItem(_nf, Icons.donut_large_rounded,
          'Anillo de progreso diario en Hábitos con mensaje motivacional.'),
      _ChangelogItem(_nf, Icons.auto_graph_rounded,
          'Sección Hábitos Atómicos: mejor racha, cumplimiento 30 días, mejor día e identidad.'),
      _ChangelogItem(_fx, Icons.dark_mode_rounded,
          'Reloj del enfoque legible en modo oscuro.'),
      _ChangelogItem(_nf, Icons.notifications_active_rounded,
          'Sonido + vibración triple al terminar sesión de enfoque.'),
      _ChangelogItem(_nf, Icons.more_time_rounded,
          'Diálogo al terminar: completar tarea o sumar +5 / +10 / +15 minutos.'),
      _ChangelogItem(_fx, Icons.bug_report_rounded,
          'Arranque corregido — la app ya no queda trabada en el logo.'),
      _ChangelogItem(_fx, Icons.crop_square_rounded,
          'Formulario de Nuevo hábito sin overflow del teclado.'),
      _ChangelogItem(_nf, Icons.cloud_sync_rounded,
          'Respaldo automático de Android — tus datos sobreviven a cada actualización del Play Store.'),
      _ChangelogItem(_nf, Icons.backup_rounded,
          'Backup manual en Configuración — exportá todo a JSON y restauralo cuando quieras.'),
      _ChangelogItem(_mj, Icons.format_quote_rounded,
          'Frase motivacional se renueva cada vez que volvés a Hoy — más citas de libros y películas épicas.'),
    ],
  ),
  _Release(
    version: '1.4.0',
    date: 'Abril 2026',
    title: 'Gestos e integración',
    items: [
      _ChangelogItem(_nf, Icons.swipe_rounded,
          'Navegación con PageView real — indicador deslizante sigue el dedo.'),
      _ChangelogItem(_mj, Icons.expand_rounded,
          'Completadas colapsables en Hoy — menos ruido visual.'),
      _ChangelogItem(_mj, Icons.undo_rounded,
          'Deshacer completación — deslizá o mantené presionado la tarea.'),
      _ChangelogItem(_mj, Icons.folder_open_rounded,
          'Proyectos en Semana separados de las tareas del día.'),
      _ChangelogItem(_nf, Icons.add_task_rounded,
          'Nueva tarea inteligente con voz, área, prioridad y recordatorio.'),
    ],
  ),
  _Release(
    version: '1.3.0',
    date: 'Abril 2026',
    title: 'Áreas y recordatorios',
    items: [
      _ChangelogItem(_mj, Icons.tab_rounded,
          'Tabs de área con colores mejorados — visibles en modo oscuro.'),
      _ChangelogItem(_nf, Icons.alarm_rounded, 'Recordatorios en nueva tarea.'),
      _ChangelogItem(_mj, Icons.view_week_rounded, 'Semana más limpia y enfocada.'),
      _ChangelogItem(_nf, Icons.new_releases_rounded, 'Pantalla de Novedades.'),
    ],
  ),
  _Release(
    version: '1.2.0',
    date: 'Abril 2026',
    title: 'Modo oscuro + voz',
    items: [
      _ChangelogItem(_nf, Icons.dark_mode_rounded,
          'Modo oscuro funcionando en todas las pantallas.'),
      _ChangelogItem(_nf, Icons.swipe_rounded,
          'Deslizá entre pestañas como en Instagram.'),
      _ChangelogItem(_nf, Icons.mic_rounded,
          'Entrada por voz en nueva tarea — hablá y lo procesa.'),
      _ChangelogItem(_nf, Icons.workspaces_rounded,
          'Áreas: Trabajo, Facultad, Personal, Casa, Salud.'),
    ],
  ),
  _Release(
    version: '1.1.0',
    date: 'Marzo 2026',
    title: 'Semana y citas',
    items: [
      _ChangelogItem(_mj, Icons.check_circle_rounded, 'Deshacer completación de tareas.'),
      _ChangelogItem(_mj, Icons.drag_indicator_rounded, 'Barra de progreso fija arriba de Hoy.'),
      _ChangelogItem(_nf, Icons.format_quote_rounded,
          'Frases motivacionales de figuras históricas.'),
      _ChangelogItem(_nf, Icons.calendar_view_week_rounded,
          'Semana con pills de días y navegación.'),
      _ChangelogItem(_nf, Icons.flag_rounded, 'Metas semanales completables.'),
    ],
  ),
  _Release(
    version: '1.0.0',
    date: 'Marzo 2026',
    title: 'Lanzamiento',
    items: [
      _ChangelogItem(_nf, Icons.rocket_launch_rounded,
          'Lanzamiento inicial de Apunto.'),
      _ChangelogItem(_nf, Icons.task_alt_rounded,
          'Gestión de tareas con prioridades.'),
      _ChangelogItem(_nf, Icons.folder_rounded, 'Proyectos con progreso y colores.'),
      _ChangelogItem(_nf, Icons.loop_rounded, 'Hábitos con racha diaria.'),
      _ChangelogItem(_nf, Icons.timer_rounded, 'Timer Pomodoro con modos de enfoque.'),
    ],
  ),
];

// ═══════════════════════════════════════════════════════════════
// UI
// ═══════════════════════════════════════════════════════════════

class _TimelineEntry extends StatelessWidget {
  final _Release release;
  final bool isLast;

  const _TimelineEntry({required this.release, required this.isLast});

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final onSurface = Theme.of(context).colorScheme.onSurface;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Rail vertical + dot
          SizedBox(
            width: 24,
            child: Column(
              children: [
                const SizedBox(height: 6),
                _TimelineDot(active: release.isLatest, color: primary),
                Expanded(
                  child: Container(
                    width: 1.5,
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    color: isLast
                        ? Colors.transparent
                        : context.dividerColor,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          // Columna del contenido
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Fila versión + chip Actual + fecha
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'v${release.version}',
                        style: GoogleFonts.jetBrainsMono(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: onSurface,
                          letterSpacing: -0.2,
                        ),
                      ),
                      if (release.isLatest) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: primary,
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            'Actual',
                            style: GoogleFonts.inter(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              letterSpacing: 0.4,
                            ),
                          ),
                        ),
                      ],
                      const Spacer(),
                      Text(
                        release.date,
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          color: context.textTertiary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  if (release.title != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      release.title!,
                      style: GoogleFonts.fraunces(
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                        color: onSurface,
                        letterSpacing: -0.2,
                      ),
                    ),
                  ],
                  const SizedBox(height: 10),
                  // Card con los items
                  Container(
                    decoration: BoxDecoration(
                      color: context.surfaceCard,
                      borderRadius: AppTheme.r12,
                      border: Border.all(
                        color: release.isLatest
                            ? primary.withValues(alpha: 0.5)
                            : context.dividerColor,
                        width: release.isLatest ? 1.2 : 1,
                      ),
                      boxShadow: release.isLatest
                          ? AppTheme.shadowMd
                          : AppTheme.shadowSm,
                    ),
                    child: Column(
                      children: [
                        for (var i = 0; i < release.items.length; i++) ...[
                          _ItemRow(item: release.items[i]),
                          if (i != release.items.length - 1)
                            Divider(
                              height: 1,
                              thickness: 1,
                              indent: 14,
                              endIndent: 14,
                              color: context.dividerColor.withValues(alpha: 0.6),
                            ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TimelineDot extends StatelessWidget {
  final bool active;
  final Color color;
  const _TimelineDot({required this.active, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 14,
      height: 14,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: active ? color : Colors.transparent,
        border: Border.all(
          color: active ? color : context.dividerColor,
          width: active ? 1.5 : 1.5,
        ),
        boxShadow: active
            ? [
                BoxShadow(
                  color: color.withValues(alpha: 0.45),
                  blurRadius: 0,
                  spreadRadius: 3,
                ),
              ]
            : null,
      ),
    );
  }
}

class _ItemRow extends StatelessWidget {
  final _ChangelogItem item;
  const _ItemRow({required this.item});

  @override
  Widget build(BuildContext context) {
    final (chipColor, chipLabel) = switch (item.kind) {
      _ChangeKind.newFeature => (
          Theme.of(context).colorScheme.primary,
          'Nuevo',
        ),
      _ChangeKind.improvement => (AppTheme.colorSuccess, 'Mejora'),
      _ChangeKind.fix => (AppTheme.colorWarning, 'Fix'),
    };

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: chipColor.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(item.icon, size: 16, color: chipColor),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // chip de tipo
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 7, vertical: 1),
                  decoration: BoxDecoration(
                    color: chipColor.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    chipLabel,
                    style: GoogleFonts.inter(
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      color: chipColor,
                      letterSpacing: 0.6,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item.text,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: context.textPrimary,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
