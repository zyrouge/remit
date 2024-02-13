import 'package:flutter/widgets.dart';
import '../theme/theme.dart';

class RuiScaffold extends StatelessWidget {
  const RuiScaffold({
    required this.child,
    this.padding,
    super.key,
  });

  final EdgeInsets? padding;
  final Widget child;

  @override
  Widget build(final BuildContext context) => Container(
        color: RuiTheme.of(context).colorScheme.background,
        padding: padding,
        child: child,
      );
}
