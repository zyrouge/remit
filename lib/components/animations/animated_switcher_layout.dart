import 'package:flutter/widgets.dart';

class AnimatedSwitcherStackedLayout {
  const AnimatedSwitcherStackedLayout({
    required this.alignment,
  });

  const AnimatedSwitcherStackedLayout.topLeft() : alignment = Alignment.topLeft;
  const AnimatedSwitcherStackedLayout.center() : alignment = Alignment.center;

  final Alignment alignment;

  Widget build(
    final Widget? currentChild,
    final List<Widget> previousChildren,
  ) =>
      Stack(
        alignment: alignment,
        children: <Widget>[
          ...previousChildren,
          if (currentChild != null) currentChild,
        ],
      );
}
