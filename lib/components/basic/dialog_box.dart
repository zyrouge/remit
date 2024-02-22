import 'package:flutter/widgets.dart';
import '../theme/color_scheme.dart';
import '../theme/theme.dart';

class RuiDialogBoxStyle {
  const RuiDialogBoxStyle({
    required this.color,
    this.width = defaultWidth,
    this.padding = defaultPadding,
    this.borderRadius = defaultBorderRadius,
    this.height,
    this.strokeColor,
  });

  factory RuiDialogBoxStyle.standard(
    final BuildContext context, {
    final double? width,
    final double? height,
    final EdgeInsets? padding,
    final BorderRadius? borderRadius,
  }) {
    final RuiColorScheme colorScheme = RuiTheme.colorSchemeOf(context);
    return RuiDialogBoxStyle(
      color: colorScheme.background,
      strokeColor: colorScheme.backgroundVariant,
      width: width ?? defaultWidth,
      height: height,
      padding: padding ?? defaultPadding,
      borderRadius: borderRadius ?? defaultBorderRadius,
    );
  }

  final double width;
  final double? height;
  final EdgeInsets padding;
  final BorderRadius borderRadius;
  final Color color;
  final Color? strokeColor;

  static const BorderRadius defaultBorderRadius =
      BorderRadius.all(Radius.circular(8));

  static const EdgeInsets defaultPadding = EdgeInsets.all(8);

  static const double defaultWidth = 320;
}

class RuiDialogBox extends StatelessWidget {
  const RuiDialogBox({
    required this.style,
    required this.child,
    super.key,
  });

  final RuiDialogBoxStyle style;
  final Widget child;

  @override
  Widget build(final BuildContext context) => Container(
        width: style.width,
        height: style.height,
        padding: style.padding,
        decoration: BoxDecoration(
          color: style.color,
          borderRadius: style.borderRadius,
          border: style.strokeColor != null
              ? Border.all(color: style.strokeColor!)
              : null,
        ),
        child: child,
      );
}
