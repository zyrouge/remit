import 'package:flutter/widgets.dart';

import 'spacer.dart';

class RuiHorizontalContent extends StatelessWidget {
  const RuiHorizontalContent({
    required this.child,
    this.spacing = defaultSpacing,
    this.mainAxisAlignment = MainAxisAlignment.center,
    this.mainAxisSize = MainAxisSize.min,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.leading,
    this.trailing,
    super.key,
  });

  final Widget? leading;
  final Widget child;
  final Widget? trailing;
  final double spacing;
  final MainAxisAlignment mainAxisAlignment;
  final MainAxisSize mainAxisSize;
  final CrossAxisAlignment crossAxisAlignment;

  @override
  Widget build(final BuildContext context) => Row(
        mainAxisAlignment: mainAxisAlignment,
        mainAxisSize: mainAxisSize,
        crossAxisAlignment: crossAxisAlignment,
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

  static const double defaultSpacing = RuiSpacer.compactPx;
}
