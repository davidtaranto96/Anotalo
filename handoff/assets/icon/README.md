# App Icon — "Anotación"

> **Source of truth:** the SVG below. PNG exports in this folder are
> rendered with Times Italic as a placeholder — when you generate the
> production icons, use **Fraunces Italic 500** (same family as the
> app's display font) for visual consistency.

## Concept

Lowercase italic `a` + terracotta dot — literally reads as
"anotá·" (anotá, the imperative "jot it down" in Rioplatense Spanish).
The serif italic anchors the icon in the same typographic family as
the app's display headers. The dot does double duty: it's a punctuation
mark that says "a pause, a note", and it's the brand's terracotta
accent that shows up everywhere else in the UI.

## Colors

| Role | Value |
|------|-------|
| Background | `#F4EFE7` (cream) |
| Letter | `#1A1815` (dark ink) |
| Dot | `#D97757` (terracotta primary) |

## Source SVG (1024 × 1024)

```svg
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1024 1024">
  <rect width="1024" height="1024" rx="230" fill="#F4EFE7"/>
  <text x="340" y="720" text-anchor="middle"
        font-family="Fraunces, serif"
        font-style="italic"
        font-size="700"
        font-weight="500"
        fill="#1A1815"
        letter-spacing="-10">a</text>
  <circle cx="740" cy="640" r="72" fill="#D97757"/>
</svg>
```

## Variants

- **Light** (default, light cream background) — primary icon for
  home screens.
- **Dark** (`#1A1815` background, cream letter, terra dot) — use for
  splash screens on dark OS themes, or the macOS dock on dark mode.
- **Monochrome** (white bg, black letter and dot) — use for favicons,
  notification tray icons, any space that requires single-color.

## iOS — sizes needed

| Size | Purpose |
|------|---------|
| 1024×1024 | App Store listing |
| 180×180   | iPhone @3x |
| 167×167   | iPad Pro @2x |
| 152×152   | iPad @2x |
| 120×120   | iPhone @2x |
| 87×87     | Settings @3x |
| 80×80     | Spotlight @2x |
| 60×60     | iPhone Settings @2x |
| 40×40     | Spotlight |
| 29×29     | Settings |
| 20×20     | Notifications |

Generate with `flutter_launcher_icons` — it handles all sizes from
one 1024 master.

## Android — adaptive icon

Android requires a 108×108dp adaptive icon with a 66dp safe zone
(so the OS can apply its shape mask — circle/squircle/rounded).

- **Foreground layer** (`ic_launcher_foreground.xml`): the `a·`
  centered inside the safe zone, on transparent background.
- **Background layer** (`ic_launcher_background.xml`): a solid
  `#F4EFE7` rectangle.
- **Monochrome layer** (Android 13+): single-color version for
  themed icons.

## Flutter setup

### 1. Add fonts (you likely already have Fraunces for display)

```yaml
# pubspec.yaml
flutter:
  fonts:
    - family: Fraunces
      fonts:
        - asset: fonts/Fraunces-Italic-500.ttf
          style: italic
          weight: 500
```

### 2. Generate launcher icons

```yaml
# pubspec.yaml
dev_dependencies:
  flutter_launcher_icons: ^0.13.1

flutter_launcher_icons:
  android: "launcher_icon"
  ios: true
  image_path: "assets/icon/anotalo-icon-1024.png"
  adaptive_icon_background: "#F4EFE7"
  adaptive_icon_foreground: "assets/icon/anotalo-icon-foreground-1024.png"
  adaptive_icon_monochrome: "assets/icon/anotalo-icon-mono-1024.png"
  min_sdk_android: 21
  web:
    generate: true
    image_path: "assets/icon/anotalo-icon-1024.png"
    background_color: "#F4EFE7"
    theme_color: "#D97757"
```

```bash
flutter pub run flutter_launcher_icons
```

### 3. Recommended: regenerate the master PNG from Fraunces

The PNG files in this folder use Times Italic as a fallback (our
export sandbox couldn't load the Fraunces WOFF2). Replace them with
properly-rendered versions:

**Option A — use your design tool.** Paste the SVG above into
Figma/Sketch/Illustrator, substitute Times → Fraunces Italic 500,
export at 1024×1024.

**Option B — use Flutter itself.** Render a widget, screenshot it:

```dart
// Create a throwaway screen in debug mode:
Container(
  width: 1024,
  height: 1024,
  decoration: BoxDecoration(
    color: const Color(0xFFF4EFE7),
    borderRadius: BorderRadius.circular(230),
  ),
  child: Stack(
    children: [
      const Center(
        child: Padding(
          padding: EdgeInsets.only(right: 110, top: 20),
          child: Text(
            'a',
            style: TextStyle(
              fontFamily: 'Fraunces',
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.w500,
              fontSize: 700,
              color: Color(0xFF1A1815),
              height: 1.0,
              letterSpacing: -10,
            ),
          ),
        ),
      ),
      Positioned(
        left: 668,
        top: 568,
        child: Container(
          width: 144,
          height: 144,
          decoration: const BoxDecoration(
            color: Color(0xFFD97757),
            shape: BoxShape.circle,
          ),
        ),
      ),
    ],
  ),
)
```

Then use `RepaintBoundary` + `toImage()` to export. Or just open the
widget in a browser (Flutter Web), take a 2x screenshot of the
viewport, crop.

## Don't do

- ❌ Don't use a sans-serif `a` — the serif is the whole point.
- ❌ Don't stretch the dot into an oval; it's a perfect circle.
- ❌ Don't color the letter terracotta — contrast kills legibility at
  32px.
- ❌ Don't add a drop shadow inside the icon — iOS and Android already
  add system shadows. You'll double-up.
- ❌ Don't fill the full safe zone on Android. Leave the 21dp margin
  so circle masks don't crop the `a`'s ink trap.
