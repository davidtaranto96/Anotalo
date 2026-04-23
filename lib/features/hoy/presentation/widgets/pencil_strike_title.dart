import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../core/feedback/feedback_service.dart';

/// Interacción-firma del 1.6: arrastrar el dedo horizontalmente sobre el
/// título de una tarea dibuja un trazo de lápiz que la sigue en tiempo real.
/// Al soltar:
///   - Si se cubrió > 55% del ancho del título → se dispara [onComplete]
///     y el trazo se queda pintado (después el rebuild del caller marcará
///     done=true y el stroke persistente se repinta como line-through
///     automático).
///   - Si no → el trazo se desvanece en 220ms.
///
/// Cuando la tarea ya está `done`, rendereamos el texto con
/// `TextDecoration.lineThrough` normal — el trazo a mano fue útil como
/// gesto, pero persistirlo entre builds no vale el compromiso de storage.
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
    with SingleTickerProviderStateMixin {
  final List<Offset> _points = [];
  bool _dragging = false;
  bool _settled = false; // mantenemos trazo visible un instante tras commit
  double _titleWidth = 0;
  late final AnimationController _fadeCtl;

  @override
  void initState() {
    super.initState();
    _fadeCtl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 220),
    );
  }

  @override
  void dispose() {
    _fadeCtl.dispose();
    super.dispose();
  }

  void _reset({bool animated = true}) {
    if (!animated) {
      setState(() {
        _points.clear();
        _dragging = false;
        _settled = false;
        _fadeCtl.value = 1.0;
      });
      return;
    }
    _fadeCtl.value = 1.0;
    _fadeCtl.reverse().whenComplete(() {
      if (!mounted) return;
      setState(() {
        _points.clear();
        _dragging = false;
        _settled = false;
        _fadeCtl.value = 1.0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.strokeColor ??
        Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.78);

    // Cuando la tarea quedó done, usar el lineThrough del TextStyle y no
    // pintar el CustomPaint — el usuario no va a volver a tachar algo que
    // ya está tachado.
    if (widget.done) {
      return Text(
        widget.title,
        style: widget.style.copyWith(decoration: TextDecoration.lineThrough),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        _titleWidth = constraints.maxWidth;
        return GestureDetector(
          // Sólo interceptamos arrastre horizontal; verticales dejan pasar
          // para que el scroll de la lista no se rompa.
          onHorizontalDragStart: (d) {
            FeedbackService.instance.tick();
            setState(() {
              _dragging = true;
              _settled = false;
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
            final coverage = _titleWidth > 0 ? span / _titleWidth : 0.0;
            if (coverage > 0.55) {
              setState(() {
                _dragging = false;
                _settled = true;
              });
              FeedbackService.instance.success();
              widget.onComplete();
            } else {
              setState(() => _dragging = false);
              _reset(animated: true);
            }
          },
          onHorizontalDragCancel: () => _reset(animated: true),
          child: AnimatedBuilder(
            animation: _fadeCtl,
            builder: (_, __) => CustomPaint(
              foregroundPainter: _PencilStrokePainter(
                points: _points,
                color: color.withValues(alpha: _fadeCtl.value.clamp(0.0, 1.0)),
                active: _dragging || _settled,
              ),
              child: Text(widget.title, style: widget.style),
            ),
          ),
        );
      },
    );
  }
}

class _PencilStrokePainter extends CustomPainter {
  _PencilStrokePainter({
    required this.points,
    required this.color,
    required this.active,
  });
  final List<Offset> points;
  final Color color;
  final bool active;
  static const double strokeWidth = 2.4;

  @override
  void paint(Canvas canvas, Size size) {
    if (!active || points.length < 2) return;
    final path = Path()..moveTo(points.first.dx, points.first.dy);
    for (var i = 1; i < points.length - 1; i++) {
      final p1 = points[i];
      final p2 = points[i + 1];
      final m = Offset((p1.dx + p2.dx) / 2, (p1.dy + p2.dy) / 2);
      path.quadraticBezierTo(p1.dx, p1.dy, m.dx, m.dy);
    }
    path.lineTo(points.last.dx, points.last.dy);

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..strokeWidth = strokeWidth
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 0.3);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _PencilStrokePainter old) =>
      old.points != points || old.color != color || old.active != active;
}
