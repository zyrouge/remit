import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import '../theme/theme.dart';

class RuiSplashLoadingIndicator extends StatefulWidget {
  const RuiSplashLoadingIndicator({
    super.key,
  });

  @override
  State<RuiSplashLoadingIndicator> createState() =>
      _RuiSplashLoadingIndicatorState();
}

class _RuiSplashLoadingIndicatorState extends State<RuiSplashLoadingIndicator> {
  Widget buildCircle(
    final BuildContext context, {
    required final BoxBorder border,
  }) =>
      Stack(
        children: <Widget>[
          Container(
            width: 35,
            height: 35,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: border,
            ),
          ),
        ],
      );

  @override
  Widget build(final BuildContext context) => Stack(
        children: <Widget>[
          buildCircle(
            context,
            border: Border.all(
              color: RuiTheme.of(context).colorScheme.backgroundVariant,
              width: 5,
            ),
          ),
          buildCircle(
            context,
            border: Border(
              top: BorderSide(
                color: RuiTheme.of(context).colorScheme.primary,
                width: 5,
              ),
            ),
          ),
        ],
      );
}
