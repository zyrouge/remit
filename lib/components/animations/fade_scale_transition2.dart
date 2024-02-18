import 'package:flutter/material.dart' show Easing;
import 'package:flutter/widgets.dart';

/// Modification of [FadeScaleTransition] to allow alignment.
class FadeScaleTransition2 extends StatelessWidget {
  const FadeScaleTransition2({
    required this.animation,
    this.alignment = Alignment.center,
    this.child,
    super.key,
  });

  final Animation<double> animation;
  final Alignment alignment;
  final Widget? child;

  static final Animatable<double> _fadeInTransition = CurveTween(
    curve: const Interval(0.0, 0.3),
  );
  static final Animatable<double> _scaleInTransition = Tween<double>(
    begin: 0.80,
    end: 1.00,
  ).chain(CurveTween(curve: Easing.legacyDecelerate));
  static final Animatable<double> _fadeOutTransition = Tween<double>(
    begin: 1.0,
    end: 0.0,
  );

  @override
  Widget build(final BuildContext context) => DualTransitionBuilder(
        animation: animation,
        forwardBuilder: (
          final BuildContext context,
          final Animation<double> animation,
          final Widget? child,
        ) =>
            FadeTransition(
          opacity: _fadeInTransition.animate(animation),
          child: ScaleTransition(
            alignment: alignment,
            scale: _scaleInTransition.animate(animation),
            child: child,
          ),
        ),
        reverseBuilder: (
          final BuildContext context,
          final Animation<double> animation,
          final Widget? child,
        ) =>
            FadeTransition(
          opacity: _fadeOutTransition.animate(animation),
          child: child,
        ),
        child: child,
      );
}
