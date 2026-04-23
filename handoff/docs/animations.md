# Anótalo — Animations & Haptics

> Every animation the redesign expects, with Flutter implementation
> strategy and the exact package to reach for.

---

## Packages to install

```yaml
# pubspec.yaml
dependencies:
  flutter_animate: ^4.5.0        # declarative chained animations (fade, slide, etc.)
  flutter_staggered_animations: ^1.1.1 # staggered list entry
  lucide_icons: ^0.257.0         # icon set matching the design (see components.md)
  google_fonts: ^6.2.1           # Instrument Serif + Inter
  gap: ^3.0.1                    # `Gap(12)` instead of SizedBox(height: 12)
```

Optional (add only if used):

```yaml
  shimmer: ^3.0.0                # skeleton loaders
  rive: ^0.13.0                  # only if you want a branded Rive loader for empty states
```

**Do NOT install:** `lottie` (heavier than Rive for our case), `flutter_hooks` (overkill for the scope), `animations` (the Material package — `flutter_animate` covers what we need and more idiomatically).

---

## 1. Pencil-stroke strikethrough (signature interaction)

**Where:** `TaskRow` title.

**What:** User drags finger horizontally across the task title. A hand-drawn line follows the finger in real time. On release:
- > 55% of title width covered → task marked complete, stroke settles in.
- < 55% → fade out over 220ms.

**How:**
- `GestureDetector` captures `onPanStart/Update/End` with local offsets.
- `CustomPainter` paints a smoothed path through captured points (quadratic Bezier through midpoints — see `_PencilStrokePainter` below).
- On commit, animate stroke drawing with `AnimationController` + `PathMetric.extractPath(start: 0, end: progress * pathLength)`.

```dart
class _PencilStrokePainter extends CustomPainter {
  final List<Offset> points;
  final Color color;
  final double strokeWidth;
  final double progress; // 0..1, used on commit anim

  _PencilStrokePainter({
    required this.points,
    required this.color,
    this.strokeWidth = 2.4,
    this.progress = 1.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (points.length < 2) return;
    final path = Path()..moveTo(points.first.dx, points.first.dy);
    for (var i = 1; i < points.length - 1; i++) {
      final p1 = points[i];
      final p2 = points[i + 1];
      final m = Offset((p1.dx + p2.dx) / 2, (p1.dy + p2.dy) / 2);
      path.quadraticBezierTo(p1.dx, p1.dy, m.dx, m.dy);
    }
    path.lineTo(points.last.dx, points.last.dy);

    // Extract a slice if we're animating in
    final metric = path.computeMetrics().first;
    final drawn = progress >= 1.0
        ? path
        : metric.extractPath(0, metric.length * progress);

    final paint = Paint()
      ..color = color.withValues(alpha: 0.92)
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..strokeWidth = strokeWidth;

    canvas.drawPath(drawn, paint);
  }

  @override
  bool shouldRepaint(covariant _PencilStrokePainter old) =>
      old.points != points || old.progress != progress;
}
```

**Tradeoff:** For performance, cap `points` at 80 entries (sample 1-in-3 after that). Users won't notice; the path stays smooth.

---

## 2. Check-in animation (non-gesture complete)

**Where:** Tapping the circular checkbox on a TaskRow.

**Sequence:**

1. `0ms` — `HapticFeedback.mediumImpact()`.
2. `0-200ms` — checkbox border fills with `colors.success`, with a scale bounce: 1.0 → 0.9 → 1.05 → 1.0 (`Curves.easeOutBack`).
3. `100-220ms` — checkmark draws in via stroke-path animation (same technique as pencil, but on a pre-defined check path).
4. `150-470ms` — a soft pencil line auto-draws across the title (see `AutoStroke` in `screens-hoy.jsx`).
5. `0-320ms` — whole row opacity transitions to 0.55.

**Flutter:**

```dart
// Using flutter_animate
Checkbox(...)
  .animate(target: done ? 1 : 0)
  .scaleXY(
    begin: 1.0, end: 1.05,
    duration: 120.ms, curve: Curves.easeOutBack,
  )
  .then()
  .scaleXY(end: 1.0, duration: 80.ms);
```

For the stroke drawing you'll want a `StatefulWidget` with a controlled `AnimationController` rather than `flutter_animate` — you need access to the `PathMetric.extractPath` API.

---

## 3. Area pill switch

**Where:** Hoy's horizontal area tabs.

**Animation:**
- Background color crossfade — 180ms, `Curves.easeInOut`.
- Border color crossfade — same.
- Count badge color — same.
- When switching areas, the task list below **staggers a re-entry**: each task fades + slides up 4pt, with a 40ms stagger.

**Flutter:**

```dart
AnimationLimiter(
  child: Column(
    children: AnimationConfiguration.toStaggeredList(
      duration: const Duration(milliseconds: 320),
      childAnimationBuilder: (w) => SlideAnimation(
        verticalOffset: 6,
        child: FadeInAnimation(child: w),
      ),
      children: tasks.map(TaskRow.new).toList(),
    ),
  ),
)
```

Reset with `AnimationLimiter.reset(...)` (or pass a new `Key`) when `activeArea` changes.

---

## 4. Page transitions

**Default:** Material's shared-axis X transition. Not the stock slide.

```dart
// Using go_router's pageBuilder
GoRoute(
  path: '/projects/:id',
  pageBuilder: (ctx, state) => CustomTransitionPage(
    child: ProjectDetailScreen(id: state.pathParameters['id']!),
    transitionDuration: context.motion.pageTransition,
    transitionsBuilder: (ctx, anim, sec, child) {
      const curve = Curves.easeOutCubic;
      return FadeTransition(
        opacity: CurvedAnimation(parent: anim, curve: curve),
        child: SlideTransition(
          position: Tween(begin: const Offset(0.02, 0), end: Offset.zero)
              .animate(CurvedAnimation(parent: anim, curve: curve)),
          child: child,
        ),
      );
    },
  ),
),
```

**Hero exceptions:** For taps on a project card → project detail, use a proper `Hero` on the colored accent bar + title. The accent bar scales from 3pt → full-width banner on the detail screen.

---

## 5. Bottom sheet entry

**Where:** NewProject, NewTask, NewHabit, QuickCapture.

**Animation:**
- Scrim fades in 0 → 1 over 200ms, `Curves.easeOut`.
- Sheet slides from bottom: `Offset(0, 1) → Offset.zero` over 300ms, `emphasized` curve (see `AnotaloMotion.emphasized`).
- Content inside the sheet: fields fade + rise 6pt, staggered 30ms each, starting at 180ms.
- Haptic: `HapticFeedback.lightImpact()` at sheet open.

Use the built-in `showModalBottomSheet` with a custom `transitionAnimationController`:

```dart
showModalBottomSheet(
  context: context,
  isScrollControlled: true,
  backgroundColor: Colors.transparent, // custom radii drawn in builder
  barrierColor: context.colors.scrim,
  transitionAnimationController: AnimationController(
    vsync: Navigator.of(context),
    duration: 300.ms,
    reverseDuration: 250.ms,
  ),
  builder: (_) => const NewProjectSheet(),
);
```

---

## 6. FAB press

**Animation:**
- On press-down: scale to 0.94 over 120ms.
- On release: scale back to 1.0 over 180ms, `Curves.easeOutCubic`.
- Haptic: `HapticFeedback.lightImpact()` on tap-down.
- On action complete (e.g. task created from the sheet): a subtle expand pulse 1.0 → 1.08 → 1.0 over 280ms, with a brief 20% fill of a secondary color.

```dart
// With flutter_animate + controller
GestureDetector(
  onTapDown: (_) {
    HapticFeedback.lightImpact();
    _fabScale.forward();
  },
  onTapUp: (_) => _fabScale.reverse(),
  onTapCancel: () => _fabScale.reverse(),
  child: Container(...).animate(controller: _fabScale, autoPlay: false)
    .scaleXY(end: 0.94, duration: 120.ms, curve: Curves.easeOut),
)
```

---

## 7. List entry (initial screen load)

**Where:** Hoy task list, Semana task list, Proyectos list.

**Animation:**
- Each row: opacity 0→1, translateY 8→0, 320ms, `Curves.easeOutCubic`.
- Stagger: 40ms between rows.
- Do NOT cascade from offscreen — stagger only the visible viewport.

Use `flutter_staggered_animations`:

```dart
AnimationLimiter(
  child: ListView.builder(
    itemCount: tasks.length,
    itemBuilder: (ctx, i) => AnimationConfiguration.staggeredList(
      position: i,
      duration: 320.ms,
      delay: 40.ms,
      child: SlideAnimation(
        verticalOffset: 8,
        child: FadeInAnimation(child: TaskRow(tasks[i])),
      ),
    ),
  ),
)
```

---

## 8. Swipe actions on TaskRow

**Spec:**
- Swipe left → reveal "Diferir" (amber) + "Eliminar" (red) actions.
- Swipe right (from left edge) → reveal "Completar" (green).
- Threshold for action commit: 40% of row width (with haptic `mediumImpact` when threshold crossed during drag — `selectionClick` for each 15% increment).
- If released before threshold: row snaps back with `Curves.easeOutBack`.
- If released past threshold: action fires, row animates out (collapse height + fade) in 260ms.

**Implementation:** `Dismissible` works, but for the dual-direction + partial reveal + haptic feedback on threshold crossing, you'll want `flutter_slidable` or a custom `GestureDetector`. Our recommendation: **custom GestureDetector** so the haptic feedback is precise — `flutter_slidable` can't trigger haptics at exact threshold crossings.

---

## 9. Pull-to-refresh

**Where:** Hoy, Semana, Habitos, Proyectos lists.

**Spec:**
- Use `CupertinoSliverRefreshControl` on iOS, `RefreshIndicator` on Android.
- Color: `colors.primary`.
- Haptic on trigger: `HapticFeedback.mediumImpact()`.
- Empty the data list with `AnimationConfiguration.synchronized` after refresh resolves, then staggered re-enter.

---

## 10. Progress bar segment fill

**Where:** Hoy "0 / 10" segmented bar.

**Spec:**
- On screen load: segments fill in left-to-right, each 260ms, with 40ms stagger, `Curves.easeOutCubic`.
- On task complete: only the newly-lit segment animates (scale 0.6→1.0 + color tween), 320ms.

---

## 11. Empty states (No proyectos, No hábitos, Inbox vacío)

**Spec:**
- Icon fades in from 0 opacity + scale 0.9→1.0, 400ms delayed 200ms after screen entry.
- Text fades in 120ms later.
- On real iOS/Android, a subtle bounce every 6s (when no user interaction for 6s) draws attention to the FAB. Use `flutter_animate`'s `.shake(hz: 1, curves: [...])` tastefully.

---

## 12. Skeleton loaders (first-load placeholders)

**Where:** When Hoy/Semana is loading data from local DB / sync.

Use `shimmer` package, but **only on the first launch** — subsequent loads should be instant (local DB). Shimmer color:

```dart
Shimmer.fromColors(
  baseColor: context.colors.surfaceContainer,
  highlightColor: context.colors.surfaceContainerHighest,
  period: 1400.ms,
  child: ..., // skeleton layout
)
```

Show skeleton for **max 400ms** then swap in real content with a 200ms fade. If real data arrives in <100ms, skip the skeleton entirely (a flicker is worse than a brief blank).

---

## Haptics reference

Flutter's `HapticFeedback` only has 5 kinds. Use this mapping for consistency across the app:

| HapticFeedback method     | When                                                     |
|---------------------------|----------------------------------------------------------|
| `selectionClick()`        | Tab switch, pill select, pan start, minor state change   |
| `lightImpact()`           | Button press, FAB tap, sheet open                        |
| `mediumImpact()`          | Task complete, destructive action (delete, uncomplete)   |
| `heavyImpact()`           | Screen-wide critical action — rarely used; e.g. end day  |
| `vibrate()`               | Error, validation failure — last resort                  |

**Rule:** every user-initiated state change deserves a haptic. No haptic = feels cheap. But chain-haptics (multiple fires in < 100ms) are worse than none — debounce.

---

## Motion design principles (for Claude Code)

1. **Duration ladder:** 160 / 240 / 360ms. Only drop below 160 for tint changes; never go above 400 for UI (above 400 = user notices and waits).
2. **Curves:** prefer `Curves.easeOutCubic` for enters, `Curves.easeInCubic` for exits. `Curves.easeInOut` only when both directions matter (toggles).
3. **Stagger ceiling:** max 40ms between items, max 8 items visible. Beyond that, the last item enters after the user already stopped paying attention.
4. **Never animate opacity+transform simultaneously on long lists** — prefer opacity+translateY (cheap), skip scale (expensive).
5. **Respect `MediaQuery.disableAnimations`** — wrap all non-essential animations in `if (!MediaQuery.disableAnimationsOf(context))`.

---

## What NOT to do

- ❌ Don't use the default `MaterialPageRoute` transitions. They feel Android-y.
- ❌ Don't sprinkle `AnimatedContainer` everywhere — it's easy to over-use and slows scroll performance.
- ❌ Don't use `Hero` on text — it flickers mid-flight. Use it on colored shapes and images.
- ❌ Don't animate list item heights on mount — use opacity+translate only. Height animations cause layout thrash.
- ❌ Don't chain haptics. One haptic per user action.
