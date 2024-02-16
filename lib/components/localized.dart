import 'package:flutter/widgets.dart';
import '../services/translations/translation.dart';

class RuiLocalized extends InheritedWidget {
  const RuiLocalized({
    required this.data,
    required super.child,
    super.key,
  });

  final RuiTranslation data;

  @override
  bool updateShouldNotify(final RuiLocalized oldWidget) =>
      data != oldWidget.data;

  static RuiLocalized? maybeOf(final BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<RuiLocalized>();

  static RuiLocalized of(final BuildContext context) {
    final RuiLocalized? result = maybeOf(context);
    assert(result != null, 'No RuiLocalized found in context');
    return result!;
  }
}

extension RuiLocalizedUtils on BuildContext {
  RuiTranslation get t => RuiLocalized.of(this).data;
}
