import 'dart:math';

import 'package:flutter/cupertino.dart' show CupertinoIcons;
import 'package:flutter/material.dart';

class CompassView extends StatefulWidget {
  const CompassView({
    Key? key,
    required this.bearing,
    required this.heading,
    this.foregroundColor = Colors.white,
    this.bearingColor = Colors.red,
  }) : super(key: key);

  final double? bearing;
  final double heading;
  final Color foregroundColor;
  final Color bearingColor;

  @override
  State<StatefulWidget> createState() => _CompassViewState();
}

class _CompassViewState extends State<CompassView>
    with TickerProviderStateMixin {
  late AnimationController _rotationController;
  late AnimationController _pulseController;
  late Animation<double> _rotationAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    
    _rotationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _rotationAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(
      parent: _rotationController,
      curve: Curves.easeInOut,
    ));

    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    _pulseController.repeat(reverse: true);
  }

  @override
  void didUpdateWidget(CompassView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.heading != widget.heading) {
      _rotationController.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: isDark
              ? [
                  theme.colorScheme.surface,
                  theme.colorScheme.surface.withOpacity(0.8),
                  theme.colorScheme.surface.withOpacity(0.6),
                ]
              : [
                  Colors.white,
                  Colors.grey.shade50,
                  Colors.grey.shade100,
                ],
          stops: const [0.0, 0.7, 1.0],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.3 : 0.1),
            blurRadius: 20,
            spreadRadius: 5,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: AspectRatio(
        aspectRatio: 1.0,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Outer ring
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: theme.colorScheme.primary.withOpacity(0.3),
                  width: 2,
                ),
              ),
            ),
            
            // Compass Rose
            AnimatedBuilder(
              animation: _rotationAnimation,
              builder: (context, child) {
                return Transform.rotate(
                  angle: (widget.heading * pi / 180) * _rotationAnimation.value,
                  child: CustomPaint(
                    painter: _CompassViewPainter(
                      heading: 0, // We handle rotation in Transform.rotate
                      foregroundColor: theme.colorScheme.onSurface,
                      isDark: isDark,
                    ),
                  ),
                );
              },
            ),

            // Center dot with pulse animation
            Center(
              child: AnimatedBuilder(
                animation: _pulseAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _pulseAnimation.value,
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: theme.colorScheme.primary,
                        boxShadow: [
                          BoxShadow(
                            color: theme.colorScheme.primary.withOpacity(0.5),
                            blurRadius: 8,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // Bearing Indicator
            if (widget.bearing != null)
              Padding(
                padding: const EdgeInsets.all(35.0),
                child: Transform.rotate(
                  angle: (widget.bearing! - widget.heading).toRadians(),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: widget.bearingColor,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: widget.bearingColor.withOpacity(0.5),
                            blurRadius: 8,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: const Icon(
                        CupertinoIcons.arrowtriangle_up_fill,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
                ),
              ),

            // Heading text
            Positioned(
              bottom: 40,
              left: 0,
              right: 0,
              child: AnimatedBuilder(
                animation: _rotationAnimation,
                builder: (context, child) {
                  return Opacity(
                    opacity: _rotationAnimation.value,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: theme.colorScheme.primary.withOpacity(0.3),
                        ),
                      ),
                      child: Text(
                        '${widget.heading.toStringAsFixed(0)}°',
                        style: theme.textTheme.headlineMedium?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CompassViewPainter extends CustomPainter {
  _CompassViewPainter({
    required this.heading,
    required this.foregroundColor,
    this.isDark = false,
    this.majorTickCount = 12,
    this.minorTickCount = 72,
    this.cardinalities = const {0: 'N', 90: 'E', 180: 'S', 270: 'W'},
  });

  final double heading;
  final Color foregroundColor;
  final bool isDark;
  final int majorTickCount;
  final int minorTickCount;
  final CardinalityMap cardinalities;

  late final bearingIndicatorPaint = Paint()
    ..style = PaintingStyle.stroke
    ..color = foregroundColor
    ..strokeWidth = 3.0
    ..strokeCap = StrokeCap.round;

  late final majorScalePaint = Paint()
    ..style = PaintingStyle.stroke
    ..color = foregroundColor
    ..strokeWidth = 2.5
    ..strokeCap = StrokeCap.round;

  late final minorScalePaint = Paint()
    ..style = PaintingStyle.stroke
    ..color = foregroundColor.withOpacity(0.6)
    ..strokeWidth = 1.0
    ..strokeCap = StrokeCap.round;

  late final majorScaleStyle = TextStyle(
    color: foregroundColor,
    fontSize: 14,
    fontWeight: FontWeight.w600,
  );

  late final cardinalityStyle = TextStyle(
    color: foregroundColor,
    fontSize: 28,
    fontWeight: FontWeight.bold,
  );

  late final _majorTicks = _layoutScale(majorTickCount);
  late final _minorTicks = _layoutScale(minorTickCount);

  @override
  void paint(Canvas canvas, Size size) {
    assert(size.width == size.height, 'Size must be square');
    const origin = Offset.zero;
    final center = size.center(origin);
    final radius = size.width / 2;

    const tickPadding = 60.0;
    const majorTickLength = 25.0;
    const minorTickLength = 15.0;

    // Paint minor scale first (so major scale appears on top)
    for (final angle in _minorTicks) {
      if (_majorTicks.contains(angle)) continue; // Skip major ticks
      
      final tickStart = Offset.fromDirection(
        _correctedAngle(angle).toRadians(),
        radius - tickPadding,
      );

      final tickEnd = Offset.fromDirection(
        _correctedAngle(angle).toRadians(),
        radius - tickPadding - minorTickLength,
      );

      canvas.drawLine(
        center + tickStart,
        center + tickEnd,
        minorScalePaint,
      );
    }

    // Paint major scale
    for (final angle in _majorTicks) {
      final tickStart = Offset.fromDirection(
        _correctedAngle(angle).toRadians(),
        radius - tickPadding,
      );

      final tickEnd = Offset.fromDirection(
        _correctedAngle(angle).toRadians(),
        radius - tickPadding - majorTickLength,
      );

      canvas.drawLine(
        center + tickStart,
        center + tickEnd,
        majorScalePaint,
      );
    }

    // Paint bearing indicator (North arrow)
    final northTickStart = Offset.fromDirection(
      -90.toRadians(),
      radius,
    );

    final northTickEnd = Offset.fromDirection(
      -90.toRadians(),
      radius - tickPadding - majorTickLength,
    );

    canvas.drawLine(
      center + northTickStart,
      center + northTickEnd,
      bearingIndicatorPaint,
    );

    // Paint major scale numbers
    for (final angle in _majorTicks) {
      const majorScaleTextPadding = 25.0;

      final textPainter = TextSpan(
        text: angle.toStringAsFixed(0),
        style: majorScaleStyle,
      ).toPainter()
        ..layout();

      final layoutOffset = Offset.fromDirection(
        _correctedAngle(angle).toRadians(),
        radius - majorScaleTextPadding,
      );

      final offset = center + layoutOffset - textPainter.center;
      textPainter.paint(canvas, offset);
    }

    // Paint cardinality text
    for (final cardinality in cardinalities.entries) {
      const cardinalityTextPadding = 90.0;

      final angle = cardinality.key.toDouble();
      final text = cardinality.value;

      final textPainter = TextSpan(
        text: text,
        style: cardinalityStyle,
      ).toPainter()
        ..layout();

      final layoutOffset = Offset.fromDirection(
        _correctedAngle(angle).toRadians(),
        radius - cardinalityTextPadding,
      );

      final offset = center + layoutOffset - textPainter.center;
      textPainter.paint(canvas, offset);
    }
  }

  @override
  bool shouldRepaint(_CompassViewPainter oldDelegate) =>
      oldDelegate.heading != heading ||
          oldDelegate.foregroundColor != foregroundColor ||
          oldDelegate.isDark != isDark ||
          oldDelegate.majorTickCount != majorTickCount ||
          oldDelegate.minorTickCount != minorTickCount;

  List<double> _layoutScale(int ticks) {
    final scale = 360 / ticks;
    return List.generate(ticks, (i) => i * scale);
  }

  double _correctedAngle(double angle) => angle - heading - 90;
}

typedef CardinalityMap = Map<num, String>;

extension on TextPainter {
  Offset get center => size.center(Offset.zero);
}

extension on TextSpan {
  TextPainter toPainter({TextDirection textDirection = TextDirection.ltr}) =>
      TextPainter(text: this, textDirection: textDirection);
}

extension on num {
  double toRadians() => this * pi / 180;
}