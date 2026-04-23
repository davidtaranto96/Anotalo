"""
Regenerate the Anotalo app icon with properly centered geometry for
Android adaptive icons.

The handoff PNGs have the "a" at x=340 (left-shifted) which only works
for a full-visible square canvas. Android adaptive icons mask the outer
27% of the canvas (launcher applies squircle/circle/teardrop shapes), so
the "a·" needs to sit inside the central 66% safe zone.

Output:
  assets/icon/anotalo-icon-1024.png           (full with bg, for launcher fallback)
  assets/icon/anotalo-icon-fg-1024.png        (transparent foreground, for adaptive)
  assets/icon/anotalo-icon-mono-1024.png      (white bg, for monochrome variant)

Run:   python handoff/assets/icon/regen.py
"""
from __future__ import annotations

import os
from PIL import Image, ImageDraw, ImageFont

OUT_DIR = os.path.normpath(
    os.path.join(os.path.dirname(__file__), "..", "..", "..", "assets", "icon")
)
os.makedirs(OUT_DIR, exist_ok=True)

SIZE = 1024
BG_CREAM = (244, 239, 231, 255)   # #F4EFE7
INK = (26, 24, 21, 255)           # #1A1815
TERRA = (217, 119, 87, 255)       # #D97757
WHITE = (255, 255, 255, 255)
TRANSPARENT = (0, 0, 0, 0)

# Times Italic as placeholder (same as handoff README — production use
# should replace with Fraunces Italic 500 once the TTF is bundled).
FONT_PATH = "C:/Windows/Fonts/timesi.ttf"


def render_icon(bg, letter_color, dot_color, *, out_path,
                letter_font_size=780, dot_radius=88,
                safe_zone_inset=0):
    """Render the a+dot composition on a canvas.

    safe_zone_inset lets us shrink the composition so the whole thing
    fits inside the Android adaptive icon safe zone (66% of the canvas).
    inset=172 gives us ~66% central area.
    """
    img = Image.new("RGBA", (SIZE, SIZE), bg)
    draw = ImageDraw.Draw(img)

    # scale the content down if we need to fit in a safe zone
    if safe_zone_inset > 0:
        content_size = SIZE - 2 * safe_zone_inset
        scale = content_size / SIZE
        letter_font_size = int(letter_font_size * scale)
        dot_radius = int(dot_radius * scale)

    font = ImageFont.truetype(FONT_PATH, letter_font_size)

    # Compose: letter "a" on the left-ish, dot on the right.
    # Center the whole composition horizontally within the safe zone.
    # Measure letter bounding box.
    bbox = draw.textbbox((0, 0), "a", font=font, anchor="la")
    letter_w = bbox[2] - bbox[0]
    letter_h = bbox[3] - bbox[1]

    gap = int(letter_font_size * 0.15)
    dot_w = dot_radius * 2
    total_w = letter_w + gap + dot_w

    safe_left = safe_zone_inset
    safe_right = SIZE - safe_zone_inset
    safe_center_x = (safe_left + safe_right) // 2

    start_x = safe_center_x - total_w // 2
    # Baseline a bit below the vertical center — Italic letters sit higher
    letter_baseline_y = SIZE // 2 + letter_h // 2 - int(letter_font_size * 0.05)
    # Draw letter at baseline
    draw.text(
        (start_x - bbox[0], letter_baseline_y - letter_h - bbox[1]),
        "a",
        font=font,
        fill=letter_color,
    )

    # Dot centered on letter x-height (roughly 55% up from baseline for italic)
    dot_cx = start_x + letter_w + gap + dot_radius
    dot_cy = letter_baseline_y - int(letter_font_size * 0.08)
    draw.ellipse(
        (dot_cx - dot_radius, dot_cy - dot_radius,
         dot_cx + dot_radius, dot_cy + dot_radius),
        fill=dot_color,
    )

    img.save(out_path)
    print(f"wrote {os.path.relpath(out_path)}")


def main() -> None:
    # 1. Main launcher icon — full canvas with cream background, centered
    render_icon(
        bg=BG_CREAM,
        letter_color=INK,
        dot_color=TERRA,
        out_path=os.path.join(OUT_DIR, "anotalo-icon-1024.png"),
    )

    # 2. Adaptive icon foreground — transparent bg, content inside 66% safe
    # zone so Android's launcher masks never clip the a/dot.
    render_icon(
        bg=TRANSPARENT,
        letter_color=INK,
        dot_color=TERRA,
        out_path=os.path.join(OUT_DIR, "anotalo-icon-fg-1024.png"),
        safe_zone_inset=172,  # 172/1024 ≈ 17% → 66% central zone
    )

    # 3. Monochrome (white bg, black letter & dot) — used in notification
    # trays and monochrome themed icons on Android 13+.
    render_icon(
        bg=WHITE,
        letter_color=INK,
        dot_color=INK,
        out_path=os.path.join(OUT_DIR, "anotalo-icon-mono-1024.png"),
    )

    # 4. Also a transparent-bg monochrome for Android 13 themed icon layer
    render_icon(
        bg=TRANSPARENT,
        letter_color=INK,
        dot_color=INK,
        out_path=os.path.join(OUT_DIR, "anotalo-icon-mono-fg-1024.png"),
        safe_zone_inset=172,
    )


if __name__ == "__main__":
    main()
