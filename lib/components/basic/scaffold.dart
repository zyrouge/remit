import 'dart:math';
import 'package:flutter/widgets.dart';
import '../theme/theme.dart';

class RuiScaffold extends StatelessWidget {
  const RuiScaffold({
    required this.body,
    this.padding = defaultPadding,
    this.maxWidth,
    this.includeDevicePadding = true,
    this.scrollableBody = false,
    super.key,
  });

  final EdgeInsets padding;
  final double? maxWidth;
  final bool includeDevicePadding;
  final bool scrollableBody;
  final Widget body;

  Widget buildBody(final BuildContext context) {
    Widget child = Padding(padding: padding, child: body);
    if (scrollableBody) {
      child = SingleChildScrollView(child: child);
    }
    return Container(
      width: maxWidth != null
          ? min(maxWidth!, MediaQuery.sizeOf(context).width)
          : double.infinity,
      height: double.infinity,
      color: RuiTheme.of(context).colorScheme.background,
      padding: MediaQuery.paddingOf(context).add(padding),
      child: child,
    );
  }

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
          buildBody(context),
        ],
      ),
    );
  }

  static const EdgeInsets defaultPadding = EdgeInsets.symmetric(horizontal: 12);
}
