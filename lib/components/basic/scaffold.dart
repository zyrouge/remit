import 'dart:math';
import 'package:flutter/widgets.dart';
import '../theme/theme.dart';

class RuiScaffold extends StatelessWidget {
  const RuiScaffold({
    required this.body,
    this.padding = defaultPadding,
    this.maxWidth,
    this.includeDevicePadding = true,
    super.key,
  });

  final EdgeInsets padding;
  final double? maxWidth;
  final bool includeDevicePadding;
  final Widget body;

  @override
  Widget build(final BuildContext context) {
    EdgeInsets finalPadding = padding;
    if (includeDevicePadding) {
      finalPadding = finalPadding + MediaQuery.paddingOf(context);
    }
    return MediaQuery.removePadding(
      context: context,
      removeLeft: true,
      removeTop: true,
      removeRight: true,
      removeBottom: true,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Container(
            width: maxWidth != null
                ? min(maxWidth!, MediaQuery.sizeOf(context).width)
                : double.infinity,
            height: double.infinity,
            color: RuiTheme.of(context).colorScheme.background,
            padding: MediaQuery.paddingOf(context).add(padding),
            child: body,
          ),
        ],
      ),
    );
  }

  static const EdgeInsets defaultPadding = EdgeInsets.symmetric(horizontal: 12);
}
