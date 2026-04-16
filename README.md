# Anotalo — App de Productividad Personal (Flutter)

App Android de productividad personal inspirada en GTD + Pomodoro. Paleta terracota/crema cálida, diseño light-mode-first basado en la estética de Claude.

**Versión actual: 1.6.0** | **Build: debug APK** | **Target: Android 21+**

---

## Estado actual del proyecto

### ✅ Funcionalidades completadas (v1.6.0)

| Feature | Descripción |
|---------|-------------|
| **Tab Hoy** | Vista diaria por prioridad GTD (primordial/importante/puede esperar). Árbol por área cuando se elige "Todo". Frases motivacionales rotativas (+1000). |
| **Tab Semana** | Grid 7 días con contadores de tareas por prioridad. Filtros: Todo / Primordial / Importante / Puede Esperar. Botón "Volver a hoy". |
| **Tab Proyectos** | Lista de proyectos con % completado, estado y categoría. Modal de detalle con tareas vinculadas y metas semanales. |
| **Tab Hábitos** | Tracker con streaks, anillo de progreso, heatmap 7 semanas. Sección "Hábitos Atómicos" con métricas. |
| **Tab Enfoque** | Timer Pomodoro con 7 modos, arco CustomPainter, sonido+vibración triple al terminar. Diálogo para sumar tiempo o completar tarea. |
| **Inbox** | Captura rápida con voz (speech_to_text) y texto. Procesamiento: convertir nota a tarea. |
| **Revisión** | Revisión diaria con mood (1-5), diario, estado de hábitos y tareas. Historial de revisiones editables. |
| **Áreas editables** | CRUD de áreas (nombre, emoji, color). 5 builtin + personalizadas. Drag para reordenar. Long-press en pestaña para editar. |
| **Backup** | Exportar/importar JSON. Auto-save a carpeta Descargas. Respaldo Android automático. |
| **Swipe gestures** | Deslizar tareas/hábitos: derecha = completar, izquierda = diferir + editar + borrar. |
| **Posponer** | Presets: mañana, 2/3 días, sábado, lunes próximo, fecha libre. |
| **Notificaciones** | Recordatorios locales por tarea + recordatorio diario configurable. |
| **Modo oscuro** | Toggle en Configuración. Paleta cálida en ambos modos. |

### 🔜 Pendiente

- Dashboard de analytics semanal (tareas completadas, minutos de foco, rachas) — `fl_chart` ya importado
- HapticFeedback completo en todas las interacciones (parcial)
- Drag & drop real en Semana para reasignar tareas a otro día
- `dart analyze` → 0 errores/warnings antes de release
- FAB long-press → QuickCapture universal en todas las tabs

---

## Historial de versiones

### v1.6.0 (Abril 2026) — commit `e711ff8`
- Revisión diaria: repasá tareas, hábitos, ánimo y cerrá el día
- Historial de revisiones: editá o borrá revisiones pasadas
- Diario del día: estado de ánimo, patrones, medicación
- Vista "Todo" en árbol por área con rama "Sin área" al principio
- Áreas editables: creá, renombrá, cambiá color/emoji, reordená
- Pestaña "+ Nueva" para crear áreas al vuelo; long-press para editar
- Backup en Descargas: se guarda solo, restaurar sin buscar archivo
- Más de 1000 frases nuevas filosóficas, divertidas y motivacionales
- **DB schema v2**: nuevas tablas `TaskAreasTable` y `DailyReviewsTable`

### v1.5.0 (Abril 2026) — incluido en commit `e711ff8`
- Tinte del área elegida pinta el fondo de Hoy
- Swipe en tareas y hábitos: derecha = completar, izquierda = posponer/editar/borrar
- Posponer con presets (mañana, sábado, lunes, etc.)
- Hábitos rediseñados: emoji grande, anillo de progreso, sección Hábitos Atómicos
- Timer: sonido + vibración triple al terminar, diálogo para completar o sumar tiempo
- Backup manual en Configuración + auto backup Android
- Frases motivacionales actualizadas

### v1.4.0 (Abril 2026) — commit `3b86fc4`
- Navegación con PageView real
- Completadas colapsables en Hoy
- Deshacer completación (swipe o long-press)
- Proyectos separados de tareas del día en Semana
- Nueva tarea inteligente con voz, área, prioridad y recordatorio

### v1.3.0 / v1.2.0 / v1.1.0 / v1.0.0 (Marzo-Abril 2026)
- Modos oscuro/claro, tabs con colores, swipe entre pestañas
- Recordatorios en nueva tarea, Novedades
- Entrada por voz, áreas (Trabajo/Facultad/Personal/Casa/Salud)
- Lanzamiento inicial: tareas, proyectos, hábitos, timer

---

## Stack técnico

| Capa | Tecnología |
|------|-----------|
| Framework | Flutter 3.41.6 / Dart 3.11.4 |
| State | Riverpod 2.5.1 (StreamProviders) |
| Routing | GoRouter 13.2.0 |
| DB | Drift 2.18.0 / SQLite, 11 tablas, schema v2 |
| Fuentes | Inter (body) + Lora (títulos) — Google Fonts |
| Target | Android minSdk 21 / targetSdk 34 |
| Device | Samsung S25+ (SM-S936B), serial `R5CXC3MN44T` |

---

## Estructura del proyecto

```
lib/
├── main.dart                              # Entry — intl ES, orientation lock
├── app/app.dart                           # MaterialApp.router + tema
├── core/
│   ├── theme/app_theme.dart               # Design tokens (colores, spacing, radii)
│   ├── theme/app_colors.dart              # BuildContext extension light/dark
│   ├── database/
│   │   ├── app_database.dart              # @DriftDatabase, schema v2, migraciones
│   │   ├── app_database.g.dart            # GENERADO por build_runner (no editar)
│   │   ├── database_providers.dart        # Singleton DB provider
│   │   └── tables/                        # 11 tablas Drift
│   ├── router/app_router.dart             # GoRouter — 5 tabs + 8 rutas standalone
│   ├── shell/app_shell.dart               # PageView + NavBar + FAB morfable
│   ├── models/task_area.dart              # TaskArea model + kBuiltinAreas
│   ├── providers/                         # shell, theme, backup, task_area
│   ├── logic/                             # Services CRUD (task, habit, project, etc.)
│   └── widgets/                           # FAB, voice input, defer picker
└── features/
    ├── hoy/           # Tab 0 — tareas del día por prioridad
    ├── semana/        # Tab 1 — grid semanal 7 días
    ├── proyectos/     # Tab 2 — gestión de proyectos
    ├── habitos/       # Tab 3 — tracker con streaks + heatmap
    ├── enfoque/       # Tab 4 — Pomodoro timer
    ├── inbox/         # Ruta /inbox — captura rápida
    ├── revision/      # Rutas /revision /review /review-history
    ├── settings/      # Ruta /settings + /manage-areas
    └── novedades/     # Ruta /novedades — changelog
```

---

## Base de datos (11 tablas Drift, schema v2)

| Tabla | Campos clave |
|-------|-------------|
| TasksTable | id, title, priority, status, area, dayId, parentProjectId, deferredTo, reminderTime |
| HabitsTable | id, title, frequency (daily/weekly), area, color, icon, isArchived |
| HabitCompletionsTable | habitId, dayId, completedAt |
| ProjectsTable | id, title, category, status, color, taskIds (JSON), weeklyGoals (JSON) |
| QuickNotesTable | id, content, type, isProcessed |
| JournalEntriesTable | id, dayId, reflection, mood (1-5), gratitude, lessonsLearned |
| WeeklyPlansTable | id (week-YYYY-WW), primordialGoals (JSON), achievements (JSON) |
| WeekDaysTable | dayId (PK), weekId, signalTaskIds (JSON), noiseTaskIds (JSON) |
| TimerSessionsTable | id, mode, taskId, durationSecs, wasCompleted, startedAt |
| **TaskAreasTable** *(v2)* | id, label, emoji, colorHex, iconName, sortOrder, isBuiltin |
| **DailyReviewsTable** *(v2)* | id, dayId (UNIQUE), completionRate, mood, reflectionNotes |

**Migración**: v1→v2 agrega TaskAreasTable + DailyReviewsTable. El hook `beforeOpen` re-siembra las 5 áreas builtin si la tabla está vacía.

---

## Design System (light mode — paleta terracota)

```dart
// Backgrounds
surfaceBase      = Color(0xFFF4F3EE)  // crema cálido — fondo de TODOS los Scaffold
surfaceCard      = Color(0xFFFFFFFF)  // blanco — cards
surfaceElevated  = Color(0xFFEDE9E3)  // crema oscuro
surfaceSheet     = Color(0xFFFAFAF7)  // bottom sheets

// Colores principales
colorPrimary     = Color(0xFFC15F3C)  // terracota — FAB, CTAs, acciones primarias
colorAccent      = Color(0xFFD97757)  // coral — links, secundario
colorSuccess     = Color(0xFF5B8A5E)  // verde musgo
colorWarning     = Color(0xFFC4963A)  // ámbar cálido
colorDanger      = Color(0xFFC44B4B)  // rojo suave

// Texto
textPrimary      = Color(0xFF1A1A1A)
textSecondary    = Color(0xFF6B6560)
textTertiary     = Color(0xFF9C9590)
```

**Tipografía**: `GoogleFonts.inter()` (body/labels) + `GoogleFonts.lora()` (solo títulos de página).  
**Spacing**: múltiplos de 4px (xs=4, sm=8, md=12, base=16, lg=20, xl=24, 2xl=32).  
**Radii**: 8 (badges), 12 (botones/inputs), 16 (cards), 20 (sheets), 999 (pills/FAB).

---

## Reglas de diseño (no romper)

1. `surfaceBase (0xFFF4F3EE)` en **todos** los Scaffold — nunca variar por página
2. `GoogleFonts.inter()` para body/labels, `GoogleFonts.lora()` SOLO para títulos de página
3. FAB solo en `AppShell` o páginas standalone — nunca `ScaffoldFAB` en tabs
4. `HapticFeedback` en todas las interacciones (light/medium/heavy según jerarquía)
5. `StreamProvider` para datos Drift — nunca `FutureProvider` para listas mutables
6. `ValueKey` obligatorio en todo `AnimatedSwitcher`
7. `BouncingScrollPhysics` en todos los scrolls
8. No deletes físicos — `status='deleted'` (soft delete, preserva historial)
9. Padding bottom de 120px en todas las páginas (clearance nav + FAB)

---

## Build en Windows

**IMPORTANTE**: Buildear desde terminal con las variables correctas — NO desde Android Studio.

### Build desde bash/terminal
```bash
cd /c/dev/Anotalo
JAVA_HOME="/c/Program Files/Eclipse Adoptium/jdk-17.0.18.8-hotspot" \
TEMP=/c/tmp TMP=/c/tmp \
JAVA_TOOL_OPTIONS="-Djava.io.tmpdir=C:/tmp -Djdk.net.unixDomain.tempDir=C:/tmp" \
flutter build apk --debug
```

### Instalar en dispositivo
```bash
adb -s R5CXC3MN44T install -r build/app/outputs/apk/debug/app-debug.apk
```

### Por qué NO buildear desde Android Studio
Windows usa rutas 8.3 para `%TEMP%` → rompe **Unix Domain Sockets** de Java que usa Gradle internamente.  
**Fix**: `TEMP=C:\tmp` + flags JVM `-Djava.io.tmpdir` + `-Djdk.net.unixDomain.tempDir`.

### Regenerar código Drift (cuando se modifican tablas)
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

---

## Dependencias principales

```yaml
flutter_riverpod: ^2.5.1        # State management
go_router: ^13.2.0              # Routing
drift: ^2.18.0                  # ORM SQLite
sqlite3_flutter_libs: ^0.5.0    # SQLite nativo
google_fonts: ^6.2.1            # Inter + Lora
shared_preferences: ^2.2.3      # Preferencias locales
uuid: ^4.4.0                    # IDs únicos
intl: ^0.19.0                   # Localización ES
flutter_slidable: ^3.1.0        # Cards deslizables
speech_to_text: ^7.0.0          # Entrada por voz
fl_chart: ^0.69.0               # Gráficos (futuro dashboard)
flutter_local_notifications: ^18.0.0  # Notificaciones
share_plus: ^10.0.0             # Compartir exportaciones
file_picker: ^8.1.2             # Importar archivos
permission_handler: ^11.3.0     # Permisos (mic, notif)
```
