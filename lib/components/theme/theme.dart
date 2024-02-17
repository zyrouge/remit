import 'package:flutter/widgets.dart';
import 'color_scheme.dart';
import 'text_theme.dart';
import 'theme_data.dart';

class RuiTheme extends InheritedWidget {
  const RuiTheme({
    required this.data,
    required super.child,
    super.key,
  });

  final RuiThemeData data;

  @override
  bool updateShouldNotify(final RuiTheme oldWidget) => data != oldWidget.data;

  RuiColorScheme get colorScheme => data.colorScheme;
  RuiTextTheme get textTheme => data.textTheme;

  static RuiTheme? maybeOf(final BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<RuiTheme>();

  static RuiTheme of(final BuildContext context) {
    final RuiTheme? result = maybeOf(context);
    assert(result != null, 'No RuiTheme found in context');
    return result!;
  }

  static RuiColorScheme colorSchemeOf(final BuildContext context) =>
      RuiTheme.of(context).colorScheme;

  static RuiTextTheme textThemeOf(final BuildContext context) =>
      RuiTheme.of(context).textTheme;
}
