import 'package:flutter/widgets.dart';
import '../theme/color_scheme.dart';
import '../theme/states.dart';
import '../theme/theme.dart';

enum RuiButtonState {
  normal,
  hovered,
  active,
  disabled;

  RuiThemeState toThemeState() => switch (this) {
        RuiButtonState.normal => RuiThemeState.normal,
        RuiButtonState.hovered => RuiThemeState.hovered,
        RuiButtonState.active => RuiThemeState.active,
        RuiButtonState.disabled => RuiThemeState.disabled,
      };
}

typedef RuiButtonStatedValue<T> = T Function(
  BuildContext context,
  RuiButtonState state,
);

class RuiButtonTheme {
  const RuiButtonTheme({
    required this.color,
    required this.textStyle,
    required this.padding,
  });

  factory RuiButtonTheme.primary({
    final TextStyle? textStyle,
    final EdgeInsets? padding,
  }) =>
      RuiButtonTheme(
        color: (final BuildContext context, final RuiButtonState state) =>
            RuiTheme.of(context)
                .colorScheme
                .primaryWhenState(state.toThemeState()),
        textStyle: (final BuildContext context, final RuiButtonState state) {
          final RuiTheme theme = RuiTheme.of(context);
          final RuiColorScheme colorScheme = theme.colorScheme;
          final TextStyle nTextStyle = textStyle ?? theme.textTheme.body;
          final Color color =
              colorScheme.onPrimaryWhenState(state.toThemeState());
          return nTextStyle.copyWith(color: color);
        },
        padding: padding ?? defaultPadding,
      );

  factory RuiButtonTheme.surface({
    final TextStyle? textStyle,
    final EdgeInsets? padding,
  }) =>
      RuiButtonTheme(
        color: (final BuildContext context, final RuiButtonState state) =>
            RuiTheme.of(context)
                .colorScheme
                .surfaceWhenState(state.toThemeState()),
        textStyle: (final BuildContext context, final RuiButtonState state) {
          final RuiTheme theme = RuiTheme.of(context);
          final RuiColorScheme colorScheme = theme.colorScheme;
          final TextStyle nTextStyle = textStyle ?? theme.textTheme.body;
          final Color color =
              colorScheme.onSurfaceWhenState(state.toThemeState());
          return nTextStyle.copyWith(color: color);
        },
        padding: padding ?? defaultPadding,
      );

  final RuiButtonStatedValue<Color> color;
  final RuiButtonStatedValue<TextStyle> textStyle;
  final EdgeInsets padding;

  static const EdgeInsets defaultPadding =
      EdgeInsets.symmetric(horizontal: 12, vertical: 8);
}

class RuiButton extends StatefulWidget {
  const RuiButton({
    required this.theme,
    required this.child,
    required this.onClick,
    this.enabled = true,
    super.key,
  });

  final RuiButtonTheme theme;
  final bool enabled;
  final Widget child;
  final VoidCallback onClick;

  @override
  State<RuiButton> createState() => _RuiButtonState();
}

class _RuiButtonState extends State<RuiButton> {
  bool isHovered = false;

  RuiButtonState toButtonState() {
    if (!widget.enabled) return RuiButtonState.disabled;
    if (isHovered) return RuiButtonState.hovered;
    return RuiButtonState.normal;
  }

  @override
  Widget build(final BuildContext context) {
    final RuiButtonState state = toButtonState();
    return GestureDetector(
      onTap: widget.onClick,
      child: MouseRegion(
        onEnter: (final _) => updateHovered(true),
        onExit: (final _) => updateHovered(false),
        child: AnimatedContainer(
          duration: Duration(milliseconds: 50),
          color: widget.theme.color(context, state),
          padding: widget.theme.padding,
          child: DefaultTextStyle.merge(
            style: widget.theme.textStyle(context, state),
            child: widget.child,
          ),
        ),
      ),
    );
  }

  void updateHovered(final bool value) {
    setState(() {
      isHovered = value;
    });
  }
}
