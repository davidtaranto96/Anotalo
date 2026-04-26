import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../core/feedback/feedback_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';

/// Gesto-firma de Apunto: arrastrar el dedo horizontalmente sobre el
/// título de una tarea pendiente dibuja un trazo de lápiz que sigue el
/// dedo. Al soltar:
///   - Si cubrió > 55% del ancho del título y todavía no estaba en
///     "pendiente de confirmar" → entra en estado armed: el trazo se
///     queda visible pintado y aparece un mini-banner "✓ Confirmar"
///     debajo. La tarea NO se completa hasta que el usuario tappee
///     ese botón. Ahí dispara `onComplete()`.
///   - Si <55% → fade-out 220ms.
///
/// La animación final del trazo (cuando se confirma) usa `PathMetric`
/// para hacer un "redibujado limpio" tipo genio: el squiggle del
/// usuario se reemplaza por una stroke uniforme con leve overdraw.
class PencilStrikeTitle extends StatefulWidget {
  const PencilStrikeTitle({
    super.key,
    required this.title,
    required this.style,
    required this.done,
    required this.onComplete,
    this.strokeColor,
  });

  final String title;
  final TextStyle style;
  final bool done;
  final VoidCallback onComplete;
  final Color? strokeColor;

  @override
  State<PencilStrikeTitle> createState() => _PencilStrikeTitleState();
}

class _PencilStrikeTitleState extends State<PencilStrikeTitle>
    with TickerProviderStateMixin {
  final List<Offset> _points = [];
  bool _dragging = false;
  bool _armed = false;
  double _titleWidth = 0;

  late final AnimationController _fadeCtl;
  late final AnimationController _polishCtl;
  late final AnimationController _confirmPulseCtl;

  @override
  void initState() {
    super.initState();
    _fadeCtl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 220),
      value: 1.0,
    );
    _polishCtl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 420),
    );
    _confirmPulseCtl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _fadeCtl.dispose();
    _polishCtl.dispose();
    _confirmPulseCtl.dispose();
    super.dispose();
  }

  void _reset({bool animated = true}) {
    if (!animated) {
      setState(() {
        _points.clear();
        _dragging = false;
        _armed = false;
        _fadeCtl.value = 1.0;
        _polishCtl.value = 0.0;
      });
      return;
    }
    _fadeCtl.value = 1.0;
    _fadeCtl.reverse().whenComplete(() {
      if (!mounted) return;
      setState(() {
        _points.clear();
        _dragging = false;
        _armed = false;
        _fadeCtl.value = 1.0;
        _polishCtl.value = 0.0;
      });
    });
  }

  void _arm() {
    setState(() {
      _dragging = false;
      _armed = true;
    });
    FeedbackService.instance.warn();
    _polishCtl.forward(from: 0);
  }

  Future<void> _confirm() async {
    FeedbackService.instance.success();
    widget.onComplete();
    // El widget va a redibujar con done:true desde el caller — el reset
    // queda implícito.
  }

  void _cancel() {
    FeedbackService.instance.tick();
    _reset(animated: true);
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.strokeColor ??
        Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.78);

    if (widget.done) {
      return Text(
        widget.title,
        style: widget.style.copyWith(decoration: TextDecoration.lineThrough),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            _titleWidth = constraints.maxWidth;
            return GestureDetector(
              onHorizontalDragStart: (d) {
                if (_armed) return;
                FeedbackService.instance.tick();
                setState(() {
                  _dragging = true;
                  _points
                    ..clear()
                    ..add(d.localPosition);
                });
              },
              onHorizontalDragUpdate: (d) {
                if (!_dragging) return;
                setState(() => _points.add(d.localPosition));
              },
              onHorizontalDragEnd: (_) {
                if (!_dragging || _points.isEmpty) {
                  _reset(animated: false);
                  return;
                }
                final xs = _points.map((p) => p.dx);
                final span = xs.reduce(math.max) - xs.reduce(math.min);
                final coverage =
                    _titleWidth > 0 ? span / _titleWidth : 0.0;
                if (coverage > 0.55) {
                  _arm();
                } else {
                  setState(() => _dragging = false);
                  _reset(animated: true);
                }
              },
              onHorizontalDragCancel: () => _reset(animated: true),
              child: AnimatedBuilder(
                animation: Listenable.merge([_fadeCtl, _polishCtl]),
                builder: (_, __) => CustomPaint(
                  foregroundPainter: _PencilStrokePainter(
                    points: _points,
                    color: color.withValues(
                        alpha: _fadeCtl.value.clamp(0.0, 1.0)),
                    active: _dragging || _armed,
                    polish: _polishCtl.value,
                  ),
                  child: Text(widget.title, style: widget.style),
                ),
              ),
            );
          },
        ),
        // Mini banner de confirmación. Aparece sólo en estado armed —
        // pulsa suave para llamar la atención sin gritar.
        AnimatedSize(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutCubic,
          alignment: Alignment.topLeft,
          child: !_armed
              ? const SizedBox.shrink()
              : Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ScaleTransition(
                        scale: Tween(begin: 1.0, end: 1.05).animate(
                          CurvedAnimation(
                            parent: _confirmPulseCtl,
                            curve: Curves.easeInOut,
                          ),
                        ),
                        child: GestureDetector(
                          onTap: _confirm,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: AppTheme.colorSuccess,
                              borderRadius: BorderRadius.circular(999),
                              boxShadow: [
                                BoxShadow(
                                  color: AppTheme.colorSuccess.withAlpha(80),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.check_rounded,
                                    size: 14, color: Colors.white),
                                const SizedBox(width: 4),
                                Text(
                                  'Confirmar',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                    fontFamily:
                                        widget.style.fontFamily,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      GestureDetector(
                        onTap: _cancel,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 5),
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(999),
                            border: Border.all(
                                color: context.dividerColor, width: 1),
                          ),
                          child: Text(
                            'Cancelar',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: context.textSecondary,
                              fontFamily: widget.style.fontFamily,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ],
    );
  }
}

class _PencilStrokePainter extends CustomPainter {
  _PencilStrokePainter({
    required this.points,
    required this.color,
    required this.active,
    required this.polish,
  });

  final List<Offset> points;
  final Color color;
  final bool active;
  /// 0..1 — al pasar a "armed" (cubrió >55%), se anima de 0→1 para
  /// repintar el squiggle como una stroke uniforme tipo "genio".
  final double polish;

  static const double _strokeWidth = 2.6;

  @override
  void paint(Canvas canvas, Size size) {
    if (!active || points.length < 2) return;

    // Path raw del usuario (con jitter natural).
    final raw = Path()..moveTo(points.first.dx, points.first.dy);
    for (var i = 1; i < points.length - 1; i++) {
      final p1 = points[i];
      final p2 = points[i + 1];
      final m = Offset((p1.dx + p2.dx) / 2, (p1.dy + p2.dy) / 2);
      raw.quadraticBezierTo(p1.dx, p1.dy, m.dx, m.dy);
    }
    raw.lineTo(points.last.dx, points.last.dy);

    // Path "pulido": una sola línea horizontal recta entre el min y
    // el max X de los puntos, a la altura promedio. Sirve como destino
    // del morph que dispara `polish` cuando se confirma.
    final xs = points.map((p) => p.dx).toList()..sort();
    final ys = points.map((p) => p.dy);
    final yAvg = ys.reduce((a, b) => a + b) / points.length;
    final polished = Path()
      ..moveTo(xs.first, yAvg)
      ..lineTo(xs.last, yAvg);

    if (polish == 0) {
      _drawStroke(canvas, raw);
    } else if (polish == 1) {
      _drawStroke(canvas, polished);
      // Overdraw sutil para que se vea el "trazo a mano confiado".
      _drawStroke(canvas, polished, strokeWidth: 1.2, alpha: 0.4);
    } else {
      // Crossfade entre raw y polished.
      _drawStroke(canvas, raw, alpha: 1 - polish);
      _drawStroke(canvas, polished, alpha: polish);
    }
  }

  void _drawStroke(Canvas canvas, Path path,
      {double strokeWidth = _strokeWidth, double alpha = 1.0}) {
    final paint = Paint()
      ..color = color.withValues(
          alpha: (color.a * alpha).clamp(0.0, 1.0))
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..strokeWidth = strokeWidth
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 0.4);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _PencilStrokePainter old) =>
      old.points != points ||
      old.color != color ||
      old.active != active ||
      old.polish != polish;
}
