# Arquitectura de Enfoque — Flutter App

App personal de productividad y gestión del tiempo para Android. Dark-mode only, basada en la estética de Fint.

---

## Para Claude: Estado del proyecto y contexto técnico

### Stack
- **Flutter 3.41.6** en `C:\flutter\flutter_windows_3.41.6-stable\flutter`
- **Dart** con Riverpod + GoRouter + Drift (SQLite) + Google Fonts (Inter) + intl
- **Android** minSdk 21, targetSdk 34, Android 16 "Baklava" en el dispositivo de prueba
- **Dispositivo de prueba**: Samsung SM-S936B (S25+), serial `R5CXC3MN44T`

### Estructura del proyecto
```
lib/
├── main.dart                          # Entry point
├── app/app.dart                       # MaterialApp + ProviderScope
├── core/
│   ├── theme/app_theme.dart           # Design tokens (colores, radii, tipografía)
│   ├── router/app_router.dart         # GoRouter: 5 tabs + rutas standalone
│   ├── shell/app_shell.dart           # Shell con glassmorphism nav bar
│   ├── providers/shell_providers.dart # Estado del shell (tab activo)
│   ├── widgets/app_fab.dart           # FAB que morfea según el tab
│   ├── database/
│   │   ├── app_database.dart          # @DriftDatabase con todas las tablas
│   │   ├── app_database.g.dart        # GENERADO por build_runner (no editar)
│   │   ├── database_providers.dart    # Provider singleton de DB
│   │   └── tables/                    # Una tabla Drift por entidad
│   ├── logic/                         # Services CRUD (task, habit, project, etc.)
│   └── utils/                         # format_utils, json_utils, area_constants
└── features/
    ├── hoy/                           # Tab "Hoy" — tareas del día por prioridad
    ├── semana/                        # Tab "Semana" — vista semanal
    ├── proyectos/                     # Tab "Proyectos" — gestión de proyectos
    ├── habitos/                       # Tab "Hábitos" — tracker con streaks
    ├── enfoque/                       # Tab "Enfoque" — Pomodoro timer
    ├── inbox/                         # Ruta standalone — quick capture
    └── revision/                      # Ruta standalone — journal + weekly review
```

### Design tokens clave (app_theme.dart)
```dart
colorPrimary    = Color(0xFF7C6EF7)  // violeta
colorAccent     = Color(0xFF5ECFB1)  // verde menta
colorDanger     = Color(0xFFFF5C6E)
surfaceBase     = Color(0xFF1E1E2C)  // fondo de TODOS los Scaffold
surfaceCard     = Color(0xFF242740)  // cards
surfaceElevated = Color(0xFF2E3253)
surfaceSheet    = Color(0xFF18181F)  // bottom sheets
```
Fuente única: `GoogleFonts.inter()`. Border radius scale: 32/24/20/16/12/8/4.

### Reglas críticas (no romper)
1. `Color(0xFF1E1E2C)` en **todos** los Scaffold — nunca variar por página
2. Solo `GoogleFonts.inter()` — ninguna otra fuente
3. FAB solo en `AppShell` o páginas standalone — nunca ScaffoldFAB en páginas de tabs
4. `HapticFeedback` en **todas** las interacciones (selection/light/medium/heavy según jerarquía)
5. `StreamProvider` para datos Drift — nunca `FutureProvider` para listas mutables
6. `ValueKey` obligatorio en todo `AnimatedSwitcher`
7. `BouncingScrollPhysics` en todos los scrolls
8. `navigateToTabProvider` para navegación cross-tab — nunca `context.go` directo

### Tablas Drift
| Tabla | Campos clave |
|-------|-------------|
| TasksTable | id, title, priority (primordial/importante/puede_esperar/ruido), status, area, dayId, parentProjectId |
| HabitsTable | id, title, frequency (daily/weekly), area, color, isArchived |
| HabitCompletionsTable | habitId, dayId, completedAt |
| ProjectsTable | id, title, category, status, color, taskIds (JSON) |
| QuickNotesTable | id, content, type, isProcessed |
| JournalEntriesTable | id, dayId (unique), reflection, mood (1-5), gratitude |
| WeeklyPlansTable | id (week-YYYY-WW), primordialGoals (JSON) |
| WeekDaysTable | dayId (PK), weekId, signalTaskIds (JSON), noiseTaskIds (JSON) |
| TimerSessionsTable | id, mode, taskId, durationSecs, wasCompleted |

---

## Cómo hacer build en Windows

**IMPORTANTE**: NO buildear desde Android Studio — el entorno no tiene los fixes necesarios.

### Build desde CMD (siempre usar este método)
```bat
cd C:\Users\DavidSebastianTarant\Claude\arquitectura-enfoque-flutter
build_apk.bat
```

### Instalar en dispositivo (USB o WiFi ADB)
```bat
C:\Users\DavidSebastianTarant\AppData\Local\Android\Sdk\platform-tools\adb.exe -s R5CXC3MN44T install -r build\app\outputs\apk\debug\app-debug.apk
```

### Por qué NO buildear desde Android Studio
Windows usa rutas 8.3 (short names) para `%TEMP%` → `C:\Users\DAVIDS~1\AppData\Local\Temp`.
Esto rompe **Unix Domain Sockets** de Java que Gradle usa internamente → error "Unable to establish loopback connection".

**Fix aplicado en `build_apk.bat`:**
- `set TEMP=C:\tmp` + `set TMP=C:\tmp`
- JVM flags: `-Djava.io.tmpdir=C:\tmp -Djdk.net.unixDomain.tempDir=C:\tmp`
- JDK: Temurin 17.0.18 en `C:\Program Files\Eclipse Adoptium\jdk-17.0.18.8-hotspot`
- Gradle 8.13 (mínimo requerido por AGP)

### Si aparecen errores en Android Studio (IDE, no build)
Los errores "Target of URI doesn't exist: 'package:flutter_riverpod/...'" son **falsos positivos** del caché del IDE.
**File → Invalidate Caches → Invalidate and Restart**

### Regenerar código Drift (si se modifican las tablas)
```bat
C:\flutter\flutter_windows_3.41.6-stable\flutter\bin\flutter.bat pub run build_runner build --delete-conflicting-outputs
```

---

## Estado de implementación

### Completado ✅
- Fase 1 — Scaffold + Nav Shell (5 tabs, glassmorphism, FAB morfing por tab)
- Fase 2 — Base de datos Drift (9 tablas, código generado con build_runner)
- Fase 3 — Domain models + servicios CRUD con streams reactivos
- Fase 4 — Riverpod providers (StreamProviders para todas las tablas)
- Fase 5 — Tab Hoy (prioridades, task cards con Slidable, habits, progress bar)
- Fase 6 — Tab Semana (grid 7 días en español via intl)
- Fase 7 — Tab Proyectos (lista + ProjectDetail standalone)
- Fase 8 — Tab Hábitos (streaks, calendar grid de puntos)
- Fase 9 — Tab Enfoque (Pomodoro timer, 7 modos, CustomPainter arc)
- Fase 10 — Inbox + Revisión (quick capture, journal diario, weekly review)
- Fix: `initializeDateFormatting('es', null)` en main.dart (resuelve LocaleDataException al iniciar)

### Pendiente 🔜
- Fase 11 — Dashboard + Polish final
- Stats semanales (tasks completadas, minutos de foco, streaks)
- HapticFeedback completo en todas las interacciones
- Padding bottom correcto en todas las páginas (clearance con nav bar + FAB)
- `dart analyze` → 0 errores/warnings antes de release
- FAB long-press → QuickCapture en todas las tabs
- Drag & drop real en tab Semana (LongPressDraggable + DragTarget actualiza dayId en DB)

---

## Dependencias (pubspec.yaml)
```yaml
dependencies:
  flutter_riverpod: ^2.5.1
  go_router: ^13.2.0
  drift: ^2.18.0
  sqlite3_flutter_libs: ^0.5.0
  google_fonts: ^6.2.1
  shared_preferences: ^2.2.3
  uuid: ^4.4.0
  intl: ^0.19.0
  path_provider: ^2.1.3
  path: ^1.9.0
  equatable: ^2.0.5
  flutter_slidable: ^3.1.0

dev_dependencies:
  drift_dev: ^2.18.0
  build_runner: ^2.4.9
  flutter_lints: ^3.0.0
```
