import 'package:flutter/widgets.dart';
import 'color_scheme.dart';

enum RuiThemeState {
  normal,
  hovered,
  active,
  disabled,
}

extension RuiThemeStateUtils on RuiColorScheme {
  Color primaryWhenState(final RuiThemeState state) => switch (state) {
        RuiThemeState.normal => primary,
        RuiThemeState.hovered => primaryVariant,
        RuiThemeState.active => primaryVariant,
        RuiThemeState.disabled => disabled,
      };

  Color onPrimaryWhenState(final RuiThemeState state) => switch (state) {
        RuiThemeState.normal => onPrimary,
        RuiThemeState.hovered => onPrimaryVariant,
        RuiThemeState.active => onPrimaryVariant,
        RuiThemeState.disabled => onDisabled,
      };

  Color surfaceWhenState(final RuiThemeState state) => switch (state) {
        RuiThemeState.normal => surface,
        RuiThemeState.hovered => surfaceVariant,
        RuiThemeState.active => surfaceVariant,
        RuiThemeState.disabled => disabled,
      };

  Color onSurfaceWhenState(final RuiThemeState state) => switch (state) {
        RuiThemeState.normal => onSurface,
        RuiThemeState.hovered => onSurfaceVariant,
        RuiThemeState.active => onSurfaceVariant,
        RuiThemeState.disabled => onDisabled,
      };
}
