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

  static const double tightPx = 4;
  static const double compactPx = 8;
  static const double normalPx = 12;
  static const double relaxedPx = 16;
  static const double cozyPx = 24;

  static const RuiSpacer horizontalTight = RuiSpacer.horizontal(tightPx);
  static const RuiSpacer horizontalCompact = RuiSpacer.horizontal(compactPx);
  static const RuiSpacer horizontalNormal = RuiSpacer.horizontal(normalPx);
  static const RuiSpacer horizontalRelaxed = RuiSpacer.horizontal(relaxedPx);
  static const RuiSpacer horizontalCozy = RuiSpacer.horizontal(cozyPx);

  static const RuiSpacer verticalTight = RuiSpacer.vertical(tightPx);
  static const RuiSpacer verticalCompact = RuiSpacer.vertical(compactPx);
  static const RuiSpacer verticalNormal = RuiSpacer.vertical(normalPx);
  static const RuiSpacer verticalRelaxed = RuiSpacer.vertical(relaxedPx);
  static const RuiSpacer verticalCozy = RuiSpacer.vertical(cozyPx);
}
