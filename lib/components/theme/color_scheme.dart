import 'package:flutter/widgets.dart';
import 'colors.dart';

class RuiColorScheme {
  const RuiColorScheme({
    required this.primary,
    required this.onPrimary,
    required this.primaryVariant,
    required this.onPrimaryVariant,
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
  });

  final Color primary;
  final Color onPrimary;
  final Color primaryVariant;
  final Color onPrimaryVariant;
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

  static const RuiColorScheme light = RuiColorScheme(
    primary: RuiColors.blue500,
    onPrimary: RuiColors.white,
    primaryVariant: RuiColors.blue400,
    onPrimaryVariant: RuiColors.white,
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
  );

  static const RuiColorScheme dark = RuiColorScheme(
    primary: RuiColors.blue500,
    onPrimary: RuiColors.white,
    primaryVariant: RuiColors.blue600,
    onPrimaryVariant: RuiColors.white,
    background: RuiColors.dark900,
    onBackground: RuiColors.white,
    backgroundVariant: RuiColors.dark800,
    onBackgroundVariant: RuiColors.white,
    surface: RuiColors.dark700,
    onSurface: RuiColors.white,
    surfaceVariant: RuiColors.dark600,
    onSurfaceVariant: RuiColors.white,
    disabled: RuiColors.dark500,
    onDisabled: RuiColors.dark300,
    dimmed: RuiColors.dark300,
  );
}
