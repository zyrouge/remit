import 'package:flutter/widgets.dart';
import 'colors.dart';

class RuiColorScheme {
  const RuiColorScheme({
    required this.primary,
    required this.onPrimary,
    required this.primaryVariant,
    required this.onPrimaryVariant,
    required this.primaryLightVariant,
    required this.onPrimaryLightVariant,
    required this.background,
    required this.onBackground,
    required this.backgroundVariant,
    required this.onBackgroundVariant,
    required this.surface,
    required this.onSurface,
    required this.surfaceVariant,
    required this.onSurfaceVariant,
    required this.disabled,
    required this.onDisabled,
    required this.dimmed,
    required this.error,
  });

  final Color primary;
  final Color onPrimary;
  final Color primaryVariant;
  final Color onPrimaryVariant;
  final Color primaryLightVariant;
  final Color onPrimaryLightVariant;
  final Color background;
  final Color onBackground;
  final Color backgroundVariant;
  final Color onBackgroundVariant;
  final Color surface;
  final Color onSurface;
  final Color surfaceVariant;
  final Color onSurfaceVariant;
  final Color disabled;
  final Color onDisabled;
  final Color dimmed;
  final Color error;

  static const RuiColorScheme light = RuiColorScheme(
    primary: RuiColors.blue500,
    onPrimary: RuiColors.white,
    primaryVariant: RuiColors.blue600,
    onPrimaryVariant: RuiColors.white,
    primaryLightVariant: RuiColors.blue400,
    onPrimaryLightVariant: RuiColors.white,
    background: RuiColors.white,
    onBackground: RuiColors.black,
    backgroundVariant: RuiColors.light100,
    onBackgroundVariant: RuiColors.black,
    surface: RuiColors.light200,
    onSurface: RuiColors.black,
    surfaceVariant: RuiColors.light300,
    onSurfaceVariant: RuiColors.black,
    disabled: RuiColors.light400,
    onDisabled: RuiColors.light600,
    dimmed: RuiColors.light600,
    error: RuiColors.red500,
  );

  static const RuiColorScheme dark = RuiColorScheme(
    primary: RuiColors.blue500,
    onPrimary: RuiColors.white,
    primaryVariant: RuiColors.blue600,
    onPrimaryVariant: RuiColors.white,
    primaryLightVariant: RuiColors.blue400,
    onPrimaryLightVariant: RuiColors.white,
    background: RuiColors.dark900,
    onBackground: RuiColors.white,
    backgroundVariant: RuiColors.dark800,
    onBackgroundVariant: RuiColors.white,
    surface: RuiColors.dark600,
    onSurface: RuiColors.white,
    surfaceVariant: RuiColors.dark700,
    onSurfaceVariant: RuiColors.white,
    disabled: RuiColors.dark500,
    onDisabled: RuiColors.dark300,
    dimmed: RuiColors.dark200,
    error: RuiColors.red500,
  );
}
