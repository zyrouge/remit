import 'dart:math';
import 'package:flutter/widgets.dart';
import '../theme/theme.dart';

class RuiScaffold extends StatelessWidget {
  const RuiScaffold({
    required this.body,
    this.padding = defaultPadding,
    this.includeDevicePadding = true,
    this.scrollableBody = false,
    this.maxWidth,
    this.overlays,
    super.key,
  });

  final EdgeInsets padding;
  final double? maxWidth;
  final bool includeDevicePadding;
  final bool scrollableBody;
  final Widget body;
  final List<Widget>? overlays;

  Widget buildBody(final BuildContext context) {
    Widget child = Padding(padding: calculatePadding(context), child: body);
    if (scrollableBody) {
      child = SingleChildScrollView(child: child);
    }
    return Container(
      width: maxWidth != null
          ? min(maxWidth!, MediaQuery.sizeOf(context).width)
          : double.infinity,
      height: double.infinity,
      color: RuiTheme.of(context).colorScheme.background,
      child: child,
    );
  }

  @override
  Widget build(final BuildContext context) => MediaQuery.removePadding(
        context: context,
        removeLeft: true,
        removeTop: true,
        removeRight: true,
        removeBottom: true,
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            buildBody(context),
            if (overlays != null) ...overlays!,
          ],
        ),
      );

  EdgeInsets calculatePadding(final BuildContext context) {
    if (includeDevicePadding) {
      return padding + MediaQuery.paddingOf(context);
    }
    return padding;
  }

  static const EdgeInsets defaultPadding =
      EdgeInsets.symmetric(horizontal: 12, vertical: 4);
}
