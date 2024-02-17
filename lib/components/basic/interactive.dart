import 'package:flutter/widgets.dart';

import '../theme/states.dart';

enum RuiInteractiveState {
  normal,
  hovered,
  active,
  disabled;

  RuiThemeState toThemeState() => switch (this) {
        normal => RuiThemeState.normal,
        hovered => RuiThemeState.hovered,
        active => RuiThemeState.active,
        disabled => RuiThemeState.disabled,
      };
}

typedef RuiInteractiveStateCallback<T> = T Function(
  BuildContext context,
  RuiInteractiveState state,
);
