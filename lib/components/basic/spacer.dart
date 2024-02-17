import 'package:flutter/widgets.dart';

class RuiSpacer extends StatelessWidget {
  const RuiSpacer({
    required this.direction,
    required this.size,
    super.key,
  });

  const RuiSpacer.horizontal(this.size) : direction = Axis.horizontal;
  const RuiSpacer.vertical(this.size) : direction = Axis.vertical;

  final Axis direction;
  final double size;

  @override
  Widget build(final BuildContext context) => switch (direction) {
        Axis.horizontal => SizedBox(width: size),
        Axis.vertical => SizedBox(height: size),
      };

  static const double tightPx = 8;
  static const double normalPx = 12;
  static const double relaxedPx = 16;

  static const RuiSpacer horizontalTight = RuiSpacer.horizontal(tightPx);
  static const RuiSpacer horizontalNormal = RuiSpacer.horizontal(normalPx);
  static const RuiSpacer horizontalRelaxed = RuiSpacer.horizontal(relaxedPx);

  static const RuiSpacer verticalTight = RuiSpacer.vertical(tightPx);
  static const RuiSpacer verticalNormal = RuiSpacer.vertical(normalPx);
  static const RuiSpacer verticalRelaxed = RuiSpacer.vertical(relaxedPx);
}