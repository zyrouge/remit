import 'package:flutter/widgets.dart';
import 'theme_data.dart';

class Theme extends InheritedWidget {
  const Theme({
    required this.themeData,
    required super.child,
    super.key,
  });

  final RuiThemeData themeData;

  @override
  bool updateShouldNotify(final Theme oldWidget) =>
      themeData != oldWidget.themeData;

  static Theme? maybeOf(final BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<Theme>();

  static Theme of(final BuildContext context) {
    final Theme? result = maybeOf(context);
    assert(result != null, 'No FrogColor found in context');
    return result!;
  }
}
