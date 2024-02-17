import 'package:flutter/widgets.dart';

class RuiVerticalContent extends StatelessWidget {
  const RuiVerticalContent({
    required this.child,
    this.spacing = defaultSpacing,
    this.leading,
    this.trailing,
    super.key,
  });

  final Widget? leading;
  final Widget child;
  final Widget? trailing;
  final double spacing;

  @override
  Widget build(final BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          if (leading != null) ...<Widget>[
            leading!,
            SizedBox(width: spacing),
          ],
          child,
          if (trailing != null) ...<Widget>[
            SizedBox(width: spacing),
            trailing!,
          ],
        ],
      );

  static const double defaultSpacing = 8;
}
