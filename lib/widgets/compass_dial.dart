import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Rotating compass rose. The card turns so the current heading sits under
/// the fixed lubber line at the top; North is highlighted in red and an
/// optional locked bearing is drawn as a marker on the bezel.
class CompassDial extends StatelessWidget {
  const CompassDial({
    super.key,
    required this.heading,
    required this.cardinals,
    this.targetBearing,
    this.onCourse = false,
  });

  /// Degrees clockwise from north, already smoothed.
  final double heading;

  /// Localized labels for N, E, S, W (in that order).
  final List<String> cardinals;
  final double? targetBearing;
  final bool onCourse;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return AspectRatio(
      aspectRatio: 1,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final size = constraints.biggest.shortestSide;
          return CustomPaint(
            painter: _DialPainter(
              heading: heading,
              targetBearing: targetBearing,
              onCourse: onCourse,
              cardinals: cardinals,
              faceColor: scheme.surfaceContainerLow,
              bezelColor: scheme.surfaceContainerHighest,
              tickColor: scheme.onSurfaceVariant,
              labelColor: scheme.onSurface,
              northColor: const Color(0xFFE53935),
              accentColor: scheme.primary,
              courseColor: const Color(0xFF43A047),
              labelFamily: theme.textTheme.titleLarge?.fontFamily,
              size: size,
            ),
          );
        },
      ),
    );
  }
}

class _DialPainter extends CustomPainter {
  _DialPainter({
    required this.heading,
    required this.targetBearing,
    required this.onCourse,
    required this.cardinals,
    required this.faceColor,
    required this.bezelColor,
    required this.tickColor,
    required this.labelColor,
    required this.northColor,
    required this.accentColor,
    required this.courseColor,
    required this.labelFamily,
    required this.size,
  });

  final double heading;
  final double? targetBearing;
  final bool onCourse;
  final List<String> cardinals;
  final Color faceColor;
  final Color bezelColor;
  final Color tickColor;
  final Color labelColor;
  final Color northColor;
  final Color accentColor;
  final Color courseColor;
  final String? labelFamily;
  final double size;

  static double _rad(double deg) => deg * math.pi / 180;

  /// Screen angle for a compass bearing, given the card rotation.
  double _screen(double bearing) => _rad(bearing - heading - 90);

  Offset _at(Offset c, double r, double a) =>
      c + Offset(math.cos(a) * r, math.sin(a) * r);

  void _text(
    Canvas canvas,
    String text,
    Offset center,
    TextStyle style, {
    double rotation = 0,
  }) {
    final tp = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
    )..layout();
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(rotation);
    tp.paint(canvas, Offset(-tp.width / 2, -tp.height / 2));
    canvas.restore();
  }

  @override
  void paint(Canvas canvas, Size s) {
    final c = s.center(Offset.zero);
    final r = s.shortestSide / 2;

    // Bezel and face with a soft shadow.
    canvas.drawCircle(
      c.translate(0, r * 0.03),
      r * 0.98,
      Paint()
        ..color = Colors.black.withValues(alpha: 0.18)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, r * 0.05),
    );
    canvas.drawCircle(c, r * 0.98, Paint()..color = bezelColor);
    canvas.drawCircle(c, r * 0.80, Paint()..color = faceColor);

    // Degree ticks on the rotating bezel.
    for (var d = 0; d < 360; d += 2) {
      final a = _screen(d.toDouble());
      final major = d % 30 == 0;
      final mid = d % 10 == 0;
      final outer = r * 0.95;
      final len = major ? r * 0.09 : (mid ? r * 0.06 : r * 0.03);
      canvas.drawLine(
        _at(c, outer, a),
        _at(c, outer - len, a),
        Paint()
          ..color = d == 0
              ? northColor
              : tickColor.withValues(alpha: major ? 0.95 : (mid ? 0.6 : 0.3))
          ..strokeWidth = major ? r * 0.014 : r * 0.007
          ..strokeCap = StrokeCap.round,
      );
    }

    // Degree numbers every 30°, skipping the cardinals.
    final numberStyle = TextStyle(
      color: tickColor,
      fontSize: r * 0.065,
      fontWeight: FontWeight.w600,
      fontFamily: labelFamily,
    );
    for (var d = 30; d < 360; d += 30) {
      if (d % 90 == 0) continue;
      final a = _screen(d.toDouble());
      _text(
        canvas,
        '$d',
        _at(c, r * 0.73, a),
        numberStyle,
        rotation: a + math.pi / 2,
      );
    }

    // Cardinal letters.
    for (var i = 0; i < 4; i++) {
      final a = _screen(i * 90.0);
      _text(
        canvas,
        cardinals[i],
        _at(c, r * 0.68, a),
        TextStyle(
          color: i == 0 ? northColor : labelColor,
          fontSize: r * (i == 0 ? 0.15 : 0.12),
          fontWeight: FontWeight.w800,
          fontFamily: labelFamily,
        ),
        rotation: a + math.pi / 2,
      );
    }

    // Inner rose: 8 slim points, north point in red.
    canvas.drawCircle(
      c,
      r * 0.50,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = r * 0.006
        ..color = tickColor.withValues(alpha: 0.25),
    );
    for (var i = 0; i < 8; i++) {
      final a = _screen(i * 45.0);
      final principal = i.isEven;
      final tip = _at(c, r * (principal ? 0.48 : 0.32), a);
      final side = r * (principal ? 0.06 : 0.04);
      final left = _at(c, side, a - math.pi / 2);
      final right = _at(c, side, a + math.pi / 2);
      final color = i == 0
          ? northColor
          : (principal
                ? labelColor.withValues(alpha: 0.75)
                : tickColor.withValues(alpha: 0.35));
      canvas.drawPath(
        Path()
          ..moveTo(tip.dx, tip.dy)
          ..lineTo(left.dx, left.dy)
          ..lineTo(right.dx, right.dy)
          ..close(),
        Paint()..color = color,
      );
    }

    // Locked bearing marker on the bezel.
    if (targetBearing != null) {
      final a = _screen(targetBearing!);
      final color = onCourse ? courseColor : accentColor;
      canvas.drawArc(
        Rect.fromCircle(center: c, radius: r * 0.885),
        a - _rad(4),
        _rad(8),
        false,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = r * 0.13
          ..strokeCap = StrokeCap.round
          ..color = color.withValues(alpha: 0.35),
      );
      canvas.drawCircle(
        _at(c, r * 0.885, a),
        r * 0.035,
        Paint()..color = color,
      );
    }

    // Hub.
    canvas.drawCircle(c, r * 0.07, Paint()..color = bezelColor);
    canvas.drawCircle(c, r * 0.035, Paint()..color = accentColor);

    // Fixed lubber line at the top (where the phone points).
    final top = Offset(c.dx, c.dy - r);
    final lubber = Path()
      ..moveTo(top.dx, top.dy + r * 0.17)
      ..lineTo(top.dx - r * 0.055, top.dy - r * 0.005)
      ..lineTo(top.dx + r * 0.055, top.dy - r * 0.005)
      ..close();
    canvas.drawPath(
      lubber,
      Paint()..color = onCourse ? courseColor : accentColor,
    );
  }

  @override
  bool shouldRepaint(_DialPainter old) =>
      old.heading != heading ||
      old.targetBearing != targetBearing ||
      old.onCourse != onCourse ||
      old.faceColor != faceColor ||
      old.labelColor != labelColor ||
      old.cardinals != cardinals ||
      old.size != size;
}
