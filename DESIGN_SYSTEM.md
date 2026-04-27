# Apunto - Design System
## Inspirado en la experiencia visual de Claude, adaptado a una app de notas y productividad

---

## Filosofia de Diseno

Claude transmite **calidez, calma y profesionalismo**. No es frio ni clinico como la mayoria de apps tech.
La clave es que se siente como una conversacion con alguien atento, no como usar un software.

### Principios

1. **Calidez sobre frialdad** - Colores crema, terracota y neutrales calidos en vez de grises azulados
2. **Calma visual** - Mucho espacio, pocos elementos compitiendo, jerarquia clara
3. **Minimalismo con proposito** - Cada elemento tiene razon de ser, nada es decorativo sin funcion
4. **Legibilidad ante todo** - Tipografia limpia, contraste comodo, fondos suaves
5. **Premium sin ser ostentoso** - Se siente cuidado y refinado sin gritar "mira que bonito soy"

---

## Paleta de Colores

### Fondos y superficies

```
Background principal     #F4F3EE   (Crema calido — reemplaza el oscuro 0xFF1E1E2C)
Surface card             #FFFFFF   (Blanco puro para cards)
Surface elevated         #EDE9E3   (Crema mas oscuro para secciones agrupadas)
Surface sheet            #FAFAF7   (Bottom sheets y modales)
Surface input            #F0EDE8   (Inputs y campos de texto)
Divider                  #E5E0D8   (Lineas divisorias suaves)
```

### Colores de marca

```
Primary (Terracota)      #C15F3C   (El naranja-oxido de Claude — CTAs, FAB, acciones principales)
Primary hover/pressed    #A8502F   (Version mas oscura para estados)
Primary light            #F5DDD3   (Background sutil para badges y tags con primary)
Accent (Coral)           #D97757   (Links, texto de acento, elementos secundarios)
```

### Texto

```
Text primary             #1A1A1A   (Negro suave para texto principal — nunca negro puro #000)
Text secondary           #6B6560   (Gris calido para subtitulos y metadata)
Text tertiary            #9C9590   (Gris mas claro para placeholders y hints)
Text on primary          #FFFFFF   (Texto sobre botones terracota)
Text link                #C15F3C   (Links inline, usa el primary)
```

### Semanticos

```
Success                  #5B8A5E   (Verde salvia — tareas completadas, habitos cumplidos)
Success light            #E8F0E8   (Background para badges de exito)
Warning                  #C4963A   (Ambar calido — alertas suaves)
Warning light            #FFF3E0   (Background para alertas)
Danger                   #C44B4B   (Rojo apagado — eliminar, errores)
Danger light             #FDE8E8   (Background para errores)
Info                     #5B7E9E   (Azul grisaceo — notas informativas)
```

### Neutrales (siempre con subtono calido, nunca azulado)

```
Neutral 50               #FAFAF7
Neutral 100              #F4F3EE
Neutral 200              #EDE9E3
Neutral 300              #E5E0D8
Neutral 400              #B1ADA1
Neutral 500              #9C9590
Neutral 600              #6B6560
Neutral 700              #4A4540
Neutral 800              #2D2A27
Neutral 900              #1A1A1A
```

---

## Tipografia

### Font Family

```
Primary:   GoogleFonts.inter()    — Para todo el body text, labels, inputs
Branding:  GoogleFonts.lora()     — Solo para titulos grandes y el nombre de la app (serif elegante)
```

Inter es limpia y moderna. Lora agrega personalidad serif en momentos clave, como hace Claude con su branding.

### Escala tipografica

```
Display     Lora     32px   w700   letterSpacing: -0.5   (Nombre de la app, titulos de pagina)
Heading 1   Lora     24px   w600   letterSpacing: -0.3   (Secciones principales)
Heading 2   Inter    20px   w600   letterSpacing: -0.2   (Subsecciones)
Heading 3   Inter    17px   w600   letterSpacing: 0      (Card titles)
Body        Inter    15px   w400   height: 1.5            (Texto general, notas)
Body small  Inter    13px   w400   height: 1.4            (Metadata, fechas)
Caption     Inter    12px   w500   height: 1.3            (Labels, badges, hints)
Overline    Inter    11px   w600   letterSpacing: 0.5     (Categorias, tags uppercase)
```

### Reglas

- **Nunca** usar mas de 2 pesos en una misma vista (ej: w400 + w600)
- Line height minimo 1.4 para legibilidad
- Color del texto siempre con subtono calido, no gris azulado
- Los titulos Lora solo en momentos "hero" (max 1-2 por pantalla)

---

## Espaciado

### Sistema de 4px

```
xs    4px    (Entre icono y texto inline)
sm    8px    (Padding interno de tags/badges)
md    12px   (Separacion entre elementos agrupados)
base  16px   (Padding horizontal de cards, separacion entre cards)
lg    20px   (Padding de pagina lateral)
xl    24px   (Separacion entre secciones)
2xl   32px   (Separacion entre bloques mayores)
3xl   48px   (Top padding de paginas, espacio antes de footer)
```

### Regla de oro

- **Mucho aire** entre bloques. Si dudas, agrega mas espacio.
- Cards con padding interno de `16-20px`
- Paginas con padding lateral de `20-24px`
- Entre secciones principales: `24-32px`

---

## Bordes y Esquinas

```
Radius small      8px    (Tags, badges, chips)
Radius medium    12px    (Inputs, botones pequenos)
Radius large     16px    (Cards, containers)
Radius xl        20px    (Bottom sheets, modales)
Radius full      999px   (Pills, avatares, FAB)
```

### Bordes

```
Border default    1px solid #E5E0D8   (Cards con borde sutil)
Border focused    1.5px solid #C15F3C (Input enfocado)
Border hover      1px solid #B1ADA1   (Card hover)
```

**Regla:** Las cards usan borde sutil + sombra minima. NO usar solo sombra sin borde (se ve flotando).

---

## Sombras

```
Shadow sm     0px 1px 2px rgba(0,0,0,0.04)                  (Botones, tags)
Shadow md     0px 2px 8px rgba(0,0,0,0.06)                  (Cards elevadas)
Shadow lg     0px 4px 16px rgba(0,0,0,0.08)                 (Modales, sheets)
Shadow focus  0px 0px 0px 3px rgba(193,95,60,0.12)           (Focus ring terracota)
```

**Filosofia:** Sombras muy sutiles. Claude NO usa sombras agresivas. Es mas un hint de profundidad que una elevacion dramatica.

---

## Componentes

### Botones

#### Primary (Terracota)
```
Background:    #C15F3C
Text:          #FFFFFF
Border radius: 12px
Padding:       14px 24px (height ~48px)
Font:          Inter 15px w600
Shadow:        shadow-sm
Hover:         #A8502F
Pressed:       #8F4428 + scale(0.98)
```

#### Secondary (Outline)
```
Background:    transparent
Text:          #C15F3C
Border:        1.5px solid #C15F3C
Border radius: 12px
Padding:       14px 24px
Hover:         background #F5DDD3
```

#### Ghost (Solo texto)
```
Background:    transparent
Text:          #6B6560
Padding:       8px 12px
Hover:         background #F4F3EE
```

#### Danger
```
Background:    #C44B4B
Text:          #FFFFFF
Border radius: 12px
```

### Cards

#### Card default
```
Background:    #FFFFFF
Border:        1px solid #E5E0D8
Border radius: 16px
Padding:       16px
Shadow:        shadow-sm
```

#### Card selected/active
```
Background:    #FFFFFF
Border:        1.5px solid #C15F3C
Shadow:        shadow-focus
```

#### Card muted (completed items)
```
Background:    #FAFAF7
Border:        1px solid #E5E0D8
Opacity:       0.7 en texto
```

### Inputs

```
Background:    #F0EDE8
Border:        1px solid transparent
Border radius: 12px
Padding:       14px 16px
Font:          Inter 15px w400 color #1A1A1A
Placeholder:   Inter 15px w400 color #9C9590
Focused:       border 1.5px solid #C15F3C, shadow-focus
```

### Tags / Badges

```
Background:    color-light variant del color semantico
Text:          color del semantico
Border radius: 8px
Padding:       4px 10px
Font:          Inter 12px w600
```

Ejemplos:
- Prioridad alta: bg #F5DDD3, text #C15F3C
- Completada: bg #E8F0E8, text #5B8A5E
- En progreso: bg #FFF3E0, text #C4963A

### Bottom Navigation

```
Background:    #FFFFFF
Border top:    1px solid #E5E0D8
Shadow:        0px -2px 8px rgba(0,0,0,0.04)
Icon inactive: #9C9590
Icon active:   #C15F3C
Label active:  Inter 11px w600 #C15F3C
Label inact:   Inter 11px w500 #9C9590
```

**No glassmorphism** — En light mode es mas limpio un fondo solido blanco con borde top sutil.

### FAB (Floating Action Button)

```
Background:    #C15F3C
Icon:          #FFFFFF
Size:          56px
Border radius: 16px (NO full circle — cuadrado redondeado como Claude)
Shadow:        shadow-md
Pressed:       scale(0.95) + #A8502F
```

### Bottom Sheets

```
Background:    #FAFAF7
Border radius: 20px (solo top)
Handle:        40px x 4px, radius full, color #E5E0D8
Shadow:        shadow-lg
Padding:       24px horizontal, 20px top
```

### Toggle / Switch

```
Track off:     #E5E0D8
Track on:      #C15F3C
Thumb:         #FFFFFF
```

---

## Iconografia

- **Material Icons Rounded** (ya los usas, son los correctos para este estilo)
- Tamano base: 20-24px
- Color: usa los colores semanticos, nunca negro puro
- Iconos de tab bar: 22px
- Iconos inline con texto: 18px

---

## Animaciones

### Principios

Claude se siente **tranquilo** — las animaciones son sutiles, nunca llamativas.

```
Duration rapida:    150ms   (hover, press states)
Duration normal:    250ms   (transiciones de pagina, fade)
Duration lenta:     400ms   (aparicion de modales, expansion)
Curve principal:    Curves.easeOutCubic  (salida suave, no bounce)
Curve entrada:      Curves.easeInOut     (para loops)
```

### Animaciones especificas

1. **Cards al aparecer** — FadeIn + SlideUp (offset: 8px, duration: 250ms, staggered 50ms entre cards)
2. **FAB** — Scale transition al cambiar de tab (150ms, easeOutCubic)
3. **Bottom sheet** — Slide up 400ms con easeOutCubic
4. **Completar tarea** — Scale down a 0.95 → strikethrough animado → fade a opacity 0.5 (300ms total)
5. **Swipe actions** — Backdrop se revela con color semantico (verde completar, rojo eliminar)
6. **Page transitions** — FadeThrough (no slide lateral agresivo)
7. **Input focus** — Border color transition 200ms + shadow-focus aparece
8. **Press state** — scale(0.98) en 100ms (feeling tactil)

### Lo que NO hacer

- No usar bounce curves (demasiado jugueton para esta estetica)
- No animar colores de forma dramatica
- No usar parallax o efectos 3D
- No hacer que cosas vuelen por la pantalla

---

## Layout de Paginas

### Estructura general

```
SafeArea
  CustomScrollView (BouncingScrollPhysics)
    SliverAppBar
      titulo (Lora 24px w600)
      subtitulo opcional (Inter 13px, color secondary)
    SliverPadding (horizontal: 20)
      [Contenido de la pagina]
    SliverToBoxAdapter (height: 120) // clearance para nav + FAB
```

### AppBar

```
Background:    transparente (usa el background de la pagina)
Title:         Lora 24px w600 color #1A1A1A
Subtitle:      Inter 13px w400 color #6B6560
Elevation:     0
Leading:       Icon #6B6560 si hay back button
Actions:       Icons #6B6560
```

**No usar AppBar con color solido** — el estilo Claude es que el header se funde con el contenido.

---

## Status Bar

```
statusBarColor:          transparent
statusBarIconBrightness: Brightness.dark    (iconos oscuros sobre fondo claro)
navigationBarColor:      #FFFFFF
```

---

## Dark Mode (Opcional, para futuro)

Si eventualmente agregas dark mode, los colores de Claude en dark:

```
Background:      #2D2A27   (marron oscuro calido, NO gris azulado)
Surface card:    #3A3632
Surface input:   #3A3632
Text primary:    #F4F3EE
Text secondary:  #B1ADA1
Accent:          #D97757   (coral mas brillante que en light)
Primary:         #D97757
Divider:         #4A4540
```

---

## Migracion desde el tema actual

### Que cambia

| Actual (Dark)                      | Nuevo (Claude-inspired)              |
|------------------------------------|--------------------------------------|
| `surfaceBase = 0xFF1E1E2C`        | `surfaceBase = 0xFFF4F3EE`          |
| `surfaceCard = 0xFF242740`        | `surfaceCard = 0xFFFFFFFF`          |
| `surfaceSheet = 0xFF18181F`       | `surfaceSheet = 0xFFFAFAF7`         |
| `colorPrimary = 0xFF7C6EF7`      | `colorPrimary = 0xFFC15F3C`         |
| `colorAccent = 0xFF5ECFB1`       | `colorAccent = 0xFFD97757`          |
| `StatusBarBrightness.light` (white icons) | `StatusBarBrightness.dark` (dark icons) |
| `Glassmorphism navbar`            | `Solid white navbar + border`        |
| `GoogleFonts.inter()` only        | `Inter` body + `Lora` headings       |
| `Text: Colors.white`              | `Text: #1A1A1A`                      |
| `Text secondary: Colors.white38`  | `Text secondary: #6B6560`            |

### Que NO cambia

- **Riverpod** — misma arquitectura de providers
- **Drift** — mismas tablas y streams
- **GoRouter** — mismas rutas y shell
- **BouncingScrollPhysics** — se mantiene
- **HapticFeedback** — se mantiene
- **Material Icons Rounded** — se mantiene
- **Estructura de features** — se mantiene

---

## Implementacion en app_theme.dart

```dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  AppTheme._();

  // ── Fondos y superficies ──
  static const surfaceBase     = Color(0xFFF4F3EE);
  static const surfaceCard     = Color(0xFFFFFFFF);
  static const surfaceElevated = Color(0xFFEDE9E3);
  static const surfaceSheet    = Color(0xFFFAFAF7);
  static const surfaceInput    = Color(0xFFF0EDE8);
  static const divider         = Color(0xFFE5E0D8);

  // ── Marca ──
  static const colorPrimary      = Color(0xFFC15F3C);
  static const colorPrimaryDark  = Color(0xFFA8502F);
  static const colorPrimaryLight = Color(0xFFF5DDD3);
  static const colorAccent       = Color(0xFFD97757);

  // ── Texto ──
  static const textPrimary   = Color(0xFF1A1A1A);
  static const textSecondary = Color(0xFF6B6560);
  static const textTertiary  = Color(0xFF9C9590);

  // ── Semanticos ──
  static const colorSuccess = Color(0xFF5B8A5E);
  static const colorSuccessLight = Color(0xFFE8F0E8);
  static const colorWarning = Color(0xFFC4963A);
  static const colorWarningLight = Color(0xFFFFF3E0);
  static const colorDanger  = Color(0xFFC44B4B);
  static const colorDangerLight = Color(0xFFFDE8E8);
  static const colorInfo    = Color(0xFF5B7E9E);

  // ── Neutrales ──
  static const neutral400 = Color(0xFFB1ADA1);
  static const neutral500 = Color(0xFF9C9590);

  // ── Radii ──
  static final r8  = BorderRadius.circular(8);
  static final r12 = BorderRadius.circular(12);
  static final r16 = BorderRadius.circular(16);
  static final r20 = BorderRadius.circular(20);
  static final rFull = BorderRadius.circular(999);

  // ── Sombras ──
  static const shadowSm = [BoxShadow(
    offset: Offset(0, 1), blurRadius: 2,
    color: Color(0x0A000000),
  )];
  static const shadowMd = [BoxShadow(
    offset: Offset(0, 2), blurRadius: 8,
    color: Color(0x0F000000),
  )];
  static const shadowLg = [BoxShadow(
    offset: Offset(0, 4), blurRadius: 16,
    color: Color(0x14000000),
  )];

  // ── ThemeData ──
  static ThemeData get theme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: surfaceBase,
    colorScheme: ColorScheme.light(
      primary: colorPrimary,
      secondary: colorAccent,
      surface: surfaceBase,
      error: colorDanger,
    ),
    textTheme: GoogleFonts.interTextTheme().copyWith(
      displayLarge: GoogleFonts.lora(
        fontSize: 32, fontWeight: FontWeight.w700,
        color: textPrimary, letterSpacing: -0.5,
      ),
      headlineMedium: GoogleFonts.lora(
        fontSize: 24, fontWeight: FontWeight.w600,
        color: textPrimary, letterSpacing: -0.3,
      ),
      titleLarge: GoogleFonts.inter(
        fontSize: 20, fontWeight: FontWeight.w600,
        color: textPrimary, letterSpacing: -0.2,
      ),
      titleMedium: GoogleFonts.inter(
        fontSize: 17, fontWeight: FontWeight.w600,
        color: textPrimary,
      ),
      bodyLarge: GoogleFonts.inter(
        fontSize: 15, fontWeight: FontWeight.w400,
        color: textPrimary, height: 1.5,
      ),
      bodyMedium: GoogleFonts.inter(
        fontSize: 13, fontWeight: FontWeight.w400,
        color: textSecondary, height: 1.4,
      ),
      labelLarge: GoogleFonts.inter(
        fontSize: 15, fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
      labelSmall: GoogleFonts.inter(
        fontSize: 11, fontWeight: FontWeight.w600,
        color: textTertiary, letterSpacing: 0.5,
      ),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      titleTextStyle: GoogleFonts.lora(
        fontSize: 24, fontWeight: FontWeight.w600,
        color: textPrimary,
      ),
      iconTheme: const IconThemeData(color: textSecondary),
    ),
    cardTheme: CardThemeData(
      color: surfaceCard,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: r16,
        side: BorderSide(color: divider),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: surfaceInput,
      border: OutlineInputBorder(
        borderRadius: r12,
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: r12,
        borderSide: const BorderSide(color: colorPrimary, width: 1.5),
      ),
      hintStyle: GoogleFonts.inter(
        fontSize: 15, color: textTertiary,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: colorPrimary,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: r12),
        textStyle: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w600),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: colorPrimary,
        side: const BorderSide(color: colorPrimary, width: 1.5),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: r12),
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: surfaceCard,
      selectedItemColor: colorPrimary,
      unselectedItemColor: neutral500,
      elevation: 0,
    ),
    dividerTheme: const DividerThemeData(
      color: divider,
      thickness: 1,
      space: 0,
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: colorPrimary,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: r16),
      elevation: 2,
    ),
  );
}
```

---

## Ejemplo visual: Card de nota

```dart
Container(
  padding: const EdgeInsets.all(16),
  decoration: BoxDecoration(
    color: AppTheme.surfaceCard,
    borderRadius: AppTheme.r16,
    border: Border.all(color: AppTheme.divider),
    boxShadow: AppTheme.shadowSm,
  ),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text('Titulo de la nota',
        style: GoogleFonts.inter(
          fontSize: 17, fontWeight: FontWeight.w600,
          color: AppTheme.textPrimary)),
      const SizedBox(height: 6),
      Text('Contenido parcial de la nota que se muestra como preview...',
        style: GoogleFonts.inter(
          fontSize: 14, color: AppTheme.textSecondary,
          height: 1.4),
        maxLines: 2, overflow: TextOverflow.ellipsis),
      const SizedBox(height: 12),
      Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppTheme.colorPrimaryLight,
              borderRadius: AppTheme.r8,
            ),
            child: Text('Trabajo',
              style: GoogleFonts.inter(
                fontSize: 12, fontWeight: FontWeight.w600,
                color: AppTheme.colorPrimary)),
          ),
          const Spacer(),
          Text('Hace 2h',
            style: GoogleFonts.inter(
              fontSize: 12, color: AppTheme.textTertiary)),
        ],
      ),
    ],
  ),
)
```

---

## Ejemplo visual: Boton primario

```dart
FilledButton(
  onPressed: () {},
  style: FilledButton.styleFrom(
    backgroundColor: AppTheme.colorPrimary,
    shape: RoundedRectangleBorder(borderRadius: AppTheme.r12),
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
  ),
  child: Text('Crear nota',
    style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w600)),
)
```

---

## Resumen de la sensacion buscada

| Sencillo (dark, finanzas)        | Apunto (light, Claude-inspired)      |
|----------------------------------|--------------------------------------|
| Fondo oscuro #1E1E2C            | Fondo crema calido #F4F3EE          |
| Violeta #7C6EF7 como primary    | Terracota #C15F3C como primary      |
| Mint #5ECFB1 como accent        | Coral #D97757 como accent           |
| Texto blanco                     | Texto oscuro calido #1A1A1A         |
| Glassmorphism blur               | Solid white + bordes sutiles         |
| Neon glows y particulas          | Sombras minimales y espacio          |
| Energetica y vibrante            | Calma, profesional y acogedora       |
| Inter everywhere                 | Inter body + Lora titulos            |
| Cards sin borde, con glow        | Cards con borde sutil + sombra       |
