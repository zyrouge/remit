import 'dart:math';
import 'package:flutter/widgets.dart';
import '../theme/color_scheme.dart';
import '../theme/theme.dart';

class RuiCircularLoadingIndicatorStyle {
  const RuiCircularLoadingIndicatorStyle({
    required this.foregroundColor,
    required this.backgroundColor,
    required this.size,
    this.strokeWidth = defaultStrokeWidth,
    this.duration = defaultDuration,
  });

  factory RuiCircularLoadingIndicatorStyle.primary(
    final BuildContext context, {
    required final double size,
    final Duration? duration,
    final double? strokeWidth,
  }) {
    final RuiColorScheme colorScheme = RuiTheme.colorSchemeOf(context);
    return RuiCircularLoadingIndicatorStyle(
      foregroundColor: colorScheme.primary,
      backgroundColor: colorScheme.backgroundVariant,
      size: size,
      strokeWidth: strokeWidth ?? defaultStrokeWidth,
      duration: duration ?? defaultDuration,
    );
  }

  factory RuiCircularLoadingIndicatorStyle.onPrimary(
    final BuildContext context, {
    required final double size,
    final Duration? duration,
    final double? strokeWidth,
  }) {
    final RuiColorScheme colorScheme = RuiTheme.colorSchemeOf(context);
    return RuiCircularLoadingIndicatorStyle(
      foregroundColor: colorScheme.onPrimary,
      backgroundColor: colorScheme.onPrimary.withOpacity(0.25),
      size: size,
      strokeWidth: strokeWidth ?? defaultStrokeWidth,
      duration: duration ?? defaultDuration,
    );
  }

  final Color foregroundColor;
  final Color backgroundColor;
  final Duration duration;
  final double size;
  final double strokeWidth;

  static const Duration defaultDuration = Duration(milliseconds: 650);
  static const double defaultStrokeWidth = 2;
}

class RuiCircularLoadingIndicator extends StatefulWidget {
  const RuiCircularLoadingIndicator({
    required this.style,
    super.key,
  });

  final RuiCircularLoadingIndicatorStyle style;

  @override
  State<RuiCircularLoadingIndicator> createState() =>
      _RuiCircularLoadingIndicatorState();
}

class _RuiCircularLoadingIndicatorState
    extends State<RuiCircularLoadingIndicator>
    with SingleTickerProviderStateMixin {
  late final AnimationController animationController;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: widget.style.duration,
    );
    animationController.repeat();
  }

  @override
  void dispose() {
    super.dispose();
    animationController.dispose();
  }

  @override
  Widget build(final BuildContext context) => AnimatedBuilder(
        animation: animationController,
        builder: (final BuildContext context, final Widget? child) =>
            RotationTransition(
          turns: animationController,
          child: child,
        ),
        child: CustomPaint(
          size: Size.square(widget.style.size),
          foregroundPainter: _RuiCircleLoadingIndicatorArc(
            color: widget.style.foregroundColor,
            strokeWidth: widget.style.strokeWidth,
          ),
          painter: _RuiCircleLoadingBackgroundArc(
            color: widget.style.backgroundColor,
            strokeWidth: widget.style.strokeWidth,
          ),
        ),
      );
}

class _RuiCircleLoadingIndicatorArc extends CustomPainter {
  _RuiCircleLoadingIndicatorArc({
    required this.color,
    required this.strokeWidth,
  }) : painter = Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth
          ..strokeCap = StrokeCap.square;

  final Color color;
  final double strokeWidth;
  final Paint painter;

  @override
  void paint(final Canvas canvas, final Size size) {
    final Offset center = Offset(size.width / 2, size.height / 2);
    final double radius = (min(size.width, size.height) - strokeWidth) / 2;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      0,
      pi / 2,
      false,
      painter,
    );
  }

  @override
  bool shouldRepaint(final CustomPainter oldDelegate) => true;
}

class _RuiCircleLoadingBackgroundArc extends CustomPainter {
  _RuiCircleLoadingBackgroundArc({
    required this.color,
    required this.strokeWidth,
  }) : painter = Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth
          ..strokeCap = StrokeCap.square;

  final Color color;
  final double strokeWidth;
  final Paint painter;

  @override
  void paint(final Canvas canvas, final Size size) {
    final Offset center = Offset(size.width / 2, size.height / 2);
    final double radius = (min(size.width, size.height) - strokeWidth) / 2;
    canvas.drawCircle(
      center,
      radius,
      painter,
    );
  }

  @override
  bool shouldRepaint(final CustomPainter oldDelegate) => true;
}
