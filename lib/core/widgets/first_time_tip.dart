import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme/app_colors.dart';

/// Coach-mark one-shot que aparece la primera vez que se monta el child
/// en runtime. La key `tipKey` identifica el tip de manera única (por
/// pantalla). Persistido en SharedPreferences — al cerrar nunca más
/// aparece para esta instalación.
///
/// Uso:
/// ```dart
/// FirstTimeTip(
///   tipKey: 'coach.hoy',
///   title: 'Deslizá tus tareas',
///   body: 'Derecha = completar. Izquierda = editar / posponer / borrar.',
///   icon: Icons.swipe_rounded,
///   child: ...,
/// )
/// ```
class FirstTimeTip extends StatefulWidget {
  const FirstTimeTip({
    super.key,
    required this.tipKey,
    required this.title,
    required this.body,
    required this.icon,
    required this.child,
  });

  final String tipKey;
  final String title;
  final String body;
  final IconData icon;
  final Widget child;

  /// Resetea todos los tips conocidos — útil para "Ver tour otra vez".
  /// La lista se mantiene acá para que un solo lugar conozca todas las
  /// keys.
  static const List<String> _allKeys = [
    'coach.hoy',
    'coach.calendario',
    'coach.proyectos',
    'coach.enfoque',
    'coach.habitos',
  ];

  static Future<void> resetAll() async {
    final prefs = await SharedPreferences.getInstance();
    for (final k in _allKeys) {
      await prefs.remove(k);
    }
  }

  @override
  State<FirstTimeTip> createState() => _FirstTimeTipState();
}

class _FirstTimeTipState extends State<FirstTimeTip> {
  bool _shouldShow = false;
  bool _checked = false;

  @override
  void initState() {
    super.initState();
    _check();
  }

  Future<void> _check() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final seen = prefs.getBool(widget.tipKey) ?? false;
      if (!mounted) return;
      setState(() {
        _shouldShow = !seen;
        _checked = true;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _checked = true);
    }
  }

  Future<void> _dismiss() async {
    setState(() => _shouldShow = false);
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(widget.tipKey, true);
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    if (!_checked || !_shouldShow) return widget.child;

    return Stack(
      children: [
        widget.child,
        // Overlay translúcido — tap fuera del card también dismisses.
        Positioned.fill(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: _dismiss,
            child: Container(
              color: Colors.black.withValues(alpha: 0.45),
            ),
          ),
        ),
        // Card centrado en la pantalla — antes estaba abajo y el FAB
        // del shell le quedaba encima.
        Positioned.fill(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Center(child: Material(
            color: Colors.transparent,
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: 1),
              duration: const Duration(milliseconds: 280),
              curve: Curves.easeOutCubic,
              builder: (_, t, child) => Opacity(
                opacity: t,
                child: Transform.translate(
                  offset: Offset(0, (1 - t) * 16),
                  child: child,
                ),
              ),
              child: Container(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
                decoration: BoxDecoration(
                  color: context.surfaceCard,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: context.colorPrimary),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.25),
                      blurRadius: 24,
                      spreadRadius: 0,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: context.colorPrimary.withValues(alpha: 0.14),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(widget.icon,
                              size: 18, color: context.colorPrimary),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            widget.title,
                            style: GoogleFonts.fraunces(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: context.textPrimary,
                              letterSpacing: -0.2,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.body,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: context.textSecondary,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: _dismiss,
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 4),
                          minimumSize: const Size(0, 32),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text(
                          'Entendido',
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: context.colorPrimary,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            ),
            ),
          ),
        ),
      ],
    );
  }
}
