import 'package:flutter/widgets.dart';
import '../theme/animation_durations.dart';
import '../theme/color_scheme.dart';
import '../theme/colors.dart';
import '../theme/states.dart';
import '../theme/theme.dart';
import 'interactive.dart';

class RuiButtonStyle {
  const RuiButtonStyle({
    required this.color,
    required this.textStyle,
    this.padding = defaultPadding,
    this.borderRadius = defaultBorderRadius,
    this.strokeColor,
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
          final TextStyle nTextStyle =
              textStyle ?? DefaultTextStyle.of(context).style;
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
          final TextStyle nTextStyle =
              textStyle ?? DefaultTextStyle.of(context).style;
          final Color color =
              colorScheme.onSurfaceWhenState(state.toThemeState());
          return nTextStyle.copyWith(color: color);
        },
        padding: padding ?? defaultPadding,
        borderRadius: borderRadius ?? defaultBorderRadius,
        width: width,
        height: height,
      );

  factory RuiButtonStyle.error({
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
                .errorWhenState(state.toThemeState()),
        textStyle:
            (final BuildContext context, final RuiInteractiveState state) {
          final RuiTheme theme = RuiTheme.of(context);
          final RuiColorScheme colorScheme = theme.colorScheme;
          final TextStyle nTextStyle =
              textStyle ?? DefaultTextStyle.of(context).style;
          final Color color =
              colorScheme.onErrorWhenState(state.toThemeState());
          return nTextStyle.copyWith(color: color);
        },
        padding: padding ?? defaultPadding,
        borderRadius: borderRadius ?? defaultBorderRadius,
        width: width,
        height: height,
      );

  factory RuiButtonStyle.outlined({
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
                .backgroundWhenState(state.toThemeState()),
        strokeColor:
            (final BuildContext context, final RuiInteractiveState state) {
          final RuiColorScheme colorScheme = RuiTheme.colorSchemeOf(context);
          return switch (state) {
            RuiInteractiveState.active ||
            RuiInteractiveState.hovered =>
              colorScheme.surface,
            _ => colorScheme.backgroundVariant,
          };
        },
        textStyle:
            (final BuildContext context, final RuiInteractiveState state) {
          final RuiTheme theme = RuiTheme.of(context);
          final RuiColorScheme colorScheme = theme.colorScheme;
          final TextStyle nTextStyle =
              textStyle ?? DefaultTextStyle.of(context).style;
          final Color color =
              colorScheme.onSurfaceWhenState(state.toThemeState());
          return nTextStyle.copyWith(color: color);
        },
        padding: padding ?? defaultPadding,
        borderRadius: borderRadius ?? defaultBorderRadius,
        width: width,
        height: height,
      );

  factory RuiButtonStyle.text({
    final TextStyle? textStyle,
    final EdgeInsets? padding,
    final BorderRadius? borderRadius,
    final double? width,
    final double? height,
  }) =>
      RuiButtonStyle(
        color: (final BuildContext context, final RuiInteractiveState state) {
          final RuiColorScheme colorScheme = RuiTheme.colorSchemeOf(context);
          if (state == RuiInteractiveState.active) {
            return colorScheme.backgroundVariant.withValues(alpha: 0.5);
          }
          return RuiColors.transparent;
        },
        strokeColor: (final _, final __) => RuiColors.transparent,
        textStyle:
            (final BuildContext context, final RuiInteractiveState state) {
          final RuiTheme theme = RuiTheme.of(context);
          final RuiColorScheme colorScheme = theme.colorScheme;
          final TextStyle nTextStyle =
              textStyle ?? DefaultTextStyle.of(context).style;
          final Color? color = switch (state) {
            RuiInteractiveState.normal => null,
            RuiInteractiveState.active ||
            RuiInteractiveState.hovered =>
              colorScheme.primaryLightVariant,
            RuiInteractiveState.disabled => colorScheme.disabled,
          };
          return nTextStyle.copyWith(color: color);
        },
        padding: padding ?? defaultPadding,
        borderRadius: borderRadius ?? defaultBorderRadius,
        width: width,
        height: height,
      );

  final RuiInteractiveStateCallback<Color> color;
  final RuiInteractiveStateCallback<Color>? strokeColor;
  final RuiInteractiveStateCallback<TextStyle> textStyle;
  final EdgeInsets padding;
  final BorderRadius borderRadius;
  final double? height;
  final double? width;

  static const BorderRadius defaultBorderRadius =
      BorderRadius.all(Radius.circular(8));

  static const EdgeInsets defaultPadding =
      EdgeInsets.symmetric(horizontal: 12, vertical: 8);
}

class RuiButton extends StatefulWidget {
  const RuiButton({
    required this.style,
    required this.child,
    required this.onClick,
    this.enabled = true,
    this.active = false,
    super.key,
  });

  final RuiButtonStyle style;
  final bool enabled;
  final bool active;
  final Widget child;
  final VoidCallback onClick;

  @override
  State<RuiButton> createState() => _RuiButtonState();
}

class _RuiButtonState extends State<RuiButton> {
  bool isHovered = false;
  bool isFocused = false;

  RuiInteractiveState toInteractiveState() {
    if (!widget.enabled) {
      return RuiInteractiveState.disabled;
    }
    if (widget.active) {
      return RuiInteractiveState.active;
    }
    if (isFocused) {
      return RuiInteractiveState.active;
    }
    if (isHovered) {
      return RuiInteractiveState.hovered;
    }
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
        onTap: widget.enabled ? widget.onClick : null,
        onTapUp: (final _) => updateHovered(false),
        onTapDown: (final _) => updateHovered(true),
        onTapCancel: () => updateHovered(false),
        onLongPressStart: (final _) => updateHovered(true),
        onLongPressEnd: (final _) => updateHovered(false),
        child: MouseRegion(
          cursor: widget.enabled ? SystemMouseCursors.click : MouseCursor.defer,
          onEnter: (final _) => updateHovered(true),
          onExit: (final _) => updateHovered(false),
          child: AnimatedContainer(
            duration: RuiAnimationDurations.fastest,
            alignment: Alignment.center,
            width: widget.style.width,
            height: widget.style.height,
            padding: widget.style.padding,
            decoration: BoxDecoration(
              color: widget.style.color(context, state),
              borderRadius: widget.style.borderRadius,
              border: widget.style.strokeColor != null
                  ? Border.all(color: widget.style.strokeColor!(context, state))
                  : null,
            ),
            child: AnimatedDefaultTextStyle(
              duration: RuiAnimationDurations.fastest,
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
