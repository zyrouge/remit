import 'package:flutter/widgets.dart';

class RuiIcon extends StatelessWidget {
  const RuiIcon(
    this.icon, {
    this.size = defaultSize,
    this.color,
    super.key,
  });

  final IconData icon;
  final double size;
  final Color? color;

  @override
  Widget build(final BuildContext context) => Icon(
        icon,
        size: size,
        color: color ?? DefaultTextStyle.of(context).style.color,
      );

  static const double defaultSize = 16;
}
