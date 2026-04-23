# What's new in the 1.6 redesign pass

This pass added five feature-level deliverables on top of the core
redesign. Each one is documented in its own file for depth; this
document is the index + migration checklist.

## TL;DR — the five things

| # | Feature | Doc | Flutter surface |
|---|---------|-----|-----------------|
| 1 | **Login screen** (Google + email + local-only) | [`login-onboarding-config.md`](./login-onboarding-config.md) | `lib/screens/login_screen.dart` |
| 2 | **Onboarding tour** (4 steps, multi-select habits + reminders) | [`login-onboarding-config.md`](./login-onboarding-config.md) | `lib/screens/onboarding_screen.dart` |
| 3 | **Accent color system** (6 curated accents, live swap) | [`accent-system.md`](./accent-system.md) | `lib/theme/accent.dart` + `ThemeExtension` |
| 4 | **Sound & haptics** (5 presets, app-wide opt-in) | [`sound-haptics.md`](./sound-haptics.md) | `lib/feedback/feedback_service.dart` |
| 5 | **ConfirmDialog + Toast + Changelog** | [`dialogs.md`](./dialogs.md) | `lib/widgets/confirm_dialog.dart`, `toast.dart`, `lib/screens/changelog_screen.dart` |
| + | **Config expanded** (12 sections, matches real app) | [`login-onboarding-config.md`](./login-onboarding-config.md) | `lib/screens/config_screen.dart` |
| + | **App Icon "Anotación"** | [`../assets/icon/README.md`](../assets/icon/README.md) | `assets/icon/` |

Config screen has been expanded to match the real app structure
(Apariencia, Color, Sonido&Hápticos, Notificaciones, Datos, Hoy,
Áreas, Revisión, Tareas, Enfoque, Acerca de). See
[`config-layout.md`](./config-layout.md) for the section-by-section
map.

## Migration checklist (in order)

1. **Accent system first.** It touches `ThemeData`, so land it before
   widgets that consume it. Add the `AnotaloAccent` enum, wire
   `ThemeExtension<AnotaloAccentTokens>`, update `MaterialApp` to
   rebuild on change.
2. **FeedbackService.** Global singleton with `playSound(kind)` and
   `haptic(kind)`. Gate both behind user prefs stored in
   `SharedPreferences`. Use `audioplayers` for sounds (bundled short
   WAVs) or `soloud` for synthesis.
3. **ConfirmDialog + Toast.** Standard reusable widgets. Every
   destructive action in the app (backup, restore, delete task,
   delete area, delete habit, reset) must go through `ConfirmDialog`.
4. **Config screen.** Rewrite as a `ListView` of `SettingsSection`
   containing `SettingsRow`. Match the 12 sections in
   `config-layout.md`. Hook each row to its action.
5. **Changelog screen.** Static data file + timeline `ListView`.
   Route: push on tap of the Novedades row in Config.
6. **Login screen.** New first-run gate. Conditional on
   `hasCompletedOnboarding` bool in prefs.
7. **Onboarding flow.** Multi-step PageView with shared
   `OnboardingBloc` or just `ValueNotifier` if you prefer keeping it
   local.

## File tree after this pass

```
lib/
├── theme/
│   ├── anotalo_theme.dart           ← existing, extended
│   ├── accent.dart                  ← NEW: 6 accents + extension
│   └── accent_preview.dart          ← NEW: live preview widget
├── feedback/
│   └── feedback_service.dart        ← NEW: sound + haptic
├── widgets/
│   ├── confirm_dialog.dart          ← NEW
│   ├── toast.dart                   ← NEW
│   └── settings/
│       ├── settings_section.dart    ← NEW
│       └── settings_row.dart        ← NEW
└── screens/
    ├── login_screen.dart            ← NEW
    ├── onboarding_screen.dart       ← NEW
    ├── config_screen.dart           ← extend existing
    └── changelog_screen.dart        ← NEW
assets/
└── sounds/
    ├── tick.wav                     ← 80ms @ 880Hz, 6% vol
    ├── success.wav                  ← 120ms glissando 660→990
    ├── warn.wav                     ← 120ms triangle @ 320Hz
    ├── danger.wav                   ← 180ms sawtooth @ 180Hz
    └── toggle.wav                   ← 40ms sine @ 520Hz
```

## Testing checklist

- [ ] Change accent from Config → every screen re-tints without
      hot-restart
- [ ] Toggle Sonidos off → confirming a dialog plays nothing
- [ ] Toggle Hápticos off → confirming a dialog doesn't vibrate
- [ ] "Borrar todo" opens red ConfirmDialog, plays warn sound on
      open, plays danger sound on confirm
- [ ] Toast auto-dismisses at 2.2s
- [ ] Onboarding: select 3 habits with reminders → finish → all 3
      appear in habit list with scheduled notifications
- [ ] Login "Usar sin cuenta" goes straight to onboarding, no
      network calls
- [ ] Changelog screen scrolls smoothly, dots align with version
      entries, "Actual" chip appears only on v1.6.0
