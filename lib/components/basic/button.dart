import 'package:flutter/widgets.dart';
import '../theme/animation_durations.dart';
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
    required this.borderRadius,
    required this.width,
    required this.height,
  });

  factory RuiButtonTheme.primary({
    final TextStyle? textStyle,
    final EdgeInsets? padding,
    final BorderRadius? borderRadius,
    final double? width,
    final double? height,
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
        borderRadius: borderRadius ?? defaultBorderRadius,
        width: width,
        height: height,
      );

  factory RuiButtonTheme.surface({
    final TextStyle? textStyle,
    final EdgeInsets? padding,
    final BorderRadius? borderRadius,
    final double? width,
    final double? height,
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
        borderRadius: borderRadius ?? defaultBorderRadius,
        width: width,
        height: height,
      );

  final RuiButtonStatedValue<Color> color;
  final RuiButtonStatedValue<TextStyle> textStyle;
  final EdgeInsets padding;
  final BorderRadius borderRadius;
  final double? height;
  final double? width;

  static final BorderRadius defaultBorderRadius = BorderRadius.circular(8);
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
        cursor: SystemMouseCursors.click,
        onEnter: (final _) => updateHovered(true),
        onExit: (final _) => updateHovered(false),
        child: AnimatedContainer(
          duration: RuiAnimationDurations.quickest,
          alignment: Alignment.center,
          width: widget.theme.width,
          height: widget.theme.height,
          padding: widget.theme.padding,
          decoration: BoxDecoration(
            color: widget.theme.color(context, state),
            borderRadius: widget.theme.borderRadius,
          ),
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
