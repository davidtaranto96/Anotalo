# Login, Onboarding, Config layout — short specs

## Login screen

Three paths, ordered by conversion value:

1. **Continuar con Google** — white button with G logo. Primary CTA.
2. **Continuar con email** — secondary, opens 2-step email/password form.
3. **Usar sin cuenta** — dashed tertiary. Banner: "Nada sube a la nube. Los datos quedan en tu teléfono."

Above the buttons: "A" brand mark (Fraunces, 96px, italic) with a soft terracotta radial glow behind it. Below: tagline "Tu sistema de enfoque · Pequeño, diario, repetible."

Flutter: `lib/screens/login_screen.dart`. Use `google_sign_in` for (1), hand-roll (2) with Firebase Auth, gate (3) behind a single `hasLocalAccount` bool in prefs.

## Onboarding — 4 steps

Progress = 4 small dots at the top, active = filled primary, completed = half-opacity primary. "Saltar →" always visible top-right.

| Step | Title | Body | Input |
|---|---|---|---|
| 1 | "Bienvenido a Anotalo" | 3 feature chips with icons: Hoy/Semana · Hábitos · Enfoque | none (just continue) |
| 2 | "¿Qué querés ordenar?" | Pick áreas you care about | multi-select 2×3 grid: Trabajo, Facultad, Personal, Salud, Proyectos, Viaje |
| 3 | "Elegí tu color" | Live preview of Hoy mockup above a 6-accent picker | single-select accent |
| 4 | "Arrancá con tus hábitos" | Multi-select + optional reminder per habit | 6 habit cards (Agua, Meditar, Correr, Leer, Caminar, Dormir), each with a reminder chip (0 or 1 time from preset: 07:00, 08:00, 12:00, 18:00, 20:00, 21:00, 22:00, 23:00) |

On finish: create the selected habits with reminders (schedule via `flutter_local_notifications`), save accent, mark onboarding done.

Flutter: `lib/screens/onboarding_screen.dart` with a `PageView` controller. State in a single `OnboardingData` value-notifier.

## Config layout — 12 sections

In order top to bottom:

1. **Apariencia** — Modo oscuro (toggle)
2. **Color de acento** — 6-swatch picker + live preview strip
3. **Sonido & Hápticos** — Sonidos toggle, Vibración toggle, "Probar sonidos" row with 4 test chips
4. **Notificaciones** — Recordatorio nocturno (toggle + time)
5. **Datos** — Hacer backup (→ confirm), Restaurar backup (→ confirm, danger), Borrar todo (→ confirm, danger)
6. **Hoy** — Mostrar frases (toggle), Mostrar hábitos en Hoy (toggle)
7. **Áreas** — Administrar áreas (→ push)
8. **Revisión** — Revisión de hoy (→ push), Historial de revisiones (→ push)
9. **Tareas** — Prioridad por defecto (chip), Área por defecto (→ push)
10. **Enfoque** — Modo por defecto (→ push)
11. **Acerca de** — **Novedades** (→ push Changelog, with v1.6.0 chip), Hecho con cuidado

Section header: overline-style, primary color, uppercase, 10px, letter-spacing 0.14em, padding-top 22.

Row component: 56px tall, 14 padding, icon chip 32×32 with 8 radius + icon-color × 18% bg, title 14/500, sub 12/textTertiary, right-side chevron or control. Divider between rows inside a section, no divider at last. Pressed state: bgElev2 on mousedown.

See `components.md` for the existing settings-row spec — extended in this pass but not replaced.
