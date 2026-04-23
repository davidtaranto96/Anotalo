# Anótalo — Component Specs

> Generated from the HTML redesign. Every measurement, color, and
> state is specified so Claude Code (or any Flutter dev) can
> implement without guessing.
>
> All tokens referenced here live in `lib/theme/anotalo_theme.dart`.
> Use `context.colors`, `context.space`, `context.radii`, etc.

---

## Table of contents

1. [Bottom Navigation](#1-bottom-navigation)
2. [Area Pills (Hoy tabs)](#2-area-pills-hoy-tabs)
3. [Task Row (the hero component)](#3-task-row)
4. [Section Header (editorial overline)](#4-section-header)
5. [Stat Card (mini widget)](#5-stat-card)
6. [Project Mini Card](#6-project-mini-card)
7. [FAB (floating action button)](#7-fab)
8. [Quote Block](#8-quote-block)
9. [Progress Bar (segmented)](#9-progress-bar-segmented)
10. [Bottom Sheet shell](#10-bottom-sheet-shell)
11. [Quick Capture input](#11-quick-capture-input)

---

## 1. Bottom Navigation

**Problem with current:** background is semi-transparent (`#0E0D0BEE`) with `blur(20px)`. On Android/web the blur sometimes doesn't composite against the scrolled tasks, so task text shows through. Fix: solid surface + stronger blur + top shadow + enough `paddingBottom` in the scroll container.

```dart
class AnotaloBottomNav extends StatelessWidget {
  final String active;
  final ValueChanged<String> onChange;
  const AnotaloBottomNav({super.key, required this.active, required this.onChange});

  static const _items = [
    ('hoy',       Icons.calendar_today_outlined,  'Hoy'),
    ('semana',    Icons.view_week_outlined,       'Semana'),
    ('proyectos', Icons.folder_outlined,          'Proyectos'),
    ('habitos',   Icons.autorenew,                'Hábitos'),
    ('enfoque',   Icons.timer_outlined,           'Enfoque'),
  ];

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
        child: Container(
          decoration: BoxDecoration(
            // SOLID surface — not translucent. Blur adds depth on scroll.
            color: colors.surface,
            border: Border(top: BorderSide(color: colors.outlineVariant)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.35),
                blurRadius: 24, offset: const Offset(0, -8),
              ),
            ],
          ),
          padding: const EdgeInsets.fromLTRB(8, 10, 8, 18),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: _items.map((it) {
              final (id, icon, label) = it;
              final isActive = id == active;
              return _NavItem(
                icon: icon, label: label, isActive: isActive,
                onTap: () {
                  HapticFeedback.selectionClick();
                  onChange(id);
                },
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
```

**Important:** wrap your `Scaffold` body in a `ListView`/`SingleChildScrollView` with `padding: EdgeInsets.only(bottom: 140)` so the last task never slides under the nav. The 140 = nav height (68) + safe area (~24) + breathing room (48).

**Active indicator:** 22×2pt bar, 10pt above the icon, `colors.primary`. No pill/indicator background — the label+icon color already tell the story.

---

## 2. Area Pills (Hoy tabs)

**Sizes**

- Height: 36pt
- Padding: 9×13
- Radius: `radii.md` (10)
- Gap between pills: 6
- Icon size: 15
- Font: `text.labelLarge` (14/500 normal, 14/600 when active)
- Count badge: 11/600, same color as area when active

**States**

| State    | bg                          | border              | text color         | icon color        |
|----------|-----------------------------|---------------------|--------------------|-------------------|
| default  | transparent                 | `outlineVariant`    | `onSurfaceVariant` | `onSurfaceVariant`|
| active   | `areaColor` @ 8% alpha      | `areaColor`         | `onSurface`        | `areaColor`       |
| pressed  | `areaColor` @ 14% alpha     | `areaColor`         | `onSurface`        | `areaColor`       |

Active pills also get a 3pt outer glow: `boxShadow: [BoxShadow(color: areaColor.withAlpha(20), blurRadius: 0, spreadRadius: 3)]`.

**"Todo" pill** uses `colors.primary` (terracotta) as its area color.

**Animation:** bg/border color crossfade 180ms, `Curves.easeInOut`.

---

## 3. Task Row

The hero component. Houses the **pencil-stroke strikethrough gesture**, area accent bar, checkbox, meta row, and action buttons.

**Anatomy**

```
┌─────────────────────────────────────────────────┐
│█│ ⚪  Ver oficina                                 │
│█│     ⏱ de hace 2 días  💼 Trabajo              │
│█│     [✓ Completar] [→ Diferir] [✕]             │
└─────────────────────────────────────────────────┘
 ↑       ↑
 area    checkbox (border = area color when open,
 bar                filled green when done)
 3pt
```

**Sizes**

- Vertical padding: 14 top, 16 bottom
- Horizontal padding inside row: 8 left (after area bar), 4 right
- Area accent bar: 3pt wide, inset from the left edge of the list container, rounded right side only (`0 2 2 0`)
- Checkbox: 22×22, 2pt border, radius `circle`
- Title font: `text.bodyLarge` (16/500)
- Meta chips gap: 10
- Meta chip height: 20, padding 2×7, radius 5
- Action buttons: 26pt tall, 10 padding, radius 7

**Colors**

- Area bar: `context.areas.byName(task.area)` — 0.85 opacity when open, 0.30 when done
- Checkbox border: area color (open) / `colors.success` (done)
- Checkbox fill: transparent (open) / `colors.success` (done)
- Checkmark: white, 3pt stroke, rounded caps

**Pencil strikethrough gesture — THE signature interaction**

When the user **drags horizontally across the title** (not just taps), render a hand-drawn line following the pointer in real-time. On release:
- If horizontal span > 55% of title width → commit: task goes to "done", line settles as a soft hand-drawn stroke over the title.
- If < 55% → discard with a 220ms fade.

Implementation in Flutter: use a `GestureDetector` with `onPanStart/Update/End` that captures local offsets, then paint via `CustomPainter`. Pseudo-code:

```dart
class _TitleWithPencil extends StatefulWidget {
  final String title;
  final bool done;
  final VoidCallback onComplete;
  // ...
}

class _TitleWithPencilState extends State<_TitleWithPencil> {
  final List<Offset> _points = [];
  bool _dragging = false;
  double _titleWidth = 0;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (ctx, constraints) {
      _titleWidth = constraints.maxWidth;
      return GestureDetector(
        onPanStart: (d) {
          if (widget.done) return;
          setState(() { _dragging = true; _points..clear()..add(d.localPosition); });
          HapticFeedback.selectionClick();
        },
        onPanUpdate: (d) {
          if (!_dragging) return;
          setState(() => _points.add(d.localPosition));
        },
        onPanEnd: (_) {
          if (!_dragging) return;
          final xs = _points.map((p) => p.dx);
          final span = xs.reduce(math.max) - xs.reduce(math.min);
          final coverage = span / _titleWidth;
          if (coverage > 0.55) {
            HapticFeedback.mediumImpact();
            widget.onComplete();
          } else {
            setState(_points.clear); // will fade via AnimatedOpacity
          }
          _dragging = false;
        },
        child: CustomPaint(
          foregroundPainter: _PencilStrokePainter(
            points: _points,
            color: context.colors.secondary,
            active: _dragging,
          ),
          child: Text(widget.title, style: context.text.bodyLarge),
        ),
      );
    });
  }
}
```

The `_PencilStrokePainter` draws a smoothed path (quadratic Bezier through midpoints, stroke width 2.4, rounded caps). When committed, it animates in using `AnimationController` (420ms, ease-out) drawing the path from start to end via `PathMetric.extractPath`.

**Haptics checklist**

| Event                        | Haptic                         |
|-----------------------------|--------------------------------|
| Pan start on title          | `selectionClick` (tiny cue)    |
| Checkbox tap → complete     | `mediumImpact`                 |
| Strike committed            | `mediumImpact`                 |
| Strike discarded (too short)| `lightImpact`                  |
| Defer tap                   | `selectionClick`               |

---

## 4. Section Header

Editorial overline used for "Importante · 3 tareas", "Hábitos · hoy", etc.

```
  • IMPORTANTE  3 tareas ──────────────────
```

**Spec**

- Height: 40 (22 top padding + 14 bottom)
- Dot: 4×4, 2pt radius, colored per section
- Overline: `text.labelSmall`, `ALL CAPS`, `letterSpacing: 2`, color = section color, weight 600
- Meta: `text.bodySmall`, `onSurfaceVariant`
- Rule: 1pt divider, `outlineVariant`, flex-fill with 6 margin-left

---

## 5. Stat Card

Used in Hoy's "Tu día" grid — racha, enfoque hoy, semana.

**Spec**

- Size: flex (2-col grid, 8pt gap)
- Padding: 11×13
- Radius: `radii.md` (10)
- Border: 1pt `outlineVariant`
- Background: `surfaceContainer`

**Content (top to bottom, 6pt gap)**

1. Overline row: icon (12pt, tinted) + `LABEL` (labelSmall, 10pt, letter-spacing 1.4)
2. Number row: big value (`displaySmall`, 26pt serif) + unit (bodySmall) + spacer + sub-meta (bodySmall right-aligned)
3. Optional 3pt progress bar at bottom

**Variants**

- `span: 1` (half width) — default
- `span: 2` (full width) — used for "Semana" card that has progress bar

---

## 6. Project Mini Card

Horizontal card in Hoy's "Proyectos · activos" section.

**Anatomy**

```
│ ⭕44% │ Mudanza oficina              │
│       │ 4/12 • Trabajo • vence en…  │ ›
```

**Spec**

- Height: ~56
- Padding: 10×12
- Radius: `radii.md`
- Background: `surfaceContainer`
- Left accent: 3pt bar, full card height, area color
- Radial progress: 34×34, `CustomPaint` (background ring + foreground arc), `strokeWidth: 2.5`. Center label: percentage in mono, 9pt, area color.
- Title: `text.bodyMedium` 13.5/500
- Meta dots: 2×2 circles as separators
- Trailing: chevron_right, 14pt, `onSurfaceVariant`

**Tap:** Hero transition to project detail screen using `Hero(tag: 'project-${p.id}')` wrapping the accent bar + title.

---

## 7. FAB

The round-square terracotta button anchored bottom-right of every main screen.

**Spec**

- Size: 52×52
- Radius: `radii.xl` (14–16)
- Background: `colors.primary`
- Icon: `plus`, 22pt, `strokeWidth: 2`, white
- Shadow: `shadows.fab` (two layers: terracotta glow + black drop)
- Position: bottom 96, right 20

**Pressed:** scale to 0.94, 120ms `Curves.easeOut`, `HapticFeedback.lightImpact()`.

**On tap:** opens the Capture sheet (NewTaskSheet or inbox) with a slide-up + scrim fade (300ms `emphasized` curve).

---

## 8. Quote Block

The Neruda quote under the hero header.

**Spec**

- Left border: 2pt, `colors.primary`, full height
- Padding: 8×14
- Quote text: serif italic, `text.bodySmall` 13, `onSurfaceVariant`
- Attribution: `labelSmall` uppercase, `onSurfaceVariant`, 10pt

**Behavior:** cycle quotes daily via a small JSON asset. Fade out/in on change (not during session — only on app launch).

---

## 9. Progress Bar (segmented)

Used for "0 / 10 — 0%" under the hero count.

**Spec**

- 10 segments, 3pt tall, gap 3, each flex 1
- Completed segment: `colors.primary`
- Empty segment: `outlineVariant`
- Animate fill with stagger: each segment fades in with 40ms delay, 260ms duration, ease-out.

---

## 10. Bottom Sheet shell

Used by: NewProject, NewHabit, NewTask, QuickCapture.

**Spec**

- Max height: 82% of screen
- Radius: `radii.sheet` (24) top-left + top-right only
- Background: `surfaceContainerHigh`
- Border-top: 1pt `outlineVariant`
- Shadow: `shadows.sheet`
- Handle: 36×4 centered, 16pt below top edge, `outline` color
- Scrim: `colors.scrim` (dark modal barrier), with a subtle blur (4pt) on the app behind

**Entry animation:** slide from bottom, 300ms `emphasized`. Scrim fades in over 200ms. Haptic: `lightImpact` at start.

---

## 11. Quick Capture input

Inline dashed pill at the bottom of Hoy that routes to inbox.

**Spec**

- Height: 42
- Padding: 11×14
- Radius: `radii.lg` (12)
- Border: 1pt dashed `outlineVariant` (use `DottedBorder` package or paint manually)
- Icon: `plus`, 14pt, `onSurfaceVariant`
- Placeholder: `text.bodySmall`, `onSurfaceVariant`
- Trailing keybind chip: mono font, 10pt, 3×7 padding, `colors.surface` bg, `outlineVariant` border

**On tap:** expand in-place (animated `SizeTransition`) into a real text field with a "Send" button, or push to a full Inbox capture screen.

---

## Icons used across the app

Map these to `lucide_icons` (preferred for consistency) or Material:

| Name          | Lucide              | Material fallback         |
|---------------|---------------------|---------------------------|
| check         | LucideIcons.check   | Icons.check               |
| x             | LucideIcons.x       | Icons.close               |
| plus          | LucideIcons.plus    | Icons.add                 |
| calendar      | LucideIcons.calendar| Icons.calendar_today      |
| clock         | LucideIcons.clock   | Icons.access_time         |
| briefcase     | LucideIcons.briefcase | Icons.work_outline      |
| book          | LucideIcons.book    | Icons.menu_book_outlined  |
| home          | LucideIcons.home    | Icons.home_outlined       |
| heart         | LucideIcons.heart   | Icons.favorite_outline    |
| inbox         | LucideIcons.inbox   | Icons.inbox_outlined      |
| folder        | LucideIcons.folder  | Icons.folder_outlined     |
| week          | LucideIcons.grid3x3 | Icons.view_week_outlined  |
| flame         | LucideIcons.flame   | Icons.local_fire_department_outlined |
| timer         | LucideIcons.timer   | Icons.timer_outlined      |
| target        | LucideIcons.target  | Icons.radio_button_checked|
| settings      | LucideIcons.settings| Icons.settings_outlined   |
| chevronRight  | LucideIcons.chevronRight | Icons.chevron_right  |
| edit          | LucideIcons.edit3   | Icons.edit_outlined       |

Stroke width: **1.6-1.8** across the board. Lucide defaults to 2; override via `LucideIcons.check` + `IconTheme` wrapper.

---

## Spacing grid cheat-sheet

| Token         | Value | Usage                                    |
|---------------|-------|------------------------------------------|
| `space.xxs`   | 2     | icon-to-text in tight chips              |
| `space.xs`    | 4     | checkbox-to-title vertical               |
| `space.sm`    | 8     | list item gaps, small stacks             |
| `space.md`    | 12    | card internal padding                    |
| `space.lg`    | 16    | between cards, list sections             |
| `space.xl`    | 20    | FAB margin, large spacing                |
| `space.xxl`   | 24    | section header top margin                |
| `space.xxxl`  | 32    | screen-level breaks                      |
| `screenPadding` | 22  | horizontal padding for all main content  |

Never hard-code these — always pull from `context.space`.
