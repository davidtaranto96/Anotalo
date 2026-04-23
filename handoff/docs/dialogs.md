# ConfirmDialog, Toast, Changelog

Three reusable pieces introduced in 1.6 to replace the previous
"just do the destructive thing and hope for the best" UX.

---

## 1. ConfirmDialog

Modal popup with spring-in animation, destructive variant, sound +
haptic. Blocks all backup / restore / delete flows.

### Anatomy

```
┌─────────────────────────────────┐
│  ┌──┐                           │
│  │🗑 │ ← 44×44 icon chip          │
│  └──┘    bg = color × 18% alpha  │
│                                  │
│  ¿Borrar todo?        ← Fraunces, 20px
│                                  │
│  Se van a eliminar...  ← body, 13px text-secondary
│                                  │
│  ┌──────────┬──────────────┐     │
│  │ Cancelar │ Sí, borrar   │     │
│  └──────────┴──────────────┘     │
│     flex:1       flex:1.4        │
└─────────────────────────────────┘
  backdrop: rgba(0,0,0,0.55) + blur(6px)
  dialog:  340 max-width, 18 radius, bgElev2
```

### States

| State | Animation | Feedback |
|---|---|---|
| Opens | `scale(0.88→1) + fadeIn + translateY(10→0)`, 260ms cubic-bezier(0.2, 1.2, 0.3, 1) | Play `warn` sound, haptic `[6, 40, 6]` |
| Confirm | Closes + fires action | Play `success` (non-destructive) or `danger` (destructive) |
| Cancel (button or backdrop tap) | Closes | Play `tick` sound, haptic 6ms |
| Icon | Spring in after 80ms delay, `scale(0.4→1) + rotate(-12→0)` | — |

### Flutter implementation

```dart
// lib/widgets/confirm_dialog.dart
import 'package:flutter/material.dart';
import '../feedback/feedback_service.dart';

Future<bool> showAnotaloConfirm({
  required BuildContext context,
  required String title,
  required String body,
  required String confirmLabel,
  String cancelLabel = 'Cancelar',
  bool danger = false,
  IconData icon = Icons.warning_amber_rounded,
}) async {
  await FeedbackService.instance.warn();
  final ok = await showGeneralDialog<bool>(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'Cerrar',
    barrierColor: Colors.black.withOpacity(0.55),
    transitionDuration: const Duration(milliseconds: 260),
    pageBuilder: (ctx, _, __) => _ConfirmDialogBody(
      title: title,
      body: body,
      confirmLabel: confirmLabel,
      cancelLabel: cancelLabel,
      danger: danger,
      icon: icon,
    ),
    transitionBuilder: (ctx, anim, __, child) {
      final curved = CurvedAnimation(
        parent: anim,
        curve: const Cubic(0.2, 1.2, 0.3, 1.0),
      );
      return FadeTransition(
        opacity: anim,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
          child: Transform.scale(
            scale: Tween(begin: 0.88, end: 1.0).evaluate(curved),
            child: Transform.translate(
              offset: Offset(0, (1 - curved.value) * 10),
              child: child,
            ),
          ),
        ),
      );
    },
  );
  return ok ?? false;
}

class _ConfirmDialogBody extends StatelessWidget {
  const _ConfirmDialogBody({
    required this.title, required this.body,
    required this.confirmLabel, required this.cancelLabel,
    required this.danger, required this.icon,
  });
  final String title, body, confirmLabel, cancelLabel;
  final bool danger;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final accent = danger ? colors.error : colors.primary;
    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: 340,
          padding: const EdgeInsets.fromLTRB(20, 22, 20, 16),
          decoration: BoxDecoration(
            color: colors.surfaceContainerHigh,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: theme.dividerColor),
            boxShadow: const [
              BoxShadow(color: Colors.black54, blurRadius: 60, offset: Offset(0, 20)),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // icon chip with spring entrance
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: 1),
                duration: const Duration(milliseconds: 320),
                curve: const Cubic(0.2, 1.4, 0.3, 1),
                builder: (_, v, __) => Transform.scale(
                  scale: 0.4 + 0.6 * v,
                  child: Transform.rotate(
                    angle: (1 - v) * -0.21, // ~-12deg
                    child: Opacity(opacity: v, child: _iconChip(accent)),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Text(title, style: theme.textTheme.headlineSmall?.copyWith(
                fontFamily: 'Fraunces', fontWeight: FontWeight.w400,
              )),
              const SizedBox(height: 6),
              Text(body, style: theme.textTheme.bodyMedium?.copyWith(
                color: colors.onSurface.withOpacity(0.7), height: 1.45,
              )),
              const SizedBox(height: 18),
              Row(children: [
                Expanded(flex: 1, child: _cancelButton(context)),
                const SizedBox(width: 8),
                Expanded(flex: 7, child: _confirmButton(context, accent)), // ~flex:1.4
              ]),
            ],
          ),
        ),
      ),
    );
  }

  Widget _iconChip(Color accent) => Container(
    width: 44, height: 44,
    decoration: BoxDecoration(
      color: accent.withOpacity(0.094),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Icon(icon, color: accent, size: 22),
  );

  Widget _cancelButton(BuildContext context) => OutlinedButton(
    onPressed: () {
      FeedbackService.instance.tick();
      Navigator.of(context).pop(false);
    },
    child: Text(cancelLabel),
  );

  Widget _confirmButton(BuildContext context, Color accent) => ElevatedButton(
    onPressed: () {
      if (danger) FeedbackService.instance.danger();
      else FeedbackService.instance.success();
      Navigator.of(context).pop(true);
    },
    style: ElevatedButton.styleFrom(
      backgroundColor: accent,
      foregroundColor: Colors.white,
    ),
    child: Text(confirmLabel),
  );
}
```

### Usage (always async)

```dart
onPressed: () async {
  final ok = await showAnotaloConfirm(
    context: context,
    title: '¿Borrar todo?',
    body: 'Se van a eliminar tareas, hábitos, áreas y revisiones. Esta acción no se puede deshacer.',
    confirmLabel: 'Sí, borrar todo',
    danger: true,
    icon: Icons.delete_outline_rounded,
  );
  if (ok) {
    await repo.wipeEverything();
    showAnotaloToast(context, 'Todos los datos fueron borrados', tone: ToastTone.warn);
  }
}
```

---

## 2. Toast

Transient success/warn bubble at the bottom. Fires-and-forgets —
no interaction, 2.2s auto-dismiss.

### Flutter

```dart
// lib/widgets/toast.dart
enum ToastTone { success, warn, info }

void showAnotaloToast(
  BuildContext context,
  String message, {
  ToastTone tone = ToastTone.success,
  Duration duration = const Duration(milliseconds: 2200),
}) {
  final scaffold = ScaffoldMessenger.of(context);
  final theme = Theme.of(context);
  final color = switch (tone) {
    ToastTone.success => Colors.green,     // or your success token
    ToastTone.warn => theme.colorScheme.error,
    ToastTone.info => theme.colorScheme.primary,
  };
  scaffold.showSnackBar(SnackBar(
    content: Row(
      children: [
        Icon(Icons.check, size: 14, color: color),
        const SizedBox(width: 10),
        Expanded(child: Text(message, style: theme.textTheme.bodyMedium)),
      ],
    ),
    backgroundColor: theme.colorScheme.surfaceContainerHigh,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
      side: BorderSide(color: color),
    ),
    behavior: SnackBarBehavior.floating,
    margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
    duration: duration,
  ));
}
```

### When to use

- After any successful async action (backup generated, data synced)
- After a destructive action completed (warn tone)
- **Never** for errors — those need a full screen or inline message;
  a toast disappears before the user reads it.

---

## 3. Changelog Screen

Full-screen push-to route showing every version and what changed.
Reached from Config → Novedades.

### Anatomy

```
◀ [ overline: NOVEDADES ]
  Historial de versiones     ← Fraunces 24px

  Todo lo que sumamos...     ← intro paragraph

  │
  ● v1.6.0   [Actual]   23 Abr 2026
  │ Color, sonidos y hábitos
  │ ┌─────────────────────────────────┐
  │ │ [Nuevo] Color de acento en Config│
  │ │         Elegí entre 6 paletas... │
  │ ├─────────────────────────────────┤
  │ │ [Mejora] Onboarding multi-habit │
  │ └─────────────────────────────────┘
  │
  ○ v1.5.2              8 Abr 2026
  │ ...
```

### Data model

```dart
// lib/data/changelog.dart
enum ChangeKind { newFeature, improvement, fix }

class ChangelogItem {
  final ChangeKind kind;
  final String title;
  final String description;
  const ChangelogItem(this.kind, this.title, this.description);
}

class Release {
  final String version;
  final DateTime date;
  final String title;
  final String? tag; // 'Actual', 'Lanzamiento', null
  final List<ChangelogItem> items;
  const Release({
    required this.version, required this.date, required this.title,
    this.tag, required this.items,
  });
}

const List<Release> kChangelog = [
  Release(
    version: '1.6.0',
    date: ... ,
    tag: 'Actual',
    title: 'Color, sonidos y hábitos',
    items: [
      ChangelogItem(ChangeKind.newFeature, 'Color de acento en Config', 'Elegí entre 6 paletas curadas...'),
      // ...
    ],
  ),
  // ... more releases
];
```

### Styling notes

- Timeline dot: current release is a filled primary circle with a 4px
  primary glow ring. Past releases are empty circles with divider
  border.
- Version label: monospace (JetBrains Mono), 18px, weight 600.
- Title: Fraunces, 18px, weight 400.
- Date: right-aligned in the version row, text-tertiary.
- Kind chip: 64px min-width, uppercase 10px, rounded-full, tinted bg
  at 18% and text at 100%.
  - `newFeature` → primary color
  - `improvement` → success color
  - `fix` → warn/amber color
- Item card: 12 radius, divider between items, no padding between
  card and the next release.

### Don't do

- ❌ Don't show unreleased features. The changelog is history, not a
  roadmap.
- ❌ Don't reverse-chronological the items within a release. Keep the
  most important at the top.
- ❌ Don't gate the changelog behind login. It should be readable
  before signup.
