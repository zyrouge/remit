import 'package:flutter/widgets.dart';

class CrossFadeTransition extends StatelessWidget {
  const CrossFadeTransition({
    required this.animation,
    this.child,
    super.key,
  });

  final Animation<double> animation;
  final Widget? child;

  @override
  Widget build(final BuildContext context) => FadeTransition(
        opacity: animation.drive(_transformer),
        child: child,
      );

  static const Animatable<double> _transformer =
      Animatable<double>.fromCallback(_transformValue);

  static double _transformValue(final double value) =>
      value > 0.75 ? (value - 0.75) * 4 : 0;
}
