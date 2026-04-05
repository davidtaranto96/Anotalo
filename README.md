# Anotalo — Arquitectura de Enfoque

App de productividad personal nativa Android, sistema de gestión de tareas y tiempo.

## Stack
- Flutter 3.41.6 + Riverpod + GoRouter + Drift SQLite + Google Fonts (Inter)
- Dark mode only, glassmorphism nav bar + morfing FAB

## Tabs
- Hoy — tareas por prioridad + hábitos + progreso
- Semana — grid 7 días drag & drop
- Proyectos — CRUD + filtros + progreso
- Hábitos — streaks + grid 28 días
- Enfoque — Pomodoro timer (7 modos) + anillo animado
- Inbox — captura rápida (long-press FAB)
- Revisión — diario diario

## Setup
```
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run
```
