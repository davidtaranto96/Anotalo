# Accent color system

The user can pick between **6 curated accents** from Config. The pick
swaps the primary color across the entire app live, without restart.

| id | Label | hex | Use case |
|---|---|---|---|
| `terracota` | Terracota | `#D97757` | Default (brand) |
| `indigo`    | Índigo    | `#6B7BFF` | Tech / professional |
| `bosque`    | Bosque    | `#5A8A6A` | Nature / calm |
| `oceano`    | Océano    | `#4A8FA8` | Cool / focus |
| `violeta`   | Violeta   | `#9B6BBB` | Creative |
| `grafito`   | Grafito   | `#6B7280` | Stealth / neutral |

All six share the same **chroma** in OKLCH space — only the hue
changes. This guarantees they feel like one family and have equal
visual weight on the same dark background.

## Flutter implementation

### 1. The enum + palette map

```dart
// lib/theme/accent.dart

enum AnotaloAccent { terracota, indigo, bosque, oceano, violeta, grafito }

class AccentPalette {
  final Color primary;
  final Color primaryDark;
  final Color primarySurface;   // 14% opacity fill
  final Color primaryBorder;    // 40% opacity
  final String label;

  const AccentPalette({
    required this.primary,
    required this.primaryDark,
    required this.primarySurface,
    required this.primaryBorder,
    required this.label,
  });
}

const Map<AnotaloAccent, AccentPalette> accentPalettes = {
  AnotaloAccent.terracota: AccentPalette(
    primary: Color(0xFFD97757),
    primaryDark: Color(0xFFC06240),
    primarySurface: Color(0x24D97757),
    primaryBorder: Color(0x66D97757),
    label: 'Terracota',
  ),
  AnotaloAccent.indigo: AccentPalette(
    primary: Color(0xFF6B7BFF),
    primaryDark: Color(0xFF5564E0),
    primarySurface: Color(0x246B7BFF),
    primaryBorder: Color(0x666B7BFF),
    label: 'Índigo',
  ),
  AnotaloAccent.bosque: AccentPalette(
    primary: Color(0xFF5A8A6A),
    primaryDark: Color(0xFF457054),
    primarySurface: Color(0x245A8A6A),
    primaryBorder: Color(0x665A8A6A),
    label: 'Bosque',
  ),
  AnotaloAccent.oceano: AccentPalette(
    primary: Color(0xFF4A8FA8),
    primaryDark: Color(0xFF377589),
    primarySurface: Color(0x244A8FA8),
    primaryBorder: Color(0x664A8FA8),
    label: 'Océano',
  ),
  AnotaloAccent.violeta: AccentPalette(
    primary: Color(0xFF9B6BBB),
    primaryDark: Color(0xFF7F5399),
    primarySurface: Color(0x249B6BBB),
    primaryBorder: Color(0x669B6BBB),
    label: 'Violeta',
  ),
  AnotaloAccent.grafito: AccentPalette(
    primary: Color(0xFF6B7280),
    primaryDark: Color(0xFF4B5563),
    primarySurface: Color(0x246B7280),
    primaryBorder: Color(0x666B7280),
    label: 'Grafito',
  ),
};
```

### 2. The controller (provider / riverpod / ValueNotifier — your call)

```dart
// lib/theme/accent_controller.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccentController extends ChangeNotifier {
  static const _key = 'user.accent';
  AnotaloAccent _current = AnotaloAccent.terracota;

  AnotaloAccent get current => _current;
  AccentPalette get palette => accentPalettes[_current]!;

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getString(_key);
    if (stored != null) {
      _current = AnotaloAccent.values.firstWhere(
        (e) => e.name == stored,
        orElse: () => AnotaloAccent.terracota,
      );
      notifyListeners();
    }
  }

  Future<void> set(AnotaloAccent accent) async {
    _current = accent;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, accent.name);
  }
}
```

### 3. Wire it into MaterialApp

```dart
// main.dart
class AnotaloApp extends StatelessWidget {
  const AnotaloApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: AccentController.instance,
      builder: (context, _) {
        final accent = AccentController.instance.palette;
        return MaterialApp(
          theme: AnotaloTheme.light(accent),
          darkTheme: AnotaloTheme.dark(accent),
          themeMode: ThemeMode.dark,
          home: const RootScreen(),
        );
      },
    );
  }
}
```

And in `anotalo_theme.dart`, update the factory to receive the accent:

```dart
static ThemeData dark(AccentPalette accent) {
  return ThemeData(
    brightness: Brightness.dark,
    colorScheme: ColorScheme.dark(
      primary: accent.primary,
      secondary: accent.primaryDark,
      // ... rest unchanged
    ),
    // ...
  );
}
```

### 4. The picker widget

```dart
// lib/widgets/accent_picker.dart
class AccentPicker extends StatelessWidget {
  const AccentPicker({super.key});

  @override
  Widget build(BuildContext context) {
    final current = AccentController.instance.current;
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 6,
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      childAspectRatio: 1,
      children: AnotaloAccent.values.map((a) {
        final palette = accentPalettes[a]!;
        final active = a == current;
        return GestureDetector(
          onTap: () {
            AccentController.instance.set(a);
            FeedbackService.instance.toggle(); // haptic + sound
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            decoration: BoxDecoration(
              color: active ? palette.primarySurface : Colors.transparent,
              border: Border.all(
                color: active ? palette.primary : Theme.of(context).dividerColor,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  color: palette.primary,
                  shape: BoxShape.circle,
                  boxShadow: active ? [
                    BoxShadow(
                      color: palette.primary,
                      blurRadius: 0,
                      spreadRadius: 3,
                    ),
                  ] : null,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
```

### 5. Live preview strip (above the grid)

Shows a mini Button + Badge + Checkbox + Link in the current accent.
Retints the moment the user picks a new color. This is the
single most important UX touch — users know immediately what they're
about to commit to.

See `accent_preview.dart` in the lib for the widget.

## Don't do

- ❌ Don't let users enter a custom hex — the curated palette is the
  point. Custom colors will clash with area colors (sage, violet,
  blue, red) and ruin the visual system.
- ❌ Don't animate the palette transition. Snap-change feels correct;
  a tween makes the whole UI feel laggy.
- ❌ Don't persist the accent in cloud sync. It's a device-level
  preference.
