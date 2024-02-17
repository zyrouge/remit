import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import '../theme/theme.dart';

class RuiDivider extends StatelessWidget {
  const RuiDivider({
    required this.direction,
    this.thickness = defaultThickness,
    this.color,
    this.size,
    super.key,
  });

  const RuiDivider.horizontal({
    this.thickness = defaultThickness,
    this.color,
    this.size,
  }) : direction = Axis.horizontal;

  const RuiDivider.vertical({
    this.thickness = defaultThickness,
    this.color,
    this.size,
  }) : direction = Axis.vertical;

  final Axis direction;
  final double thickness;
  final Color? color;
  final double? size;

  @override
  Widget build(final BuildContext context) {
    final Color resolvedColor =
        color ?? RuiTheme.of(context).colorScheme.backgroundVariant;
    return switch (direction) {
      Axis.horizontal =>
        Container(width: size, height: thickness, color: resolvedColor),
      Axis.vertical =>
        Container(width: thickness, height: size, color: resolvedColor),
    };
  }

  static const double defaultThickness = 1;
}
