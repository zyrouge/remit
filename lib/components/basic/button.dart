import 'package:flutter/widgets.dart';
import '../theme/animation_durations.dart';
import '../theme/color_scheme.dart';
import '../theme/states.dart';
import '../theme/theme.dart';
import 'interactive.dart';

class RuiButtonStyle {
  const RuiButtonStyle({
    required this.color,
    required this.textStyle,
    required this.padding,
    required this.borderRadius,
    this.width,
    this.height,
  });

  factory RuiButtonStyle.primary({
    final TextStyle? textStyle,
    final EdgeInsets? padding,
    final BorderRadius? borderRadius,
    final double? width,
    final double? height,
  }) =>
      RuiButtonStyle(
        color: (final BuildContext context, final RuiInteractiveState state) =>
            RuiTheme.of(context)
                .colorScheme
                .primaryWhenState(state.toThemeState()),
        textStyle:
            (final BuildContext context, final RuiInteractiveState state) {
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

  factory RuiButtonStyle.surface({
    final TextStyle? textStyle,
    final EdgeInsets? padding,
    final BorderRadius? borderRadius,
    final double? width,
    final double? height,
  }) =>
      RuiButtonStyle(
        color: (final BuildContext context, final RuiInteractiveState state) =>
            RuiTheme.of(context)
                .colorScheme
                .surfaceWhenState(state.toThemeState()),
        textStyle:
            (final BuildContext context, final RuiInteractiveState state) {
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

  final RuiInteractiveStateCallback<Color> color;
  final RuiInteractiveStateCallback<TextStyle> textStyle;
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
    required this.style,
    required this.child,
    required this.onClick,
    this.enabled = true,
    super.key,
  });

  final RuiButtonStyle style;
  final bool enabled;
  final Widget child;
  final VoidCallback onClick;

  @override
  State<RuiButton> createState() => _RuiButtonState();
}

class _RuiButtonState extends State<RuiButton> {
  bool isHovered = false;
  bool isFocused = false;

  RuiInteractiveState toInteractiveState() {
    if (!widget.enabled) return RuiInteractiveState.disabled;
    if (isFocused) return RuiInteractiveState.active;
    if (isHovered) return RuiInteractiveState.hovered;
    return RuiInteractiveState.normal;
  }

  @override
  Widget build(final BuildContext context) {
    final RuiInteractiveState state = toInteractiveState();
    return Focus(
      canRequestFocus: true,
      onFocusChange: (final bool focused) {
        setState(() {
          isFocused = focused;
        });
      },
      child: GestureDetector(
        onTap: widget.onClick,
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          onEnter: (final _) => updateHovered(true),
          onExit: (final _) => updateHovered(false),
          child: AnimatedContainer(
            duration: RuiAnimationDurations.quickest,
            alignment: Alignment.center,
            width: widget.style.width,
            height: widget.style.height,
            padding: widget.style.padding,
            decoration: BoxDecoration(
              color: widget.style.color(context, state),
              borderRadius: widget.style.borderRadius,
              // border: widget.style.strokeColor != null
              //     ? Border.all(color: widget.style.strokeColor!(context, state))
              //     : null,
            ),
            child: AnimatedDefaultTextStyle(
              duration: RuiAnimationDurations.quickest,
              style: widget.style.textStyle(context, state),
              child: widget.child,
            ),
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
