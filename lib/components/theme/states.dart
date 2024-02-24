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
        RuiThemeState.hovered || RuiThemeState.active => primaryVariant,
        RuiThemeState.disabled => disabled,
      };

  Color onPrimaryWhenState(final RuiThemeState state) => switch (state) {
        RuiThemeState.normal => onPrimary,
        RuiThemeState.hovered || RuiThemeState.active => onPrimaryVariant,
        RuiThemeState.disabled => onDisabled,
      };

  Color backgroundWhenState(final RuiThemeState state) => switch (state) {
        RuiThemeState.normal => background,
        RuiThemeState.hovered || RuiThemeState.active => backgroundVariant,
        RuiThemeState.disabled => background,
      };

  Color onBackgroundWhenState(final RuiThemeState state) => switch (state) {
        RuiThemeState.normal => onBackground,
        RuiThemeState.hovered || RuiThemeState.active => onBackgroundVariant,
        RuiThemeState.disabled => onDisabled,
      };

  Color surfaceWhenState(final RuiThemeState state) => switch (state) {
        RuiThemeState.normal => surface,
        RuiThemeState.hovered || RuiThemeState.active => surfaceVariant,
        RuiThemeState.disabled => disabled,
      };

  Color onSurfaceWhenState(final RuiThemeState state) => switch (state) {
        RuiThemeState.normal => onSurface,
        RuiThemeState.hovered || RuiThemeState.active => onSurfaceVariant,
        RuiThemeState.disabled => onDisabled,
      };

  Color errorWhenState(final RuiThemeState state) => switch (state) {
        RuiThemeState.normal => error,
        RuiThemeState.hovered || RuiThemeState.active => errorVariant,
        RuiThemeState.disabled => disabled,
      };

  Color onErrorWhenState(final RuiThemeState state) => switch (state) {
        RuiThemeState.normal => onError,
        RuiThemeState.hovered || RuiThemeState.active => onErrorVariant,
        RuiThemeState.disabled => onDisabled,
      };
}
