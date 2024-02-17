import 'dart:math';
import 'package:flutter/widgets.dart';
import '../theme/theme.dart';

class RuiScaffold extends StatelessWidget {
  const RuiScaffold({
    required this.body,
    this.padding,
    this.maxWidth,
    super.key,
  });

  final EdgeInsets? padding;
  final double? maxWidth;
  final Widget body;

  @override
  Widget build(final BuildContext context) => Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Container(
            width: maxWidth != null
                ? min(maxWidth!, MediaQuery.sizeOf(context).width)
                : double.infinity,
            height: double.infinity,
            color: RuiTheme.of(context).colorScheme.background,
            padding: padding,
            child: body,
          ),
        ],
      );
}
